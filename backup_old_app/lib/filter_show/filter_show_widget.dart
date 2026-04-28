import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'filter_show_model.dart';
export 'filter_show_model.dart';

class FilterShowWidget extends StatefulWidget {
  const FilterShowWidget({
    super.key,
    this.today,
    this.yesterday,
    this.last7Days,
    this.last30days,
    this.next7days,
    this.next30days,
    this.completeYesterday,
    this.completelast7Days,
    this.completelast30Days,
  });

  final String? today;
  final String? yesterday;
  final String? last7Days;
  final String? last30days;
  final String? next7days;
  final String? next30days;
  final String? completeYesterday;
  final String? completelast7Days;
  final String? completelast30Days;

  static String routeName = 'filterShow';
  static String routePath = '/filterShow';

  @override
  State<FilterShowWidget> createState() => _FilterShowWidgetState();
}

class _FilterShowWidgetState extends State<FilterShowWidget> {
  late FilterShowModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String get _activeFilter {
    final rawFilter = widget.today ??
        widget.yesterday ??
        widget.last7Days ??
        widget.last30days ??
        widget.next7days ??
        widget.next30days ??
        widget.completeYesterday ??
        widget.completelast7Days ??
        widget.completelast30Days;

    if (rawFilter == null || rawFilter.trim().isEmpty) {
      return 'Today';
    }

    return rawFilter.trim();
  }

  DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  DateTimeRange _dateRangeFor(String filter) {
    final now = DateTime.now();
    final today = _startOfDay(now);
    final tomorrow = today.add(Duration(days: 1));

    switch (filter) {
      case 'Today':
        return DateTimeRange(start: today, end: tomorrow);
      case 'Yesterday':
      case 'Service Complete Yesterday':
        final yesterday = today.subtract(Duration(days: 1));
        return DateTimeRange(start: yesterday, end: today);
      case 'Last 7 Days':
      case 'Service Complete Last 7 Days':
        return DateTimeRange(
          start: today.subtract(Duration(days: 6)),
          end: tomorrow,
        );
      case 'Last 30 Days':
      case 'Service Complete Last 30 Days':
        return DateTimeRange(
          start: today.subtract(Duration(days: 29)),
          end: tomorrow,
        );
      case 'Service Next 7 Days':
        return DateTimeRange(
          start: tomorrow,
          end: tomorrow.add(Duration(days: 7)),
        );
      case 'Service Next 30 Days':
        return DateTimeRange(
          start: tomorrow,
          end: tomorrow.add(Duration(days: 30)),
        );
      default:
        return DateTimeRange(start: today, end: tomorrow);
    }
  }

  bool _matchesSearch(String vehicleNo, String searchQuery) {
    if (searchQuery.isEmpty) {
      return true;
    }

    return vehicleNo.toLowerCase().contains(searchQuery);
  }

