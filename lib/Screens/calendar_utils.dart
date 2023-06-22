import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../Model/list_item.dart';

class CalendarUtils {
  final List<ListItem> exams;
  CalendarFormat format = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  CalendarUtils(this.exams);

  void onFormatChanged(CalendarFormat newFormat) {
    format = newFormat;
  }

  void onPageChanged(DateTime newFocusedDay) {
    focusedDay = newFocusedDay;
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay = selectedDay;
    this.focusedDay = focusedDay;
  }

  bool hasSubject(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(date);
    final List<String> datesWithoutTime = exams.map((subject) {
      final DateTime dateTime = subject.date;
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }).toList();
    return datesWithoutTime.any((subjectDate) => subjectDate == formattedDate);
  }
}
