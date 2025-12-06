import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.systemAlertWindow.isDenied) {
      await Permission.systemAlertWindow.request();
    }
    if (await Permission.locationAlways.isDenied) {
      await Permission.locationAlways.request();
    }
  }

  void _toggleService() async {
    await _requestPermissions();
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();

    // Garante que as permissões foram concedidas antes de iniciar
    if (!await Permission.location.isGranted || !await Permission.notification.isGranted) {
      // Opcional: mostrar um diálogo informando o usuário que as permissões são necessárias
      return;
    }

    if (isRunning) {
      service.invoke("stopService");
      FlutterOverlayWindow.closeOverlay();
    } else {
      // Inicia o serviço em primeiro plano
      service.startService();
      // Mostra a janela flutuante
      if (await FlutterOverlayWindow.isActive() != true) {
         FlutterOverlayWindow.showOverlay(
           height: 120, // Altura ajustada
           width: 240,  // Largura ajustada
           alignment: OverlayAlignment.topRight, // CORRIGIDO
           flag: OverlayFlag.focusPointer,
           enableDrag: true,
         );
      }
    }
    setState(() {
      _isServiceRunning = !isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rastreamento LogVida'),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              // Para o serviço se estiver rodando antes de deslogar
              if (_isServiceRunning) {
                _toggleService();
              }
              await authService.signOut();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _isServiceRunning ? Icons.location_on : Icons.location_off,
              color: _isServiceRunning ? Colors.greenAccent[400] : Colors.redAccent,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              _isServiceRunning ? 'RASTREAMENTO ATIVO' : 'RASTREAMENTO INATIVO',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: Icon(_isServiceRunning ? Icons.stop_circle_outlined : Icons.play_circle_outline),
              label: Text(_isServiceRunning ? 'Parar Rastreamento' : 'Iniciar Rastreamento'),
              onPressed: _toggleService,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: _isServiceRunning ? Colors.redAccent : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
