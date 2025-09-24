import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../theming/colors.dart';
import '../../../../../theming/text_styles.dart';
import '../../bloc/rent_create_bloc.dart';
import '../../bloc/rent_create_event.dart';
import '../../bloc/rent_create_state.dart';

class AvailabilityStep extends StatefulWidget {
  const AvailabilityStep({super.key});

  @override
  State<AvailabilityStep> createState() => _AvailabilityStepState();
}

class _AvailabilityStepState extends State<AvailabilityStep> {
  DateTime _focusedDay = DateTime.now();
  final Set<String> _selectedWeekdays = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentCreateBloc, RentCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildWeekdaySelector(context, state),
              SizedBox(height: 24.h),
              _buildCalendar(context, state),
              SizedBox(height: 24.h),
              _buildSelectedDatesInfo(state),
              SizedBox(height: 100.h), // Space for bottom navigation
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available In',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Modify Date',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdaySelector(BuildContext context, RentCreateState state) {
    const weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available In These Days',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: weekdays.map((weekday) {
            final isSelected = _selectedWeekdays.contains(weekday);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedWeekdays.remove(weekday);
                  } else {
                    _selectedWeekdays.add(weekday);
                  }
                });
                _updateAvailabilityBasedOnWeekdays(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  weekday,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context, RentCreateState state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar<DateTime>(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return state.formData.availableDates.any((date) => isSameDay(date, day));
        },
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
          ),
          weekendStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
          ),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          selectedDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
          ),
          weekendTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
          ),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
          
          final isAlreadySelected = state.formData.availableDates
              .any((date) => isSameDay(date, selectedDay));
          
          if (isAlreadySelected) {
            context.read<RentCreateBloc>().add(RemoveAvailableDateEvent(selectedDay));
          } else {
            context.read<RentCreateBloc>().add(AddAvailableDateEvent(selectedDay));
          }
        },
      ),
    );
  }

  Widget _buildSelectedDatesInfo(RentCreateState state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Dates',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            state.formData.availableDates.isEmpty
                ? 'No dates selected'
                : '${state.formData.availableDates.length} dates selected',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          if (state.formData.availableDates.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'Tip: Select the dates when your property will be available for booking.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _updateAvailabilityBasedOnWeekdays(BuildContext context) {
    final bloc = context.read<RentCreateBloc>();
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 365));
    
    // Clear existing dates
    final currentDates = List<DateTime>.from(bloc.state.formData.availableDates);
    for (final date in currentDates) {
      bloc.add(RemoveAvailableDateEvent(date));
    }
    
    // Add dates based on selected weekdays
    for (var date = now; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      final weekdayName = _getWeekdayName(date.weekday);
      if (_selectedWeekdays.contains(weekdayName)) {
        bloc.add(AddAvailableDateEvent(date));
      }
    }
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }
}
