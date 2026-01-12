import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_cubit.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CustomTabBarWidget extends StatefulWidget {
  final List<String> tabTitles;
  final Function(int) onTabIndexChange;

  const CustomTabBarWidget({
    super.key,
    required this.tabTitles,
    required this.onTabIndexChange,
  });

  @override
  State<CustomTabBarWidget> createState() => _CustomTabBarWidgetState();
}

class _CustomTabBarWidgetState extends State<CustomTabBarWidget> {
  List<String> _tabTitles = [];
  List<GlobalKey> _tabKeys = [];
  ValueNotifier<List<double>> _tabWidths = ValueNotifier([]);
  ValueNotifier<List<double>> _tabOffsets = ValueNotifier([]);
  final ValueNotifier<int> _activeIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _tabTitles = widget.tabTitles;
    _tabKeys = List.generate(_tabTitles.length, (_) => GlobalKey());
    _tabWidths = ValueNotifier(List.filled(_tabTitles.length, 0.0));
    _tabOffsets = ValueNotifier(List.filled(_tabTitles.length, 0.0));
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateTabSizes());
  }

  void _calculateTabSizes() {
    double totalWidth = 0.0;
    final widths = List.filled(_tabTitles.length, 0.0);
    final offsets = List.filled(_tabTitles.length, 0.0);
    for (int i = 0; i < _tabTitles.length; i++) {
      final RenderBox? renderBox =
          _tabKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        widths[i] = renderBox.size.width;
        offsets[i] = totalWidth;
        totalWidth += renderBox.size.width;
      }
    }
    _tabWidths.value = widths;
    _tabOffsets.value = offsets;
  }

  void _onTabTapped(int index, BuildContext context) {
    _activeIndex.value = index;
    final bool enabled = context.read<HapticsCubit>().state.enabled;
    AudioService.instance.triggerInteractionFeedback(hapticsEnabled: enabled);
    widget.onTabIndexChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          height: 50.px,
          padding: EdgeInsets.symmetric(vertical: 5.px, horizontal: 8.px),
          decoration: BoxDecoration(
            color: AppColor.primary.withOpacityValue(0.08),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: ValueListenableBuilder(
            valueListenable: _activeIndex,
            builder: (context, activeIndex, _) {
              return Stack(
                children: [
                  // Sliding indicator
                  ValueListenableBuilder(
                    valueListenable: _tabWidths,
                    builder: (context, widths, _) {
                      return ValueListenableBuilder(
                        valueListenable: _tabOffsets,
                        builder: (context, offsets, _) {
                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            left: offsets.isNotEmpty
                                ? offsets[activeIndex]
                                : 0.0,
                            width: widths.isNotEmpty
                                ? widths[activeIndex]
                                : 0.0,
                            height: 40.px,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(50.px),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.k6A6262.withOpacityValue(
                                      0.1,
                                    ),
                                    spreadRadius: 2,
                                    blurRadius: 5.px,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Tab buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_tabTitles.length, (index) {
                      final bool isSelected = activeIndex == index;
                      return Expanded(
                        child: InkWell(
                          key: _tabKeys[index],
                          onTap: () => _onTabTapped(index, context),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 8.px),
                            child: CustomText(
                              text: _tabTitles[index],
                              color: isSelected
                                  ? AppColor.primary
                                  : AppColor.black,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 15.px,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
