import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CarServiceRecord extends FirestoreRecord {
  CarServiceRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "engine_oil" field.
  String? _engineOil;
  String get engineOil => _engineOil ?? '';
  bool hasEngineOil() => _engineOil != null;

  // "coolant" field.
  String? _coolant;
  String get coolant => _coolant ?? '';
  bool hasCoolant() => _coolant != null;

  // "airfilter" field.
  String? _airfilter;
  String get airfilter => _airfilter ?? '';
  bool hasAirfilter() => _airfilter != null;

  // "oil_filter" field.
  String? _oilFilter;
  String get oilFilter => _oilFilter ?? '';
  bool hasOilFilter() => _oilFilter != null;

  // "ac_filter" field.
  String? _acFilter;
  String get acFilter => _acFilter ?? '';
  bool hasAcFilter() => _acFilter != null;

  // "car_wash" field.
  String? _carWash;
  String get carWash => _carWash ?? '';
  bool hasCarWash() => _carWash != null;

  // "break_pads" field.
  String? _breakPads;
  String get breakPads => _breakPads ?? '';
  bool hasBreakPads() => _breakPads != null;

  // "break_disc" field.
  String? _breakDisc;
  String get breakDisc => _breakDisc ?? '';
  bool hasBreakDisc() => _breakDisc != null;

  // "lights_signal" field.
  String? _lightsSignal;
  String get lightsSignal => _lightsSignal ?? '';
  bool hasLightsSignal() => _lightsSignal != null;

  // "break_fluid" field.
  String? _breakFluid;
  String get breakFluid => _breakFluid ?? '';
  bool hasBreakFluid() => _breakFluid != null;

  // "gear_fluid" field.
  String? _gearFluid;
  String get gearFluid => _gearFluid ?? '';
  bool hasGearFluid() => _gearFluid != null;

  // "wiper_blades" field.
  String? _wiperBlades;
  String get wiperBlades => _wiperBlades ?? '';
  bool hasWiperBlades() => _wiperBlades != null;

  // "battery" field.
  String? _battery;
  String get battery => _battery ?? '';
  bool hasBattery() => _battery != null;

  // "suspension" field.
  String? _suspension;
  String get suspension => _suspension ?? '';
  bool hasSuspension() => _suspension != null;

  // "dashboar_warning_light" field.
  String? _dashboarWarningLight;
  String get dashboarWarningLight => _dashboarWarningLight ?? '';
  bool hasDashboarWarningLight() => _dashboarWarningLight != null;

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
    _coolant = snapshotData['coolant'] as String?;
    _airfilter = snapshotData['airfilter'] as String?;
    _oilFilter = snapshotData['oil_filter'] as String?;
    _acFilter = snapshotData['ac_filter'] as String?;
    _carWash = snapshotData['car_wash'] as String?;
    _breakPads = snapshotData['break_pads'] as String?;
    _breakDisc = snapshotData['break_disc'] as String?;
    _lightsSignal = snapshotData['lights_signal'] as String?;
    _breakFluid = snapshotData['break_fluid'] as String?;
    _gearFluid = snapshotData['gear_fluid'] as String?;
    _wiperBlades = snapshotData['wiper_blades'] as String?;
    _battery = snapshotData['battery'] as String?;
    _suspension = snapshotData['suspension'] as String?;
    _dashboarWarningLight = snapshotData['dashboar_warning_light'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _vechileNo = snapshotData['vechile_no'] as String?;
    _notifications = snapshotData['notifications'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('car_service');

  static Stream<CarServiceRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CarServiceRecord.fromSnapshot(s));

  static Future<CarServiceRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CarServiceRecord.fromSnapshot(s));

  static CarServiceRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CarServiceRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CarServiceRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CarServiceRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CarServiceRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CarServiceRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCarServiceRecordData({
  String? engineOil,
  String? coolant,
  String? airfilter,
  String? oilFilter,
  String? acFilter,
  String? carWash,
  String? breakPads,
  String? breakDisc,
  String? lightsSignal,
  String? breakFluid,
  String? gearFluid,
  String? wiperBlades,
  String? battery,
  String? suspension,
  String? dashboarWarningLight,
  DateTime? date,
  String? vechileNo,
  String? notifications,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'engine_oil': engineOil,
      'coolant': coolant,
      'airfilter': airfilter,
      'oil_filter': oilFilter,
      'ac_filter': acFilter,
      'car_wash': carWash,
      'break_pads': breakPads,
      'break_disc': breakDisc,
      'lights_signal': lightsSignal,
      'break_fluid': breakFluid,
      'gear_fluid': gearFluid,
      'wiper_blades': wiperBlades,
      'battery': battery,
      'suspension': suspension,
      'dashboar_warning_light': dashboarWarningLight,
      'date': date,
      'vechile_no': vechileNo,
      'notifications': notifications,
    }.withoutNulls,
  );

  return firestoreData;
}

class CarServiceRecordDocumentEquality implements Equality<CarServiceRecord> {
  const CarServiceRecordDocumentEquality();

  @override
  bool equals(CarServiceRecord? e1, CarServiceRecord? e2) {
    return e1?.engineOil == e2?.engineOil &&
        e1?.coolant == e2?.coolant &&
        e1?.airfilter == e2?.airfilter &&
        e1?.oilFilter == e2?.oilFilter &&
        e1?.acFilter == e2?.acFilter &&
        e1?.carWash == e2?.carWash &&
        e1?.breakPads == e2?.breakPads &&
        e1?.breakDisc == e2?.breakDisc &&
        e1?.lightsSignal == e2?.lightsSignal &&
        e1?.breakFluid == e2?.breakFluid &&
        e1?.gearFluid == e2?.gearFluid &&
        e1?.wiperBlades == e2?.wiperBlades &&
        e1?.battery == e2?.battery &&
        e1?.suspension == e2?.suspension &&
        e1?.dashboarWarningLight == e2?.dashboarWarningLight &&
        e1?.date == e2?.date &&
        e1?.vechileNo == e2?.vechileNo &&
        e1?.notifications == e2?.notifications;
  }

  @override
  int hash(CarServiceRecord? e) => const ListEquality().hash([
        e?.engineOil,
        e?.coolant,
        e?.airfilter,
        e?.oilFilter,
        e?.acFilter,
        e?.carWash,
        e?.breakPads,
        e?.breakDisc,
        e?.lightsSignal,
        e?.breakFluid,
        e?.gearFluid,
        e?.wiperBlades,
        e?.battery,
        e?.suspension,
        e?.dashboarWarningLight,
        e?.date,
        e?.vechileNo,
        e?.notifications
      ]);

  @override
  bool isValidKey(Object? o) => o is CarServiceRecord;
}
