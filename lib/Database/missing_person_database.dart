import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  DocumentReference reference;
  int id; //this will probably be deleted but I'm leaving it for now
  String image;
  String firstName;
  String lastName;
  DateTime missingSince;

  Person(this.id);

  Map<String, dynamic> toMap() => {
        'id': id,
        'image': image,
        'firstName': firstName,
        'lastName': lastName,
        'missingSince': missingSince
      };

  Person.fromMap(Map<String, dynamic> map, {this.reference}) {
    id = map['id'];
    image = map['image'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    Timestamp time = map['missingSince'];
    missingSince = time.toDate();
  }
}

class MissingPeopleModel {
  final people = FirebaseFirestore.instance.collection('persons');

  Stream<QuerySnapshot> getAllPeople() {
    return people.snapshots();
  }

  Stream<QuerySnapshot> getPeopleFromIds(List ids) {
    List<String> docIds = [];
    for (var id in ids) {
      docIds.add(id['id']);
    }
    return people.where(FieldPath.documentId, whereIn: docIds).snapshots();
  }
}
