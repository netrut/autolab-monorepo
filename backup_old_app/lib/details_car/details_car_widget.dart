import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'details_car_model.dart';
export 'details_car_model.dart';

class DetailsCarWidget extends StatefulWidget {
  const DetailsCarWidget({
    super.key,
    this.vechileno,
    this.date,
    this.data,
  });

  final String? vechileno;
  final DateTime? date;
  final DocumentReference? data;

  static String routeName = 'detailsCar';
  static String routePath = '/detailsCar';

  @override
  State<DetailsCarWidget> createState() => _DetailsCarWidgetState();
}

class _DetailsCarWidgetState extends State<DetailsCarWidget> {
  late DetailsCarModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildServiceField(String label, String value) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Color(0xFFE8E8E8),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                      color: Color(0xFF1F1F1F),
                      fontSize: 14.0,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            SizedBox(width: 12.0),
            Text(
              value,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                    color: Color(0xFF7A7A7A),
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetailsCarModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF3F3F3),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: AppBar(
            backgroundColor: Color(0xFFF3F3F3),
            automaticallyImplyLeading: false,
            actions: [],
            centerTitle: false,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Form(
            key: _model.formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: StreamBuilder<List<CarServiceRecord>>(
              stream: queryCarServiceRecord(
                queryBuilder: (carServiceRecord) => carServiceRecord.where(
                  'date',
                  isEqualTo: widget.date,
                ),
                singleRecord: true,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  );
                }
                List<CarServiceRecord> columnCarServiceRecordList =
                    snapshot.data!;
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                final columnCarServiceRecord =
                    columnCarServiceRecordList.isNotEmpty
                        ? columnCarServiceRecordList.first
                        : null;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Header Card
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2F7DE1), Color(0xFF1F4FA8)],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(0.0, -1.0),
                              end: AlignmentDirectional(0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.0,
                                color: Color(0x1F000000),
                                offset: Offset(0.0, 4.0),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 20.0, 16.0, 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Car Service',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        color: Color(0xFFE0E0E0),
                                        fontSize: 12.0,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  dateTimeFormat(
                                    'd MMMM, yyyy',
                                    columnCarServiceRecord!.date!,
                                    locale:
                                        FFLocalizations.of(context).languageCode,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                        ),
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),

                        // Service Details
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Text(
                            'Service Checklist',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: Color(0xFF1F1F1F),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        _buildServiceField('1. Engine Oil', columnCarServiceRecord.engineOil),
                        SizedBox(height: 10.0),
                        _buildServiceField('2. Coolant', columnCarServiceRecord.coolant),
                        SizedBox(height: 10.0),
                        _buildServiceField('3. Air Filter', columnCarServiceRecord.airfilter),
                        SizedBox(height: 10.0),
                        _buildServiceField('4. Oil Filter', columnCarServiceRecord.oilFilter),
                        SizedBox(height: 10.0),
                        _buildServiceField('5. AC Filter', columnCarServiceRecord.acFilter),
                        SizedBox(height: 10.0),
                        _buildServiceField('6. Car Wash', columnCarServiceRecord.carWash),
                        SizedBox(height: 10.0),
                        _buildServiceField('7. Break Pads', columnCarServiceRecord.breakPads),
                        SizedBox(height: 10.0),
                        _buildServiceField('8. Break Disc', columnCarServiceRecord.breakDisc),
                        SizedBox(height: 10.0),
                        _buildServiceField('9. Lights Signal', columnCarServiceRecord.lightsSignal),
                        SizedBox(height: 10.0),
                        _buildServiceField('10. Break Fluid', columnCarServiceRecord.breakFluid),
                        SizedBox(height: 10.0),
                        _buildServiceField('11. Gear Fluid', columnCarServiceRecord.gearFluid),
                        SizedBox(height: 10.0),
                        _buildServiceField('12. Wiper Blades', columnCarServiceRecord.wiperBlades),
                        SizedBox(height: 10.0),
                        _buildServiceField('13. Battery', columnCarServiceRecord.battery),
                        SizedBox(height: 10.0),
                        _buildServiceField('14. Suspension', columnCarServiceRecord.suspension),
                        SizedBox(height: 10.0),
                        _buildServiceField('15. Dashboard Warning Light', columnCarServiceRecord.dashboarWarningLight),

                        SizedBox(height: 32.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
