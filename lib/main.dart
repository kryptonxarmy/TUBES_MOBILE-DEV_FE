import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Menginisialisasi Flutter binding
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Failed to load .env: $e'); // Debug jika file .env gagal dimuat
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner DEBUG
      title: 'Kasir App',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Mengganti warna tema utama
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
