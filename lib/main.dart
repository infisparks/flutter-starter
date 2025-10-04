import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_gate.dart';
import 'custom_components.dart';

// Your Supabase Credentials
const String supabaseUrl = 'https://lziedfqnmovuhbwtondz.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx6aWVkZnFubW92dWhid3RvbmR6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1Nzc2NzIsImV4cCI6MjA3NTE1MzY3Mn0.T7wRNQcN0onnxePIk-G3i2ZnnPZI-Fp5Gsaim4HHe7k';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase client
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maden Management Auth',
      // Theming for professional look
      theme: ThemeData(
        // Set Poppins as the default font family for the entire app
        fontFamily: 'Poppins',

        // Use the professional blue color scheme
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
        primaryColor: primaryBlue,
        useMaterial3: true,

        // Custom Text Theme to ensure full Poppins application
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Poppins',
        ),
      ),
      // AuthGate handles the initial routing based on Supabase session
      home: const AuthGate(),
    );
  }
}
