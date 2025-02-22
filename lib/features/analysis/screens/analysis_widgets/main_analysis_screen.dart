import 'package:caffedict/features/analysis/screens/analysis_widgets/analysis_history_tab.dart';
import 'package:caffedict/features/analysis/screens/analysis_widgets/new_analysis_tab.dart';
import 'package:flutter/material.dart';

class MainAnalysisScreen extends StatelessWidget {
  const MainAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Analysis',
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'New Analysis'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NewAnalysisTab(),
            AnalysisHistoryTab(),
          ],
        ),
      ),
    );
  }
}
