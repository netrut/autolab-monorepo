import '/flutter_flow/flutter_flow_util.dart';
import 'bookings_widget.dart' show BookingsWidget;
import 'package:flutter/material.dart';

class BookingsModel extends FlutterFlowModel<BookingsWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for price widget.
  FocusNode? priceFocusNode1;
  TextEditingController? priceTextController1;
  String? Function(BuildContext, String?)? priceTextController1Validator;
  // State field(s) for salesPrice widget.
  FocusNode? salesPriceFocusNode1;
  TextEditingController? salesPriceTextController1;
  String? Function(BuildContext, String?)? salesPriceTextController1Validator;
  // State field(s) for salesPrice widget.
  FocusNode? salesPriceFocusNode2;
  TextEditingController? salesPriceTextController2;
  String? Function(BuildContext, String?)? salesPriceTextController2Validator;
  // State field(s) for price widget.
  FocusNode? priceFocusNode2;
  TextEditingController? priceTextController2;
  String? Function(BuildContext, String?)? priceTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    priceFocusNode1?.dispose();
    priceTextController1?.dispose();

    salesPriceFocusNode1?.dispose();
    salesPriceTextController1?.dispose();

    salesPriceFocusNode2?.dispose();
    salesPriceTextController2?.dispose();

    priceFocusNode2?.dispose();
    priceTextController2?.dispose();
  }
}
