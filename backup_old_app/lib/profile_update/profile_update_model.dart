import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_update_widget.dart' show ProfileUpdateWidget;
import 'package:flutter/material.dart';

class ProfileUpdateModel extends FlutterFlowModel<ProfileUpdateWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for address widget.
  FocusNode? addressFocusNode;
  TextEditingController? addressTextController;
  String? Function(BuildContext, String?)? addressTextControllerValidator;
  // State field(s) for area widget.
  FocusNode? areaFocusNode;
  TextEditingController? areaTextController;
  String? Function(BuildContext, String?)? areaTextControllerValidator;
  // State field(s) for city widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? Function(BuildContext, String?)? cityTextControllerValidator;
  // State field(s) for gstno widget.
  FocusNode? gstnoFocusNode;
  TextEditingController? gstnoTextController;
  String? Function(BuildContext, String?)? gstnoTextControllerValidator;
  // State field(s) for location widget.
  FocusNode? locationFocusNode;
  TextEditingController? locationTextController;
  String? Function(BuildContext, String?)? locationTextControllerValidator;
  // State field(s) for pin widget.
  FocusNode? pinFocusNode;
  TextEditingController? pinTextController;
  String? Function(BuildContext, String?)? pinTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    addressFocusNode?.dispose();
    addressTextController?.dispose();

    areaFocusNode?.dispose();
    areaTextController?.dispose();

    cityFocusNode?.dispose();
    cityTextController?.dispose();

    gstnoFocusNode?.dispose();
    gstnoTextController?.dispose();

    locationFocusNode?.dispose();
    locationTextController?.dispose();

    pinFocusNode?.dispose();
    pinTextController?.dispose();
  }
}
