import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> _geLoadingMessages(BuildContext context) {
    final messages = <String>[
      AppLocalizations.of(context)!.loadingMessage2,
      AppLocalizations.of(context)!.loadingMessage3,
      AppLocalizations.of(context)!.loadingMessage4,
      AppLocalizations.of(context)!.loadingMessage5,
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
          Text(AppLocalizations.of(context)!.home),
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
            stream: _geLoadingMessages(context),
            builder: (context, snapshot) => snapshot.hasData
                ? Text(snapshot.data!)
                : Text(AppLocalizations.of(context)!.loadingMessage1),
          ),
        ],
      ),
    );
  }
}
