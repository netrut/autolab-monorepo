import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'service_form1_widget.dart' show ServiceForm1Widget;
import 'package:flutter/material.dart';

class ServiceForm1Model extends FlutterFlowModel<ServiceForm1Widget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for EngineOil widget.
  String? engineOilValue;
  FormFieldController<String>? engineOilValueController;
  // State field(s) for Airfilter widget.
  String? airfilterValue;
  FormFieldController<String>? airfilterValueController;
  // State field(s) for Oilfilter widget.
  String? oilfilterValue;
  FormFieldController<String>? oilfilterValueController;
  // State field(s) for Sparkplug widget.
  String? sparkplugValue;
  FormFieldController<String>? sparkplugValueController;
  // State field(s) for Selfstart widget.
  String? selfstartValue;
  FormFieldController<String>? selfstartValueController;
  // State field(s) for Bikewash widget.
  String? bikewashValue;
  FormFieldController<String>? bikewashValueController;
  // State field(s) for Brakepads widget.
  String? brakepadsValue;
  FormFieldController<String>? brakepadsValueController;
  // State field(s) for Breakdisc widget.
  String? breakdiscValue;
  FormFieldController<String>? breakdiscValueController;
  // State field(s) for Lightssignals widget.
  String? lightssignalsValue;
  FormFieldController<String>? lightssignalsValueController;
  // State field(s) for Clutchwire widget.
  String? clutchwireValue;
  FormFieldController<String>? clutchwireValueController;
  // State field(s) for Battery widget.
  String? batteryValue;
  FormFieldController<String>? batteryValueController;
  // State field(s) for Drivechain widget.
  String? drivechainValue;
  FormFieldController<String>? drivechainValueController;
  // State field(s) for Horn widget.
  String? hornValue;
  FormFieldController<String>? hornValueController;
  // State field(s) for UnusualNoise widget.
  String? unusualNoiseValue;
  FormFieldController<String>? unusualNoiseValueController;
  // State field(s) for Wash widget.
  String? washValue;
  FormFieldController<String>? washValueController;
  // State field(s) for Notification widget.
  String? notificationValue;
  FormFieldController<String>? notificationValueController;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
