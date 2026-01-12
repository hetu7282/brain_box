import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/animations/animations.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/extensions/string_extension.dart';
import 'package:brain_box/src/core/services/snackbar_service.dart';
import 'package:brain_box/src/core/utils/post_frame_callback_mixin.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_button.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_optimized_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/piece_by_piece/presentation/bloc/piece_by_piece_cubit.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class ChooseYourPuzzleScreen extends StatefulWidget {
  const ChooseYourPuzzleScreen({super.key});

  @override
  State<ChooseYourPuzzleScreen> createState() => _ChooseYourPuzzleScreenState();
}

class _ChooseYourPuzzleScreenState extends State<ChooseYourPuzzleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PieceByPieceCubit(),
      child: ChooseYourPuzzleView(),
    );
  }
}

class ChooseYourPuzzleView extends StatefulWidget {
  const ChooseYourPuzzleView({super.key});

  @override
  State<ChooseYourPuzzleView> createState() => _ChooseYourPuzzleViewState();
}

class _ChooseYourPuzzleViewState extends State<ChooseYourPuzzleView>
    with PostFrameCallbackMixin {
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _itemsScrollController = ScrollController();
  int? _selectedItemIndex;
  String? _previousCategory; // Track previous category to detect changes

  @override
  void onPostFrameCallback() {
    context.read<PieceByPieceCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      appBar: BlocBuilder<PieceByPieceCubit, PieceByPieceState>(
        builder: (context, state) {
          return CustomAppBar(
            title:
                state.selectedCategory?.toCapitalize() ?? 'Choose Your Puzzle',
            leadingOnTap: state.selectedCategory != null
                ? () {
                    context.read<PieceByPieceCubit>().goBackToCategories();
                  }
                : null,
          );
        },
      ),
      body: BlocListener<PieceByPieceCubit, PieceByPieceState>(
        listenWhen: (previous, current) =>
            previous.selectedCategory != current.selectedCategory ||
            previous.selectedItem != current.selectedItem,
        listener: (context, state) {
          // Only reset scroll when category actually changes, not when item is selected
          final categoryChanged = _previousCategory != state.selectedCategory;

          if (state.selectedCategory == null) {
            // Going back to categories - reset category scroll
            if (_categoryScrollController.hasClients) {
              _categoryScrollController.jumpTo(0);
            }
            setState(() {
              _selectedItemIndex = null;
              _previousCategory = null;
            });
          } else if (categoryChanged) {
            // Category actually changed (or first time selecting a category) - reset items scroll
            if (_itemsScrollController.hasClients) {
              _itemsScrollController.jumpTo(0);
            }
            setState(() {
              _previousCategory = state.selectedCategory;
            });
          }
          // If category didn't change (just item selection), don't reset scroll

          // Reset local selection when cubit selection changes to null
          if (state.selectedItem == null && state.selectedCategory != null) {
            setState(() => _selectedItemIndex = null);
          }
        },
        child: BlocBuilder<PieceByPieceCubit, PieceByPieceState>(
          builder: (context, state) {
            // Show loading while fetching
            if (state.categoryList.isEmpty && state.allItems.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.98,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: state.selectedCategory == null
                  ? Padding(
                      key: const ValueKey('categories_view'),
                      padding: EdgeInsets.symmetric(horizontal: 12.px),
                      child: GridView.builder(
                        key: const PageStorageKey<String>('categories_grid'),
                        controller: _categoryScrollController,
                        padding: EdgeInsets.zero.copyWith(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 10.px,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.9,
                            ),
                        itemCount: state.categoryList.length,
                        itemBuilder: (context, index) {
                          final category = state.categoryList[index];
                          final thumbnailPath =
                              state.categoryThumbnails[category];

                          return ScaleOnTap(
                            onPressed: () {
                              context.read<PieceByPieceCubit>().selectCategory(
                                category,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: themeState.settingCustomContainerColor!,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeState
                                        .settingCustomContainerShadowColor!,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        topRight: Radius.circular(14),
                                      ),
                                      child: CustomAssetImage(
                                        image: thumbnailPath ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  GapH(10.px),
                                  CustomText(
                                    text: category.toUpperCase(),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: themeState.splashLogoColor!,
                                  ),
                                  GapH(10.px),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Padding(
                      key: ValueKey(
                        'items_view_${state.selectedCategory ?? ''}',
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.px),
                      child: Column(
                        children: [
                          Expanded(
                            child: MasonryGridView.builder(
                              padding: EdgeInsets.zero,
                              key: PageStorageKey<String>(
                                'items_grid_${state.selectedCategory ?? ''}',
                              ),
                              controller: _itemsScrollController,
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              addAutomaticKeepAlives: false,
                              addRepaintBoundaries: true,
                              itemCount: state.filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = state.filteredItems[index];
                                final bool isSelected =
                                    state.selectedItem?.path == item.path ||
                                    _selectedItemIndex == index;
                                return ScaleOnTap(
                                  onPressed: () {
                                    setState(() => _selectedItemIndex = index);
                                    context
                                        .read<PieceByPieceCubit>()
                                        .selectItem(item);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeOut,
                                    decoration: BoxDecoration(
                                      color: themeState
                                          .settingCustomContainerColor!,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: isSelected
                                            ? themeState
                                                  .settingCustomContainerBorderColor!
                                            : Colors.white.withOpacityValue(
                                                0.1,
                                              ),
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected
                                              ? themeState
                                                    .settingCustomContainerBorderColor!
                                              : Colors.black.withOpacityValue(
                                                  0.2,
                                                ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: CustomOptimizedImage(
                                        imagePath: item.path ?? '',
                                        fit: BoxFit.cover,
                                        padding: 24,
                                        spacing: 12,
                                        crossAxisCount: 2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          GapH(10.px),
                          CustomButton(
                            text: 'Continue',
                            onTap: () {
                              if (state.selectedItem != null) {
                                context.pushNamed(
                                  Routes.selectDifficulty.name,
                                  extra: state.selectedItem,
                                );
                              } else {
                                SnackBarService.showInfoSnackBar(
                                  context,
                                  'Please select a puzzle',
                                );
                              }
                            },
                          ),
                          GapBottom(extraHight: 10.px),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

// ScaleOnTap moved to core/animations/scale_on_tap.dart
