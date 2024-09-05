import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/main.dart';
import 'package:roomflow/services/space_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final TextEditingController keyController = TextEditingController();

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   // keyController.dispose();
  // }

  @override
  void initState() {
    super.initState();
    checkWalletConnection();
  }

  void checkWalletConnection() async {
    var spacesServices = context.read<SpaceServices>();
    bool isConnected = await spacesServices.w3mService.isConnected;
    if (isConnected) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var spacesServices = context.watch<SpaceServices>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF111111), // Fixed color value format
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              W3MAccountButton(service: spacesServices.w3mService),
              const SizedBox(height: 20,),
              W3MConnectWalletButton(service: spacesServices.w3mService,),
              const SizedBox(height: 20,),
              W3MNetworkSelectButton(service: spacesServices.w3mService),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                },
                child: const Text('Login'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
  /* @override
  Widget build(BuildContext context) {
    var spacesServices = context.watch<SpaceServices>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(111111)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              W3MConnectWalletButton(service: spacesServices.w3mService),
              W3MNetworkSelectButton(service: spacesServices.w3mService),
              W3MAccountButton(service: spacesServices.w3mService),
              
            ],
          ),
        ),
      ),
    );

    /* var spacesServices = context.watch<SpaceServices>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(111111)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: keyController,
                decoration: const InputDecoration(
                  hintText: 'Enter Privare Key',

                ),
              ),
              TextButton(
                  onPressed: () async{
                    spacesServices.setPrivateKey(keyController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    );
                  },
                  child: Text("Continue"))
            ],
          ),
        ),
      ),
    ); */
  }
} */
