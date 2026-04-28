import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_copy_widget.dart' show LoginCopyWidget;
import 'package:flutter/material.dart';

class LoginCopyModel extends FlutterFlowModel<LoginCopyWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for mobile widget.
  FocusNode? mobileFocusNode;
  TextEditingController? mobileTextController;
  String? Function(BuildContext, String?)? mobileTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController1?.dispose();

    mobileFocusNode?.dispose();
    mobileTextController?.dispose();
  }
}
