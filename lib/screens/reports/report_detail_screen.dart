import 'package:flutter/material.dart';

class ReportDetailScreen extends StatefulWidget {
  final String reportId;

  const ReportDetailScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: Center(
        child: Text('Report Details for ID: ${widget.reportId}'),
      ),
    );
  }
}