import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addLocation(LocationData locationData) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.collection('driverLocations').doc(user.uid).set({
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
        'accuracy': locationData.accuracy,
        'heading': locationData.heading,
        'speed': locationData.speed,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
