import 'package:web3dart/web3dart.dart';

class Review {
  final int id;
  final int spaceId;
  final String reviewText;
  final int timestamp;
  final EthereumAddress reviewer;

  Review({
    required this.id,
    required this.spaceId,
    required this.reviewText,
    required this.timestamp,
    required this.reviewer,
  });
}
