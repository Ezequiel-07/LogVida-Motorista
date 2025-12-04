import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'firestore_service.dart';

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final firestoreService = FirestoreService();
  final location = Location();
  LocationData? lastLocation;

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  location.onLocationChanged.listen((LocationData currentLocation) {
    if (lastLocation != null && currentLocation.speed != null) {
      FlutterOverlayWindow.shareData({'speed': currentLocation.speed! * 3.6});
    }
    lastLocation = currentLocation;
    firestoreService.addLocation(currentLocation);
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'my_app_channel', 
      initialNotificationTitle: 'Rastreamento de Localização',
      initialNotificationContent: 'O aplicativo está rastreando sua localização.',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: (ServiceInstance service) async {
        return true;
      },
    ),
  );
}
