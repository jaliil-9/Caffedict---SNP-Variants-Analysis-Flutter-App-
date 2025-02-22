import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AnalysisOptionTile extends StatelessWidget {
  const AnalysisOptionTile({
    super.key,
    required this.context,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
  });

  final BuildContext context;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isSelected ? Iconsax.tick_circle : icon,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
