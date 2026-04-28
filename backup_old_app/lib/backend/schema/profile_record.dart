import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProfileRecord extends FirestoreRecord {
  ProfileRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Mobile" field.
  String? _mobile;
  String get mobile => _mobile ?? '';
  bool hasMobile() => _mobile != null;

  // "Address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "Area" field.
  String? _area;
  String get area => _area ?? '';
  bool hasArea() => _area != null;

  // "City" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "Pin" field.
  String? _pin;
  String get pin => _pin ?? '';
  bool hasPin() => _pin != null;

  // "Location" field.
  String? _location;
  String get location => _location ?? '';
  bool hasLocation() => _location != null;

  // "GstNo" field.
  String? _gstNo;
  String get gstNo => _gstNo ?? '';
  bool hasGstNo() => _gstNo != null;

  // "Payment" field.
  String? _payment;
  String get payment => _payment ?? '';
  bool hasPayment() => _payment != null;

  // "Services" field.
  String? _services;
  String get services => _services ?? '';
  bool hasServices() => _services != null;

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  void _initializeFields() {
    _mobile = snapshotData['Mobile'] as String?;
    _address = snapshotData['Address'] as String?;
    _area = snapshotData['Area'] as String?;
    _city = snapshotData['City'] as String?;
    _pin = snapshotData['Pin'] as String?;
    _location = snapshotData['Location'] as String?;
    _gstNo = snapshotData['GstNo'] as String?;
    _payment = snapshotData['Payment'] as String?;
    _services = snapshotData['Services'] as String?;
    _name = snapshotData['Name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('profile');

  static Stream<ProfileRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProfileRecord.fromSnapshot(s));

  static Future<ProfileRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProfileRecord.fromSnapshot(s));

  static ProfileRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProfileRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProfileRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProfileRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProfileRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProfileRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProfileRecordData({
  String? mobile,
  String? address,
  String? area,
  String? city,
  String? pin,
  String? location,
  String? gstNo,
  String? payment,
  String? services,
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Mobile': mobile,
      'Address': address,
      'Area': area,
      'City': city,
      'Pin': pin,
      'Location': location,
      'GstNo': gstNo,
      'Payment': payment,
      'Services': services,
      'Name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProfileRecordDocumentEquality implements Equality<ProfileRecord> {
  const ProfileRecordDocumentEquality();

  @override
  bool equals(ProfileRecord? e1, ProfileRecord? e2) {
    return e1?.mobile == e2?.mobile &&
        e1?.address == e2?.address &&
        e1?.area == e2?.area &&
        e1?.city == e2?.city &&
        e1?.pin == e2?.pin &&
        e1?.location == e2?.location &&
        e1?.gstNo == e2?.gstNo &&
        e1?.payment == e2?.payment &&
        e1?.services == e2?.services &&
        e1?.name == e2?.name;
  }

  @override
  int hash(ProfileRecord? e) => const ListEquality().hash([
        e?.mobile,
        e?.address,
        e?.area,
        e?.city,
        e?.pin,
        e?.location,
        e?.gstNo,
        e?.payment,
        e?.services,
        e?.name
      ]);

  @override
  bool isValidKey(Object? o) => o is ProfileRecord;
}
