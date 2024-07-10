import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/models/booking.dart';
import 'package:roomflow/models/models.dart';
import 'package:roomflow/screens/booking/widgets/booked_spaces.dart';
import 'package:roomflow/screens/widgets/widgets.dart';
import 'package:roomflow/services/space_service.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // late Map<BigInt, Booking> bookings;

  @override
  Widget build(BuildContext context) {
    var spacesServices = context.watch<SpaceServices>();
    List<Space> spaces = spacesServices.getBookedSpaces();
    return Scaffold(
      body: SafeArea(
        child: spacesServices.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  spacesServices.spaces.clear();
                  // spaces.clear();
                  spacesServices.fetchSpaces();

                  spaces = spacesServices.getBookedSpaces();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const CustomSearchBar(),
                      spacesServices.bookings.isEmpty
                          ? Text("No Bookings found")
                          : BookedSpaces(spaces: spaces),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
