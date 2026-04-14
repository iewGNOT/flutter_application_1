import 'package:flutter/material.dart';

import '../../../../app/widgets/app_metric_tile.dart';

final class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppMetricTile(
      label: title,
      value: value,
      helper: subtitle,
      icon: icon,
    );
  }
}
