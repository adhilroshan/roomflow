import 'package:web3dart/web3dart.dart';

class Space {
  final BigInt id;
  final String name;
  final String description;
  final String images;
  final BigInt rooms;
  final BigInt price;
  final EthereumAddress owner;
  final bool booked;
  final bool deleted;
  final bool availability;
  final BigInt timestamp;

  Space({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.rooms,
    required this.price,
    required this.owner,
    required this.booked,
    required this.deleted,
    required this.availability,
    required this.timestamp,
  });

}

  // factory Space.fromJson(Map<String, dynamic> json) {
  //   return Space(
  //     id: json['id'],
  //     name: json['name'],
  //     description: json['description'],
  //     images: json['images'],
  //     rooms: json['rooms'],
  //     price: json['price'],
  //     owner: json['owner'],
  //     booked: json['booked'],
  //     deleted: json['deleted'],
  //     availability: json['availability'],
  //     timestamp: json['timestamp'],
  //     // ... other properties
  //   );
  // }