import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BikeServiceRecord extends FirestoreRecord {
  BikeServiceRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "engine_oil" field.
  String? _engineOil;
  String get engineOil => _engineOil ?? '';
  bool hasEngineOil() => _engineOil != null;

  // "air_filter" field.
  String? _airFilter;
  String get airFilter => _airFilter ?? '';
  bool hasAirFilter() => _airFilter != null;

  // "oil_filter" field.
  String? _oilFilter;
  String get oilFilter => _oilFilter ?? '';
  bool hasOilFilter() => _oilFilter != null;

  // "spark_plug" field.
  String? _sparkPlug;
  String get sparkPlug => _sparkPlug ?? '';
  bool hasSparkPlug() => _sparkPlug != null;

  // "self_start" field.
  String? _selfStart;
  String get selfStart => _selfStart ?? '';
  bool hasSelfStart() => _selfStart != null;

  // "bike_wash" field.
  String? _bikeWash;
  String get bikeWash => _bikeWash ?? '';
  bool hasBikeWash() => _bikeWash != null;

  // "brake_pads" field.
  String? _brakePads;
  String get brakePads => _brakePads ?? '';
  bool hasBrakePads() => _brakePads != null;

  // "break_disc" field.
  String? _breakDisc;
  String get breakDisc => _breakDisc ?? '';
  bool hasBreakDisc() => _breakDisc != null;

  // "lights_signal" field.
  String? _lightsSignal;
  String get lightsSignal => _lightsSignal ?? '';
  bool hasLightsSignal() => _lightsSignal != null;

  // "clutch_wire" field.
  String? _clutchWire;
  String get clutchWire => _clutchWire ?? '';
  bool hasClutchWire() => _clutchWire != null;

  // "battery" field.
  String? _battery;
  String get battery => _battery ?? '';
  bool hasBattery() => _battery != null;

  // "drive_chain" field.
  String? _driveChain;
  String get driveChain => _driveChain ?? '';
  bool hasDriveChain() => _driveChain != null;

  // "horn" field.
  String? _horn;
  String get horn => _horn ?? '';
  bool hasHorn() => _horn != null;

  // "unusal_noise" field.
  String? _unusalNoise;
  String get unusalNoise => _unusalNoise ?? '';
  bool hasUnusalNoise() => _unusalNoise != null;

  // "wash" field.
  String? _wash;
  String get wash => _wash ?? '';
  bool hasWash() => _wash != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "vechile_no" field.
  String? _vechileNo;
  String get vechileNo => _vechileNo ?? '';
  bool hasVechileNo() => _vechileNo != null;

  // "notifications" field.
  String? _notifications;
  String get notifications => _notifications ?? '';
  bool hasNotifications() => _notifications != null;

  void _initializeFields() {
    _engineOil = snapshotData['engine_oil'] as String?;
    _airFilter = snapshotData['air_filter'] as String?;
    _oilFilter = snapshotData['oil_filter'] as String?;
    _sparkPlug = snapshotData['spark_plug'] as String?;
    _selfStart = snapshotData['self_start'] as String?;
    _bikeWash = snapshotData['bike_wash'] as String?;
    _brakePads = snapshotData['brake_pads'] as String?;
    _breakDisc = snapshotData['break_disc'] as String?;
    _lightsSignal = snapshotData['lights_signal'] as String?;
    _clutchWire = snapshotData['clutch_wire'] as String?;
    _battery = snapshotData['battery'] as String?;
    _driveChain = snapshotData['drive_chain'] as String?;
    _horn = snapshotData['horn'] as String?;
    _unusalNoise = snapshotData['unusal_noise'] as String?;
    _wash = snapshotData['wash'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _vechileNo = snapshotData['vechile_no'] as String?;
    _notifications = snapshotData['notifications'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('bike_service');

  static Stream<BikeServiceRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BikeServiceRecord.fromSnapshot(s));

  static Future<BikeServiceRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BikeServiceRecord.fromSnapshot(s));

  static BikeServiceRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BikeServiceRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BikeServiceRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BikeServiceRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BikeServiceRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BikeServiceRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBikeServiceRecordData({
  String? engineOil,
  String? airFilter,
  String? oilFilter,
  String? sparkPlug,
  String? selfStart,
  String? bikeWash,
  String? brakePads,
  String? breakDisc,
  String? lightsSignal,
  String? clutchWire,
  String? battery,
  String? driveChain,
  String? horn,
  String? unusalNoise,
  String? wash,
  DateTime? date,
  String? vechileNo,
  String? notifications,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'engine_oil': engineOil,
      'air_filter': airFilter,
      'oil_filter': oilFilter,
      'spark_plug': sparkPlug,
      'self_start': selfStart,
      'bike_wash': bikeWash,
      'brake_pads': brakePads,
      'break_disc': breakDisc,
      'lights_signal': lightsSignal,
      'clutch_wire': clutchWire,
      'battery': battery,
      'drive_chain': driveChain,
      'horn': horn,
      'unusal_noise': unusalNoise,
      'wash': wash,
      'date': date,
      'vechile_no': vechileNo,
      'notifications': notifications,
    }.withoutNulls,
  );

  return firestoreData;
}

class BikeServiceRecordDocumentEquality implements Equality<BikeServiceRecord> {
  const BikeServiceRecordDocumentEquality();

  @override
  bool equals(BikeServiceRecord? e1, BikeServiceRecord? e2) {
    return e1?.engineOil == e2?.engineOil &&
        e1?.airFilter == e2?.airFilter &&
        e1?.oilFilter == e2?.oilFilter &&
        e1?.sparkPlug == e2?.sparkPlug &&
        e1?.selfStart == e2?.selfStart &&
        e1?.bikeWash == e2?.bikeWash &&
        e1?.brakePads == e2?.brakePads &&
        e1?.breakDisc == e2?.breakDisc &&
        e1?.lightsSignal == e2?.lightsSignal &&
        e1?.clutchWire == e2?.clutchWire &&
        e1?.battery == e2?.battery &&
        e1?.driveChain == e2?.driveChain &&
        e1?.horn == e2?.horn &&
        e1?.unusalNoise == e2?.unusalNoise &&
        e1?.wash == e2?.wash &&
        e1?.date == e2?.date &&
        e1?.vechileNo == e2?.vechileNo &&
        e1?.notifications == e2?.notifications;
  }

  @override
  int hash(BikeServiceRecord? e) => const ListEquality().hash([
        e?.engineOil,
        e?.airFilter,
        e?.oilFilter,
        e?.sparkPlug,
        e?.selfStart,
        e?.bikeWash,
        e?.brakePads,
        e?.breakDisc,
        e?.lightsSignal,
        e?.clutchWire,
        e?.battery,
        e?.driveChain,
        e?.horn,
        e?.unusalNoise,
        e?.wash,
        e?.date,
        e?.vechileNo,
        e?.notifications
      ]);

  @override
  bool isValidKey(Object? o) => o is BikeServiceRecord;
}
