import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/main.dart';
import 'package:roomflow/services/space_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController keyController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    keyController.dispose();
  }

  @override
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
    );
  }
}
