import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theming/colors.dart';
import '../../../../theming/text_styles.dart';

class PropertyAvailabilityStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrevious;
  final Map<String, dynamic> initialData;

  const PropertyAvailabilityStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.initialData,
  });

  @override
  State<PropertyAvailabilityStep> createState() =>
      _PropertyAvailabilityStepState();
}

class _PropertyAvailabilityStepState extends State<PropertyAvailabilityStep> {
  DateTime _currentMonth = DateTime.now();
  Map<DateTime, bool> _availableDays = {};
  Map<DateTime, double> _dayPrices = {};

  final List<String> _weekDays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // Quick select buttons
  final List<String> _quickSelectDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  Set<String> _selectedQuickDays = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _initializeDefaultAvailability();
  }

  void _loadInitialData() {
    if (widget.initialData['availabilityData'] != null) {
      Map<String, dynamic> availabilityData =
          widget.initialData['availabilityData'];
      _availableDays = Map<DateTime, bool>.from(
        availabilityData['availableDays'] ?? {},
      );
      _dayPrices = Map<DateTime, double>.from(
        availabilityData['dayPrices'] ?? {},
      );
      _selectedQuickDays = Set<String>.from(
        availabilityData['selectedQuickDays'] ?? {},
      );
    }
  }

  void _initializeDefaultAvailability() {
    // Set some default available days for demonstration
    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final date = DateTime(now.year, now.month, now.day + i);
      if ([
        DateTime.tuesday,
        DateTime.thursday,
        DateTime.friday,
      ].contains(date.weekday)) {
        _availableDays[_normalizeDate(date)] = true;
        _dayPrices[_normalizeDate(date)] =
            0.0; // Default price, will be set later
      }
    }

    // Set quick select defaults
    _selectedQuickDays = {'Tuesday', 'Thursday', 'Friday'};
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _toggleDayAvailability(DateTime date) {
    setState(() {
      final normalizedDate = _normalizeDate(date);
      if (_availableDays[normalizedDate] == true) {
        _availableDays.remove(normalizedDate);
        _dayPrices.remove(normalizedDate);
      } else {
        _availableDays[normalizedDate] = true;
        _dayPrices[normalizedDate] = 0.0;
      }
    });
  }

  void _toggleQuickSelectDay(String day) {
    setState(() {
      if (_selectedQuickDays.contains(day)) {
        _selectedQuickDays.remove(day);
        // Remove all days of this weekday from availability
        _removeWeekdayFromAvailability(day);
      } else {
        _selectedQuickDays.add(day);
        // Add all days of this weekday to availability for the next month
        _addWeekdayToAvailability(day);
      }
    });
  }

  void _removeWeekdayFromAvailability(String dayName) {
    final weekdayIndex = _quickSelectDays.indexOf(dayName);
    final now = DateTime.now();

    for (int i = 0; i < 60; i++) {
      // Check next 60 days
      final date = DateTime(now.year, now.month, now.day + i);
      if (date.weekday % 7 == weekdayIndex) {
        final normalizedDate = _normalizeDate(date);
        _availableDays.remove(normalizedDate);
        _dayPrices.remove(normalizedDate);
      }
    }
  }

  void _addWeekdayToAvailability(String dayName) {
    final weekdayIndex = _quickSelectDays.indexOf(dayName);
    final now = DateTime.now();

    for (int i = 0; i < 60; i++) {
      // Check next 60 days
      final date = DateTime(now.year, now.month, now.day + i);
      if (date.weekday % 7 == weekdayIndex) {
        final normalizedDate = _normalizeDate(date);
        _availableDays[normalizedDate] = true;
        _dayPrices[normalizedDate] = 0.0;
      }
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

  void _handleNext() {
    if (_availableDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one available day'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Prepare availability data for API
    List<Map<String, dynamic>> availabilityList = _availableDays.entries.map((
      entry,
    ) {
      return {
        'date':
            '${entry.key.year}-${entry.key.month.toString().padLeft(2, '0')}-${entry.key.day.toString().padLeft(2, '0')}',
        'isAvailable': entry.value,
        'price': _dayPrices[entry.key] ?? 0.0,
        'note': '',
      };
    }).toList();

    final data = {
      'availabilityList': availabilityList,
      'availabilityData': {
        'availableDays': _availableDays,
        'dayPrices': _dayPrices,
        'selectedQuickDays': _selectedQuickDays,
      },
    };

    widget.onNext(data);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modify Date button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available In These Days',
                        style: AppTextStyles.h5.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Modify Date',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Quick select days
                  _buildQuickSelectDays(),

                  SizedBox(height: 24.h),

                  // Calendar
                  _buildCalendar(),

                  SizedBox(height: 100.h), // Space for floating button
                ],
              ),
            ),
          ),

          // Next button
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildQuickSelectDays() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _quickSelectDays.map((day) {
        final isSelected = _selectedQuickDays.contains(day);
        return GestureDetector(
          onTap: () => _toggleQuickSelectDay(day),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              day,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Calendar header
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: Icon(
                    Icons.chevron_left,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                ),
                Text(
                  '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                  style: AppTextStyles.h5.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),

          // Week days header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weekDays.map((day) {
                return Container(
                  width: 32.w,
                  height: 32.h,
                  child: Center(
                    child: Text(
                      day,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container(width: 32.w, height: 32.h));
    }

    // Add days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final normalizedDate = _normalizeDate(date);
      final isAvailable = _availableDays[normalizedDate] == true;
      final isToday = _normalizeDate(DateTime.now()) == normalizedDate;
      final isPast = date.isBefore(
        DateTime.now().subtract(const Duration(days: 1)),
      );

      dayWidgets.add(
        GestureDetector(
          onTap: isPast ? null : () => _toggleDayAvailability(date),
          child: Container(
            width: 32.w,
            height: 32.h,
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isAvailable
                  ? Colors.green
                  : (isToday
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent),
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(color: AppColors.primary, width: 1)
                  : null,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: isAvailable
                      ? Colors.white
                      : (isPast ? Colors.grey[400] : Colors.black),
                  fontWeight: isAvailable ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Organize into rows of 7
    List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayWidgets.sublist(
              i,
              i + 7 > dayWidgets.length ? dayWidgets.length : i + 7,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...rows,
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildNextButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      child: FloatingActionButton.extended(
        onPressed: _handleNext,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        label: Icon(Icons.arrow_forward, color: Colors.white, size: 24.sp),
      ),
    );
  }
}
