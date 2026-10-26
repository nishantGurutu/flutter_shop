import 'package:shop/bloc/home_bloc/home_bloc.dart';
import 'package:shop/config/color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchTabButton extends StatelessWidget {
  const MatchTabButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Container(
          height: 40.h,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              _tabItem(
                context: context,
                title: "MEET ME",
                index: 0,
                selectedIndex: state.selectedIndex,
              ),
              _tabItem(
                context: context,
                title: "MY MATCHES",
                index: 1,
                selectedIndex: state.selectedIndex,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tabItem({
    required BuildContext context,
    required String title,
    required int index,
    required int selectedIndex,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<HomeBloc>().add(TabChanged(index));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFB56AFF), Color(0xFF8F4CFF)],
                  )
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}
