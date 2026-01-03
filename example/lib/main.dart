import 'package:flutter/widgets.dart';
import 'package:cu_ui/cu_ui.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CuShowcaseApp());
}

/// cu design language showcase
class CuShowcaseApp extends StatelessWidget {
  const CuShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CuTheme(
      theme: CuThemeData.dark(),
      child: WidgetsApp(
        title: 'cu',
        color: const Color(0xFF000000),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return const SplashScreen();
        },
      ),
    );
  }
}
