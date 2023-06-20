import 'package:cinemapedia/domain/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rolesByActorProvider =
    StateNotifierProvider<RolesByActorNotifier, Map<String, List<Role>>>((ref) {
  final getRoles = ref.watch(actorRepositoryProvider).getRolesByActor;
  return RolesByActorNotifier(getRoles);
});

typedef GetRolesCallback = Future<List<Role>> Function(String actorId);

class RolesByActorNotifier extends StateNotifier<Map<String, List<Role>>> {
  final GetRolesCallback getRoles;

  RolesByActorNotifier(this.getRoles) : super({});

  Future<void> loadRoles(String actorId) async {
    if (state[actorId] == null) {
      final List<Role> roles = await getRoles(actorId);
      state = {...state, actorId: roles};
    }
  }
}
