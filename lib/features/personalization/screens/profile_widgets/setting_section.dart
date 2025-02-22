import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class SettingSection extends StatelessWidget {
  const SettingSection({
    super.key,
    required this.context,
    required this.title,
    required this.children,
  });

  final BuildContext context;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
