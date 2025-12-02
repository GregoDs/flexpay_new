import 'package:flutter/material.dart';

Future<void> showOfflineDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (c) {
      return AlertDialog(
        title: const Text('No internet connection'),
        content: const Text('Please check your network and try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(c).pop();
              // caller should attempt retry
            },
            child: const Text('Retry'),
          ),
        ],
      );
    },
  );
}