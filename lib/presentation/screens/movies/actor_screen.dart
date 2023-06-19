import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/domain/entities/actor_biography.dart';

class ActorScreen extends ConsumerStatefulWidget {
  static const String name = 'actor-screen';

  final String actorId;

  const ActorScreen({
    super.key,
    required this.actorId,
  });

  @override
  ActorScreenState createState() => ActorScreenState();
}

class ActorScreenState extends ConsumerState<ActorScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(actorBiographyProvider.notifier).loadActor(widget.actorId);
  }

  @override
  Widget build(BuildContext context) {
    final ActorBiography? actor =
        ref.watch(actorBiographyProvider)[widget.actorId];

    return actor == null
        ? const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Scaffold(
            body: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(strokeWidth: 2),
                  Text(actor.name),
                ],
              ),
            ),
          );
  }
}
