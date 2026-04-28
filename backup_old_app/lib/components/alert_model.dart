import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'alert_widget.dart' show AlertWidget;
import 'package:flutter/material.dart';

class AlertModel extends FlutterFlowModel<AlertWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for shortBio widget.
  FocusNode? shortBioFocusNode;
  TextEditingController? shortBioTextController;
  String? Function(BuildContext, String?)? shortBioTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  VechileDetailsRecord? vechileSearch;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  VechileDetailsRecord? userVechileMap;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    shortBioFocusNode?.dispose();
    shortBioTextController?.dispose();
  }
}
