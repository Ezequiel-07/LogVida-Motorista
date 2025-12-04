import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addLocation(LocationData locationData) async {
    await _db.collection('locations').add({
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
