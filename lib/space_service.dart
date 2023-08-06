import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomflow/models/models.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class SpaceServices extends ChangeNotifier {
  List<Space> spaces = [];
  final String _rpcUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  final String _wsUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
  final String _privateKey =
      '0xec57a7fb0314f2942ead1bb0b1189f60b476cd10303c69e2616df39e8e1b98f2';

  bool isLoading = true;
  final chainId = 1337;

  SpaceServices() {
    init();
  }

  late Web3Client web3client;
  Future<void> init() async {
    web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile = await rootBundle.loadString('src/artifacts/RoomFlow.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode =
        ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'RoomFlowContract');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey creds;
  Future<void> getCredentials() async {
    creds = EthPrivateKey.fromHex(_privateKey);
  }

  late DeployedContract _deployedContract;
  // late ContractFunction _totalSpaces;
  late ContractFunction _createSpace;
  late ContractFunction _updateSpace;
  late ContractFunction _deleteSpace;
  late ContractFunction _getSpaces;
  late ContractFunction _getSpace;
  late ContractFunction _bookSpace;
  late ContractFunction _checkInSpace;
  late ContractFunction _claimFunds;
  late ContractFunction _refundBooking;
  late ContractFunction _hasBookedDateReached;
  late ContractFunction _getUnavailableDates;
  late ContractFunction _getBookings;
  late ContractFunction _getBooking;
  late ContractFunction _updateSecurityFee;
  late ContractFunction _updateTaxPercent;
  late ContractFunction _addReview;
  late ContractFunction _getReviews;
  late ContractFunction _tenantBooked;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    // _totalSpaces = _deployedContract.function('totalSpaces');
    _createSpace = _deployedContract.function('createSpace');
    _updateSpace = _deployedContract.function('updateSpace');
    _deleteSpace = _deployedContract.function('deleteSpace');
    _getSpaces = _deployedContract.function('getSpaces');
    _getSpace = _deployedContract.function('getSpace');
    _bookSpace = _deployedContract.function('bookSpace');
    _checkInSpace = _deployedContract.function('checkInSpace');
    _claimFunds = _deployedContract.function('claimFunds');
    _refundBooking = _deployedContract.function('refundBooking');
    _hasBookedDateReached = _deployedContract.function('hasBookedDateReached');
    _getUnavailableDates = _deployedContract.function('getUnavailableDates');
    _getBookings = _deployedContract.function('getBookings');
    _getBooking = _deployedContract.function('getBooking');
    _updateSecurityFee = _deployedContract.function('updateSecurityFee');
    _updateTaxPercent = _deployedContract.function('updateTaxPercent');
    _addReview = _deployedContract.function('addReview');
    _getReviews = _deployedContract.function('getReviews');
    _tenantBooked = _deployedContract.function('tenantBooked');
    await fetchSpaces();
  }

  // Future<void> a() async {
  //   List totalSpaceList = await _web3cient.call(
  //     contract: _deployedContract,
  //     function: _totalSpaces,
  //     params: [],
  //   );

  //   int totalSpaceLen = totalSpaceList[0].toInt();
  //   spaces.clear();
  //   for (var i = 0; i < totalSpaceLen; i++) {
  //     var temp = await _web3cient.call(
  //         contract: _deployedContract, function: _s, params: [BigInt.from(i)]);
  //     if (temp[1] != "") {
  //       notes.add(
  //         Note(
  //           id: (temp[0] as BigInt).toInt(),
  //           title: temp[1],
  //           description: temp[2],
  //         ),
  //       );
  //     }
  //   }

  //   notifyListeners();
  // }

  // Future<List<Space>> fetchSpaces() async {
  Future<void> fetchSpaces() async {
    // final List spaceData = await _web3client.call(
    //   contract: _deployedContract,
    //   function: _getSpaces,
    //   params: [],
    // );

    // List<Space> spaces = [];
    // for (final data in spaceData) {
    //   spaces.add(
    //       Space.fromJson(data)); // Create a Space model and add it to the list
    // }

    final List<dynamic> result = await web3client
        .call(contract: _deployedContract, function: _getSpaces, params: []);
    // print("\n----\n$result\n----\n");

    for (var spaceData in result[0]) {
      Space space = Space(
        id: spaceData[0],
        name: spaceData[1],
        description: spaceData[2],
        images: spaceData[3],
        rooms: spaceData[4],
        price: spaceData[5],
        owner: spaceData[6],
        booked: spaceData[7],
        deleted: spaceData[8],
        availability: spaceData[9],
        timestamp: spaceData[10],
      );
      spaces.add(space);
    }
    // print("\n----\n$spaces\n----\n");

    isLoading = false;
    notifyListeners();
    // return spaces;
  }

  Future<void> createSpace(
    String name,
    String description,
    String images,
    BigInt rooms,
    BigInt price,
  ) async {
    print("\n----\nCalling create Space Function\n----\n");

    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _createSpace.encodeCall([
      name,
      description,
      images,
      rooms,
      price,
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      maxGas: 6000000,
      nonce: nonce,
    );

    final signedTransaction = await web3client.signTransaction(
        creds, transaction,
        chainId: chainId); // Adjust the chainId if necessary

    final response = await web3client.sendRawTransaction(signedTransaction);

    // final transaction = Transaction.callContract(
    //   contract: _deployedContract,
    //   function: _createSpace,
    //   parameters: [
    //     name,
    //     description,
    //     images,
    //     rooms,
    //     price,
    //   ],
    //   gasPrice: EtherAmount.inWei(
    //       BigInt.from(20000000000)), // Replace with appropriate gas price
    //   maxGas: 6721975, // Replace with appropriate gas limit
    // );
    print("\n----\n$response\n----\n");

    // final credentials = await _web3client.credentials;
    // final response = await web3client.sendTransaction(_creds, transaction);
    // print("\n----\n$response\n----\n");

    // try {
    //   final response = await web3client.sendTransaction(_creds, transaction);
    //   print("Transaction response: $response");
    // } catch (error) {
    //   print("Error sending transaction: $error");
    // }

    // await response.confirmation;
    isLoading = true;
    notifyListeners();
    spaces.clear();
    fetchSpaces();
  }

  Future<void> updateSpace(
    BigInt spaceId,
    String name,
    String description,
    String images,
    BigInt rooms,
    BigInt price,
  ) async {
    print("\n----\nCalling update Space Function\n----\n");

    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _updateSpace.encodeCall([
      spaceId,
      name,
      description,
      images,
      rooms,
      price,
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      maxGas: 6000000,
      nonce: nonce,
    );

    final signedTransaction = await web3client.signTransaction(
        creds, transaction,
        chainId: chainId); // Adjust the chainId if necessary

    final response = await web3client.sendRawTransaction(signedTransaction);

    print("\n----\n$response\n----\n");
    isLoading = true;
    notifyListeners();
    spaces.clear();
    fetchSpaces();
  }

  Future<void> deleteSpace(
    BigInt spaceId,
  ) async {
    print("\n----\nCalling delete Space Function\n----\n");

    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _deleteSpace.encodeCall([
      spaceId,
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      maxGas: 6000000,
      nonce: nonce,
    );

    final signedTransaction = await web3client.signTransaction(
        creds, transaction,
        chainId: chainId); // Adjust the chainId if necessary

    final response = await web3client.sendRawTransaction(signedTransaction);

    print("\n----\n$response\n----\n");
    isLoading = true;
    notifyListeners();
    spaces.clear();
    fetchSpaces();
  }

  Future<Space> fetchSpace(BigInt spaceId) async {
    final List<dynamic> result = await web3client.call(
        contract: _deployedContract, function: _getSpace, params: [spaceId]);

    print("\n----\n$result\n----\n");

    // Process the result and return a Space object
    if (result.isNotEmpty) {
      return Space(
        id: spaceId,
        name: result[0],
        description: result[1],
        images: result[2],
        rooms: result[3],
        price: result[4],
        owner: result[5], // Assuming the owner's address is at index 5
        booked: result[6], // Assuming booked status is at index 6
        deleted: result[7], // Assuming deleted status is at index 7
        availability: result[8], // Assuming availability status is at index 8
        timestamp: result[9], // Assuming timestamp is at index 9
      );
    } else {
      throw Exception('Space not found');
    }
    // print("\n----\n$spaces\n----\n");
    // return spaces;
  }

  Future<void> bookSpace(
      BigInt spaceId, BigInt startDate, BigInt endDate) async {
    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _bookSpace.encodeCall([
      spaceId,
      startDate,
      endDate,
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      maxGas: 6000000,
      nonce: nonce,
    );

    final signedTransaction = await web3client.signTransaction(
      creds,
      transaction,
      chainId: chainId, // Adjust the chainId if necessary
    );

    final response = await web3client.sendRawTransaction(signedTransaction);

    print("\n----\n$response\n----\n");
    // You can handle the response here, maybe listen for confirmation
  }

  Future<void> checkInSpace(BigInt spaceId, BigInt bookingId) async {
    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _checkInSpace.encodeCall([
      spaceId,
      bookingId,
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      maxGas: 6000000,
      nonce: nonce,
    );

    final signedTransaction = await web3client.signTransaction(
      creds,
      transaction,
      chainId: chainId, // Adjust the chainId if necessary
    );

    final response = await web3client.sendRawTransaction(signedTransaction);

    print("\n----\n$response\n----\n");
    // You can handle the response here, maybe listen for confirmation
  }

  Future<void> claimFunds(BigInt spaceId, BigInt bookingId) async {
    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _claimFunds.encodeCall([
      spaceId,
      bookingId,
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      maxGas: 6000000,
      nonce: nonce,
    );

    final signedTransaction = await web3client.signTransaction(
      creds,
      transaction,
      chainId: chainId, // Adjust the chainId if necessary
    );

    final response = await web3client.sendRawTransaction(signedTransaction);

    print("\n----\n$response\n----\n");
    // You can handle the response here, maybe listen for confirmation
  }

  Future<void> refundBooking(BigInt spaceId, BigInt bookingId, BigInt date) async {
    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _refundBooking.encodeCall([
      spaceId,
      bookingId,
      date
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      maxGas: 6000000,
      nonce: nonce,
    );

    final signedTransaction = await web3client.signTransaction(
      creds,
      transaction,
      chainId: chainId,
    );

    final response = await web3client.sendRawTransaction(signedTransaction);

    print("\n----\n$response\n----\n");
    // You can handle the response here, maybe listen for confirmation
  }
  Future<void> hasBookedDateReached(BigInt spaceId, BigInt bookingId) async {
  final List<dynamic> result = await web3client.call(
        contract: _deployedContract, function: _getSpace, params: [spaceId]);

    print("\n----\n$result\n----\n");

    // // Process the result and return a Space object
    // if (result.isNotEmpty) {
    //   return Space(
    //     id: spaceId,
    //     name: result[0],
    //     description: result[1],
    //     images: result[2],
    //     rooms: result[3],
    //     price: result[4],
    //     owner: result[5], // Assuming the owner's address is at index 5
    //     booked: result[6], // Assuming booked status is at index 6
    //     deleted: result[7], // Assuming deleted status is at index 7
    //     availability: result[8], // Assuming availability status is at index 8
    //     timestamp: result[9], // Assuming timestamp is at index 9
    //   );
    // } else {
    //   throw Exception('Space not found');
    // }
    // print("\n----\n$spaces\n----\n");
    // return spaces;
  }

  Future<void> getBookings(BigInt spaceId) async {
    final List<dynamic> result = await web3client.call(
        contract: _deployedContract, function: _getSpace, params: [spaceId]);

    print("\n----\n$result\n----\n");

    // Process the result and return a Space object
    if (result.isNotEmpty) {
      // return Space(
      //   id: spaceId,
      //   name: result[0],
      //   description: result[1],
      //   images: result[2],
      //   rooms: result[3],
      //   price: result[4],
      //   owner: result[5], // Assuming the owner's address is at index 5
      //   booked: result[6], // Assuming booked status is at index 6
      //   deleted: result[7], // Assuming deleted status is at index 7
      //   availability: result[8], // Assuming availability status is at index 8
      //   timestamp: result[9], // Assuming timestamp is at index 9
      // );
      // return Booking(id: Space, tenant: tenant, startDate: startDate, endDate: endDate, totalPrice: totalPrice, checked: checked, cancelled: cancelled)
    } else {
      throw Exception('Space not found');
    }
    // print("\n----\n$spaces\n----\n");
    // return spaces;
  }
}


















// import 'package:web3dart/web3dart.dart';

// class EthereumService {
//   final Web3Client _client;
//   final EthereumAddress _contractAddress;
//   final ContractAbi _contractAbi;

//   EthereumService(String rpcUrl, String contractAddress, String contractAbi)
//       : _client = Web3Client(rpcUrl, Client()),
//         _contractAddress = EthereumAddress.fromHex(contractAddress),
//         _contractAbi = ContractAbi.fromJson(contractAbi, 'RoomFlow');

//   Future<String> createSpace(
//     String name,
//     String description,
//     String images,
//     int capacity,
//     BigInt price,
//   ) async {
//     final credentials =
//         await _client.credentialsFromPrivateKey('YOUR_PRIVATE_KEY');

//     final createSpaceFunction = _contractAbi.functions
//         .firstWhere((element) => element.name == 'createSpace');

//     final response = await _client.sendTransaction(
//       credentials,
//       Transaction.callContract(
//         contract: _contractAddress,
//         function: createSpaceFunction,
//         parameters: [
//           name,
//           description,
//           images,
//           capacity,
//           price,
//         ],
//       ),
//       chainId: 4,
//     );

//     return response;
//   }

//   Future<String> bookSpace(
//     int spaceId,
//     int bookingId,
//     int days,
//     EtherAmount value,
//   ) async {
//     final credentials =
//         await _client.credentialsFromPrivateKey('YOUR_PRIVATE_KEY');

//     final bookSpaceFunction = _contractAbi.functions
//         .firstWhere((element) => element.name == 'bookSpace');

//     final response = await _client.sendTransaction(
//       credentials,
//       Transaction.callContract(
//         contract: _contractAddress,
//         function: bookSpaceFunction,
//         parameters: [
//           spaceId,
//           bookingId,
//           days,
//         ],
//         value: value.getInWei,
//       ),
//       chainId: 4,
//     );

//     return response;
//   }

//   // Add more functions for interacting with other contract functions

//   Stream<RoomBookedEvent> get onRoomBooked {
//     final roomBookedEvent = _contractAbi.events
//         .firstWhere((element) => element.name == 'RoomBooked');

//     return _client
//         .events(
//       filter: FilterOptions.events(
//         contract: _contractAddress,
//         event: roomBookedEvent,
//       ),
//       fromBlock: BlockNum.genesis(),
//       toBlock: BlockNum.pending(),
//     )
//         .map((event) {
//       final decoded = roomBookedEvent.decodeResults(event.topics, event.data);
//       return RoomBookedEvent(
//         spaceId: decoded[0].toInt(),
//         bookingId: decoded[1].toInt(),
//         booker: EthereumAddress.fromHex(decoded[2].toString()),
//       );
//     });
//   }

//   // Add more event streams for other events
// }

// class RoomBookedEvent {
//   final int spaceId;
//   final int bookingId;
//   final EthereumAddress booker;

//   RoomBookedEvent({
//     required this.spaceId,
//     required this.bookingId,
//     required this.booker,
//   });
// }
