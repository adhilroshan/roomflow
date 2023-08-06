import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/space_service.dart';
import 'package:roomflow/utils/app_styles.dart';
import 'package:roomflow/utils/size_config.dart';
// import 'package:roomflow/screens/product_detail_page.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  List<String> categories = [
    "House",
    "Apartment",
    "Hotel",
    "Villa",
    "Cottage",
  ];

  int current = 0;

  @override
  Widget build(BuildContext context) {
    var spacesServices = context.watch<SpaceServices>();
    SizeConfig().init(context);

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title:Text("RoomFlow")
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           title: const Text('New Space'),
      //           content: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               TextField(
      //                 controller: titleController,
      //                 decoration: const InputDecoration(
      //                   hintText: 'Enter name',
      //                 ),
      //               ),
      //               TextField(
      //                 controller: descriptionController,
      //                 decoration: const InputDecoration(
      //                   hintText: 'Enter description',
      //                 ),
      //                 enableSuggestions: true,
      //               ),
      //               TextField(
      //                 controller: imgUrlController,
      //                 decoration: const InputDecoration(
      //                   hintText:
      //                       'Enter the URLs of the images separated by commas(,)',
      //                 ),
      //                 // expands: true,
      //                 maxLines: 3,
      //                 keyboardType: TextInputType.multiline,
      //               ),
      //               TextField(
      //                 controller: roomsController,
      //                 decoration: const InputDecoration(
      //                   hintText:
      //                       'Enter the number of rooms available at your Space',
      //                 ),
      //                 keyboardType: TextInputType.number,
      //               ),
      //               TextField(
      //                 controller: priceController,
      //                 decoration: const InputDecoration(
      //                   hintText: 'Enter the Price of your space',
      //                 ),
      //                 keyboardType: TextInputType.number,
      //               ),
      //             ],
      //           ),
      //           actions: [
      //             TextButton(
      //               onPressed: () {
      //                 spacesServices.createSpace(
      //                     titleController.text,
      //                     descriptionController.text,
      //                     imgUrlController.text,
      //                     BigInt.parse(roomsController.text),
      //                     BigInt.parse(priceController.text));
      //                 Navigator.pop(context);
      //               },
      //               child: const Text('Add'),
      //             ),
      //           ],
      //         );
      //       },
      //     );
      //     // spacesServices.createSpace(name, description, images, rooms, price)
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: SafeArea(
        child: spacesServices.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  spacesServices.spaces.clear();
                  spacesServices.fetchSpaces();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const LocationPicker(),
                      const CustomSearchBar(),
                      const SizedBox(
                        height: kPadding24,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 34,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  current = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: index == 0 ? kPadding20 : 12,
                                  right: index == categories.length - 1
                                      ? kPadding20
                                      : 0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kPadding16,
                                ),
                                height: 34,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 0,
                                      offset: const Offset(0, 18),
                                      blurRadius: 18,
                                      color: current == index
                                          ? kBlue.withOpacity(0.1)
                                          : kBlue.withOpacity(0),
                                    )
                                  ],
                                  gradient: current == index
                                      ? kLinearGradientBlue
                                      : kLinearGradientWhite,
                                  borderRadius: BorderRadius.circular(
                                    kBorderRadius10,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    categories[index],
                                    style: kRalewayMedium.copyWith(
                                      color:
                                          current == index ? kWhite : kGrey85,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal! * 2.5,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      NearFromYou(spacesServices: spacesServices),
                      BestForYou(spacesServices: spacesServices),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
