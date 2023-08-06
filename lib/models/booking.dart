import 'package:web3dart/web3dart.dart';

class Booking {
  final BigInt id;
  final EthereumAddress tenant;
  final BigInt startDate;
  final BigInt endDate;
  final BigInt totalPrice;
  final bool checked;
  final bool cancelled;

  Booking({
    required this.id,
    required this.tenant,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.checked,
    required this.cancelled,
  });
}
