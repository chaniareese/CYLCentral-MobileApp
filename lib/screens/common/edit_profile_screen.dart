import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/constants.dart';
import '/data/models/user_model.dart';
import '/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _contactNumberController;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _contactNumberController = TextEditingController(text: widget.user.contactNumber ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Map<String, dynamic> updateData = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'contact_number': _contactNumberController.text.trim(),
      };
      // If image is picked, add to updateData (implement backend support for image upload)
      if (_imageFile != null) {
        updateData['profile_picture'] = _imageFile;
      }
      await authProvider.updateProfile(updateData);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMint,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontSize: 16, color: kWhite, fontWeight: FontWeight.w600)),
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: kGreenGradient1)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: kGreen2.withOpacity(0.2),
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (widget.user.profilePicture != null && widget.user.profilePicture!.isNotEmpty)
                            ? NetworkImage(widget.user.profilePicture!) as ImageProvider
                            : null,
                    child: (_imageFile == null && (widget.user.profilePicture == null || widget.user.profilePicture!.isEmpty))
                        ? const Icon(Icons.person, size: 60, color: kGreen1)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: PopupMenuButton<ImageSource>(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: kGreen1,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                      onSelected: _pickImage,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: ImageSource.camera,
                          child: Text('Take Photo'),
                        ),
                        const PopupMenuItem(
                          value: ImageSource.gallery,
                          child: Text('Choose from Gallery'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _firstNameController,
                decoration: authInputDecoration.copyWith(labelText: 'First Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: authInputDecoration.copyWith(labelText: 'Last Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactNumberController,
                decoration: authInputDecoration.copyWith(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value)) return 'Enter a valid contact number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.user.email,
                enabled: false,
                decoration: authInputDecoration.copyWith(labelText: 'Email'),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: kGreen1)
                            : const Text('Save Changes', style: TextStyle(color: kGreen1, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: kGreen1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: kGreen1, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

