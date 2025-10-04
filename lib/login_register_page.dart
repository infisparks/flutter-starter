import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'custom_components.dart';

// --- Supabase Client Access ---
// Note: The client is initialized in main.dart
final SupabaseClient supabase = Supabase.instance.client;

enum AuthType { login, register }

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  AuthType _currentAuthType = AuthType.login;
  bool _isLoading = false;
  bool _isPasswordObscure = true;
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _toggleAuthType() {
    setState(() {
      _currentAuthType = _currentAuthType == AuthType.login ? AuthType.register : AuthType.login;
      _formKey.currentState?.reset(); // Clear form on switch
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // --- Auth Handlers ---

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_currentAuthType == AuthType.login) {
        await _signIn();
      } else {
        await _signUp();
      }
    } catch (error) {
      showCustomAlertDialog(context, 'Error', error.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw 'Invalid login credentials.';
    }

    // AuthGate handles navigation automatically on successful login.
    showCustomAlertDialog(context, 'Success', 'Welcome back!');
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();

    // 1. Sign up the user (creates the auth entry)
    final authResponse = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (authResponse.user == null) {
      throw 'Registration failed. Check if email is already in use.';
    }

    final userId = authResponse.user!.id;

    // 2. Insert additional profile data into a 'profiles' table
    // NOTE: You must have a 'profiles' table with 'id', 'name', and 'number' columns set up in Supabase.
    await supabase.from('profiles').insert({
      'id': userId,
      'name': name,
      'number': number,
      'email': email, // Optional, but useful
    });

    showCustomAlertDialog(context, 'Success', 'Registration successful! Please check your email to confirm your account.');
    _toggleAuthType(); // Switch to login page after successful registration
  }

  // --- UI Builder Methods ---

  Widget _buildLoginForm() {
    return Column(
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: primaryBlue),
        ),
        const SizedBox(height: 30),
        CustomTextInput(
          controller: _emailController,
          labelText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          prefixIcon: const Icon(Icons.email_outlined, color: primaryBlue),
        ),
        CustomTextInput(
          controller: _passwordController,
          labelText: 'Password',
          obscureText: _isPasswordObscure,
          validator: _validatePassword,
          prefixIcon: const Icon(Icons.lock_outline, color: primaryBlue),
          suffixIcon: IconButton(
            icon: Icon(_isPasswordObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: () {
              setState(() => _isPasswordObscure = !_isPasswordObscure);
            },
          ),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Sign In',
          isLoading: _isLoading,
          onPressed: _handleAuth,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        const Text(
          'Create Account',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: primaryBlue),
        ),
        const SizedBox(height: 30),
        CustomTextInput(
          controller: _nameController,
          labelText: 'Full Name',
          validator: (v) => v!.isEmpty ? 'Name is required' : null,
          prefixIcon: const Icon(Icons.person_outline, color: primaryBlue),
        ),
        CustomTextInput(
          controller: _numberController,
          labelText: 'Phone Number',
          keyboardType: TextInputType.phone,
          validator: (v) => v!.isEmpty ? 'Number is required' : null,
          prefixIcon: const Icon(Icons.phone_outlined, color: primaryBlue),
        ),
        CustomTextInput(
          controller: _emailController,
          labelText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          prefixIcon: const Icon(Icons.email_outlined, color: primaryBlue),
        ),
        CustomTextInput(
          controller: _passwordController,
          labelText: 'Password',
          obscureText: _isPasswordObscure,
          validator: _validatePassword,
          prefixIcon: const Icon(Icons.lock_outline, color: primaryBlue),
          suffixIcon: IconButton(
            icon: Icon(_isPasswordObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: () {
              setState(() => _isPasswordObscure = !_isPasswordObscure);
            },
          ),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Sign Up',
          isLoading: _isLoading,
          onPressed: _handleAuth,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleText = _currentAuthType == AuthType.login ? 'Sign In' : 'Sign Up';

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kSpacing * 2),
          child: SizedBox(
            width: 450, // Fixed width for desktop/tablet view
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo Placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(kBorderRadius * 2),
                    ),
                    child: const Icon(Icons.person_pin, color: primaryBlue, size: 50),
                  ),
                  const SizedBox(height: 40),

                  _currentAuthType == AuthType.login ? _buildLoginForm() : _buildRegisterForm(),

                  const SizedBox(height: 20),

                  CustomButton(
                    text: _currentAuthType == AuthType.login
                        ? "Don't have an account? Register"
                        : "Already have an account? Login",
                    type: ButtonType.textOnly,
                    onPressed: _toggleAuthType,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
