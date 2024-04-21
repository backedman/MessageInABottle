import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

void writeBottle(user, message, city, location) {

    var collection = firestore.collection("bottles");

    var doc = {
      'user' : user,
      'message': message,
      'location': location,
      'city': city
    };

    collection.add(doc).then((value) {
      print("Bottle added with ID: ${value.id}");
    })
    .catchError((error) {
      print("Failed to add bottle: $error");
    });
  }

void readData() {
  firestore.collection('bottles').get()
  .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print('${doc.id}: ${doc.data()}');
    });
  })
  .catchError((error) {
    print("Failed to retrieve bottles: $error");
  });
}

void deleteBottle(key) {

    var collection = firestore.collection("bottles");

    collection.doc(key).delete();
}