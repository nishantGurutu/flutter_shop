import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shop/bloc/booking_bloc/booking_bloc.dart';
import 'package:shop/config/color/app_color.dart';
import 'package:shop/model/professional/professional_model.dart';

class BookingAppointmentScreen extends StatefulWidget {
  final ProfessionalModel? professional;
  const BookingAppointmentScreen({super.key, this.professional});

  @override
  State<BookingAppointmentScreen> createState() =>
      _BookingAppointmentScreenState();
}

class _BookingAppointmentScreenState extends State<BookingAppointmentScreen> {
  final List<String> timeSlots = [
    '08:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '12:00 PM - 02:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingBloc(),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F9FC),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1E50CE),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Book Appointment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                _buildStepper(state.currentStep),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          if (state.currentStep == 0)
                            ..._buildScheduleStep(context, state),
                          if (state.currentStep == 1)
                            const Center(child: Text('Address Step Content')),
                          if (state.currentStep == 2)
                            const Center(child: Text('Payment Step Content')),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildProceedButton(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepper(int currentStep) {
    return Container(
      color: const Color(0xFF1E50CE),
      padding: EdgeInsets.only(bottom: 20.h, left: 16.w, right: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem('Schedule', 0, currentStep, isFirst: true),
          _buildStepItem('Address', 1, currentStep),
          _buildStepItem('Payment', 2, currentStep, isLast: true),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    String title,
    int stepIndex,
    int currentStep, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    bool isActive = stepIndex <= currentStep;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            '${stepIndex + 1}. $title',
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScheduleStep(BuildContext context, BookingState state) {
    return [
      _buildSectionCard(
        title: 'Select Date',
        icon: Icons.calendar_today,
        child: _buildDateSelector(context, state),
      ),
      SizedBox(height: 16.h),
      _buildSectionCard(
        title: 'Select Time Slot',
        icon: Icons.access_time,
        child: _buildTimeSlotSelector(context, state),
      ),
      SizedBox(height: 16.h),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ListTile(
          leading: Icon(
            Icons.local_offer_outlined,
            color: const Color(0xFF1E50CE),
            size: 24.sp,
          ),
          title: Text(
            'Apply Coupon',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: Colors.grey.shade400,
          ),
          onTap: () {},
        ),
      ),
    ];
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20.sp, color: Colors.grey.shade600),
                    SizedBox(width: 8.w),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(padding: EdgeInsets.all(16.w), child: child),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, BookingState state) {
    final now = DateTime.now();
    return SizedBox(
      height: 70.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));
          final isSelected =
              state.selectedDate?.day == date.day &&
              state.selectedDate?.month == date.month;
          return GestureDetector(
            onTap: () => context.read<BookingBloc>().add(SelectDateEvent(date)),
            child: Container(
              width: 50.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1E50CE) : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E50CE)
                      : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlotSelector(BuildContext context, BookingState state) {
    return Column(
      children: timeSlots.map((slot) {
        final isSelected = state.selectedTimeSlot == slot;
        return GestureDetector(
          onTap: () =>
              context.read<BookingBloc>().add(SelectTimeSlotEvent(slot)),
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isSelected ? Colors.green : Colors.grey.shade400,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      slot,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.darkText,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProceedButton(BuildContext context, BookingState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed:
              (state.selectedDate != null && state.selectedTimeSlot != null)
              ? () {
                  context.read<BookingBloc>().add(
                    ProceedToNextStepEvent(professional: widget.professional),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E50CE),
            disabledBackgroundColor: Colors.grey.shade300,
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Proceed',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
