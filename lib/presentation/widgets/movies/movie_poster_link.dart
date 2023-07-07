import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;

  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () => goToMoviePage(context, movie.id),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage(
            height: 180,
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/images/bottle-loader.gif'),
            image: NetworkImage(movie.posterPath),
          ),
        ),
      ),
    );
  }
}
