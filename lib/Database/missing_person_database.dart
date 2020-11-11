import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';

class Person {
  DocumentReference reference;
  int id; //this will probably be deleted but I'm leaving it for now
  String image;
  String firstName;
  String lastName;
  String city, province;
  DateTime missingSince;

  Person(this.id);

  Map<String, dynamic> toMap() => {
        'id': id,
        'image': image,
        'firstName': firstName,
        'lastName': lastName,
        'city': city,
        'province': province,
        'missingSince': missingSince
      };

  Person.fromMap(Map<String, dynamic> map, {this.reference}) {
    id = map['id'];
    image = map['image'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    Timestamp time = map['missingSince'];
    missingSince = time.toDate();
    city = map['city'];
    province = map['province'];
  }
}

class MissingPeopleModel {
  final people = FirebaseFirestore.instance.collection('persons');

  Stream<QuerySnapshot> getAllPeople() {
    return people.snapshots();
  }

  Stream getPeopleFromIds(List ids) {
    List<String> docIds = [];
    List<Stream> streamChunks = [];
    List chunkIds = [];

    for (var id in ids) {
      docIds.add(id['id']);
    }

    for (var i = 0; i < docIds.length; i += 9) {
      chunkIds.add(
          docIds.sublist(i, i + 9 > docIds.length ? docIds.length : i + 9));
    }

    for (var chunk in chunkIds) {
      streamChunks
          .add(people.where(FieldPath.documentId, whereIn: chunk).snapshots());
    }

    return StreamZip(streamChunks);
  }

  Stream<QuerySnapshot> getPersonWhereName(name) {
    if (name.firstName.isNotEmpty && name.lastName.isNotEmpty) {
      return people
          .where('firstName', isEqualTo: name.firstName)
          .where('lastName', isEqualTo: name.lastName)
          .snapshots();
    } else if (name.firstName.isNotEmpty) {
      return people.where('firstName', isEqualTo: name.firstName).snapshots();
    } else {
      return people.where('lastName', isEqualTo: name.lastName).snapshots();
    }
  }

  Stream<QuerySnapshot> getPersonWhereDate(DateTime date) {
    DateTime tmrwDate = date.add(Duration(days: 1));
    Timestamp dateTimeStamp = Timestamp.fromDate(date);
    Timestamp nextDateTimeStamp = Timestamp.fromDate(tmrwDate);

    return people
        .where('missingSince', isGreaterThanOrEqualTo: dateTimeStamp)
        .where('missingSince', isLessThan: nextDateTimeStamp)
        .snapshots();
  }
}
