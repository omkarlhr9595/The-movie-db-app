import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_movie_app/app.dart';
import 'package:the_movie_app/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await dotenv.load();
  runApp(const MainApp());
}

/// Main app widget
class MainApp extends StatelessWidget {
  /// Constructor for the MainApp widget
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
