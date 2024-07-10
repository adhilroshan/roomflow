import 'package:flutter/material.dart';
import 'package:roomflow/services/location_service.dart';
// import 'package:provider/provider.dart';
// import 'package:roomflow/space_service.dart';
import 'package:roomflow/utils/app_styles.dart';
import 'package:roomflow/utils/size_config.dart';
// import 'package:roomflow/screens/product_detail_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({
    super.key,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  // late Location location;
  String? lat, long, country, adminArea;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: kPadding20,
        left: kPadding20,
        right: kPadding20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location',
                style: kRalewayRegular.copyWith(
                  color: kGrey83,
                  fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 0.5,
              ),
              Row(
                children: [
                  Text(
                    adminArea != null ? adminArea! : 'Kochi',
                    style: kRalewayMedium.copyWith(
                      color: kBlack,
                      fontSize: SizeConfig.blockSizeHorizontal! * 5,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 0.5,
                  ),
                  // SvgPicture.asset(
                  //   'assets/icon_dropdown.svg',
                  // ),
                ],
              )
            ],
          ),
          SvgPicture.asset(
            'assets/icon_notification_has_notif.svg',
          ),
        ],
      ),
    );
  }

  void getLocation() async {
    final service = LocationService();
    final locationData = await service.getLocation();

    if (locationData != null) {
      final placeMark = await service.getPlaceMark(locationData: locationData);

      setState(() {
        lat = locationData.latitude!.toStringAsFixed(2);
        long = locationData.longitude!.toStringAsFixed(2);

        country = placeMark?.country ?? 'could not get country';
        adminArea = placeMark?.administrativeArea ?? 'could not get admin area';
      });
      print(lat);
    }
  }
}