  Widget _buildNoDataState(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 20.0),
        padding: EdgeInsetsDirectional.fromSTEB(18.0, 24.0, 18.0, 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Color(0xFFE8E8E8)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: Color(0xFF8A8A8A),
              size: 42.0,
            ),
            SizedBox(height: 10.0),
            Text(
              'No data available for this filter',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
                    color: Color(0xFF232323),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 6.0),
            Text(
              'Try another filter or check your data in Firestore.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: Color(0xFF7A7A7A),
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 6.0, 16.0, 8.0),
      child: Text(
        title,
        style: FlutterFlowTheme.of(context).titleMedium.override(
              font: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
              color: Color(0xFF1F1F1F),
              letterSpacing: 0.0,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _buildCarServiceCard(BuildContext context, CarServiceRecord record) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 10.0),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: Color(0xFFE4E4E4)),
        ),
        child: Row(
          children: [
            Container(
              width: 96.0,
              height: 96.0,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
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
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.vechileNo,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF222222),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    dateTimeFormat('d/M/y', record.date),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                          color: Color(0xFF7A7A7A),
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(
                              ServiceForm2Widget.routeName,
                              queryParameters: {
                                'vechileNo': serializeParam(
                                  record.vechileNo,
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          },
                          text: 'Service',
                          options: FFButtonOptions(
                            height: 34.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            color: Color(0xFF1F1F1F),
                            textStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(
                              HistoryCarWidget.routeName,
                              queryParameters: {
                                'vechileNo': serializeParam(
                                  record.vechileNo,
                                  ParamType.String,
                                ),
                                'carBike': serializeParam(
                                  'Car',
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          },
                          text: 'History',
                          options: FFButtonOptions(
                            height: 34.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            color: Colors.white,
                            textStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF1F1F1F),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                            elevation: 0.0,
                            borderSide: BorderSide(color: Color(0xFF1F1F1F)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBikeServiceCard(BuildContext context, BikeServiceRecord record) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 10.0),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: Color(0xFFE4E4E4)),
        ),
        child: Row(
          children: [
            Container(
              width: 96.0,
              height: 96.0,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/images/two-wheeler.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.vechileNo,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF222222),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    dateTimeFormat('d/M/y', record.date),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                          color: Color(0xFF7A7A7A),
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(
                              ServiceForm1Widget.routeName,
                              queryParameters: {
                                'vechileNo': serializeParam(
                                  record.vechileNo,
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          },
                          text: 'Service',
                          options: FFButtonOptions(
                            height: 34.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            color: Color(0xFF1F1F1F),
                            textStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(
                              HistoryBikeWidget.routeName,
                              queryParameters: {
                                'vechileNo': serializeParam(
                                  record.vechileNo,
                                  ParamType.String,
                                ),
                                'carBike': serializeParam(
                                  'Bike',
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          },
                          text: 'History',
                          options: FFButtonOptions(
                            height: 34.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            color: Colors.white,
                            textStyle:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF1F1F1F),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                            elevation: 0.0,
                            borderSide: BorderSide(color: Color(0xFF1F1F1F)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
    _model = createModel(context, () => FilterShowModel());

    _model.searchFieldTextController ??= TextEditingController();
    _model.searchFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFilter = _activeFilter;
    final selectedRange = _dateRangeFor(selectedFilter);
    final searchQuery =
        _model.searchFieldTextController.text.toLowerCase().trim();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF6F6F6),
        appBar: AppBar(
          backgroundColor: Color(0xFFF6F6F6),
          iconTheme: IconThemeData(color: Color(0xFF2A2A2A)),
          automaticallyImplyLeading: true,
          title: Text(
            selectedFilter,
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: Color(0xFF1F1F1F),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w700,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 46.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Color(0xFFE1E1E1),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: Color(0xFF8A8A8A),
                            size: 22.0,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  4.0, 0.0, 0.0, 0.0),
                              child: TextFormField(
                                controller: _model.searchFieldTextController,
                                focusNode: _model.searchFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.searchFieldTextController',
                                  Duration(milliseconds: 300),
                                  () => safeSetState(() {}),
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Search vehicle number',
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  suffixIcon: _model.searchFieldTextController!
                                          .text.isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            _model.searchFieldTextController
                                                ?.clear();
                                            safeSetState(() {});
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: 20.0,
                                          ),
                                        )
                                      : null,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0xFF2B2B2B),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                textAlign: TextAlign.start,
                                validator: _model
                                    .searchFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: StreamBuilder<List<CarServiceRecord>>(
                  stream: queryCarServiceRecord(
                    queryBuilder: (carServiceRecord) => carServiceRecord
                        .where(
                          'date',
                          isGreaterThanOrEqualTo: selectedRange.start,
                        )
                        .where(
                          'date',
                          isLessThan: selectedRange.end,
                        )
                        .orderBy('date', descending: true),
                  ),
                  builder: (context, carSnapshot) {
                    if (!carSnapshot.hasData) {
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

                    final filteredCars = carSnapshot.data!
                        .where((record) =>
                            _matchesSearch(record.vechileNo, searchQuery))
                        .toList();

                    return StreamBuilder<List<BikeServiceRecord>>(
                      stream: queryBikeServiceRecord(
                        queryBuilder: (bikeServiceRecord) => bikeServiceRecord
                            .where(
                              'date',
                              isGreaterThanOrEqualTo: selectedRange.start,
                            )
                            .where(
                              'date',
                              isLessThan: selectedRange.end,
                            )
                            .orderBy('date', descending: true),
                      ),
                      builder: (context, bikeSnapshot) {
                        if (!bikeSnapshot.hasData) {
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

                        final filteredBikes = bikeSnapshot.data!
                            .where((record) =>
                                _matchesSearch(record.vechileNo, searchQuery))
                            .toList();

                        if (filteredCars.isEmpty && filteredBikes.isEmpty) {
                          return _buildNoDataState(context);
                        }

                        return ListView(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 20.0),
                          children: [
                            if (filteredCars.isNotEmpty)
                              _buildSectionTitle(context, 'Car Services'),
                            ...filteredCars
                                .map((record) =>
                                    _buildCarServiceCard(context, record))
                                .toList(),
                            if (filteredBikes.isNotEmpty)
                              _buildSectionTitle(context, 'Bike Services'),
                            ...filteredBikes
                                .map((record) =>
                                    _buildBikeServiceCard(context, record))
                                .toList(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
