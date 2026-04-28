import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'vechile_details_widget.dart' show VechileDetailsWidget;
import 'package:flutter/material.dart';

class VechileDetailsModel extends FlutterFlowModel<VechileDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  String? _nameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter the patients full name.';
    }

    return null;
  }

  // State field(s) for mobile widget.
  FocusNode? mobileFocusNode;
  TextEditingController? mobileTextController;
  String? Function(BuildContext, String?)? mobileTextControllerValidator;
  String? _mobileTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter an age for the patient.';
    }

    return null;
  }

  // State field(s) for car_bike widget.
  String? carBikeValue;
  FormFieldController<String>? carBikeValueController;
  // State field(s) for DropDownCar widget.
  String? dropDownCarValue;
  FormFieldController<String>? dropDownCarValueController;
  // State field(s) for DropDownBike widget.
  String? dropDownBikeValue;
  FormFieldController<String>? dropDownBikeValueController;
  // State field(s) for DropDownMaruti widget.
  String? dropDownMarutiValue;
  FormFieldController<String>? dropDownMarutiValueController;
  // State field(s) for DropDownHyundai widget.
  String? dropDownHyundaiValue;
  FormFieldController<String>? dropDownHyundaiValueController;
  // State field(s) for DropDownTataMotors widget.
  String? dropDownTataMotorsValue;
  FormFieldController<String>? dropDownTataMotorsValueController;
  // State field(s) for DropDownMahindra widget.
  String? dropDownMahindraValue;
  FormFieldController<String>? dropDownMahindraValueController;
  // State field(s) for DropDownHonda widget.
  String? dropDownHondaValue1;
  FormFieldController<String>? dropDownHondaValueController1;
  // State field(s) for DropDownToyota widget.
  String? dropDownToyotaValue;
  FormFieldController<String>? dropDownToyotaValueController;
  // State field(s) for DropDownKiaMotors widget.
  String? dropDownKiaMotorsValue;
  FormFieldController<String>? dropDownKiaMotorsValueController;
  // State field(s) for DropDownRenault widget.
  String? dropDownRenaultValue;
  FormFieldController<String>? dropDownRenaultValueController;
  // State field(s) for DropDownVolkswagen widget.
  String? dropDownVolkswagenValue;
  FormFieldController<String>? dropDownVolkswagenValueController;
  // State field(s) for DropDownSkoda widget.
  String? dropDownSkodaValue;
  FormFieldController<String>? dropDownSkodaValueController;
  // State field(s) for DropDownNissan widget.
  String? dropDownNissanValue;
  FormFieldController<String>? dropDownNissanValueController;
  // State field(s) for DropDownMG widget.
  String? dropDownMGValue;
  FormFieldController<String>? dropDownMGValueController;
  // State field(s) for DropDownFord widget.
  String? dropDownFordValue;
  FormFieldController<String>? dropDownFordValueController;
  // State field(s) for DropDownMercedesBenz widget.
  String? dropDownMercedesBenzValue;
  FormFieldController<String>? dropDownMercedesBenzValueController;
  // State field(s) for DropDownBMW widget.
  String? dropDownBMWValue;
  FormFieldController<String>? dropDownBMWValueController;
  // State field(s) for DropDownAudi widget.
  String? dropDownAudiValue;
  FormFieldController<String>? dropDownAudiValueController;
  // State field(s) for DropDownJeep widget.
  String? dropDownJeepValue;
  FormFieldController<String>? dropDownJeepValueController;
  // State field(s) for DropDownVolvo widget.
  String? dropDownVolvoValue;
  FormFieldController<String>? dropDownVolvoValueController;
  // State field(s) for DropDownJaguar widget.
  String? dropDownJaguarValue;
  FormFieldController<String>? dropDownJaguarValueController;
  // State field(s) for DropDownLandRover widget.
  String? dropDownLandRoverValue;
  FormFieldController<String>? dropDownLandRoverValueController;
  // State field(s) for DropDownHeroMotoCorp widget.
  String? dropDownHeroMotoCorpValue;
  FormFieldController<String>? dropDownHeroMotoCorpValueController;
  // State field(s) for DropDownHonda widget.
  String? dropDownHondaValue2;
  FormFieldController<String>? dropDownHondaValueController2;
  // State field(s) for DropDownTVS widget.
  String? dropDownTVSValue;
  FormFieldController<String>? dropDownTVSValueController;
  // State field(s) for DropDownBajajAuto widget.
  String? dropDownBajajAutoValue;
  FormFieldController<String>? dropDownBajajAutoValueController;
  // State field(s) for DropDownRoyalEnfield widget.
  String? dropDownRoyalEnfieldValue;
  FormFieldController<String>? dropDownRoyalEnfieldValueController;
  // State field(s) for DropDownSuzukiMotorcycle widget.
  String? dropDownSuzukiMotorcycleValue;
  FormFieldController<String>? dropDownSuzukiMotorcycleValueController;
  // State field(s) for DropDownYamaha widget.
  String? dropDownYamahaValue;
  FormFieldController<String>? dropDownYamahaValueController;
  // State field(s) for DropDownKTM widget.
  String? dropDownKTMValue;
  FormFieldController<String>? dropDownKTMValueController;
  // State field(s) for DropDownHusqvarnaOwnedbyKTMbikesassembledinIndia widget.
  String? dropDownHusqvarnaOwnedbyKTMbikesassembledinIndiaValue;
  FormFieldController<String>?
      dropDownHusqvarnaOwnedbyKTMbikesassembledinIndiaValueController;
  // State field(s) for DropDownMahindraTwoWheelers widget.
  String? dropDownMahindraTwoWheelersValue;
  FormFieldController<String>? dropDownMahindraTwoWheelersValueController;
  // State field(s) for DropDownJawaMotorcycles widget.
  String? dropDownJawaMotorcyclesValue;
  FormFieldController<String>? dropDownJawaMotorcyclesValueController;
  // State field(s) for DropDownBMWMotorrad widget.
  String? dropDownBMWMotorradValue;
  FormFieldController<String>? dropDownBMWMotorradValueController;
  // State field(s) for DropDownHarleyDavidson widget.
  String? dropDownHarleyDavidsonValue;
  FormFieldController<String>? dropDownHarleyDavidsonValueController;
  // State field(s) for DropDownTriumphMotorcycles widget.
  String? dropDownTriumphMotorcyclesValue;
  FormFieldController<String>? dropDownTriumphMotorcyclesValueController;
  // State field(s) for DropDownKawasaki widget.
  String? dropDownKawasakiValue;
  FormFieldController<String>? dropDownKawasakiValueController;
  // State field(s) for DropDownDucati widget.
  String? dropDownDucatiValue;
  FormFieldController<String>? dropDownDucatiValueController;
  // State field(s) for DropDownBenelli widget.
  String? dropDownBenelliValue;
  FormFieldController<String>? dropDownBenelliValueController;
  // State field(s) for DropDownMVAgusta widget.
  String? dropDownMVAgustaValue;
  FormFieldController<String>? dropDownMVAgustaValueController;
  // State field(s) for DropDownAprilia widget.
  String? dropDownApriliaValue;
  FormFieldController<String>? dropDownApriliaValueController;
  // State field(s) for DropDownVespaPiaggio widget.
  String? dropDownVespaPiaggioValue;
  FormFieldController<String>? dropDownVespaPiaggioValueController;
  // State field(s) for DropDownOkinawaElectrictwowheelers widget.
  String? dropDownOkinawaElectrictwowheelersValue;
  FormFieldController<String>?
      dropDownOkinawaElectrictwowheelersValueController;
  // State field(s) for DropDownAtherEnergyElectrictwo-wheelers widget.
  String? dropDownAtherEnergyElectrictwoWheelersValue;
  FormFieldController<String>?
      dropDownAtherEnergyElectrictwoWheelersValueController;
  // State field(s) for DropDownRevoltMotorsElectrictwo-wheelers widget.
  String? dropDownRevoltMotorsElectrictwoWheelersValue;
  FormFieldController<String>?
      dropDownRevoltMotorsElectrictwoWheelersValueController;
  // State field(s) for Makeyear widget.
  FocusNode? makeyearFocusNode;
  TextEditingController? makeyearTextController;
  String? Function(BuildContext, String?)? makeyearTextControllerValidator;
  // State field(s) for Vehicleno widget.
  FocusNode? vehiclenoFocusNode;
  TextEditingController? vehiclenoTextController;
  String? Function(BuildContext, String?)? vehiclenoTextControllerValidator;
  // State field(s) for ChasisNo widget.
  FocusNode? chasisNoFocusNode;
  TextEditingController? chasisNoTextController;
  String? Function(BuildContext, String?)? chasisNoTextControllerValidator;
  // State field(s) for FuelType widget.
  String? fuelTypeValue;
  FormFieldController<String>? fuelTypeValueController;
  // State field(s) for Transmisison widget.
  String? transmisisonValue;
  FormFieldController<String>? transmisisonValueController;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  VechileDetailsRecord? vechileSearch;

  @override
  void initState(BuildContext context) {
    nameTextControllerValidator = _nameTextControllerValidator;
    mobileTextControllerValidator = _mobileTextControllerValidator;
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    mobileFocusNode?.dispose();
    mobileTextController?.dispose();

    makeyearFocusNode?.dispose();
    makeyearTextController?.dispose();

    vehiclenoFocusNode?.dispose();
    vehiclenoTextController?.dispose();

    chasisNoFocusNode?.dispose();
    chasisNoTextController?.dispose();
  }
}
