import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'service_form2_widget.dart' show ServiceForm2Widget;
import 'package:flutter/material.dart';

class ServiceForm2Model extends FlutterFlowModel<ServiceForm2Widget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for EngineOil widget.
  String? engineOilValue;
  FormFieldController<String>? engineOilValueController;
  // State field(s) for Coolant widget.
  String? coolantValue;
  FormFieldController<String>? coolantValueController;
  // State field(s) for Airfilter widget.
  String? airfilterValue;
  FormFieldController<String>? airfilterValueController;
  // State field(s) for Oilfilter widget.
  String? oilfilterValue;
  FormFieldController<String>? oilfilterValueController;
  // State field(s) for ACfilter widget.
  String? aCfilterValue;
  FormFieldController<String>? aCfilterValueController;
  // State field(s) for Carwash widget.
  String? carwashValue;
  FormFieldController<String>? carwashValueController;
  // State field(s) for Brakepads widget.
  String? brakepadsValue;
  FormFieldController<String>? brakepadsValueController;
  // State field(s) for Breakdisc widget.
  String? breakdiscValue;
  FormFieldController<String>? breakdiscValueController;
  // State field(s) for Lightssignals widget.
  String? lightssignalsValue;
  FormFieldController<String>? lightssignalsValueController;
  // State field(s) for BrakeFluid widget.
  String? brakeFluidValue;
  FormFieldController<String>? brakeFluidValueController;
  // State field(s) for GearFluid widget.
  String? gearFluidValue;
  FormFieldController<String>? gearFluidValueController;
  // State field(s) for Wiperblades widget.
  String? wiperbladesValue;
  FormFieldController<String>? wiperbladesValueController;
  // State field(s) for Battery widget.
  String? batteryValue;
  FormFieldController<String>? batteryValueController;
  // State field(s) for Suspension widget.
  String? suspensionValue;
  FormFieldController<String>? suspensionValueController;
  // State field(s) for Dashboardwarninglights widget.
  String? dashboardwarninglightsValue;
  FormFieldController<String>? dashboardwarninglightsValueController;
  // State field(s) for Notifications widget.
  String? notificationsValue;
  FormFieldController<String>? notificationsValueController;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
