import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomflow/models/models.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class SpaceServices extends ChangeNotifier {
  List<Space> spaces = [];
  Map<BigInt, Booking> bookings = {};

  // List<Booking> bookings = [];z

  final String _rpcUrl = 'https://eth-sepolia.g.alchemy.com/v2/hN9G-jqNR8VhEgtek2IclMCjrp-wyMX-';
  // final String _rpcUrl =
  //     Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  // final String _wsUrl =
  //     Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
  final String? _wsUrl = dotenv.env['SEPOLIA_WS_URL'];
  // final String _privateKey =
  //     '0xbf35ed4b5b32e425ae5dd3ad8a031b9482ba0c89be732d9cba9353b30ed7d207';
  // '0xec57a7fb0314f2942ead1bb0b1189f60b476cd10303c69e2616df39e8e1b98f2';
  // '0xdf5c2269caaea26303adfc37237bc839aef0a349c7637e77e348eb2ff7a10374';
  // '0x2c8f0fac8f5858cf4d96cc41b4fd5f18c2cb89cc3a87b41299fc54170ad59730';

  bool isLoading = true;
  final chainId = 11155111;
  static const _chainId = "11155111";

  final _sepoliaChain = W3MChainInfo(
    chainName: 'Sepolia',
    namespace: 'eip155:$_chainId',
    chainId: _chainId,
    tokenName: 'ETH',
    rpcUrl: 'https://rpc.sepolia.org/',
    blockExplorer: W3MBlockExplorer(
      name: 'Sepolia Explorer',
      url: 'https://sepolia.etherscan.io/',
    ),
  );
  // final chainId = 80001;
  late BigInt securityFee;

  // THIS PRIVATE KEY IS FOR TESTING PURPOSES ONLY
  // late String _privateKey =
  //     '0xea297c14fa849199597af13a39e843dd493df81c920ea674772b4570c2838e1c';
  // Future<void> setPrivateKey(String privateKey) async {
  //   // _privateKey = '0x$privateKey';
  //   _privateKey = privateKey;

  //   // await getABI();
  //   // await getCredentials();
  //   // await getDeployedContract();
  // }

  SpaceServices() {
    init();
  }

  List<Space> getBookedSpaces() {
    List<BigInt> spaceId = [];
    List<Space> spacess = [];
    bookings.forEach((key, value) {
      if (value.tenant == walletAddress) {
        spaceId.add(key);
        print(key);
      }
    });
    for (final s in spaceId) {
      // spacess.add(spaces[s.]);
      // print(s.toInt());
    }

    return spaces;
    // bookings.keys.firstWhere((key) => bookings[key] = )
  }

  final Set<String> excludedWalletIds = {
    // 'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96', // MetaMask
    // '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0', // Trust
    'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa', // Coinbase Wallet
  };

  late Web3Client web3client;
  late W3MService w3mService;
  Future<void> init() async {
    W3MChainPresets.chains.putIfAbsent('11155111', () => _sepoliaChain);
    w3mService = W3MService(
      projectId: '1dea236f62963108a1717ac158808356',
      metadata: const PairingMetadata(
        name: 'RoomFlow',
        description: 'RoomFlow',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutterdapp://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
      excludedWalletIds: excludedWalletIds,
    );
    // await w3mService.init();
    try {
      await w3mService.init();
    } catch (e) {
      print("Error initializing W3MService: $e");
      // Handle the error appropriately
    }
    web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl!).cast<String>();
    });
    print("RPC URL:  $_rpcUrl");

    await getABI();
    // await getCredentials();
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
        EthereumAddress.fromHex(jsonABI["networks"]["11155111"]["address"]);
    print("\nContract Address $_contractAddress\n");
    // EthereumAddress.fromHex(jsonABI["networks"]["80001"]["address"]);
    // _contractAddress =
    // EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  // late EthPrivateKey creds;
  // Future<void> getCredentials() async {
  //   creds = EthPrivateKey.fromHex(_privateKey);
  // }

  // Future<void> connectWallet() async {
  //   try {
  //     await w3mService.openModal();
  //     notifyListeners();
  //   } catch (e) {
  //     print("Error connecting wallet: $e");
  //   }
  // }

  bool get isConnected => w3mService.isConnected;

  // Future<void> disconnectWallet() async {
  //   await w3mService.disconnect();
  //   notifyListeners();
  // }

  void launchWallet() {
    w3mService.launchConnectedWallet();
  }

  // get connected wallet address
  String? get walletAddress => w3mService.session?.address;

  late DeployedContract _deployedContract;
  late ContractFunction _securityFee;
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
  // late ContractFunction _updateSecurityFee;
  // late ContractFunction _updateTaxPercent;
  late ContractFunction _addReview;
  late ContractFunction _getReviews;
  // late ContractFunction _tenantBooked;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    // _totalSpaces = _deployedContract.function('totalSpaces');
    _securityFee = _deployedContract.function('securityFee');
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
    // _updateSecurityFee = _deployedContract.function('updateSecurityFee');
    // _updateTaxPercent = _deployedContract.function('updateTaxPercent');
    _addReview = _deployedContract.function('addReview');
    _getReviews = _deployedContract.function('getReviews');
    // _tenantBooked = _deployedContract.function('tenantBooked');
    await fetchSpaces();
    await fetchSecurityFee();
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

  Future<void> fetchSecurityFee() async {
    // final securityFee = await contract.read('securityFee');
    final sF = await web3client
        .call(contract: _deployedContract, function: _securityFee, params: []);
    securityFee = sF[0];
    print('Security Fee: $securityFee');
  }

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
    print("\n----\n$result\n----\n");

    for (var spaceData in result[0]) {
      Space space = Space(
        id: spaceData[0],
        title: spaceData[1],
        subtitle: spaceData[2],
        description: spaceData[3],
        images: spaceData[4],
        rooms: spaceData[5],
        price: spaceData[6],
        owner: spaceData[7],
        booked: spaceData[8],
        deleted: spaceData[9],
        availability: spaceData[10],
        timestamp: spaceData[11],
      );
      spaces.add(space);
    }
    // print("\n----\n$spaces\n----\n");

    isLoading = false;
    notifyListeners();
    // return spaces;
  }

  /* Future<void> createSpace(
    String title,
    String subtitle,
    String description,
    String images,
    BigInt rooms,
    BigInt price,
  ) async {
    print("\n----\nCalling create Space Function\n----\n");

    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _createSpace.encodeCall([
      title,
      subtitle,
      description,
      images,
      rooms,
      price,
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      // gasPrice: EtherAmount.inWei(BigInt.from(100000000)),
      // maxGas: 6000000,
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
  } */

  /* Future<void> createSpace(
    String title,
    String subtitle,
    String description,
    String images,
    BigInt rooms,
    BigInt price,
  ) async {
    if (_w3mService.session == null) {
      throw Exception("Wallet not connected");
    }

    final functionCall = _createSpace.encodeCall([
      title,
      subtitle,
      description,
      images,
      rooms,
      price,
    ]);

    final transaction = Transaction(
      to: _contractAddress,
      data: functionCall,
    );

    try {
      final result = await _w3mService.request(
        topic: _w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction.toJson()],
        ),
      );

      print("Transaction hash: $result");
      isLoading = true;
      notifyListeners();
      spaces.clear();
      await fetchSpaces();
    } catch (e) {
      print("Error sending transaction: $e");
    }
  } */

  Future<void> createSpace(
    String title,
    String subtitle,
    String description,
    String images,
    BigInt rooms,
    BigInt price, 
  ) async {
    if (!isConnected) {
      throw Exception("Wallet not connected");
    }

    final functionCall = _createSpace.encodeCall([
      title,
      subtitle,
      description,
      images,
      rooms,
      price,
    ]);

    print("\n----\nCalling create Space Function\n----\n");
    print("The datas are $title, $subtitle, $description, $images, $rooms, $price");

    final transaction = {
      'to': _contractAddress.hexEip55,
      'data': functionCall,
    };
    print("\n----\n$transaction\n----\n");
    try {
      final result = await w3mService.request(
        topic: w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction],
        ),
      );

      print("Transaction hash: $result");
      isLoading = true;
      notifyListeners();
      spaces.clear();
      await fetchSpaces();
    } catch (e) {
      print("Error sending transaction: $e");
    }
    finally{
      print("Completed");
    }
    print("\n----\n$spaces\n----\n");

  }

  /* Future<void> updateSpace(
    BigInt spaceId,
    String title,
    String subtitle,
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
      title,
      subtitle,
      description,
      images,
      rooms,
      price,
    ]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      // gasPrice: EtherAmount.inWei(BigInt.from(10000000)),
      // maxGas: 6000000,
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
    await fetchSpaces();
  } */

  Future<void> updateSpace(
    BigInt spaceId,
    String title,
    String subtitle,
    String description,
    String images,
    BigInt rooms,
    BigInt price,
  ) async {
    if (!isConnected) {
      throw Exception("Wallet not connected");
    }

    final functionCall = _updateSpace.encodeCall([
      spaceId,
      title,
      subtitle,
      description,
      images,
      rooms,
      price,
    ]);

    final transaction = {
      'to': _contractAddress.hexEip55,
      'data': functionCall,
    };

    try {
      final result = await w3mService.request(
        topic: w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction],
        ),
      );

      print("Transaction hash: $result");
      isLoading = true;
      notifyListeners();
      spaces.clear();
      await fetchSpaces();
    } catch (e) {
      print("Error sending transaction: $e");
    }
  }

  Future<void> deleteSpace(BigInt spaceId) async {
    if (!isConnected) {
      throw Exception("Wallet not connected");
    }

    final functionCall = _deleteSpace.encodeCall([spaceId]);

    final transaction = {
      'to': _contractAddress.hexEip55,
      'data': functionCall,
    };

    try {
      final result = await w3mService.request(
        topic: w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction],
        ),
      );

      print("Transaction hash: $result");
      isLoading = true;
      notifyListeners();
      spaces.clear();
      await fetchSpaces();
    } catch (e) {
      print("Error sending transaction: $e");
    }
  }

  /* Future<void> deleteSpace(
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
      // gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      // maxGas: 6000000,
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
  } */

  Future<Space> fetchSpace(BigInt spaceId) async {
    final List<dynamic> result = await web3client.call(
        contract: _deployedContract, function: _getSpace, params: [spaceId]);

    print("\n----\n$result\n----\n");

    // Process the result and return a Space object
    if (result.isNotEmpty) {
      return Space(
        id: spaceId,
        title: result[0],
        subtitle: result[1],
        description: result[2],
        images: result[3],
        rooms: result[4],
        price: result[5],
        owner: result[6], // Assuming the owner's address is at index 5
        booked: result[7], // Assuming booked status is at index 6
        deleted: result[8], // Assuming deleted status is at index 7
        availability: result[9], // Assuming availability status is at index 8
        timestamp: result[10], // Assuming timestamp is at index 9
      );
    } else {
      throw Exception('Space not found');
    }
    // print("\n----\n$spaces\n----\n");
    // return spaces;
  }

  /* Future<void> bookSpace(
      BigInt spaceId, BigInt startDate, BigInt endDate, BigInt price) async {
    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);
    final functionCall = _bookSpace.encodeCall([
      spaceId,
      startDate,
      endDate,
    ]);

    // Space? space;
    // for (var i = 1; i < spaces.length; i++) {
    //   if (spaces[i].id == spaceId) {
    //     space = spaces[i];
    //   }
    // }
    // final securityFee
    final BigInt bookingPrice = price * (endDate - startDate + BigInt.from(1));
    // print(bookingPrice);
    // print(startDate);
    // print(endDate);
    final totalPayment = bookingPrice + securityFee;
    bookings[spaceId] = Booking(
        id: spaceId,
        tenant: creds.address,
        startDate: startDate,
        endDate: endDate,
        totalPrice: totalPayment,
        checked: false,
        cancelled: false);

    EtherAmount amount = EtherAmount.inWei(totalPayment);
    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      gasPrice: EtherAmount.inWei(BigInt.from(10000000)),
      maxGas: 8000000000,
      value: amount,
      nonce: nonce,
    );

    final estimatedGas = await web3client.estimateGas(
        sender: creds.address,
        to: transaction.to,
        value: transaction.value,
        data: transaction.data);
    print("\nEGAS: -> $estimatedGas\n");

    final signedTransaction = await web3client.signTransaction(
      creds,
      transaction,
      chainId: chainId, // Adjust the chainId if necessary
    );
    // for (final booking in bookings) {
    //   if (booking[spaceId] == null)
    //     bookings.add({
    //       spaceId: Booking(
    //         id: spaceId,
    //         startDate: startDate,
    //         endDate: endDate,
    //         tenant: creds.address,
    //         totalPrice: totalPayment,
    //         checked: false,
    //         cancelled: false,
    //       )
    //     });
    // }

    final response = await web3client.sendRawTransaction(signedTransaction);
    notifyListeners();
    print("\n----\n$response\n----\n");
    print("\n----\n$bookings\n----\n");
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
      // gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      // maxGas: 6000000,
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
      // gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      // maxGas: 6000000,
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

  Future<void> refundBooking(
      BigInt spaceId, BigInt bookingId, BigInt date) async {
    final senderAddress = creds.address;
    final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _refundBooking.encodeCall(
        [spaceId, bookingId, date]); // Encode your function call data here

    final transaction = Transaction(
      to: _deployedContract.address,
      data: functionCall,
      // gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
      // maxGas: 6000000,
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
  } */

  Future<void> bookSpace(
      BigInt spaceId, BigInt startDate, BigInt endDate, BigInt price) async {
    if (!isConnected) {
      throw Exception("Wallet not connected");
    }

    final functionCall = _bookSpace.encodeCall([
      spaceId,
      startDate,
      endDate,
    ]);

    final BigInt bookingPrice = price * (endDate - startDate + BigInt.from(1));
    final totalPayment = bookingPrice + securityFee;

    final transaction = {
      'to': _contractAddress.hexEip55,
      'data': functionCall,
      'value': '0x${totalPayment.toRadixString(16)}',
    };

    try {
      final result = await w3mService.request(
        topic: w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction],
        ),
      );

      print("Transaction hash: $result");
      notifyListeners();
    } catch (e) {
      print("Error sending transaction: $e");
    }
  }

  Future<void> checkInSpace(BigInt spaceId, BigInt bookingId) async {
    if (!isConnected) {
      throw Exception("Wallet not connected");
    }

    final functionCall = _checkInSpace.encodeCall([spaceId, bookingId]);

    final transaction = {
      'to': _contractAddress.hexEip55,
      'data': functionCall,
    };

    try {
      final result = await w3mService.request(
        topic: w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction],
        ),
      );

      print("Transaction hash: $result");
    } catch (e) {
      print("Error sending transaction: $e");
    }
  }

  Future<void> claimFunds(BigInt spaceId, BigInt bookingId) async {
    if (!isConnected) {
      throw Exception("Wallet not connected");
    }

    final functionCall = _claimFunds.encodeCall([spaceId, bookingId]);

    final transaction = {
      'to': _contractAddress.hexEip55,
      'data': functionCall,
    };

    try {
      final result = await w3mService.request(
        topic: w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction],
        ),
      );

      print("Transaction hash: $result");
    } catch (e) {
      print("Error sending transaction: $e");
    }
  }

  Future<void> refundBooking(
      BigInt spaceId, BigInt bookingId, BigInt date) async {
    if (!isConnected) {
      throw Exception("Wallet not connected");
    }

    final functionCall = _refundBooking.encodeCall([spaceId, bookingId, date]);

    final transaction = {
      'to': _contractAddress.hexEip55,
      'data': functionCall,
    };

    try {
      final result = await w3mService.request(
        topic: w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction],
        ),
      );

      print("Transaction hash: $result");
    } catch (e) {
      print("Error sending transaction: $e");
    }
  }

  Future<bool> hasBookedDateReached(BigInt spaceId, BigInt bookingId) async {
    final List<dynamic> result = await web3client.call(
      contract: _deployedContract,
      function: _hasBookedDateReached,
      params: [spaceId, bookingId],
    );

    if (result.isNotEmpty) {
      return result[0] as bool;
    } else {
      throw Exception('Error fetching booked date status');
    }
  }

  Future<List<Booking>> getBookings(BigInt spaceId) async {
    final List<dynamic> result = await web3client.call(
      contract: _deployedContract,
      function: _getBookings,
      params: [spaceId],
    );

    List<Booking> bookings = [];

    for (var bookingData in result[0]) {
      Booking booking = Booking(
        id: bookingData[0],
        tenant: bookingData[1],
        startDate: bookingData[2],
        endDate: bookingData[3],
        totalPrice: bookingData[4],
        checked: bookingData[5],
        cancelled: bookingData[6],
      );
      bookings.add(booking);
    }

    return bookings;
  }

  Future<List<BigInt>> getUnavailableDates(BigInt spaceId) async {
    final List<dynamic> result = await web3client.call(
      contract: _deployedContract,
      function: _getUnavailableDates,
      params: [spaceId],
    );

    List<BigInt> unavailableDates = [];

    if (result.isNotEmpty) {
      for (var date in result[0]) {
        unavailableDates.add(date as BigInt);
      }
      return unavailableDates;
    } else {
      throw Exception('Error fetching unavailable dates');
    }
  }

  Future<Booking> getBooking(BigInt spaceId, BigInt bookingId) async {
    final List<dynamic> result = await web3client.call(
      contract: _deployedContract,
      function: _getBooking,
      params: [spaceId, bookingId],
    );

    if (result.isNotEmpty) {
      return Booking(
        id: result[0],
        tenant: result[1],
        startDate: result[2],
        endDate: result[3],
        totalPrice: result[4],
        checked: result[5],
        cancelled: result[6],
      );
    } else {
      throw Exception('Booking not found');
    }
  }

  Future<void> addReview(BigInt spaceId, String reviewText) async {
    if (!isConnected) {
      throw Exception("Wallet not connected");
    }
    // final senderAddress = creds.address;
    // final nonce = await web3client.getTransactionCount(senderAddress);

    final functionCall = _addReview.encodeCall([spaceId, reviewText]);

    final transaction = {
      'to': _contractAddress.hexEip55,
      'data': functionCall,
    };

    // final transaction = Transaction(
    //   to: _deployedContract.address,
    //   data: functionCall,
    //   nonce: nonce,
    // );

    // final signedTransaction = await web3client.signTransaction(
    //   creds,
    //   transaction,
    //   chainId: chainId,
    // );

    // final response = await web3client.sendRawTransaction(signedTransaction);

    try {
      final result = await w3mService.request(
        topic: w3mService.session!.topic,
        chainId: 'eip155:$chainId',
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [transaction],
        ),
      );

      print("Transaction hash: $result");
    } catch (e) {
      print("Error sending transaction: $e");
    }

    // print("\n----\n$response\n----\n");
    // You can handle the response here, maybe listen for confirmation
  }

  Future<List<Review>> getReviews(BigInt spaceId) async {
    final List<dynamic> result = await web3client.call(
        contract: _deployedContract, function: _getReviews, params: [spaceId]);

    List<Review> reviews = [];

    for (var reviewData in result[0]) {
      Review review = Review(
        id: reviewData[0],
        spaceId: reviewData[1],
        reviewText: reviewData[2],
        timestamp: reviewData[3],
        reviewer: EthereumAddress.fromHex(reviewData[4]),
      );
      reviews.add(review);
    }

    return reviews;
  }
}
