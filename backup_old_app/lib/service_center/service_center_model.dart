import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'service_center_widget.dart' show ServiceCenterWidget;
import 'package:flutter/material.dart';

class ServiceCenterModel extends FlutterFlowModel<ServiceCenterWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for serviceCente widget.
  FocusNode? serviceCenteFocusNode;
  TextEditingController? serviceCenteTextController;
  String? Function(BuildContext, String?)? serviceCenteTextControllerValidator;
  String? _serviceCenteTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the patients full name.';
    }

    return null;
  }

  // State field(s) for address widget.
  FocusNode? addressFocusNode;
  TextEditingController? addressTextController;
  String? Function(BuildContext, String?)? addressTextControllerValidator;
  String? _addressTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter an age for the patient.';
    }

    return null;
  }

  // State field(s) for area widget.
  FocusNode? areaFocusNode;
  TextEditingController? areaTextController;
  String? Function(BuildContext, String?)? areaTextControllerValidator;
  // State field(s) for city widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? Function(BuildContext, String?)? cityTextControllerValidator;
  String? _cityTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the date of birth of the patient.';
    }

    return null;
  }

  // State field(s) for state widget.
  FocusNode? stateFocusNode;
  TextEditingController? stateTextController;
  String? Function(BuildContext, String?)? stateTextControllerValidator;
  // State field(s) for gst widget.
  FocusNode? gstFocusNode;
  TextEditingController? gstTextController;
  String? Function(BuildContext, String?)? gstTextControllerValidator;
  // State field(s) for ownerName widget.
  FocusNode? ownerNameFocusNode;
  TextEditingController? ownerNameTextController;
  String? Function(BuildContext, String?)? ownerNameTextControllerValidator;
  // State field(s) for carAc widget.
  bool? carAcValue;
  // State field(s) for carDetailing widget.
  bool? carDetailingValue;
  // State field(s) for carAccessories widget.
  bool? carAccessoriesValue;
  // State field(s) for carwash widget.
  bool? carwashValue;
  // State field(s) for hardware widget.
  bool? hardwareValue;
  // State field(s) for electricBattery widget.
  bool? electricBatteryValue;
  // State field(s) for windshieldreplacement widget.
  bool? windshieldreplacementValue;
  // State field(s) for dentingandPainting widget.
  bool? dentingandPaintingValue;
  // State field(s) for breakdownassistance widget.
  bool? breakdownassistanceValue;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  ServiceCenterRecord? createService;

  @override
  void initState(BuildContext context) {
    serviceCenteTextControllerValidator = _serviceCenteTextControllerValidator;
    addressTextControllerValidator = _addressTextControllerValidator;
    cityTextControllerValidator = _cityTextControllerValidator;
  }

  @override
  void dispose() {
    serviceCenteFocusNode?.dispose();
    serviceCenteTextController?.dispose();

    addressFocusNode?.dispose();
    addressTextController?.dispose();

    areaFocusNode?.dispose();
    areaTextController?.dispose();

    cityFocusNode?.dispose();
    cityTextController?.dispose();

    stateFocusNode?.dispose();
    stateTextController?.dispose();

    gstFocusNode?.dispose();
    gstTextController?.dispose();

    ownerNameFocusNode?.dispose();
    ownerNameTextController?.dispose();
  }
}
