// turf_models.dart

import 'package:flutter/material.dart';

class TurfShift {
  TimeOfDay start;
  TimeOfDay end;
  double price;

  TurfShift({
    required this.start,
    required this.end,
    this.price = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'start': '${start.hour}:${start.minute}',
      'end': '${end.hour}:${end.minute}',
      'price': price,
    };
  }

  factory TurfShift.fromMap(Map<String, dynamic> map) {
    final startParts = (map['start'] as String).split(':');
    final endParts = (map['end'] as String).split(':');
    
    return TurfShift(
      start: TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      ),
      end: TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      ),
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  String getTimeRange() {
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class TurfDay {
  bool isOpen;
  List<TurfShift> shifts;

  TurfDay({
    this.isOpen = false,
    List<TurfShift>? shifts,
  }) : shifts = shifts ?? [];

  Map<String, dynamic> toMap() {
    return {
      'isOpen': isOpen,
      'shifts': shifts.map((s) => s.toMap()).toList(),
    };
  }

  factory TurfDay.fromMap(Map<String, dynamic> map) {
    return TurfDay(
      isOpen: map['isOpen'] ?? false,
      shifts: (map['shifts'] as List?)
          ?.map((s) => TurfShift.fromMap(s as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}