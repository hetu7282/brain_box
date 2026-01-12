// // date_format_extension.dart
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// /// Extension to format a date string from 'yyyy-MM-dd' to 'dd MMM yyyy'.
// extension DateFormatExtension on String {
//   String toDateRangeFormat() {
//     DateFormat inputFormat = DateFormat('yyyy-MM-dd'); // Input format.
//     DateTime start = inputFormat.parse(this); // Parsing the date.
//     DateFormat outputFormat = DateFormat(
//       'dd MMM yyyy',
//     ); // Desired output format.
//     String formattedStart = outputFormat.format(start); // Formatting the date.

//     return formattedStart; // Return the formatted date string.
//   }

//   String toSetFormate() {
//   DateTime dateTime = DateTime.parse(this);
//   String formattedDate = DateFormat("MMM dd, yyyy - hh:mm a").format(dateTime);
//   return formattedDate;
// }
// }

// extension DateTimeExtension on DateTime {
//   String toFormatedString([String format = 'dd/MM/yyyy']) {
//     return DateFormat(format).format(this);
//   }

//   String toFormatedString1([String format = 'yyyy-MM-dd']) {
//     return DateFormat(format).format(this);
//   }

//   String getRelativeDate({bool isFromNotification = false}) {
//     DateTime now = DateTime.now();
//     if (year == now.year && month == now.month && day == now.day) {
//       return "Today${isFromNotification ? ", ${toFormatedString("MMM dd")}" : ""}";
//     } else if (year == now.year && month == now.month && day == now.day - 1) {
//       return "Yesterday${isFromNotification ? ", ${toFormatedString("MMM dd")}" : ""}";
//     } else {
//       return isFromNotification
//           ? toFormatedString('MMM dd')
//           : toFormatedString();
//     }
//   }

//   String get timeAgo {
//     final now = DateTime.now();
//     final difference = now.difference(toLocal());
//     if (difference.inDays > 365) {
//       return '${(difference.inDays / 365).floor()} years ago';
//     } else if (difference.inDays > 30) {
//       return '${(difference.inDays / 30).floor()} months ago';
//     } else if (difference.inDays > 0) {
//       return '${difference.inDays} days ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} hours ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} minutes ago';
//     } else {
//       return 'a moment ago';
//     }
//   }
// }

// extension TimeOnlyExtension on String {
//   String toTimeOnly() {
//     try {
//       final dateTime = DateFormat("yyyy-MM-dd hh:mm a").parse(this);
//       return DateFormat("hh:mm a").format(dateTime);
//     } catch (e) {
//       return this;
//     }
//   }
// }

// extension TimeStringExtensions on String {
//   // Convert a UTC time string to a local time string
//   String toLocalTimeString() {
//     DateTime utcDateTime = DateTime.parse(
//       this,
//     ); // Parse the UTC string to DateTime
//     DateTime localDateTime = utcDateTime.toLocal(); // Convert to local time
//     return DateFormat('hh:mm aa').format(localDateTime); // Format to string
//   }

//   // Convert a local time string to UTC time string
//   String toUTCString() {
//     DateTime localDateTime = DateTime.parse(
//       this,
//     ); // Parse the local string to DateTime
//     DateTime utcDateTime = localDateTime.toUtc(); // Convert to UTC
//     return DateFormat(
//       'yyyy-MM-dd HH:mm:ss',
//     ).format(utcDateTime); // Format to string
//   }
// }

// extension StringDateFormatter on String {
//   /// Converts a string like "2025-05-15" to formatted string like "May 15, 2025"
//   String toFormattedDate([String outputFormat = 'dd-MM-yyyy']) {
//     try {
//       final inputDate = DateTime.parse(this);
//       return DateFormat(outputFormat).format(inputDate);
//     } catch (e) {
//       return this; // return original if parsing fails
//     }
//   }
// }

// String getReadableDuration(DateTime startDate, DateTime endDate) {
//   int totalDays = endDate.difference(startDate).inDays;

//   int months = totalDays ~/ 30;
//   int remainingDays = totalDays % 30;

//   int weeks = remainingDays ~/ 7;
//   int days = remainingDays % 7;

//   List<String> parts = [];

//   if (months > 0) parts.add("$months month${months > 1 ? 's' : ''}");
//   if (weeks > 0) parts.add("$weeks week${weeks > 1 ? 's' : ''}");
//   if (days > 0 && months == 0) parts.add("$days day${days > 1 ? 's' : ''}");

//   return parts.isNotEmpty
//       ? parts.join(' ')
//       : (startDate == endDate)
//       ? '1 day'
//       : '0 days';
// }

// String formatTimeOfDay(TimeOfDay timeOfDay) {
//   final hour = timeOfDay.hour;
//   final minute = timeOfDay.minute;

//   // Format hour and minute to two digits (e.g., 09:05)
//   String formattedHour = hour < 10 ? '0$hour' : '$hour';
//   String formattedMinute = minute < 10 ? '0$minute' : '$minute';

//   return '$formattedHour:$formattedMinute'; // Returns time in HH:mm format
// }
