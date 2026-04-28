import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'history_car_model.dart';
export 'history_car_model.dart';

class HistoryCarWidget extends StatefulWidget {
  const HistoryCarWidget({
    super.key,
    this.vechileNo,
    this.carBike,
  });

  final String? vechileNo;
  final String? carBike;

  static String routeName = 'historyCar';
  static String routePath = '/historyCar';

  @override
  State<HistoryCarWidget> createState() => _HistoryCarWidgetState();
}

class _HistoryCarWidgetState extends State<HistoryCarWidget> {
  late HistoryCarModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HistoryCarModel());
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
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Color(0xFFF3F3F3),
            iconTheme: IconThemeData(color: Color(0xFF2A2A2A)),
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 45.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF1F1F1F),
                size: 30.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
            title: Text(
              'SERVICE HISTORY',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                    ),
                    color: Color(0xFF1F1F1F),
                    fontSize: 18.0,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Vehicle Header Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: Color(0xFFE4E4E4),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10.0,
                          color: Color(0x14000000),
                          offset: Offset(0.0, 4.0),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                'assets/images/four-wheeler.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    widget.vechileNo,
                                    'Vehicle Number',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                        ),
                                        color: Color(0xFF1F1F1F),
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Car',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        color: Color(0xFF7A7A7A),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: 12.0),
                                FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed(
                                      ServiceForm2Widget.routeName,
                                      queryParameters: {
                                        'vechileNo': serializeParam(
                                          widget.vechileNo,
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  text: 'Service',
                                  options: FFButtonOptions(
                                    height: 36.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    color: Color(0xFF1F1F1F),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),

                  // Service History Header
                  Align(
                    alignment: AlignmentDirectional(-1.0, 0.0),
                    child: Text(
                      'Past Services',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                            color: Color(0xFF1F1F1F),
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  SizedBox(height: 12.0),

                  // Service History List
                  StreamBuilder<List<CarServiceRecord>>(
                    stream: queryCarServiceRecord(
                      queryBuilder: (carServiceRecord) => carServiceRecord
                          .where('vechile_no', isEqualTo: widget.vechileNo)
                          .orderBy('date'),
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
                      List<CarServiceRecord> listViewCarServiceRecordList =
                          snapshot.data!;
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ...listViewCarServiceRecordList.map((listViewCarServiceRecord) {
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                              child: InkWell(
                                onTap: () async {
                                  context.pushNamed(
                                    DetailsCarWidget.routeName,
                                    queryParameters: {
                                      'vechileno': serializeParam(
                                        widget.vechileNo,
                                        ParamType.String,
                                      ),
                                      'date': serializeParam(
                                        listViewCarServiceRecord.date,
                                        ParamType.DateTime,
                                      ),
                                      'data': serializeParam(
                                        listViewCarServiceRecord.reference,
                                        ParamType.DocumentReference,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Container(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 12.0, 16.0, 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dateTimeFormat(
                                            'd MMM, yyyy',
                                            listViewCarServiceRecord.date!,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                color: Color(0xFF1F1F1F),
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF8A8A8A),
                                          size: 16.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
