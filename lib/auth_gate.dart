import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_register_page.dart';
import 'home_page.dart';
import 'custom_components.dart'; // Import to access primaryBlue constant

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Stream of authentication state changes
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while Supabase initializes
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: primaryBlue)),
          );
        }

        // If the user is logged in (session exists), show the Home Page
        final session = snapshot.data?.session;
        if (session != null) {
          return const HomePage();
        }

        // Otherwise, show the Login/Register Page
        return const LoginRegisterPage();
      },
    );
  }
}
