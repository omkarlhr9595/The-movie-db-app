import 'package:cine_parker/features/trending_movies/domain/entities/movie.dart';
import 'package:cine_parker/features/trending_movies/presentation/screens/movie_details_screen.dart';
import 'package:cine_parker/features/trending_movies/presentation/screens/trending_screen.dart' show TrendingScreen;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Router configuration for Cine Parker
class AppRouter {
  /// Global navigator key for the root navigator
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  
  /// Main router configuration
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => const TrendingScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: 'movie',
            name: MovieDetailsScreen.routeName,
            builder: (context, state) {
              final extra = state.extra! as Movie;
              return MovieDetailsScreen(movie: extra);
            },
          ),
        ],
      ),
    ],
  );
}
