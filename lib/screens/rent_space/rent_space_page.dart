import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/models/models.dart';
import 'package:roomflow/screens/widgets/widgets.dart';
import 'package:roomflow/space_service.dart';
import 'package:roomflow/utils/size_config.dart';
import 'widgets/widgets.dart';

class RentSpace extends StatefulWidget {
  const RentSpace({super.key});

  @override
  State<RentSpace> createState() => _RentSpaceState();
}

class _RentSpaceState extends State<RentSpace> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imgUrlController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    imgUrlController.dispose();
    roomsController.dispose();
    priceController.dispose();
  }

  List<Space> spaces = [];
  @override
  @override
  Widget build(BuildContext context) {
    var spacesServices = context.watch<SpaceServices>();
    for (var i = 0; i < spacesServices.spaces.length; i++) {
      if (spacesServices.spaces[i].owner == spacesServices.creds.address) {
        spaces.add(spacesServices.spaces[i]);
      }
    }
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Space'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter name',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter description',
                      ),
                      enableSuggestions: true,
                    ),
                    TextField(
                      controller: imgUrlController,
                      decoration: const InputDecoration(
                        hintText:
                            'Enter the URLs of the images separated by commas(,)',
                      ),
                      // expands: true,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    TextField(
                      controller: roomsController,
                      decoration: const InputDecoration(
                        hintText:
                            'Enter the number of rooms available at your Space',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the Price of your space',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      spacesServices.createSpace(
                          titleController.text,
                          descriptionController.text,
                          imgUrlController.text,
                          BigInt.parse(roomsController.text),
                          BigInt.parse(priceController.text));
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
          // spacesServices.createSpace(name, description, images, rooms, price)
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
          child: spacesServices.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    spacesServices.spaces.clear();
                    spaces.clear();
                    spacesServices.fetchSpaces();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const CustomSearchBar(),
                        YourSpaces(spaces: spaces)
                      ],
                    ),
                  ))),
    );
  }
}
