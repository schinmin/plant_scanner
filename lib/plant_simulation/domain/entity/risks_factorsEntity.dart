import 'package:equatable/equatable.dart';

class RisksFactorEntity extends Equatable {
  final String id;
  final String? riskType;
  final String? description;
  final String? mitigation;

  const RisksFactorEntity({
    required this.id,
    this.riskType,
    this.description,
    this.mitigation,
  });

  @override
  List<Object?> get props => [id, riskType, description, mitigation];
}

// {
//                 "risk_type": "Pest Infestation",
//                 "description": "Rice stem borer and leaf folder can affect yield.",
//                 "mitigation": "Regular monitoring and timely use of recommended pesticides; crop rotation.",
//                 "_id": "6a78921374bac6bf15a8d9b0"
//             },
