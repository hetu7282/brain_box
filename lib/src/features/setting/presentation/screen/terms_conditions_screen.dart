import 'package:brain_box/src/core/animations/fade_in_animation.dart';
import 'package:brain_box/src/core/extensions/color_extension.dart';
import 'package:brain_box/src/core/widgets/custom_appbar.dart';
import 'package:brain_box/src/core/widgets/custom_bg_widget.dart';
import 'package:brain_box/src/core/widgets/custom_text.dart';
import 'package:brain_box/src/core/widgets/gap.dart';
import 'package:brain_box/src/features/setting/presentation/bloc/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      appBar: CustomAppBar(title: 'Terms & Conditions'),
      body: FadeInAnimation(
        duration: const Duration(milliseconds: 400),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Last Updated: January 2024',
                fontSize: 12.px,
                fontWeight: FontWeight.w400,
                color: themeState.appBarTitleColor!.withOpacityValue(0.6),
              ),
              GapH(30.px),

              // Section 1
              _buildSection(
                context: context,
                title: '1. Acceptance of Terms',
                content:
                    'By accessing and using Brain Box ("the App"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
              ),

              GapH(25.px),

              // Section 2
              _buildSection(
                context: context,
                title: '2. Use License',
                content:
                    'Permission is granted to temporarily download one copy of Brain Box for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose or for any public display\n• Attempt to decompile or reverse engineer any software contained in the App\n• Remove any copyright or other proprietary notations from the materials',
              ),

              GapH(25.px),

              // Section 3
              _buildSection(
                context: context,
                title: '3. Disclaimer',
                content:
                    'The materials on Brain Box are provided on an "as is" basis. Brain Box makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
              ),

              GapH(25.px),

              // Section 4
              _buildSection(
                context: context,
                title: '4. Limitations',
                content:
                    'In no event shall Brain Box or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Brain Box.',
              ),

              GapH(25.px),

              // Section 5
              _buildSection(
                context: context,
                title: '5. Revisions',
                content:
                    'Brain Box may revise these terms of service for its app at any time without notice. By using this app you are agreeing to be bound by the then current version of these terms of service.',
              ),

              GapH(25.px),

              // Section 6
              _buildSection(
                context: context,
                title: '6. Governing Law',
                content:
                    'These terms and conditions are governed by and construed in accordance with applicable laws and you irrevocably submit to the exclusive jurisdiction of the courts in that location.',
              ),

              GapH(40.px),

              // Footer
              Container(
                padding: EdgeInsets.all(20.px),
                decoration: BoxDecoration(
                  color: themeState.settingCustomContainerColor!,
                  borderRadius: BorderRadius.circular(12.px),
                ),
                child: CustomText(
                  text:
                      'If you have any questions about these Terms & Conditions, please contact us.',
                  fontSize: 12.px,
                  fontWeight: FontWeight.w400,
                  color: themeState.appBarTitleColor!.withOpacityValue(0.7),
                  textAlign: TextAlign.center,
                ),
              ),
              GapBottom(extraHight: 10.px),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    final themeState = context.watch<ThemeCubit>().state;
    return Container(
      padding: EdgeInsets.all(20.px),
      decoration: BoxDecoration(
        color: themeState.settingCustomContainerColor!,
        borderRadius: BorderRadius.circular(16.px),
        border: Border.all(
          color: themeState.settingCustomContainerBorderColor!,
          width: 1.px,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 18.px,
            fontWeight: FontWeight.bold,
            color: themeState.splashLogoColor!,
          ),
          GapH(15.px),
          CustomText(
            text: content,
            fontSize: 14.px,
            fontWeight: FontWeight.w400,
            color: themeState.appBarTitleColor!.withOpacityValue(0.9),
            height: 1.6,
          ),
        ],
      ),
    );
  }
}
