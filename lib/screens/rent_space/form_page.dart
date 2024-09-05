import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/services/space_service.dart';
import 'package:roomflow/utils/app_styles.dart';
import 'package:roomflow/utils/size_config.dart';
// import './custom_button.dart';
import './custom_input.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
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

  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    var spacesServices = context.watch<SpaceServices>();

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "Rent a Space ",
          style: kRalewayBold.copyWith(
            // color:  kGrey85,
            // fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        
          padding: const EdgeInsets.all(20),
          child: Stepper(

            connectorColor: MaterialStateProperty.all<Color>(kDarkBlue),
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepCancel: () => currentStep == 0
                ? null
                : setState(() {
                    currentStep -= 1;
                  }),
            onStepContinue: () async {
              bool isLastStep = (currentStep == getSteps().length - 1);
              if (isLastStep) {
                //Do something with this information
                print("Title: ${titleController.text}");
                print("Subtitle: ${subtitleController.text}");
                print("Description: ${descriptionController.text}");
                print("Rooms Available: ${roomsController.text}");
                print("Price per Room: ${priceController.text}");
                print("Image URLs: ${imgUrlController.text}");
                // Assuming createSpace is an asynchronous method in SpaceServices
                try {
                  await spacesServices.createSpace(
                      titleController.text,
                      subtitleController.text,
                      descriptionController.text,
                      imgUrlController.text,
                      BigInt.parse(roomsController.text),
                      BigInt.parse(priceController.text));
                  // Handle success, maybe navigate away or show a success message
                } catch (e) {
                  // Handle error, maybe show an error message
                  print("Error creating space: $e");
                }
              } else {
                setState(() {
                  currentStep += 1;
                });
              }
            },
            onStepTapped: (step) => setState(() {
              currentStep = step;
            }),
            steps: getSteps(),
          )),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Basic Info"),
        content: Column(
          children: [
            CustomInput(
              hint: "Title",
              controller: titleController,
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Subtitle",
              controller: subtitleController,
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Description",
              controller: descriptionController,
              inputBorder: OutlineInputBorder(),
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Pricing Info"),
        content: Column(
          children: [
            CustomInput(
              hint: "No of Rooms Available",
              controller: roomsController,
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Price per Room",
              controller: priceController,
              inputBorder: OutlineInputBorder(),
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Misc"),
        content: Column(
          children: [
            CustomInput(
              hint: "Image URLs separated by commas",
              controller: imgUrlController,
              inputBorder: OutlineInputBorder(),
            ),
          ],
        ),
      ),
    ];
  }
}
