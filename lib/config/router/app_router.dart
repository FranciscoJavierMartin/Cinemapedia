import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) => HomeScreen(
        pageIndex: int.parse(state.pathParameters['page'] ?? '0'),
      ),
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) =>
              MovieScreen(movieId: state.pathParameters['id'] ?? 'no-id'),
        ),
        GoRoute(
          path: 'actor/:id',
          name: ActorScreen.name,
          builder: (context, state) =>
              ActorScreen(actorId: state.pathParameters['id'] ?? 'no-id'),
        ),
      ],
    ),
    GoRoute(path: '/', redirect: (_, __) => '/home/0'),
  ],
);

void goToMoviePage(BuildContext context, int movieId) {
  context.push('/home/0/movie/$movieId');
}

void goToActorPage(BuildContext context, int actorId) {
  context.push('/home/0/actor/$actorId');
}
