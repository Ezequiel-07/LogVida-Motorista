import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import 'services/auth_service.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/background_service.dart';
import 'screens/wrapper.dart';
import 'screens/overlay_screen.dart';

@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MaterialApp(home: OverlayScreen()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  await LocationService().requestPermission();
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        StreamProvider<LocationData?>.value(
          value: LocationService().locationStream,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Localização em Tempo Real',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Wrapper(),
      ),
    );
  }
}
