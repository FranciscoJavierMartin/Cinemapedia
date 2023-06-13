import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> _geLoadingMessages() {
    final messages = <String>[
      'Loading movies',
      'Heating pop corns',
      'Prepare for the best entertaiment',
      'Please be patient',
    ];

    return Stream.periodic(const Duration(seconds: 5), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Loading...'),
          const SizedBox(
            height: 10,
          ),
          const CircularProgressIndicator(
            strokeWidth: 2,
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: _geLoadingMessages(),
            builder: (context, snapshot) => snapshot.hasData
                ? Text(snapshot.data!)
                : const Text('Loading...'),
          ),
        ],
      ),
    );
  }
}
