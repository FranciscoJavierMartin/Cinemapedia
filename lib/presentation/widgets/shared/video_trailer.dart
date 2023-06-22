import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/domain/entities/entities.dart';

final FutureProviderFamily<List<Video>, int> trailersProvider =
    FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getTrailers(movieId);
});

class VideoTrailer extends ConsumerWidget {
  final int movieId;
  const VideoTrailer({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trailers = ref.watch(trailersProvider(movieId));

    return trailers.when(
      data: (videos) => _TrailerList(videos),
      error: (_, __) =>
          Center(child: Text(AppLocalizations.of(context)!.notLoadTrailers)),
      loading: () => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _TrailerList extends StatelessWidget {
  final List<Video> trailers;

  const _TrailerList(this.trailers);

  @override
  Widget build(BuildContext context) {
    final TextTheme textStyles = Theme.of(context).textTheme;

    return trailers.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  AppLocalizations.of(context)!.trailer,
                  style: textStyles.titleLarge,
                ),
              ),
              _VideoPlayer(trailers.first.youtubeKey, trailers.first.name),
            ],
          );
  }
}

class _VideoPlayer extends StatefulWidget {
  final String youtubeId;
  final String name;

  const _VideoPlayer(this.youtubeId, this.name);

  @override
  __VideoPlayerState createState() => __VideoPlayerState();
}

class __VideoPlayerState extends State<_VideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(controller: _controller),
        ],
      ),
    );
  }
}
