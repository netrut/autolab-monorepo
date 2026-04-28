import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VechileDetailsRecord extends FirestoreRecord {
  VechileDetailsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "mobile" field.
  String? _mobile;
  String get mobile => _mobile ?? '';
  bool hasMobile() => _mobile != null;

  // "company" field.
  String? _company;
  String get company => _company ?? '';
  bool hasCompany() => _company != null;

  // "model" field.
  String? _model;
  String get model => _model ?? '';
  bool hasModel() => _model != null;

  // "vechile_no" field.
  String? _vechileNo;
  String get vechileNo => _vechileNo ?? '';
  bool hasVechileNo() => _vechileNo != null;

  // "make_year" field.
  String? _makeYear;
  String get makeYear => _makeYear ?? '';
  bool hasMakeYear() => _makeYear != null;

  // "chasis_no" field.
  String? _chasisNo;
  String get chasisNo => _chasisNo ?? '';
  bool hasChasisNo() => _chasisNo != null;

  // "fuel_type" field.
  String? _fuelType;
  String get fuelType => _fuelType ?? '';
  bool hasFuelType() => _fuelType != null;

  // "transmission" field.
  String? _transmission;
  String get transmission => _transmission ?? '';
  bool hasTransmission() => _transmission != null;

  // "car_bike" field.
  String? _carBike;
  String get carBike => _carBike ?? '';
  bool hasCarBike() => _carBike != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _mobile = snapshotData['mobile'] as String?;
    _company = snapshotData['company'] as String?;
    _model = snapshotData['model'] as String?;
    _vechileNo = snapshotData['vechile_no'] as String?;
    _makeYear = snapshotData['make_year'] as String?;
    _chasisNo = snapshotData['chasis_no'] as String?;
    _fuelType = snapshotData['fuel_type'] as String?;
    _transmission = snapshotData['transmission'] as String?;
    _carBike = snapshotData['car_bike'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('vechile_details');

  static Stream<VechileDetailsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VechileDetailsRecord.fromSnapshot(s));

  static Future<VechileDetailsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VechileDetailsRecord.fromSnapshot(s));

  static VechileDetailsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      VechileDetailsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VechileDetailsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VechileDetailsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VechileDetailsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VechileDetailsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVechileDetailsRecordData({
  String? name,
  String? mobile,
  String? company,
  String? model,
  String? vechileNo,
  String? makeYear,
  String? chasisNo,
  String? fuelType,
  String? transmission,
  String? carBike,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'mobile': mobile,
      'company': company,
      'model': model,
      'vechile_no': vechileNo,
      'make_year': makeYear,
      'chasis_no': chasisNo,
      'fuel_type': fuelType,
      'transmission': transmission,
      'car_bike': carBike,
    }.withoutNulls,
  );

  return firestoreData;
}

class VechileDetailsRecordDocumentEquality
    implements Equality<VechileDetailsRecord> {
  const VechileDetailsRecordDocumentEquality();

  @override
  bool equals(VechileDetailsRecord? e1, VechileDetailsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.mobile == e2?.mobile &&
        e1?.company == e2?.company &&
        e1?.model == e2?.model &&
        e1?.vechileNo == e2?.vechileNo &&
        e1?.makeYear == e2?.makeYear &&
        e1?.chasisNo == e2?.chasisNo &&
        e1?.fuelType == e2?.fuelType &&
        e1?.transmission == e2?.transmission &&
        e1?.carBike == e2?.carBike;
  }

  @override
  int hash(VechileDetailsRecord? e) => const ListEquality().hash([
        e?.name,
        e?.mobile,
        e?.company,
        e?.model,
        e?.vechileNo,
        e?.makeYear,
        e?.chasisNo,
        e?.fuelType,
        e?.transmission,
        e?.carBike
      ]);

  @override
  bool isValidKey(Object? o) => o is VechileDetailsRecord;
}
