import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shop/config/theme/app_theme.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final DateTime? currentDate;
  final Function(DateTime)? onDateSelected;
  final List<DateTime>? markedDates;

  const CustomCalendar({
    super.key,
    this.selectedDate,
    this.currentDate,
    this.onDateSelected,
    this.markedDates,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentMonth;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate;
      });
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasMarkedDate(DateTime date) {
    if (widget.markedDates == null) return false;
    return widget.markedDates!.any((marked) => _isSameDay(marked, date));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Month and Navigation
          _buildHeader(),
          SizedBox(height: 20.h),
          // Weekday Labels
          _buildWeekdayLabels(),
          SizedBox(height: 12.h),
          // Calendar Grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Month/Year Display
        Text(
          DateFormat('MMMM yyyy').format(_currentMonth),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        // Navigation Arrows
        Row(
          children: [
            _buildNavigationArrow(Icons.chevron_left, _previousMonth),
            SizedBox(width: 8.w),
            _buildNavigationArrow(Icons.chevron_right, _nextMonth),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return SizedBox(
          width: 36.w,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: day == 'Sun' || day == 'Sat'
                  ? AppTheme.error
                  : AppTheme.textSecondary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;

    final days = <Widget>[];

    // Empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      days.add(const SizedBox.shrink());
    }

    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected = _selectedDate != null && _isSameDay(date, _selectedDate!);
      final isCurrent = widget.currentDate != null && _isSameDay(date, widget.currentDate!);
      final hasMark = _hasMarkedDate(date);

      days.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
            if (widget.onDateSelected != null) {
              widget.onDateSelected!(date);
            }
          },
          child: _buildDayCell(
            day: day,
            isSelected: isSelected,
            isCurrent: isCurrent,
            hasMark: hasMark,
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 12.h,
      childAspectRatio: 0.8,
      children: days,
    );
  }

  Widget _buildDayCell({
    required int day,
    required bool isSelected,
    required bool isCurrent,
    required bool hasMark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? const Color(0xFF4A9B9B) // Teal color from image
                : isCurrent
                    ? Colors.white
                    : Colors.transparent,
            border: isCurrent && !isSelected
                ? Border.all(
                    color: const Color(0xFF4A9B9B),
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected || isCurrent ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isCurrent
                        ? const Color(0xFF4A9B9B)
                        : AppTheme.textPrimary,
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        // Small dot indicator for marked dates
        if (hasMark && !isSelected)
          Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4A9B9B).withOpacity(0.5),
            ),
          )
        else
          SizedBox(height: 4.w),
      ],
    );
  }
}

// Example usage widget showing the calendar with some marked dates
class CalendarExample extends StatefulWidget {
  const CalendarExample({super.key});

  @override
  State<CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<CalendarExample> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(2024, 4, 23); // Selected date like in image
  }

  @override
  Widget build(BuildContext context) {
    // Example marked dates (with small dots)
    final markedDates = [
      DateTime(2024, 4, 2),
      DateTime(2024, 4, 3),
      DateTime(2024, 4, 6),
      DateTime(2024, 4, 10),
      DateTime(2024, 4, 15),
      DateTime(2024, 4, 22),
      DateTime(2024, 4, 24),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomCalendar(
          selectedDate: _selectedDate,
          currentDate: DateTime(2024, 4, 1), // Current date like in image
          markedDates: markedDates,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ),
    );
  }
}
