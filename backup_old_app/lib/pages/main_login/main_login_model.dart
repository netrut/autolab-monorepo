import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'main_login_widget.dart' show MainLoginWidget;
import 'package:flutter/material.dart';

class MainLoginModel extends FlutterFlowModel<MainLoginWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for login mode toggle
  bool isEmailMode = true; // Default to email mode since phone auth is broken

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for mobile widget.
  FocusNode? mobileFocusNode;
  TextEditingController? mobileTextController;
  String? Function(BuildContext, String?)? mobileTextControllerValidator;

  // State field(s) for email login
  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;

  // State field(s) for password
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  bool passwordVisible = false;
  String? Function(BuildContext, String?)? passwordControllerValidator;

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  UsersRecord? loginCheck;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController1?.dispose();

    mobileFocusNode?.dispose();
    mobileTextController?.dispose();

    emailFocusNode?.dispose();
    emailController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();
  }
}
