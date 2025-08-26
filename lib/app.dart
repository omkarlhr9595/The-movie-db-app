import 'package:cine_parker/features/search_movies/presentation/bloc/search_bloc.dart';
import 'package:cine_parker/features/trending_movies/presentation/bloc/cast_cubit.dart';
import 'package:cine_parker/features/trending_movies/presentation/bloc/trending_bloc.dart';
import 'package:cine_parker/injection_container.dart';
import 'package:cine_parker/router.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Main app widget
class App extends StatelessWidget {
  /// Constructor for the App widget
  const App({super.key});

  /// Build method for the App widget
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<TrendingBloc>(create: (_) => TrendingBloc(sl())..add(const TrendingRequestedEvent())),
        BlocProvider<SearchBloc>(create: (_) => SearchBloc(sl())),
        BlocProvider<CastCubit>(create: (_) => CastCubit()),
      ],
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          ColorScheme lightScheme;
          ColorScheme darkScheme;

          if (lightDynamic != null && darkDynamic != null) {
            lightScheme = lightDynamic.harmonized();
            darkScheme = darkDynamic.harmonized();
          } else {
            const fallbackSeed = Color(0xFF6750A4);
            lightScheme = ColorScheme.fromSeed(
              seedColor: fallbackSeed,
            );
            darkScheme = ColorScheme.fromSeed(
              seedColor: fallbackSeed,
              brightness: Brightness.dark,
            );
          }

          final router = AppRouter.router;

          return MaterialApp.router(
            theme: ThemeData(
              colorScheme: lightScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.interTextTheme(
                ThemeData(
                  colorScheme: lightScheme,
                  useMaterial3: true,
                ).textTheme,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: darkScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.interTextTheme(
                ThemeData(
                  colorScheme: darkScheme,
                  useMaterial3: true,
                ).textTheme,
              ),
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
