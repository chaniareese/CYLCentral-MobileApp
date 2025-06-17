import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '/providers/auth_provider.dart';
import '/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _contactNumberController = TextEditingController();

  String? _emailError;
  String? _contactNumberError;
  String? _passwordError;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Track if user has attempted to submit (for required field error display)
  bool _submitted = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _contactNumberController.dispose();
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

  // Clear all input fields
  void _clearInputs() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _contactNumberController.clear();
  }

  // Register the user
  Future<void> _register() async {
    setState(() {
      _submitted = true;
      _emailError = null;
      _contactNumberError = null;
      _passwordError = null;
    });
    if (!_formKey.currentState!.validate()) {
      _showSnackBar(
        'Please fill in all required fields.',
        color: Colors.red[700],
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _emailError = null;
      _contactNumberError = null;
      _passwordError = null;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        contactNumber: _contactNumberController.text.trim(),
      );
      if (mounted) {
        _clearInputs();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: kMint,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Registration Successful',
                style: TextStyle(color: kGreen1, fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Your account has been created successfully.',
                style: TextStyle(color: kGreen1),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: kGreen1),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            );
          },
        );
      }
    } on Exception catch (e) {
      Map<String, dynamic>? errorMap;
      try {
        final errorStr = e.toString();
        if (errorStr.trim().startsWith('{')) {
          errorMap = Map<String, dynamic>.from(json.decode(errorStr));
        }
      } catch (_) {}
      setState(() {
        _isLoading = false;
        _emailError = null;
        _contactNumberError = null;
        _passwordError = null;
      });
      if (errorMap != null && errorMap['errors'] != null) {
        final errors = errorMap['errors'];
        setState(() {
          _emailError = errors['email'] != null ? errors['email'][0] : null;
          _contactNumberError =
              errors['contact_number'] != null
                  ? errors['contact_number'][0]
                  : null;
          _passwordError =
              errors['password'] != null ? errors['password'][0] : null;
        });
      } else {
        final error = e.toString().toLowerCase();
        if (error.contains('network') ||
            error.contains('socket') ||
            error.contains('timeout')) {
          _showSnackBar(
            'Network error. Please check your connection.',
            color: Colors.red[700],
          );
        } else if (error.contains('contact number')) {
          setState(() {
            _contactNumberError = 'Contact number already in use.';
          });
        } else if (error.contains('email')) {
          setState(() {
            _emailError = 'Email already in use.';
          });
        } else {
          _showSnackBar(
            'Registration failed. Please try again.',
            color: Colors.red[700],
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Removed the back arrow button
        leading: null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset('assets/images/logo_name.png', height: 50),
              ),
              const SizedBox(height: 10),
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kGreen1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Sign up to get started',
                style: TextStyle(
                  fontSize: 14,
                  color: kGreen1.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Name and Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: authInputDecoration.copyWith(
                              labelText: 'First Name',
                            ),
                            validator: (value) {
                              if (!_submitted) return null;
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onChanged: (_) {
                              if (_formKey.currentState != null) {
                                _formKey.currentState!.validate();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: authInputDecoration.copyWith(
                              labelText: 'Last Name',
                            ),
                            validator: (value) {
                              if (!_submitted) return null;
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onChanged: (_) {
                              if (_formKey.currentState != null) {
                                _formKey.currentState!.validate();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Contact Number
                    TextFormField(
                      controller: _contactNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: authInputDecoration.copyWith(
                        labelText: 'Contact Number',
                        errorText: _contactNumberError,
                      ),
                      validator: (value) {
                        if (!_submitted) return null;
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        if (!RegExp(r'^[0-9]{7,15}').hasMatch(value)) {
                          return 'Please enter a valid contact number';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        if (_formKey.currentState != null) {
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: authInputDecoration.copyWith(
                        labelText: 'Email Address',
                        errorText: _emailError,
                      ),
                      validator: (value) {
                        if (!_submitted) return null;
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        if (_formKey.currentState != null) {
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
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
                        errorText: _passwordError,
                      ),
                      validator: (value) {
                        if (!_submitted) return null;
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
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
                      onChanged: (_) {
                        if (_formKey.currentState != null) {
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: authInputDecoration.copyWith(
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (!_submitted) return null;
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        if (_formKey.currentState != null) {
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    // Register button
                    GreenGradientButton(
                      text: _isLoading ? '' : 'SIGN UP',
                      onPressed: _isLoading ? () {} : _register,
                      height: 48,
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kWhite,
                      ),
                      icon: _isLoading ? null : null,
                    ),
                    if (_isLoading)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: kGreen1,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Forgot password link
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/forgot-password',
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: kGreen1,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(color: kGreen1, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kGreen1,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
