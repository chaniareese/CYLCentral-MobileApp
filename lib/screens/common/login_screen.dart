import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  // Track if user has attempted to submit (for required field error display)
  bool _submitted = false;
  int _failedAttempts = 0;
  static const int _maxAttempts = 4;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper: Show a themed snackbar
  void _showSnackBar(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color ?? kGreen1,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Helper: Clear all input fields
  void _clearInputs() {
    _emailController.clear();
    _passwordController.clear();
  }

  // Login function
  Future<void> _login() async {
    setState(() {
      _submitted = true;
    });
    if (!_formKey.currentState!.validate()) return;

    if (_failedAttempts >= _maxAttempts) {
      _showSnackBar(
        'Session expired or too many attempts. Please try again later.',
        color: Colors.red[700],
      );
      _clearInputs();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (context.mounted) {
        setState(() {
          _failedAttempts = 0;
        }); // Reset on success
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on Exception catch (e) {
      final error = e.toString().toLowerCase();
      _failedAttempts++;
      if (_failedAttempts >= _maxAttempts) {
        _showSnackBar(
          'Session expired or too many attempts. Please try again later.',
          color: Colors.red[700],
        );
        _clearInputs();
      } else if (error.contains('network') ||
          error.contains('socket') ||
          error.contains('timeout')) {
        _showSnackBar(
          'Network error. Please check your connection.',
          color: Colors.red[700],
        );
        _clearInputs();
      } else if (error.contains('email not registered') ||
          error.contains('account not found')) {
        _showSnackBar(
          'Account not found. This email is not registered.',
          color: Colors.red[700],
        );
        _clearInputs();
      } else if (error.contains('not found')) {
        _showSnackBar(
          'Invalid account. Please check your input details.',
          color: Colors.red[700],
        );
        _clearInputs();
      } else if (error.contains('invalid credentials')) {
        _showSnackBar(
          'Invalid credentials. Please try again.',
          color: Colors.red[700],
        );
        _clearInputs();
      } else if (error.contains('incorrect password')) {
        _showSnackBar(
          'Incorrect password. Please try again.',
          color: Colors.red[700],
        );
        _clearInputs();
      } else if (error.contains('session expired') ||
          error.contains('too many')) {
        _showSnackBar(
          'Session expired or too many attempts. Please try again later.',
          color: Colors.red[700],
        );
        _clearInputs();
      } else {
        _showSnackBar(
          'Login failed. Please try again.',
          color: Colors.red[700],
        );
        _clearInputs();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMint, // Using kMint from constants.dart
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            defaultPadding,
          ), // Using defaultPadding from constants
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ), // Replace with actual logo asset path
                Image.asset('assets/images/logo_name.png', height: 50),
                const SizedBox(height: 77),
                Column(
                  children: [
                    // Gradient text using GradientText component
                    GradientText(
                      text: 'Welcome Back!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      gradient: kGreenGradient1,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Log in to continue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: authInputDecoration.copyWith(
                      labelText: 'Email or phone number',
                    ),
                    validator: (value) {
                      if (!_submitted) return null;
                      if (value == null || value.isEmpty) {
                        return 'Required field';
                      }
                      // Accept either valid email or phone number (basic check)
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      final phoneRegex = RegExp(r'^[0-9]{7,15}$');
                      if (!emailRegex.hasMatch(value.trim()) &&
                          !phoneRegex.hasMatch(value.trim())) {
                        return 'Enter a valid email or phone number';
                      }
                      return null;
                    },
                    onChanged: (_) {
                      setState(
                        () {},
                      ); // Rebuild to update password enabled state
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    enabled: _emailController.text.trim().isNotEmpty,
                    decoration: authInputDecoration.copyWith(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (!_submitted) return null;
                      if (value == null || value.isEmpty) {
                        return 'Required field';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Password must contain an uppercase letter';
                      }
                      if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return 'Password must contain a lowercase letter';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Password must contain a number';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),
                // Gradient button for login
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                    gradient: kGreenGradient1,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'LOG IN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 6),
                // Forgot password
                TextButton(
                  onPressed: () {
                    // Navigate to forgot password screen
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kGreen1,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 100),
                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: kGreen1, fontSize: 12),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: GradientText(
                        text: 'Sign up',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        gradient: kGreenGradient1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
