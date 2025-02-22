import 'package:caffedict/features/analysis/screens/analysis_widgets/guest_analysis_screen.dart';
import 'package:caffedict/features/analysis/screens/analysis_widgets/main_analysis_screen.dart';
import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key, required this.isGuestUser});

  final bool isGuestUser;

  @override
  Widget build(BuildContext context) {
    if (isGuestUser) {
      return GuestAnalysisScreen(context: context);
    }

    return MainAnalysisScreen();
  }
}
