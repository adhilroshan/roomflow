import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/space_service.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
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

  @override
  Widget build(BuildContext context) {
    var spacesServices = context.watch<SpaceServices>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("RoomFlow"),
      ),
      body: spacesServices.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                spacesServices.spaces.clear();
                spacesServices.fetchSpaces();
              },
              child: ListView.builder(
                  itemCount: spacesServices.spaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return AlertDialog(
                        //         title: const Text('New Booking'),
                        //         content: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: [
                        //               TextField(
                        //                 controller: idController,
                        //                 decoration: const InputDecoration(
                        //                   hintText: '',
                        //                 ),
                        //               ),
                        //             ]),
                        //       );
                        //     });
                        // Choose a start date.
                        DateTime? startDate, endDate;
                        showCustomDateRangePicker(
                          context,
                          dismissible: true,
                          minimumDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          maximumDate:
                              DateTime.now().add(const Duration(days: 30)),
                          endDate: endDate,
                          startDate: startDate,
                          backgroundColor: Colors.white,
                          primaryColor: Theme.of(context).primaryColor,
                          onApplyClick: (start, end) {
                            setState(() {
                              endDate = end;
                              startDate = start;
                            });
                            // int ab = endDate!.millisecondsSinceEpoch -
                            //     startDate!.millisecondsSinceEpoch;
                            // double b = ab / 86400000;
                            // print(
                            //     '\n\n-----------\n$startDate\n-------------\n\n');
                            // print(
                            //     '\n\n-----------\n$endDate\n-------------\n\n');
                            // print('\n\n-----------\n$b\n-------------\n\n');
                            print('\n\n-----------\nDate\n-------------\n\n');
                            spacesServices.bookSpace(
                                spacesServices.spaces[index].id,
                                BigInt.from(startDate!.millisecondsSinceEpoch),
                                BigInt.from(endDate!.millisecondsSinceEpoch));
                            print('\n\n-----------\nDate\n-------------\n\n');
                          },
                          onCancelClick: () {
                            setState(() {
                              endDate = null;
                              startDate = null;
                            });
                          },
                        );
                      },
                      title: Text(spacesServices.spaces[index].name),
                      subtitle: Text(spacesServices.spaces[index].description),
                      leading: CircleAvatar(
                        // radius:  5,
                        backgroundImage:
                            NetworkImage(spacesServices.spaces[index].images),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          spacesServices
                              .deleteSpace(spacesServices.spaces[index].id);
                        },
                      ),
                      // child: Image.network(
                      //     spacesServices.spaces[index].images,fit: BoxFit.cover,)),
                      // trailing: IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                    );
                  }),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
                    ),
                    TextField(
                      controller: imgUrlController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the imageUrl',
                      ),
                    ),
                    TextField(
                      controller: roomsController,
                      decoration: const InputDecoration(
                        hintText:
                            'Enter the number of rooms available at your Space',
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        hintText: 'Enter the Price of your space',
                      ),
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
        },
      ),
    );
  }
}
