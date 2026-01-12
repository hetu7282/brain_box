import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/app_string.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/config/router/router.dart';
import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_image.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/quick_type_quest/presentation/bloc/quick_type_quest_cubit.dart';
import 'package:brain_box/src/features/quick_type_quest/presentation/widget/input_listener.dart';
import 'package:brain_box/src/features/quick_type_quest/presentation/widget/quick_type_quest_settings_dialog.dart';
import 'package:brain_box/src/features/quick_type_quest/presentation/widget/theme_colors.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class QuickTypeQuestScreen extends StatelessWidget {
  const QuickTypeQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuickTypeQuestCubit(),
      child: const QuickTypeQuestView(),
    );
  }
}

class QuickTypeQuestView extends StatefulWidget {
  const QuickTypeQuestView({super.key});

  @override
  State<QuickTypeQuestView> createState() => _QuickTypeQuestViewState();
}

class _QuickTypeQuestViewState extends State<QuickTypeQuestView>
    with WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _textCardKey = GlobalKey();
  bool _hasNavigatedToResult = false;
  int _lastTypingVersion = 0;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.addListener(_onFocusChange);
    _isKeyboardVisible = _isKeyboardCurrentlyVisible();
    // Load and set the stop music on background setting
    _loadBackgroundMusicSetting();
  }

  Future<void> _loadBackgroundMusicSetting() async {
    final stopOnBackground = Storage.instance.getStopMusicOnBackground();
    await AudioService.instance.setStopMusicOnBackground(stopOnBackground);
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _focusNode.hasFocus;
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final view = dispatcher.views.isNotEmpty ? dispatcher.views.first : null;
    if (view == null) return;
    final isVisible = view.viewInsets.bottom > 0;
    if (isVisible != _isKeyboardVisible && mounted) {
      setState(() {
        _isKeyboardVisible = isVisible;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // void _startGame() {
  //   context.read<QuickTypeQuestCubit>().startGame();
  // }

  void _showKeyboard() {
    if (!mounted) return;
    FocusScope.of(context).requestFocus(_focusNode);
    SystemChannels.textInput.invokeMethod('TextInput.show');
    setState(() {
      _isKeyboardVisible = true;
    });
  }

  void _hideKeyboard() {
    if (mounted) {
      _focusNode.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      setState(() {
        _isKeyboardVisible = false;
      });
    }
  }

  bool _isKeyboardCurrentlyVisible() {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final view = dispatcher.views.isNotEmpty ? dispatcher.views.first : null;
    if (view == null) return false;
    return view.viewInsets.bottom > 0;
  }

  void _processTextFieldInput(String newValue) {
    context.read<QuickTypeQuestCubit>().processTextFieldInput(newValue);
    _textController.clear();
  }

  // void _resetGame() {
  //   _textController.clear();
  //   _hasNavigatedToResult = false;
  //   _lastTypingVersion = 0;
  //   context.read<QuickTypeQuestCubit>().resetGame();
  //   _focusNode.unfocus();
  //   // Reset scroll position
  //   if (_scrollController.hasClients) {
  //     _scrollController.jumpTo(0);
  //   }
  // }

  void _scrollToCurrentPosition() {
    if (!_scrollController.hasClients || !mounted) return;

    final context = _textCardKey.currentContext;
    if (context != null) {
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        // Get the text card's position relative to the scroll view
        final position = renderBox.localToGlobal(Offset.zero);
        final scrollPosition = _scrollController.offset;
        final viewportHeight = _scrollController.position.viewportDimension;

        // Calculate where the text card is in the scroll view
        final cardTopInScrollView = position.dy + scrollPosition;

        // Scroll to keep the text card in the middle-upper portion of the viewport
        // This ensures the typing area stays visible
        final targetScroll = cardTopInScrollView - (viewportHeight * 0.3);

        // Only scroll if the card is not well-positioned
        final currentScroll = _scrollController.offset;
        if ((targetScroll - currentScroll).abs() > 50) {
          _scrollController.animateTo(
            targetScroll.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      }
    }
  }

  void _navigateToResultScreen(
    BuildContext context,
    QuickTypeQuestState state,
  ) {
    if (!mounted) return;

    // Calculate time elapsed - use startTime if available, otherwise estimate
    int timeElapsed = 0;
    if (state.startTime > 0) {
      final elapsedMs = DateTime.now().millisecondsSinceEpoch - state.startTime;
      timeElapsed = (elapsedMs / 1000).round();
    } else {
      // Fallback: estimate from difficulty default time
      final cubit = context.read<QuickTypeQuestCubit>();
      final initialTime = cubit.getInitialTimeForDifficulty(
        state.selectedDifficulty,
      );
      timeElapsed = initialTime - state.timeRemaining;
    }

    // Get difficulty name
    final difficultyName = state.selectedDifficulty.name;
    final difficultyDisplayName =
        difficultyName[0].toUpperCase() + difficultyName.substring(1);

    context.pushReplacementNamed(
      Routes.quickTypeQuestResult.name,
      extra: {
        'wpm': state.wpm,
        'accuracy': state.accuracy,
        'totalCharacters': state.totalCharacters,
        'correctCharacters': state.correctCharacters,
        'timeElapsed': timeElapsed,
        'difficulty': difficultyDisplayName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuickTypeQuestCubit, QuickTypeQuestState>(
      listener: (context, state) {
        // Navigate to result screen when game finishes
        if (state.gameState == GameState.finished && !_hasNavigatedToResult) {
          _hasNavigatedToResult = true;
          _hideKeyboard();
          _navigateToResultScreen(context, state);
        }
      },
      child: BlocBuilder<QuickTypeQuestCubit, QuickTypeQuestState>(
        builder: (context, state) {
          // Auto-scroll when typing progresses
          if (state.typingVersion != _lastTypingVersion &&
              state.gameState == GameState.playing &&
              state.typingContext != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToCurrentPosition();
            });
            _lastTypingVersion = state.typingVersion;
          }

          final themeState = context.watch<ThemeCubit>().state;
          return CustomBgWidget(
            appBar: CustomAppBar(
              title: 'QuickTypeQuest',
              actionWidget: _buildTimeWidget(state, themeState),
              leadingOnTap: () {
                // Navigate to home screen instead of popping
                context.goNamed(Routes.homeScreen.name);
              },
            ),
            body: Stack(
              children: [
                InputListener(
                  focusNode: _focusNode,
                  enabled:
                      state.gameState == GameState.playing ||
                      state.gameState == GameState.idle,
                  onCharacterInput: (char) => context
                      .read<QuickTypeQuestCubit>()
                      .handleCharacterInput(char),
                  onSpacePressed: () =>
                      context.read<QuickTypeQuestCubit>().handleSpacePressed(),
                  onBackspacePressed: () => context
                      .read<QuickTypeQuestCubit>()
                      .handleBackspacePressed(),
                  onCtrlBackspacePressed: context
                      .read<QuickTypeQuestCubit>()
                      .onCtrlBackspacePressed,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 25.px),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'Speed Typing Challenge',
                          fontSize: 18.px,
                          fontWeight: FontWeight.bold,
                          color: themeState.appBarTitleColor!,
                        ),
                        GapH(8.px),
                        CustomText(
                          text: 'Improve your typing speed and accuracy',
                          fontSize: 14.px,
                          fontWeight: FontWeight.normal,
                          color: themeState.appBarTitleColor!,
                        ),
                        GapH(25.px),
                        _buildTextCard(context, state, _textCardKey),

                        // GapH(20.px),
                        // if (state.gameState == GameState.idle &&
                        //     !_isKeyboardVisible)
                        //   _buildStartButton(),
                        GapBottom(extraHight: 20.px),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Opacity(
                      opacity: 0,
                      child: SizedBox(
                        height: 1,
                        width: 1,
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          autofocus: false,
                          enabled:
                              state.gameState == GameState.playing ||
                              state.gameState == GameState.idle,
                          readOnly: false,
                          showCursor: false,
                          obscureText: false,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(
                            color: Colors.transparent,
                            fontSize: 1,
                            height: 1,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onChanged: _processTextFieldInput,
                          onSubmitted: (_) {
                            _focusNode.requestFocus();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextCard(
    BuildContext context,
    QuickTypeQuestState state,
    GlobalKey key,
  ) {
    final themeState = context.watch<ThemeCubit>().state;
    if (state.typingContext == null) {
      return GestureDetector(
        onTap: _showKeyboard,
        child: Container(
          key: key,
          padding: EdgeInsets.all(15.px),
          decoration: BoxDecoration(
            color: themeState.settingCustomContainerColor!.withOpacityValue(
              0.15,
            ),
            borderRadius: BorderRadius.circular(16.px),
            border: Border.all(
              color: themeState.settingCustomContainerBorderColor!
                  .withOpacityValue(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: themeState.settingCustomContainerShadowColor!
                    .withOpacityValue(0.3),
                blurRadius: 15.px,
                offset: Offset(0, 5.px),
              ),
            ],
          ),
          child: CustomText(
            text: state.challengeText,
            color: themeState.appBarTitleColor!,
            fontSize: 15.px,
          ),
        ),
      );
    }

    // Calculate current character position in the full text
    int totalTypedChars = 0;
    final words = state.challengeText.split(' ');
    final currentWordIndex = state.typingContext!.currentWordIndex;
    final enteredText = state.typingContext!.enteredText;

    // Count characters up to current word
    for (int i = 0; i < currentWordIndex; i++) {
      if (i < words.length) {
        totalTypedChars += words[i].length + 1; // +1 for space
      }
    }
    // Add entered characters in current word
    totalTypedChars += enteredText.length;

    return GestureDetector(
      onTap: _showKeyboard,
      child: Container(
        key: key,
        padding: EdgeInsets.all(15.px),
        decoration: BoxDecoration(
          color: themeState.settingCustomContainerColor!.withOpacityValue(0.15),
          borderRadius: BorderRadius.circular(16.px),
          border: Border.all(
            color: themeState.settingCustomContainerBorderColor!
                .withOpacityValue(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: themeState.settingCustomContainerShadowColor!
                  .withOpacityValue(0.3),
              blurRadius: 15.px,
              offset: Offset(0, 5.px),
            ),
          ],
        ),
        child: _buildCharacterByCharacterText(state, totalTypedChars),
      ),
    );
  }

  Widget _buildCharacterByCharacterText(
    QuickTypeQuestState state,
    int currentCharIndex,
  ) {
    final themeState = context.watch<ThemeCubit>().state;
    final words = state.challengeText.split(' ');
    final currentWordIndex = state.typingContext!.currentWordIndex;
    final enteredText = state.typingContext!.enteredText;

    List<TextSpan> spans = [];

    for (int wordIndex = 0; wordIndex < words.length; wordIndex++) {
      final word = words[wordIndex];

      for (int charIndex = 0; charIndex < word.length; charIndex++) {
        final char = word[charIndex];

        if (wordIndex < currentWordIndex) {
          // Completed words - check character-by-character correctness
          try {
            final typedWord = state.typingContext!.getTypedWord(wordIndex);
            final typedWordValue = typedWord.value;
            final expectedWord = word;

            // Compare character-by-character
            bool isCharCorrect;
            if (charIndex < typedWordValue.length &&
                charIndex < expectedWord.length) {
              // Compare the typed character with expected character
              isCharCorrect =
                  typedWordValue[charIndex] == expectedWord[charIndex];
            } else if (charIndex < expectedWord.length) {
              // Typed word is shorter - missing characters are incorrect
              isCharCorrect = false;
            } else {
              // Beyond expected word length - if typed word is longer, extra chars are incorrect
              isCharCorrect = false;
            }

            spans.add(
              TextSpan(
                text: char,
                style: TextStyle(
                  fontFamily: AppString.fontFamily,
                  fontSize: 15.px,
                  color: isCharCorrect ? ThemeColors.green : ThemeColors.red,
                ),
              ),
            );
          } catch (e) {
            // Fallback - show in green
            spans.add(
              TextSpan(
                text: char,
                style: TextStyle(
                  fontFamily: AppString.fontFamily,
                  fontSize: 15.px,
                  color: ThemeColors.green,
                ),
              ),
            );
          }
        } else if (wordIndex == currentWordIndex) {
          // Current word being typed
          if (charIndex < enteredText.length) {
            // Typed character
            final typedChar = enteredText[charIndex];
            final expectedChar = word[charIndex];
            final isCorrect = typedChar == expectedChar;

            spans.add(
              TextSpan(
                text: char,
                style: TextStyle(
                  fontFamily: AppString.fontFamily,
                  fontSize: 15.px,
                  color: isCorrect ? ThemeColors.green : ThemeColors.red,
                  backgroundColor: isCorrect
                      ? ThemeColors.green.withOpacityValue(0.2)
                      : ThemeColors.red.withOpacityValue(0.2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          } else if (charIndex == enteredText.length) {
            // Current character to type - highlight in blue
            spans.add(
              TextSpan(
                text: char,
                style: TextStyle(
                  fontFamily: AppString.fontFamily,
                  fontSize: 15.px,
                  color: themeState.splashLogoColor!,
                  backgroundColor: themeState.splashLogoColor!.withOpacityValue(
                    0.3,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            // Upcoming characters in current word
            spans.add(
              TextSpan(
                text: char,
                style: TextStyle(
                  fontFamily: AppString.fontFamily,
                  fontSize: 15.px,
                  color: themeState.appBarTitleColor!.withOpacityValue(0.7),
                ),
              ),
            );
          }
        } else {
          // Upcoming words - show in gray
          spans.add(
            TextSpan(
              text: char,
              style: TextStyle(
                fontFamily: AppString.fontFamily,
                fontSize: 15.px,
                color: themeState.appBarTitleColor!.withOpacityValue(0.5),
              ),
            ),
          );
        }
      }

      // Add space after word (except last word)
      if (wordIndex < words.length - 1) {
        if (wordIndex < currentWordIndex) {
          spans.add(
            TextSpan(
              text: ' ',
              style: TextStyle(
                fontFamily: AppString.fontFamily,
                fontSize: 15.px,
                color: ThemeColors.green,
              ),
            ),
          );
        } else if (wordIndex == currentWordIndex) {
          if (enteredText.length >= word.length) {
            // Space after completed current word
            spans.add(
              TextSpan(
                text: ' ',
                style: TextStyle(
                  fontFamily: AppString.fontFamily,
                  fontSize: 15.px,
                  color: ThemeColors.green,
                ),
              ),
            );
          } else {
            // Space not yet typed
            spans.add(
              TextSpan(
                text: ' ',
                style: TextStyle(
                  fontFamily: AppString.fontFamily,
                  fontSize: 15.px,
                  color: AppColor.white.withOpacityValue(0.5),
                ),
              ),
            );
          }
        } else {
          spans.add(
            TextSpan(
              text: ' ',
              style: TextStyle(
                fontFamily: AppString.fontFamily,
                fontSize: 15.px,
                color: AppColor.white.withOpacityValue(0.5),
              ),
            ),
          );
        }
      }
    }

    return SelectableText.rich(
      TextSpan(
        children: spans,
        style: TextStyle(
          fontFamily: AppString.fontFamily,
          fontSize: 15.px,
          height: 1.6,
        ),
      ),
    );
  }

  // Widget _buildMetricsRow(QuickTypeQuestState state) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: _buildMetricCard('WPM', '${state.wpm}', Assets.assetsIconsWPM),
  //       ),
  //       GapW(12.px),
  //       Expanded(
  //         child: _buildMetricCard(
  //           'Accuracy',
  //           '${state.accuracy}%',
  //           Assets.assetsIconsAccuracy,
  //         ),
  //       ),
  //       GapW(12.px),
  //       Expanded(
  //         child: _buildMetricCard(
  //           'Time',
  //           '${state.timeRemaining}s',
  //           Assets.assetsIconsTimer,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildMetricCard(String label, String value, String icon) {
  //   final themeState = context.watch<ThemeCubit>().state;
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 18.px),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           themeState.settingCustomContainerColor!,
  //           themeState.settingCustomContainerColor!,
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(12.px),
  //       border: Border.all(
  //         color: themeState.settingCustomContainerBorderColor!.withOpacityValue(
  //           0.3,
  //         ),
  //         width: 1.0,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: themeState.settingCustomContainerShadowColor!
  //               .withOpacityValue(0.3),
  //           blurRadius: 10.px,
  //           offset: Offset(0, 4.px),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         CustomAssetImage(
  //           image: icon,
  //           height: 20.px,
  //           width: 20.px,
  //           color: themeState.splashLogoColor!,
  //         ),
  //         GapH(8.px),
  //         CustomText(
  //           text: label,
  //           fontSize: 12.px,
  //           color: themeState.appBarTitleColor!,
  //         ),
  //         GapH(6.px),
  //         CustomText(
  //           text: value,
  //           fontSize: 22.px,
  //           fontWeight: FontWeight.bold,
  //           color: themeState.appBarTitleColor!,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTimeWidget(QuickTypeQuestState state, dynamic themeState) {
    return Row(
      children: [
        CustomAssetImage(
          image: Assets.assetsIconsTimer,
          height: 20.px,
          width: 20.px,
          color: themeState.splashLogoColor!,
        ),
        GapW(6.px),
        CustomText(
          text: '${state.timeRemaining}s',
          fontSize: 16.px,
          fontWeight: FontWeight.bold,
          color: themeState.appBarTitleColor!,
        ),
        GapW(10.px),
        GestureDetector(
          onTap: () {
            _showSettingsDialog(context, state);
          },
          child: CustomIcon(
            icon: Assets.assetsIconsSettings,
            size: 40.px,
            color: themeState.textOnboardingColor!,
            backgroundColor: themeState.appBarIconBackgroundColor!,
          ),
        ),
      ],
    );
  }

  // Widget _buildStartButton() {
  //   return CustomButton(text: 'Start Typing', onTap: _startGame);
  // }

  void _showSettingsDialog(BuildContext context, QuickTypeQuestState state) {
    QuickTypeQuestSettingsDialog.show(
      context,
      initialDifficulty: state.selectedDifficulty,
      initialTime: state.timeRemaining,
    );
  }

  /*
  Widget _buildGameFinishedMessage() {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: EdgeInsets.all(20.px),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeState.settingCustomContainerColor!.withOpacityValue(0.2),
            AppColor.k64B5F6.withOpacityValue(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16.px),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!.withOpacityValue(
            0.5,
          ),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          CustomText(
            text: 'Time\'s Up!',
            fontSize: 20.px,
            fontWeight: FontWeight.bold,
            color: themeState.splashLogoColor!,
          ),
          GapH(10.px),
          CustomText(
            text: 'Final WPM: $_wpm',
            fontSize: 18.px,
            fontWeight: FontWeight.w600,
            color: themeState.appBarTitleColor!,
          ),
          GapH(5.px),
          CustomText(
            text: 'Accuracy: $_accuracy%',
            fontSize: 18.px,
            fontWeight: FontWeight.w600,
            color: themeState.appBarTitleColor!,
          ),
        ],
      ),
    );
  }
 */
}
