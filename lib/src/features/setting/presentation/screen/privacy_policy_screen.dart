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

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    return CustomBgWidget(
      appBar: CustomAppBar(title: 'Privacy Policy'),
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

              // Introduction
              _buildSection(
                context: context,
                title: 'Introduction',
                content:
                    'Brain Box ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
              ),

              GapH(25.px),

              // Information We Collect
              _buildSection(
                context: context,
                title: 'Information We Collect',
                content:
                    'We may collect information about you in a variety of ways:\n\n• Personal Information: We may collect personal information such as your name, email address, and other contact details when you register or use our services.\n• Usage Data: We automatically collect information about how you use the app, including your interactions, game scores, and preferences.\n• Device Information: We may collect information about your device, including its unique identifier, operating system, and mobile network information.',
              ),

              GapH(25.px),

              // How We Use Your Information
              _buildSection(
                context: context,
                title: 'How We Use Your Information',
                content:
                    'We use the information we collect in the following ways:\n\n• To provide, maintain, and improve our services\n• To personalize your experience and deliver content relevant to your interests\n• To process your game scores and achievements\n• To send you technical notices and support messages\n• To detect, prevent, and address technical issues',
              ),

              GapH(25.px),

              // Data Security
              _buildSection(
                context: context,
                title: 'Data Security',
                content:
                    'We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable.',
              ),

              GapH(25.px),

              // Your Rights
              _buildSection(
                context: context,
                title: 'Your Rights',
                content:
                    'You have the right to:\n\n• Access the personal information we hold about you\n• Request correction of inaccurate personal information\n• Request deletion of your personal information\n• Object to processing of your personal information\n• Request restriction of processing your personal information',
              ),

              GapH(25.px),

              // Children\'s Privacy
              _buildSection(
                context: context,
                title: 'Children\'s Privacy',
                content:
                    'Our services are not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information.',
              ),

              GapH(25.px),

              // Changes to This Privacy Policy
              _buildSection(
                context: context,
                title: 'Changes to This Privacy Policy',
                content:
                    'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. You are advised to review this Privacy Policy periodically for any changes.',
              ),

              GapH(40.px),

              // Contact Information
              Container(
                padding: EdgeInsets.all(20.px),
                decoration: BoxDecoration(
                  color: themeState.settingCustomContainerColor!,
                  borderRadius: BorderRadius.circular(12.px),
                  border: Border.all(
                    color: themeState.settingCustomContainerBorderColor!,
                    width: 1.px,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.contact_mail,
                      color: themeState.splashLogoColor!,
                      size: 32.px,
                    ),
                    GapH(12.px),
                    CustomText(
                      text: 'Contact Us',
                      fontSize: 16.px,
                      fontWeight: FontWeight.bold,
                      color: themeState.appBarTitleColor!,
                    ),
                    GapH(8.px),
                    CustomText(
                      text:
                          'If you have questions or concerns about this Privacy Policy, please contact us at privacy@brainbox.com',
                      fontSize: 12.px,
                      fontWeight: FontWeight.w400,
                      color: themeState.appBarTitleColor!.withOpacityValue(0.8),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
