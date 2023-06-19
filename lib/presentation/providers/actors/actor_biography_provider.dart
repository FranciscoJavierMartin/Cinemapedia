import 'package:cinemapedia/domain/entities/actor_biography.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorBiographyProvider =
    StateNotifierProvider<ActorBiographyNotifier, Map<String, ActorBiography>>(
        (ref) {
  final getActorBiography = ref.watch(actorRepositoryProvider).getActorById;
  return ActorBiographyNotifier(getActorBiography);
});

typedef GetActorBiographyCallback = Future<ActorBiography> Function(
    String actorId);

class ActorBiographyNotifier
    extends StateNotifier<Map<String, ActorBiography>> {
  final GetActorBiographyCallback getActorBiography;

  ActorBiographyNotifier(this.getActorBiography) : super({});

  Future<void> loadActor(String actorId) async {
    if (state[actorId] == null) {
      final ActorBiography actorBiography = await getActorBiography(actorId);
      state = {...state, actorId: actorBiography};
    }
  }
}
