import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'custom_components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Handles the Supabase sign-out process.
  Future<void> _signOut(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();
    } on AuthException catch (e) {
      // Use the custom alert dialog for professional error display
      showCustomAlertDialog(context, 'Logout Error', e.message);
    } catch (e) {
      showCustomAlertDialog(context, 'Error', 'An unknown error occurred during logout.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access theme properties which will use the primaryBlue color and Poppins font
    final primaryColor = Theme.of(context).primaryColor;
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false, // Hide back button as AuthGate handles navigation
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _signOut(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kSpacing * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Success Icon
              Icon(Icons.check_circle_outline, color: primaryColor, size: 100),
              const SizedBox(height: 20),

              // Welcome Message
              Text(
                'Access Granted!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 10),

              Text(
                'You are logged in as:',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 5),

              // Display User Email
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: Text(
                  user?.email ?? 'User',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),

              const SizedBox(height: 40),

              // Logout Button
              SizedBox(
                width: 300, // Constrain button width on the dashboard
                child: CustomButton(
                  text: 'Sign Out',
                  type: ButtonType.secondary,
                  onPressed: () => _signOut(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
