import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/alert_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_search/text_search.dart';
import 'filter_model.dart';
export 'filter_model.dart';

enum _ServiceGroup {
  due,
  upcoming,
  completed,
}

class _ServiceFilterItem {
  const _ServiceFilterItem({
    required this.label,
    required this.queryValue,
  });

  final String label;
  final String queryValue;
}

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    super.key,
    this.service,
    this.mode,
  });

  final String? service;
  final String? mode;

  static String routeName = 'filter';
  static String routePath = '/filter';

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late FilterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  _ServiceGroup _selectedServiceGroup = _ServiceGroup.due;

  bool get _isVehicleMode => widget.mode == 'vehicle';

  bool get _isLegacyGroupLocked =>
      widget.service == 'due' || widget.service == 'next';

  _ServiceGroup get _lockedLegacyGroup =>
      widget.service == 'next' ? _ServiceGroup.upcoming : _ServiceGroup.due;

  _ServiceGroup get _activeLegacyGroup =>
      _isLegacyGroupLocked ? _lockedLegacyGroup : _selectedServiceGroup;

  Color _groupColor(_ServiceGroup group) {
    switch (group) {
      case _ServiceGroup.due:
        return Color(0xFFDA8A1D);
      case _ServiceGroup.upcoming:
        return Color(0xFF2F7DE1);
      case _ServiceGroup.completed:
        return Color(0xFF2F9E56);
    }
  }

  String _groupTitle(_ServiceGroup group) {
    switch (group) {
      case _ServiceGroup.due:
        return 'Due Services';
      case _ServiceGroup.upcoming:
        return 'Upcoming Services';
      case _ServiceGroup.completed:
        return 'Service Completed';
    }
  }

  List<_ServiceFilterItem> _groupItems(_ServiceGroup group) {
    switch (group) {
      case _ServiceGroup.due:
        return const [
          _ServiceFilterItem(label: 'Today Service Due', queryValue: 'Today'),
          _ServiceFilterItem(
              label: 'Due Service Yesterday', queryValue: 'Yesterday'),
          _ServiceFilterItem(
              label: 'Due Service Last 7 Days', queryValue: 'Last 7 Days'),
          _ServiceFilterItem(
              label: 'Due Service Last 30 Days', queryValue: 'Last 30 Days'),
        ];
      case _ServiceGroup.upcoming:
        return const [
          _ServiceFilterItem(
              label: 'Service Next 7 Days', queryValue: 'Service Next 7 Days'),
          _ServiceFilterItem(
              label: 'Service Next 30 Days',
              queryValue: 'Service Next 30 Days'),
        ];
      case _ServiceGroup.completed:
        return const [
          _ServiceFilterItem(
              label: 'Service Complete Yesterday',
              queryValue: 'Service Complete Yesterday'),
          _ServiceFilterItem(
              label: 'Service Complete Last 7 Days',
              queryValue: 'Service Complete Last 7 Days'),
          _ServiceFilterItem(
              label: 'Service Complete Last 30 Days',
              queryValue: 'Service Complete Last 30 Days'),
        ];
    }
  }

  Widget _buildLegacyGroupChip(BuildContext context, _ServiceGroup group) {
    final isSelected = _activeLegacyGroup == group;
    final color = _groupColor(group);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: _isLegacyGroupLocked
          ? null
          : () {
              setState(() {
                _selectedServiceGroup = group;
              });
            },
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected ? color : Color(0xFFD8D8D8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.0),
            Text(
              _groupTitle(group),
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodySmall.fontStyle,
                    ),
                    color: isSelected ? color : Color(0xFF525252),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegacyFilterOptionTile(
    BuildContext context,
    _ServiceGroup group,
    _ServiceFilterItem item,
  ) {
    final color = _groupColor(group);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        context.pushNamed(
          FilterShowWidget.routeName,
          queryParameters: {
            'today': serializeParam(
              item.queryValue.trim(),
              ParamType.String,
            ),
          }.withoutNulls,
        );
      },
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 10.0, 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Color(0xFFE7E7E7)),
        ),
        child: Row(
          children: [
            Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                item.label,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: Color(0xFF1F1F1F),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.0,
              color: Color(0xFF8A8A8A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, VechileDetailsRecord record) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Color(0xFFE7E7E7)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
        child: Row(
          children: [
            Container(
              width: 112.0,
              height: 112.0,
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: Image.network(
                  record.carBike == 'Car'
                      ? 'https://res.cloudinary.com/dgiioqoop/image/upload/v1748438468/car_actqon.png'
                      : 'https://res.cloudinary.com/dgiioqoop/image/upload/scotty_kitycv.png',
                  fit: BoxFit.contain,
                  alignment: AlignmentDirectional(0.0, 0.0),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF1E1E1E),
                          fontSize: 17.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    record.carBike,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: Color(0xFF6A6A6A),
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Owner: ${record.mobile}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                          color: Color(0xFF8A8A8A),
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 12.0),
                  Align(
                    alignment: AlignmentDirectional(1.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return Dialog(
                              elevation: 0,
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(dialogContext).unfocus();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.8,
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  child: AlertWidget(
                                    chasisNo: record.chasisNo,
                                    vechileNo: record.vechileNo,
                                    mobileNo: record.mobile,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      text: 'Add Service',
                      options: FFButtonOptions(
                        height: 34.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            14.0, 0.0, 14.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFF1F1F1F),
                        textStyle:
                            FlutterFlowTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
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
    _model = createModel(context, () => FilterModel());

    _selectedServiceGroup =
        widget.service == 'next' ? _ServiceGroup.upcoming : _ServiceGroup.due;

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
    if (_isVehicleMode) {
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
              'Vehicle Filter',
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
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 8.0, 10.0, 12.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(color: Color(0xFFE6E6E6)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 16.0,
                          offset: Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 12.0, 12.0, 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filter vehicles by type and number',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF202020),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 12.0),
                          Container(
                            height: 46.0,
                            decoration: BoxDecoration(
                              color: Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 8.0, 0.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF8A8A8A),
                                    size: 22.0,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _model.searchFieldTextController,
                                      focusNode: _model.searchFieldFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.searchFieldTextController',
                                        Duration(milliseconds: 350),
                                        () => safeSetState(() {}),
                                      ),
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Search vehicle number or mobile',
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        contentPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                10.0, 0.0, 10.0, 0.0),
                                        suffixIcon: _model
                                                .searchFieldTextController!
                                                .text
                                                .isNotEmpty
                                            ? InkWell(
                                                onTap: () async {
                                                  _model
                                                      .searchFieldTextController
                                                      ?.clear();
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
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF2B2B2B),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              ChoiceChip(
                                label: Text('All'),
                                selected: _model.selectedVehicleType == 'All',
                                onSelected: (_) => setState(() {
                                  _model.selectedVehicleType = 'All';
                                }),
                              ),
                              ChoiceChip(
                                label: Text('Car'),
                                selected: _model.selectedVehicleType == 'Car',
                                onSelected: (_) => setState(() {
                                  _model.selectedVehicleType = 'Car';
                                }),
                              ),
                              ChoiceChip(
                                label: Text('Bike'),
                                selected: _model.selectedVehicleType == 'Bike',
                                onSelected: (_) => setState(() {
                                  _model.selectedVehicleType = 'Bike';
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Expanded(
                    child: StreamBuilder<List<VechileDetailsRecord>>(
                      stream: queryVechileDetailsRecord(
                        queryBuilder: (vechileDetailsRecord) =>
                            vechileDetailsRecord
                                .where(
                                  'mobile',
                                  isNotEqualTo: currentPhoneNumber,
                                )
                                .orderBy('name'),
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

                        final searchQuery = _model
                            .searchFieldTextController.text
                            .toLowerCase()
                            .trim();
                        final filteredRecords = snapshot.data!.where((record) {
                          final matchesType =
                              _model.selectedVehicleType == 'All' ||
                                  record.carBike == _model.selectedVehicleType;
                          final matchesSearch = searchQuery.isEmpty ||
                              record.vechileNo
                                  .toLowerCase()
                                  .contains(searchQuery) ||
                              record.mobile
                                  .toLowerCase()
                                  .contains(searchQuery) ||
                              record.carBike
                                  .toLowerCase()
                                  .contains(searchQuery);
                          return matchesType && matchesSearch;
                        }).toList();

                        if (filteredRecords.isEmpty) {
                          return Center(
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
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filteredRecords.length,
                          itemBuilder: (context, index) {
                            return _buildVehicleCard(
                              context,
                              filteredRecords[index],
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
        ),
      );
    }

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
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: Colors.white,
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xFF2A2A2A),
                size: 24.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 16.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.95,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  width: 2.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 8.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4.0, 0.0, 4.0, 0.0),
                                      child: Icon(
                                        Icons.search_rounded,
                                        color: Color(0xFF95A1AC),
                                        size: 24.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4.0, 0.0, 0.0, 0.0),
                                        child: TextFormField(
                                          controller:
                                              _model.searchFieldTextController,
                                          focusNode:
                                              _model.searchFieldFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            '_model.searchFieldTextController',
                                            Duration(milliseconds: 2000),
                                            () => safeSetState(() {}),
                                          ),
                                          onFieldSubmitted: (_) async {
                                            await queryBikeServiceRecordOnce()
                                                .then(
                                                  (records) => _model
                                                          .simpleSearchResults =
                                                      TextSearch(
                                                    records
                                                        .map(
                                                          (record) =>
                                                              TextSearchItem
                                                                  .fromTerms(
                                                                      record, [
                                                            record.engineOil,
                                                            record.airFilter,
                                                            record.oilFilter,
                                                            record.sparkPlug,
                                                            record.selfStart,
                                                            record.bikeWash,
                                                            record.brakePads,
                                                            record.breakDisc,
                                                            record.lightsSignal,
                                                            record.clutchWire,
                                                            record.battery,
                                                            record.driveChain,
                                                            record.horn,
                                                            record.unusalNoise,
                                                            record.wash
                                                          ]),
                                                        )
                                                        .toList(),
                                                  )
                                                          .search('')
                                                          .map((r) => r.object)
                                                          .toList(),
                                                )
                                                .onError((_, __) => _model
                                                    .simpleSearchResults = [])
                                                .whenComplete(
                                                    () => safeSetState(() {}));
                                          },
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Search ',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            suffixIcon: _model
                                                    .searchFieldTextController!
                                                    .text
                                                    .isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      _model
                                                          .searchFieldTextController
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
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Color(0xFF95A1AC),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          textAlign: TextAlign.start,
                                          validator: _model
                                              .searchFieldTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.tune_rounded,
                                      color: Colors.black,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, -1.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 770.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(color: Color(0xFFE6E6E6)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x0D000000),
                                    blurRadius: 16.0,
                                    offset: Offset(0.0, 5.0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 12.0, 12.0, 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Filter Services',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF202020),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(height: 10.0),
                                    if (!_isLegacyGroupLocked)
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            _buildLegacyGroupChip(
                                                context, _ServiceGroup.due),
                                            SizedBox(width: 8.0),
                                            _buildLegacyGroupChip(context,
                                                _ServiceGroup.upcoming),
                                            SizedBox(width: 8.0),
                                            _buildLegacyGroupChip(context,
                                                _ServiceGroup.completed),
                                          ],
                                        ),
                                      ),
                                    if (_isLegacyGroupLocked)
                                      Row(
                                        children: [
                                          Container(
                                            width: 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              color: _groupColor(
                                                  _activeLegacyGroup),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            _groupTitle(_activeLegacyGroup),
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: _groupColor(
                                                      _activeLegacyGroup),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    SizedBox(height: 12.0),
                                    ..._groupItems(_activeLegacyGroup)
                                        .map(
                                          (item) =>
                                              _buildLegacyFilterOptionTile(
                                            context,
                                            _activeLegacyGroup,
                                            item,
                                          ),
                                        )
                                        .toList()
                                        .divide(SizedBox(height: 10.0)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
