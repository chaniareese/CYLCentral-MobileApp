import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

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
  final _birthdateController = TextEditingController();
  final _employmentStatusController = TextEditingController();
  final _companyController = TextEditingController();
  
  String? _region;
  String? _province;
  String? _errorMessage;
  bool _isLoading = false;
  DateTime? _selectedDate;
  
  // Employment status options
  final List<String> _employmentStatusOptions = [
    'Employed',
    'Self-employed',
    'Unemployed',
    'Student',
    'Retired'
  ];

  // Region options
  final List<String> _regions = [
    'NCR',
    'CAR',
    'Region I',
    'Region II',
    'Region III',
    'Region IV-A',
    'Region IV-B',
    'Region V',
    'Region VI',
    'Region VII',
    'Region VIII',
    'Region IX',
    'Region X',
    'Region XI',
    'Region XII',
    'Region XIII',
    'BARMM'
  ];

  // Provinces by region
  final Map<String, List<String>> _provincesByRegion = {
    'NCR': ['Manila', 'Quezon City', 'Makati', 'Pasig', 'Taguig'],
    'CAR': ['Abra', 'Apayao', 'Benguet', 'Ifugao', 'Kalinga', 'Mountain Province'],
    'Region I': ['Ilocos Norte', 'Ilocos Sur', 'La Union', 'Pangasinan'],
    'Region III': ['Aurora', 'Bataan', 'Bulacan', 'Nueva Ecija', 'Pampanga', 'Tarlac', 'Zambales'],
  };

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _contactNumberController.dispose();
    _birthdateController.dispose();
    _employmentStatusController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  // Show date picker for birthdate
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'Select Birthdate',
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Register the user
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).register(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        contactNumber: _contactNumberController.text.trim(),
        birthdate: _birthdateController.text.trim(), 
        employmentStatus: _employmentStatusController.text.trim(),
        company: _companyController.text.trim(),
        region: _region,
        province: _province,
      );

      print('Registration successful!');

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Registration Successful'),
              content: Text('Your account has been created successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Registration error: $e');
      setState(() {
        _errorMessage = e.toString();
        if (_errorMessage!.contains('Exception: Registration failed: Exception: ')) {
          _errorMessage = _errorMessage!.replaceFirst('Exception: Registration failed: Exception: ', '');
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // // Test direct registration
  // Future<void> _testDirectRegistration() async {
  //   if (!_formKey.currentState!.validate()) return;
    
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });

  //   try {
  //     final apiService = ApiService();
      
  //     print('Testing direct registration...');
      
  //     final result = await apiService.register(
  //       firstName: _firstNameController.text.trim(),
  //       lastName: _lastNameController.text.trim(),
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text,
  //       contactNumber: _contactNumberController.text.trim(),
  //       birthdate: _birthdateController.text.trim(),
  //       employmentStatus: _employmentStatusController.text.trim(),
  //       company: _companyController.text.trim(),
  //       region: _region,
  //       province: _province,
  //     );
      
  //     setState(() {
  //       _errorMessage = "✅ Registration successful! User ID: ${result['user']['id']}";
  //     });
      
  //     Future.delayed(Duration(seconds: 1), () {
  //       if (mounted) {
  //         Navigator.of(context).pushReplacementNamed('/home');
  //       }
  //     });
      
  //   } catch (e) {
  //     print('Direct registration test error: $e');
  //     setState(() {
  //       String errorMsg = e.toString();
  //       if (errorMsg.contains('Exception: Registration failed: Exception: ')) {
  //         errorMsg = errorMsg.replaceFirst('Exception: Registration failed: Exception: ', '');
  //       }
  //       _errorMessage = "❌ Registration error: $errorMsg";
  //     });
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kGreen1),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
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
                child: Image.asset(
                  'assets/images/cylcentral_logo.png',
                  height: 50,
                ),
              ),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    GradientText(
                      text: 'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      gradient: kGreenGradient,
                    ),
                    const SizedBox(height: 24),

                    // First Name and Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: authInputDecoration.copyWith(labelText: 'First Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: authInputDecoration.copyWith(labelText: 'Last Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: authInputDecoration.copyWith(labelText: 'Email Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Contact Number
                    TextFormField(
                      controller: _contactNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: authInputDecoration.copyWith(labelText: 'Contact Number'),
                    ),
                    const SizedBox(height: 10),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: authInputDecoration.copyWith(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: authInputDecoration.copyWith(labelText: 'Confirm Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _errorMessage!.contains('✅') 
                              ? Colors.green.withOpacity(0.1) 
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _errorMessage!.contains('✅') ? Colors.green : Colors.red,
                          ),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: _errorMessage!.contains('✅') ? Colors.green : Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    
                    if (_errorMessage != null) const SizedBox(height: 16),

                    // Register button
                    GreenGradientButton(
                      text: _isLoading ? '' : 'CREATE ACCOUNT',
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
                    
                 

                    // Login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: kGreen1,
                              fontSize: 12,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: GradientText(
                              text: 'Log in',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              gradient: kGreenGradient,
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