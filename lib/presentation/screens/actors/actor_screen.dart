import 'package:cinemapedia/presentation/providers/actors/actor_roles_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
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
    // ref.read(rolesByActorProvider.notifier).loadRoles(widget.actorId);
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
            body: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                _CustomSliverAppBar(actor),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) => _BiographyDetails(actor),
                  ),
                ),
              ],
            ),
          );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final ActorBiography actorBiography;

  const _CustomSliverAppBar(this.actorBiography);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                actorBiography.profilePath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress != null ? const SizedBox() : child,
              ),
            ),
            const CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
            ),
            const CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1.0],
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
            ),
            const CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.3],
              colors: [
                Colors.black87,
                Colors.transparent,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BiographyDetails extends StatelessWidget {
  final ActorBiography biography;

  const _BiographyDetails(this.biography);

  @override
  Widget build(BuildContext context) {
    final TextTheme textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              biography.name,
              style: textStyles.titleLarge,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(biography.biography),
        ),
        // _Roles(biography.id),
        const SizedBox(height: 100)
      ],
    );
  }
}

class _Roles extends ConsumerWidget {
  final int actorId;

  const _Roles(this.actorId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Use trailer approach to load roles "when"
    final rolesByActor = ref.watch(rolesByActorProvider);
    print(rolesByActor[actorId]?.length);
    return rolesByActor[actorId] == null
        ? const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : SizedBox(
            height: 300,
            child: Text(rolesByActor[actorId]!.length.toString()),
          );
  }
}
