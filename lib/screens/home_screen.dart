import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';


import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isServiceRunning = false;

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
  }

  Future<void> _checkServiceStatus() async {
    final isRunning = await FlutterBackgroundService().isRunning();
    setState(() {
      _isServiceRunning = isRunning;
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
    await Permission.location.request();
    await Permission.systemAlertWindow.request();
  }

  void _toggleService() async {
    await _requestPermissions();
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
      FlutterOverlayWindow.closeOverlay();
    } else {
      service.startService();
      FlutterOverlayWindow.showOverlay(
        height: 200,
        width: 300,
        alignment: OverlayAlignment.topRight,
      );
    }
    setState(() {
      _isServiceRunning = !isRunning;
    });
  }


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final locationData = Provider.of<LocationData?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Rastreamento de Localização em Tempo Real',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (locationData != null)
              Text(
                'Latitude: ${locationData.latitude}\nLongitude: ${locationData.longitude}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              )
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleService,
              child: Text(_isServiceRunning ? 'Parar Serviço' : 'Iniciar Serviço'),
            ),
          ],
        ),
      ),
    );
  }
}
