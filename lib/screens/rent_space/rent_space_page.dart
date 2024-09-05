import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/models/models.dart';
import 'package:roomflow/screens/widgets/widgets.dart';
import 'package:roomflow/services/space_service.dart';
import 'package:roomflow/utils/size_config.dart';
import 'widgets/widgets.dart';
import 'form_page.dart';

class RentSpace extends StatefulWidget {
  const RentSpace({super.key});

  @override
  State<RentSpace> createState() => _RentSpaceState();
}

class _RentSpaceState extends State<RentSpace> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imgUrlController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
    imgUrlController.dispose();
    roomsController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Space> spaces = [];
    var spacesServices = context.watch<SpaceServices>();
    for (var i = 0; i < spacesServices.spaces.length; i++) {
      if (spacesServices.spaces[i].owner == spacesServices.walletAddress) {
        spaces.add(spacesServices.spaces[i]);
      }

    }
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        
          /* showDialog(
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
                        hintText: 'Enter title',
                      ),
                    ),
                    TextField(
                      controller: subtitleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter subtitle',
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
                        hintText: 'Enter the Price of your space in wei',
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
                          subtitleController.text,
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
           */
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const CustomSearchBar(),
                      YourSpaces(spaces: spaces)
                    ],
                  ),
                ),
              ),
      ),
      // bottomNavigationBar: ,
    );
  }
}
