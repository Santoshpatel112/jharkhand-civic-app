import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool isOverlay;

  const LoadingWidget({
    super.key,
    this.message,
    this.isOverlay = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (isOverlay) {
      return Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(child: content),
      );
    }

    return Center(child: content);
  }
}