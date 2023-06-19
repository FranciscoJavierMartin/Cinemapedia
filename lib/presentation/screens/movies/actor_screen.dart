import 'package:flutter/material.dart';

class ActorScreen extends StatelessWidget {
  static const String name = 'actor-screen';

  final String actorId;

  const ActorScreen({
    super.key,
    required this.actorId,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(actorId),
    );
  }
}
