import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:roomflow/space_service.dart';
import 'package:roomflow/utils/app_styles.dart';
import 'package:roomflow/utils/size_config.dart';
// import 'package:roomflow/screens/product_detail_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationPicker extends StatelessWidget {
  const LocationPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding20,
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
                    'Jakarta',
                    style: kRalewayMedium.copyWith(
                      color: kBlack,
                      fontSize: SizeConfig.blockSizeHorizontal! * 5,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 0.5,
                  ),
                  SvgPicture.asset(
                    'assets/icon_dropdown.svg',
                  ),
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
}
