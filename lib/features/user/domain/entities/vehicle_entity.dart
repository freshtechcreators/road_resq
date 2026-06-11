enum VehicleType { bike, car }

class VehicleEntity {
  final String id;
  final String userId;
  final String name;
  final String registrationNumber;
  final String fuelType;
  final String brand;
  final VehicleType type;

  VehicleEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.registrationNumber,
    required this.fuelType,
    required this.brand,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'registrationNumber': registrationNumber,
      'fuelType': fuelType,
      'brand': brand,
      'type': type.name,
    };
  }

  factory VehicleEntity.fromMap(Map<String, dynamic> map) {
    return VehicleEntity(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      fuelType: map['fuelType'] ?? '',
      brand: map['brand'] ?? '',
      type: VehicleType.values.byName(map['type'] ?? 'car'),
    );
  }
}