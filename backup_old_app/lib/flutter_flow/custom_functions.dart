import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

DateTime? getStartOfToday() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day); // Midnight today
}

DateTime? getStartOfTomorrow() {
  DateTime now = DateTime.now();
  DateTime tomorrow =
      DateTime(now.year, now.month, now.day).add(Duration(days: 1));
  return tomorrow; // Midnight tomorrow
}

DateTime? getStartOfYesterday() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day).subtract(Duration(days: 1));
}

DateTime? getStartDateForFilter(String filter) {
  DateTime now = DateTime.now();
  DateTime startDate;

  switch (filter) {
    case "Today":
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
      break;

    case "Yesterday":
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0)
          .subtract(Duration(days: 1));
      break;

    case "Last 7 Days":
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0)
          .subtract(Duration(days: 7));
      break;

    case "Last 30 Days":
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0)
          .subtract(Duration(days: 30));
      break;

    case "Service Next 7 Days":
      startDate = now.add(Duration(days: 1)); // Start from tomorrow
      break;

    case "Service Next 30 Days":
      startDate = now.add(Duration(days: 1)); // Start from tomorrow
      break;

    case "Service Complete Yesterday":
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0)
          .subtract(Duration(days: 1));
      break;

    case "Service Complete Last 7 Days":
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0)
          .subtract(Duration(days: 7));
      break;

    case "Service Complete Last 30 Days":
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0)
          .subtract(Duration(days: 30));
      break;

    default:
      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
  }

  return startDate;
}
