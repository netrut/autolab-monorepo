import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'search_model.dart';
export 'search_model.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static String routeName = 'search';
  static String routePath = '/search';  

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late SearchModel _model;
  String? _selectedDateFilter;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime get _startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String? _getServiceStatusFromDates(Iterable<DateTime?> dates) {
    final validDates = dates.whereType<DateTime>().toList();
    if (validDates.isEmpty) {
      return null;
    }

    validDates.sort((a, b) => b.compareTo(a));
    final latest = validDates.first;

    if (latest.isAfter(_startOfToday)) {
      return 'upcoming';
    }
    if (latest.isBefore(_startOfToday.subtract(Duration(days: 30)))) {
      return 'completed';
    }
    return 'due';
  }

  bool _matchesServiceFilter(String vehicleServiceStatus) {
    if (_model.selectedServiceFilter == null || _model.selectedServiceFilter == 'all') {
      return true;
    }
    return vehicleServiceStatus == _model.selectedServiceFilter;
  }

  ({String label, Color bgColor, Color textColor}) _statusTagStyle(
      String status) {
    switch (status) {
      case 'upcoming':
        return (
          label: 'Upcoming Service',
          bgColor: Color(0xFFEAF2FF),
          textColor: Color(0xFF2F7DE1),
        );
      case 'completed':
        return (
          label: 'Service Completed',
          bgColor: Color(0xFFE8F7EE),
          textColor: Color(0xFF2F9E56),
        );
      default:
        return (
          label: 'Due Service',
          bgColor: Color(0xFFFFF0DE),
          textColor: Color(0xFFDA8A1D),
        );
    }
  }

  Color _getFilterBgColor(String? filter) {
    switch (filter) {
      case 'due':
        return Color(0xFFFFF0DE);
      case 'upcoming':
        return Color(0xFFEAF2FF);
      case 'completed':
        return Color(0xFFE8F7EE);
      default:
        return Color(0xFFEFEFEF);
    }
  }

  Color _getFilterTextColor(String? filter) {
    switch (filter) {
      case 'due':
        return Color(0xFFDA8A1D);
      case 'upcoming':
        return Color(0xFF2F7DE1);
      case 'completed':
        return Color(0xFF2F9E56);
      default:
        return Color(0xFF2B2B2B);
    }
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final style = _statusTagStyle(status);

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        style.label,
        style: FlutterFlowTheme.of(context).bodySmall.override(
              font: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
              ),
              color: style.textColor,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildServiceFilterChips(BuildContext context) {
    final filterOptions = [
      ('all', 'All Services'),
      ('due', 'Due Services'),
      ('upcoming', 'Upcoming Services'),
      ('completed', 'Service Completed'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
        child: Row(
          children: filterOptions.map((option) {
            final filterValue = option.$1;
            final filterLabel = option.$2;
            final isSelected = _model.selectedServiceFilter == filterValue || 
                (_model.selectedServiceFilter == null && filterValue == 'all');

            return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
              child: FilterChip(
                label: Text(
                  filterLabel,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                        color: isSelected 
                            ? _getFilterTextColor(filterValue == 'all' ? null : filterValue)
                            : Color(0xFF7A7A7A),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _model.selectedServiceFilter = filterValue == 'all' ? null : filterValue;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: _getFilterBgColor(filterValue == 'all' ? null : filterValue),
                side: BorderSide(
                  color: isSelected 
                      ? _getFilterTextColor(filterValue == 'all' ? null : filterValue)
                      : Color(0xFFDCDCDC),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchCardWithFilter(
      BuildContext context, VechileDetailsRecord record) {
    if (record.carBike == 'Car') {
      return StreamBuilder<List<CarServiceRecord>>(
        stream: queryCarServiceRecord(
          queryBuilder: (carServiceRecord) =>
              carServiceRecord.where('vechile_no', isEqualTo: record.vechileNo),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          final status =
              _getServiceStatusFromDates(snapshot.data!.map((e) => e.date));
          if (status == null || !_matchesServiceFilter(status)) {
            return SizedBox.shrink();
          }
          return _buildSearchCard(context, record, status);
        },
      );
    }

    return StreamBuilder<List<BikeServiceRecord>>(
      stream: queryBikeServiceRecord(
        queryBuilder: (bikeServiceRecord) =>
            bikeServiceRecord.where('vechile_no', isEqualTo: record.vechileNo),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        final status =
            _getServiceStatusFromDates(snapshot.data!.map((e) => e.date));
        if (status == null || !_matchesServiceFilter(status)) {
          return SizedBox.shrink();
        }
        return _buildSearchCard(context, record, status);
      },
    );
  }

  Widget _buildSearchCard(
      BuildContext context, VechileDetailsRecord record, String status) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: Container(
        width: double.infinity,
        height: 154.0,
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
        child: Row(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 10.0, 12.0),
              child: Container(
                width: 112.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    record.carBike == 'Car'
                        ? 'assets/images/four-wheeler.png'
                        : 'assets/images/carApp2.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 12.0, 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.vechileNo,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle:
                                  FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                            ),
                            color: Color(0xFF232323),
                            fontSize: 17.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 6.0),
                    _buildStatusChip(context, status),
                    SizedBox(height: 6.0),
                    Text(
                      '${record.carBike} • ${record.mobile}',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0xFF7A7A7A),
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: FFButtonWidget(
                            onPressed: () async {
                              if (record.carBike == 'Car') {
                                context.pushNamed(
                                  ServiceForm2Widget.routeName,
                                  queryParameters: {
                                    'vechileNo': serializeParam(
                                      record.vechileNo,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              } else {
                                context.pushNamed(
                                  ServiceForm1Widget.routeName,
                                  queryParameters: {
                                    'vechileNo': serializeParam(
                                      record.vechileNo,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              }
                            },
                            text: 'Service',
                            options: FFButtonOptions(
                              height: 34.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Color(0xFF1F1F1F),
                              textStyle:
                                  FlutterFlowTheme.of(context).bodySmall.override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        fontSize: 12.5,
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
                              if (record.carBike == 'Car') {
                                context.pushNamed(
                                  HistoryCarWidget.routeName,
                                  queryParameters: {
                                    'vechileNo': serializeParam(
                                      record.vechileNo,
                                      ParamType.String,
                                    ),
                                    'carBike': serializeParam(
                                      record.carBike,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              } else {
                                context.pushNamed(
                                  HistoryBikeWidget.routeName,
                                  queryParameters: {
                                    'vechileNo': serializeParam(
                                      record.vechileNo,
                                      ParamType.String,
                                    ),
                                    'carBike': serializeParam(
                                      record.carBike,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              }
                            },
                            text: 'History',
                            options: FFButtonOptions(
                              height: 34.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Colors.white,
                              textStyle:
                                  FlutterFlowTheme.of(context).bodySmall.override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: Color(0xFF1F1F1F),
                                        fontSize: 12.5,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: Color(0xFF1F1F1F),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          insetPadding: EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Date',
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Due Services Section
                  Text(
                    'Due Service',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFDA8A1D),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _buildFilterOption('Due Today', 'due_today'),
                  _buildFilterOption('Due Yesterday', 'due_yesterday'),
                  _buildFilterOption('Due Last 7 Days', 'due_7days'),
                  _buildFilterOption('Due Last 30 Days', 'due_30days'),
                  SizedBox(height: 20.0),
                  // Upcoming Services Section
                  Text(
                    'Upcoming Services',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F7DE1),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _buildFilterOption('Next 7 Days', 'upcoming_7days'),
                  _buildFilterOption('Next 30 Days', 'upcoming_30days'),
                  SizedBox(height: 20.0),
                  // Service Completed Section
                  Text(
                    'Service Completed',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F9E56),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _buildFilterOption('Completed Yesterday', 'completed_yesterday'),
                  _buildFilterOption('Completed Last 7 Days', 'completed_7days'),
                  _buildFilterOption('Completed Last 30 Days', 'completed_30days'),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Close',
                          style: GoogleFonts.poppins(
                            color: Color(0xFF2F7DE1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, String value) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDateFilter = value;
          });
          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsetsDirectional.fromSTEB(14.0, 12.0, 14.0, 12.0),
          decoration: BoxDecoration(
            color: _selectedDateFilter == value ? Color(0xFFF5F5F5) : Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: _selectedDateFilter == value 
                  ? Color(0xFF2F7DE1)
                  : Color(0xFFDCDCDC),
              width: _selectedDateFilter == value ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
              if (_selectedDateFilter == value)
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF2F7DE1),
                  size: 20.0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());

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
    final searchQuery =
        _model.searchFieldTextController.text.toLowerCase().trim();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF3F3F3),
        appBar: AppBar(
          backgroundColor: Color(0xFFF3F3F3),
          iconTheme: IconThemeData(color: Color(0xFF2A2A2A)),
          automaticallyImplyLeading: true,
          title: Text(
            'SEARCH',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: Color(0xFF1F1F1F),
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        // bottomNavigationBar: MainBottomNavBar(
        //   currentIndex: 2,
        // ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 6.0, 10.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search Vehicles',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF1E1E1E),
                                  fontSize: 30.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      Text(
                        'Find your vehicle and open service or history in one tap',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: Color(0xFF7A7A7A),
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                Container(
                  height: 46.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Color(0xFFDCDCDC),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 8.0, 0.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Color(0xFF8B8B8B),
                          size: 22.0,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _model.searchFieldTextController,
                            focusNode: _model.searchFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.searchFieldTextController',
                              Duration(milliseconds: 350),
                              () {
                                _model.searchText =
                                    _model.searchFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Search vehicle number or mobile',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF8A8A8A),
                                    letterSpacing: 0.0,
                                  ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              suffixIcon: _model.searchFieldTextController!.text
                                      .isNotEmpty
                                  ? InkWell(
                                      onTap: () async {
                                        _model.searchFieldTextController
                                            ?.clear();
                                        _model.searchText = _model
                                            .searchFieldTextController.text;
                                        safeSetState(() {});
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Color(0xFF7A7A7A),
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
                                ),
                            textAlign: TextAlign.start,
                            validator: _model.searchFieldTextControllerValidator
                                .asValidator(context),
                          ),
                        ),
                        InkWell(
                          onTap: () => _showFilterDialog(context),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              Icons.tune_rounded,
                              color: Color(0xFF2A2A2A),
                              size: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.0),
                _buildServiceFilterChips(context),
                SizedBox(height: 14.0),
                Expanded(
                  child: PagedListView<DocumentSnapshot<Object?>?,
                      VechileDetailsRecord>(
                    pagingController: _model.setListViewController(
                      VechileDetailsRecord.collection,
                    ),
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                    primary: false,
                    shrinkWrap: false,
                    reverse: false,
                    scrollDirection: Axis.vertical,
                    builderDelegate:
                        PagedChildBuilderDelegate<VechileDetailsRecord>(
                      firstPageProgressIndicatorBuilder: (_) => Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ),
                      newPageProgressIndicatorBuilder: (_) => Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (_) => Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 40.0, 0.0, 0.0),
                          child: Text(
                            'No vehicles found',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF7A7A7A),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                      itemBuilder: (context, _, listViewIndex) {
                        final record = _model
                            .listViewPagingController!.itemList![listViewIndex];
                        final matchesQuery = searchQuery.isEmpty ||
                            record.vechileNo
                                .toLowerCase()
                                .contains(searchQuery) ||
                            record.carBike
                                .toLowerCase()
                                .contains(searchQuery) ||
                            record.mobile.toLowerCase().contains(searchQuery);

                        if (!matchesQuery) {
                          return SizedBox.shrink();
                        }

                        return _buildSearchCardWithFilter(context, record);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
