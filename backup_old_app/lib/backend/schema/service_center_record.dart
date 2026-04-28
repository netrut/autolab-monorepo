import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ServiceCenterRecord extends FirestoreRecord {
  ServiceCenterRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "center_name" field.
  String? _centerName;
  String get centerName => _centerName ?? '';
  bool hasCenterName() => _centerName != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "area" field.
  String? _area;
  String get area => _area ?? '';
  bool hasArea() => _area != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  bool hasState() => _state != null;

  // "gst_number" field.
  String? _gstNumber;
  String get gstNumber => _gstNumber ?? '';
  bool hasGstNumber() => _gstNumber != null;

  // "owner_name" field.
  String? _ownerName;
  String get ownerName => _ownerName ?? '';
  bool hasOwnerName() => _ownerName != null;

  // "car_ac" field.
  bool? _carAc;
  bool get carAc => _carAc ?? false;
  bool hasCarAc() => _carAc != null;

  // "car_detailing" field.
  bool? _carDetailing;
  bool get carDetailing => _carDetailing ?? false;
  bool hasCarDetailing() => _carDetailing != null;

  // "car_accessories" field.
  bool? _carAccessories;
  bool get carAccessories => _carAccessories ?? false;
  bool hasCarAccessories() => _carAccessories != null;

  // "wash_center" field.
  bool? _washCenter;
  bool get washCenter => _washCenter ?? false;
  bool hasWashCenter() => _washCenter != null;

  // "hardware" field.
  bool? _hardware;
  bool get hardware => _hardware ?? false;
  bool hasHardware() => _hardware != null;

  // "electrical" field.
  bool? _electrical;
  bool get electrical => _electrical ?? false;
  bool hasElectrical() => _electrical != null;

  // "windshield" field.
  bool? _windshield;
  bool get windshield => _windshield ?? false;
  bool hasWindshield() => _windshield != null;

  // "denting" field.
  bool? _denting;
  bool get denting => _denting ?? false;
  bool hasDenting() => _denting != null;

  // "breakdown" field.
  bool? _breakdown;
  bool get breakdown => _breakdown ?? false;
  bool hasBreakdown() => _breakdown != null;

  void _initializeFields() {
    _centerName = snapshotData['center_name'] as String?;
    _address = snapshotData['address'] as String?;
    _area = snapshotData['area'] as String?;
    _city = snapshotData['city'] as String?;
    _state = snapshotData['state'] as String?;
    _gstNumber = snapshotData['gst_number'] as String?;
    _ownerName = snapshotData['owner_name'] as String?;
    _carAc = snapshotData['car_ac'] as bool?;
    _carDetailing = snapshotData['car_detailing'] as bool?;
    _carAccessories = snapshotData['car_accessories'] as bool?;
    _washCenter = snapshotData['wash_center'] as bool?;
    _hardware = snapshotData['hardware'] as bool?;
    _electrical = snapshotData['electrical'] as bool?;
    _windshield = snapshotData['windshield'] as bool?;
    _denting = snapshotData['denting'] as bool?;
    _breakdown = snapshotData['breakdown'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('service_center');

  static Stream<ServiceCenterRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ServiceCenterRecord.fromSnapshot(s));

  static Future<ServiceCenterRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ServiceCenterRecord.fromSnapshot(s));

  static ServiceCenterRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ServiceCenterRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ServiceCenterRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ServiceCenterRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ServiceCenterRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ServiceCenterRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createServiceCenterRecordData({
  String? centerName,
  String? address,
  String? area,
  String? city,
  String? state,
  String? gstNumber,
  String? ownerName,
  bool? carAc,
  bool? carDetailing,
  bool? carAccessories,
  bool? washCenter,
  bool? hardware,
  bool? electrical,
  bool? windshield,
  bool? denting,
  bool? breakdown,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'center_name': centerName,
      'address': address,
      'area': area,
      'city': city,
      'state': state,
      'gst_number': gstNumber,
      'owner_name': ownerName,
      'car_ac': carAc,
      'car_detailing': carDetailing,
      'car_accessories': carAccessories,
      'wash_center': washCenter,
      'hardware': hardware,
      'electrical': electrical,
      'windshield': windshield,
      'denting': denting,
      'breakdown': breakdown,
    }.withoutNulls,
  );

  return firestoreData;
}

class ServiceCenterRecordDocumentEquality
    implements Equality<ServiceCenterRecord> {
  const ServiceCenterRecordDocumentEquality();

  @override
  bool equals(ServiceCenterRecord? e1, ServiceCenterRecord? e2) {
    return e1?.centerName == e2?.centerName &&
        e1?.address == e2?.address &&
        e1?.area == e2?.area &&
        e1?.city == e2?.city &&
        e1?.state == e2?.state &&
        e1?.gstNumber == e2?.gstNumber &&
        e1?.ownerName == e2?.ownerName &&
        e1?.carAc == e2?.carAc &&
        e1?.carDetailing == e2?.carDetailing &&
        e1?.carAccessories == e2?.carAccessories &&
        e1?.washCenter == e2?.washCenter &&
        e1?.hardware == e2?.hardware &&
        e1?.electrical == e2?.electrical &&
        e1?.windshield == e2?.windshield &&
        e1?.denting == e2?.denting &&
        e1?.breakdown == e2?.breakdown;
  }

  @override
  int hash(ServiceCenterRecord? e) => const ListEquality().hash([
        e?.centerName,
        e?.address,
        e?.area,
        e?.city,
        e?.state,
        e?.gstNumber,
        e?.ownerName,
        e?.carAc,
        e?.carDetailing,
        e?.carAccessories,
        e?.washCenter,
        e?.hardware,
        e?.electrical,
        e?.windshield,
        e?.denting,
        e?.breakdown
      ]);

  @override
  bool isValidKey(Object? o) => o is ServiceCenterRecord;
}
