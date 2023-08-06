import 'package:flutter/material.dart';
import 'package:roomflow/models/models.dart';
import 'package:roomflow/screens/rent_space/space_detail_page.dart';
// import 'package:roomflow/space_service.dart';
import 'package:roomflow/utils/app_styles.dart';
import 'package:roomflow/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class YourSpaces extends StatelessWidget {
  const YourSpaces({super.key, required this.spaces});

  final List<Space> spaces;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Spaces',
                style: kRalewayMedium.copyWith(
                  color: kBlack,
                  fontSize: SizeConfig.blockSizeHorizontal! * 4,
                ),
              ),
              // Text(
              //   'See more',
              //   style: kRalewayRegular.copyWith(
              //     color: kGrey85,
              //     fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(
          height: kPadding24,
        ),
        spaces.isEmpty
            ? Text("No Spaces",
                style: kRalewayMedium.copyWith(
                  color: Colors.black45,
                ))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: spaces.length,
                itemBuilder: (context, index) {
                  var images = spaces[index].images.split(',');
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: (() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpaceDetailPage(spaceId: index),
                            ),
                          )),
                      child: Container(
                        height: 272,
                        width: 222,
                        margin: const EdgeInsets.only(
                          left: kPadding20,
                          right: kPadding20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            kBorderRadius20,
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 0,
                              offset: const Offset(0, 18),
                              blurRadius: 18,
                              color: kBlack.withOpacity(0.1),
                            )
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              images[0],
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 136,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(kBorderRadius20),
                                    bottomRight:
                                        Radius.circular(kBorderRadius20),
                                  ),
                                  gradient: kLinearGradientBlack,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kPadding16,
                                  vertical: kPadding20,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              kBorderRadius20,
                                            ),
                                            color: kBlack.withOpacity(
                                              0.24,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kPadding8,
                                            vertical: kPadding4,
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icon_pinpoint.svg',
                                              ),
                                              const SizedBox(
                                                width: kPadding4,
                                              ),
                                              Text(
                                                '1.8 km',
                                                style: kRalewayRegular.copyWith(
                                                  color: kWhite,
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal! *
                                                      2.5,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          spaces[index].name,
                                          style: kRalewayMedium.copyWith(
                                            color: kWhite,
                                            fontSize: SizeConfig
                                                    .blockSizeHorizontal! *
                                                4,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical! *
                                                  0.5,
                                        ),
                                        Text(
                                          spaces[index].description,
                                          style: kRalewayRegular.copyWith(
                                            color: kWhite,
                                            fontSize: SizeConfig
                                                    .blockSizeHorizontal! *
                                                2.5,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
