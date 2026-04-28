import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'filter_show_widget.dart' show FilterShowWidget;
import 'package:flutter/material.dart';

class FilterShowModel extends FlutterFlowModel<FilterShowWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for searchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
  }
}
