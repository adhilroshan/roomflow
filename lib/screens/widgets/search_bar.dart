
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:roomflow/space_service.dart';
import 'package:roomflow/utils/app_styles.dart';
import 'package:roomflow/utils/size_config.dart';
// import 'package:roomflow/screens/product_detail_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kPadding24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kPadding20,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: kRalewayRegular.copyWith(
                    color: kBlack,
                    fontSize: SizeConfig.blockSizeHorizontal! * 3,
                  ),
                  controller: TextEditingController(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: kPadding16,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(
                        kPadding8,
                      ),
                      child: SvgPicture.asset(
                        'assets/icon_search.svg',
                      ),
                    ),
                    hintText: 'Search address, or near you',
                    border: kInputBorder,
                    errorBorder: kInputBorder,
                    disabledBorder: kInputBorder,
                    focusedBorder: kInputBorder,
                    enabledBorder: kInputBorder,
                    hintStyle: kRalewayRegular.copyWith(
                      color: kGrey85,
                      fontSize: SizeConfig.blockSizeHorizontal! * 3,
                    ),
                    filled: true,
                    fillColor: kWhiteF7,
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal! * 4,
              ),
              Container(
                height: 49,
                width: 49,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadius10),
                  // gradient: kLinearGradientBlue,
                  color: kBlue,
                ),
                child: SvgPicture.asset(
                  'assets/icon_filter.svg',
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
