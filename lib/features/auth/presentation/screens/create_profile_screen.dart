import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:road_resq/features/auth/domain/entities/mechanic_entity.dart';
import 'package:road_resq/features/auth/domain/entities/user_entity.dart';
import 'package:road_resq/features/auth/presentation/providers/auth_provider.dart';

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _experienceController = TextEditingController();
  final _servicesController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  String? _base64Image;
  bool _isEditMode = false;
  bool _hasInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _shopNameController.dispose();
    _experienceController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    final role = ref.read(userRoleProvider);
    final saveProfile = ref.read(saveProfileUseCaseProvider);

    try {
      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        _base64Image = base64Encode(bytes);
      }

      if (role == 'user') {
        final user = UserEntity(
          uid: currentUser.uid,
          phoneNumber: currentUser.phoneNumber ?? '',
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          profileImage: _base64Image,
        );
        await saveProfile.saveUser(user);
        ref.invalidate(userProfileProvider);
        
        if (!mounted) return;
        if (_isEditMode) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated!')));
           context.pop();
        } else {
           context.go('/vehicles');
        }
      } else {
        final services = _servicesController.text.split(',').map((e) => e.trim()).toList();
        final mechanic = MechanicEntity(
          uid: currentUser.uid,
          phoneNumber: currentUser.phoneNumber ?? '',
          name: _nameController.text.trim(),
          shopName: _shopNameController.text.trim(),
          email: _emailController.text.trim(),
          experience: _experienceController.text.trim(),
          services: services,
          profileImage: _base64Image,
          isApproved: true,
        );
        await saveProfile.saveMechanic(mechanic);
        ref.invalidate(mechanicProfileProvider);

        if (!mounted) return;
        if (_isEditMode) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated!')));
           context.pop();
        } else {
           context.go('/mechanic-dashboard');
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _initializeData(String role) {
    if (_hasInitialized) return;
    
    if (role == 'user') {
      final profile = ref.read(userProfileProvider).value;
      if (profile != null) {
        _isEditMode = true;
        _nameController.text = profile.name ?? '';
        _emailController.text = profile.email ?? '';
        _base64Image = profile.profileImage;
      }
    } else {
      final profile = ref.read(mechanicProfileProvider).value;
      if (profile != null) {
        _isEditMode = true;
        _nameController.text = profile.name ?? '';
        _emailController.text = profile.email ?? '';
        _shopNameController.text = profile.shopName ?? '';
        _experienceController.text = profile.experience ?? '';
        _servicesController.text = profile.services?.join(', ') ?? '';
        _base64Image = profile.profileImage;
      }
    }
    _hasInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(userRoleProvider);
    _initializeData(role);

    return Scaffold(
      appBar: AppBar(title: Text(_isEditMode ? 'Edit Profile' : 'Create Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _imageFile != null 
                      ? FileImage(_imageFile!) 
                      : (_base64Image != null && _base64Image!.isNotEmpty
                          ? MemoryImage(base64Decode(_base64Image!))
                          : null) as ImageProvider?,
                  child: (_imageFile == null && (_base64Image == null || _base64Image!.isEmpty))
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Profile Image'),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              if (role == 'mechanic') ...[
                const SizedBox(height: 15),
                TextFormField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(
                    labelText: 'Shop Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Experience (Years)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _servicesController,
                  decoration: const InputDecoration(
                    labelText: 'Services (comma separated)',
                    hintText: 'Flat Tire, Oil Change, Engine',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isEditMode ? 'Update Profile' : 'Complete Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
