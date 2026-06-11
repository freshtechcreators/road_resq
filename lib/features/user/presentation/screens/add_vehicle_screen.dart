import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/vehicle_provider.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _regController = TextEditingController();
  final _fuelController = TextEditingController();
  final _brandController = TextEditingController();
  VehicleType _selectedType = VehicleType.car;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vehicle')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<VehicleType>(
              value: _selectedType,
              items: VehicleType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()))).toList(),
              onChanged: (val) => setState(() => _selectedType = val!),
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
            ),
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Vehicle Name')),
            TextFormField(controller: _brandController, decoration: const InputDecoration(labelText: 'Brand')),
            TextFormField(controller: _regController, decoration: const InputDecoration(labelText: 'Registration Number')),
            TextFormField(controller: _fuelController, decoration: const InputDecoration(labelText: 'Fuel Type')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final vehicle = VehicleEntity(
                    id: const Uuid().v4(),
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    name: _nameController.text,
                    registrationNumber: _regController.text,
                    fuelType: _fuelController.text,
                    brand: _brandController.text,
                    type: _selectedType,
                  );
                  await ref.read(vehicleRepositoryProvider).addVehicle(vehicle);
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Save Vehicle'),
            ),
          ],
        ),
      ),
    );
  }
}