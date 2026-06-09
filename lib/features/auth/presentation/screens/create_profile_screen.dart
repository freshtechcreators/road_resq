import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final _specializationController = TextEditingController();
  bool _isLoading = false;

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
      if (role == 'user') {
        final user = UserEntity(
          uid: currentUser.uid,
          phoneNumber: currentUser.phoneNumber ?? '',
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );
        await saveProfile.saveUser(user);
      } else {
        final mechanic = MechanicEntity(
          uid: currentUser.uid,
          phoneNumber: currentUser.phoneNumber ?? '',
          name: _nameController.text.trim(),
          shopName: _shopNameController.text.trim(),
          email: _emailController.text.trim(),
          specialization: _specializationController.text.trim(),
        );
        await saveProfile.saveMechanic(mechanic);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Created Successfully!')),
      );
      // Here you would navigate to the Home screen if it existed.
      // Since it doesn't, we just stop here as per instructions.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(userRoleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us more about you',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              if (role == 'mechanic') ...[
                const SizedBox(height: 15),
                TextFormField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(labelText: 'Shop Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(labelText: 'Specialization (e.g., Bike, Car, EV)'),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
              ],
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Complete Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
