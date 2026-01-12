import 'package:brain_box/src/config/constants/app_color.dart';
import 'package:brain_box/src/config/constants/assets.dart';
import 'package:brain_box/src/core/bloc/audio/audio_cubit.dart';
import 'package:brain_box/src/core/bloc/audio/audio_state.dart';
import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/services/audio_service.dart';
import 'package:brain_box/src/core/widgets/custom_divider.dart';
import 'package:brain_box/src/core/widgets/custom_icon.dart';
import 'package:brain_box/src/core/widgets/custom_switch_widget.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class GameSettingWidget extends StatefulWidget {
  const GameSettingWidget({super.key});

  @override
  State<GameSettingWidget> createState() => _GameSettingWidgetState();
}

class _GameSettingWidgetState extends State<GameSettingWidget> {
  late final ValueNotifier<bool> _soundEnabled;

  @override
  void initState() {
    super.initState();
    // Load sound enabled state from storage (defaults to true)
    _soundEnabled = ValueNotifier<bool>(Storage.instance.getSoundEnabled());
  }

  @override
  void dispose() {
    _soundEnabled.dispose();
    super.dispose();
  }

  Future<void> _handleSoundToggle(bool value) async {
    _soundEnabled.value = value;
    await Storage.instance.setSoundEnabled(value);
    await AudioService.instance.setSoundEnabled(value);
  }

  Future<void> _handleMusicToggle(bool value, AudioCubit audioCubit) async {
    await audioCubit.toggleMusic(value);
    await AudioService.instance.triggerInteractionFeedback();
  }

  @override
  Widget build(BuildContext context) {
    final audioCubit = context.read<AudioCubit>();
    return ValueListenableBuilder<bool>(
      valueListenable: _soundEnabled,
      builder: (context, soundEnabled, _) {
        return BlocBuilder<AudioCubit, AudioState>(
          builder: (context, audioState) {
            final themeState = context.watch<ThemeCubit>().state;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 12.px),
              decoration: BoxDecoration(
                color: themeState.settingCustomContainerColor!,
                borderRadius: BorderRadius.circular(16.px),
                border: Border.all(
                  color: themeState.settingCustomContainerBorderColor!,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeState.settingCustomContainerShadowColor!,
                    blurRadius: 15.px,
                    offset: Offset(0, 5.px),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSettingRow(
                    context: context,
                    icon: Assets.assetsIconsSound,
                    title: 'Sound',
                    value: soundEnabled,
                    onChanged: (newValue) => _handleSoundToggle(newValue),
                  ),
                  GapH(12.px),
                  DividerWidget(
                    color: themeState.settingCustomContainerBorderColor!,
                  ),
                  GapH(12.px),
                  _buildSettingRow(
                    context: context,
                    icon: Assets.assetsIconsMusic,
                    title: 'Music',
                    value: audioState.isMusicEnabled,
                    onChanged: (newValue) =>
                        _handleMusicToggle(newValue, audioCubit),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingRow({
    required BuildContext context,
    required String icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final themeState = context.watch<ThemeCubit>().state;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.px),
      child: Row(
        children: [
          CustomIcon(
            icon: icon,
            size: 40.px,
            color: themeState.textOnboardingColor!,
            backgroundColor: themeState.settingIconBackgroundColor!,
          ),
          GapW(15.px),
          CustomText(
            text: title,
            fontSize: 14.px,
            fontWeight: FontWeight.w500,
            color: themeState.appBarTitleColor!,
          ),
          Spacer(),
          CustomSwitch(
            initialValue: value,
            onChanged: (dynamic newValue) {
              onChanged(newValue as bool);
            },
            activeColor: themeState.settingIconBackgroundColor!,
            inactiveColor: AppColor.kABA6A6,
            width: 40.px,
            height: 20.px,
          ),
        ],
      ),
    );
  }
}
