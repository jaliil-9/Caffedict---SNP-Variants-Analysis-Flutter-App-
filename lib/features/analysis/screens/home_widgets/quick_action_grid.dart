import 'package:caffedict/features/analysis/screens/analysis_widgets/analysis_history_tab.dart';
import 'package:caffedict/features/analysis/screens/analysis_widgets/new_analysis_tab.dart';
import 'package:caffedict/features/analysis/screens/home_widgets/action_card.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid(
      {super.key, required this.context, required this.isGuestUser});

  final BuildContext context;
  final bool isGuestUser;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: Sizes.spaceBtwItems,
      crossAxisSpacing: Sizes.spaceBtwItems,
      children: [
        ActionCard(
            context: context,
            title: 'New Analysis',
            icon: Iconsax.chart_21,
            onTap: () {
              Get.to(() => NewAnalysisTab(
                    showAppBar: true,
                    isGuestUser: isGuestUser,
                  ));
            }),
        ActionCard(
            context: context,
            title: 'View History',
            icon: Iconsax.story,
            onTap: () {
              Get.to(() => AnalysisHistoryTab(
                    showAppBar: true,
                    isGuestUser: isGuestUser,
                  ));
            }),
      ],
    );
  }
}
