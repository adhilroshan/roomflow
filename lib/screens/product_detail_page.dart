import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomflow/models/models.dart';
import 'package:roomflow/space_service.dart';
import 'package:roomflow/utils/app_styles.dart';
import 'package:roomflow/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    Key? key,
    required this.spaceId,
  }) : super(key: key);
  final int spaceId;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var spacesServices = context.watch<SpaceServices>();
    Space space = spacesServices.spaces[spaceId];
    var images = spacesServices.spaces[spaceId].images.split(',');

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding8,
        ),
        height: 43,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: kPadding20,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Price',
                    style: kRalewayRegular.copyWith(
                      color: kGrey85,
                      fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 0.5,
                  ),
                  Text(
                    '${space.price} / Day',
                    style: kRalewayMedium.copyWith(
                      color: kBlack,
                      fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                debugPrint('Rent Now Tapped');
              },
              child: Container(
                height: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    kBorderRadius10,
                  ),
                  gradient: kLinearGradientBlue,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding24,
                ),
                child: Center(
                  child: Text(
                    'Rent Now',
                    style: kRalewaySemibold.copyWith(
                      color: kWhite,
                      fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: kPadding20,
          ),
          child: Column(
            children: [
              Container(
                height: 319,
                width: double.infinity,
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
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(kBorderRadius20),
                            bottomRight: Radius.circular(kBorderRadius20),
                          ),
                          gradient: kLinearGradientBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(kPadding20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context, true),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: kBlack.withOpacity(0.24),
                                  child: SvgPicture.asset(
                                    'assets/icon_arrow_back.svg',
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 17,
                                backgroundColor: kBlack.withOpacity(0.24),
                                child: SvgPicture.asset(
                                  'assets/icon_bookmark.svg',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                space.name,
                                style: kRalewaySemibold.copyWith(
                                  color: kWhite,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal! * 4.5,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 0.5,
                              ),
                              Text(
                                space.description,
                                style: kRalewayRegular.copyWith(
                                  color: kWhite,
                                  fontSize: SizeConfig.blockSizeHorizontal! * 3,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 1.5,
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height:
                                            SizeConfig.blockSizeHorizontal! * 7,
                                        width:
                                            SizeConfig.blockSizeHorizontal! * 7,
                                        decoration: BoxDecoration(
                                          color: kWhite.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            kBorderRadius5,
                                          ),
                                        ),
                                        padding:
                                            const EdgeInsets.all(kPadding4),
                                        child: SvgPicture.asset(
                                          'assets/icon_bedroom_white.svg',
                                        ),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.blockSizeHorizontal! *
                                            2.5,
                                      ),
                                      Text(
                                        '${space.rooms} Bedroom',
                                        style: kRalewayRegular.copyWith(
                                          color: kWhite,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal! *
                                                  3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        SizeConfig.blockSizeHorizontal! * 7.5,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       height:
                                  //           SizeConfig.blockSizeHorizontal! * 7,
                                  //       width:
                                  //           SizeConfig.blockSizeHorizontal! * 7,
                                  //       decoration: BoxDecoration(
                                  //         color: kWhite.withOpacity(0.2),
                                  //         borderRadius: BorderRadius.circular(
                                  //           kBorderRadius5,
                                  //         ),
                                  //       ),
                                  //       padding:
                                  //           const EdgeInsets.all(kPadding4),
                                  //       child: SvgPicture.asset(
                                  //         'assets/icon_bathroom_white.svg',
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       width: SizeConfig.blockSizeHorizontal! *
                                  //           2.5,
                                  //     ),
                                  //     Text(
                                  //       '4 Bathroom',
                                  //       style: kRalewayRegular.copyWith(
                                  //         color: kWhite,
                                  //         fontSize:
                                  //             SizeConfig.blockSizeHorizontal! *
                                  //                 2.5,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Row(
                children: [
                  Text(
                    'Description',
                    style: kRalewayMedium.copyWith(
                      color: kBlack,
                      fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: kPadding24,
              ),
              ReadMoreText(
                space.description,
                trimLines: 2,
                trimMode: TrimMode.Line,
                delimiter: '...',
                trimCollapsedText: 'Show More',
                trimExpandedText: 'Show Less',
                style: kRalewayRegular.copyWith(
                  color: kGrey85,
                  fontSize: SizeConfig.blockSizeHorizontal! * 3,
                ),
                moreStyle: kRalewayRegular.copyWith(
                  color: kBlue,
                  fontSize: SizeConfig.blockSizeHorizontal! * 3,
                ),
                lessStyle: kRalewayRegular.copyWith(
                  color: kBlue,
                  fontSize: SizeConfig.blockSizeHorizontal! * 3,
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          'https://cdn.iconscout.com/icon/free/png-256/free-avatar-370-456322.png?f=webp',
                        ),
                        backgroundColor: kBlue,
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${space.owner.toString().substring(0, 12)}...${space.owner.toString().substring(space.owner.toString().length - 12, space.owner.toString().length)}",
                            style: kRalewayMedium.copyWith(
                              color: kBlack,
                              fontSize: SizeConfig.blockSizeHorizontal! * 4,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 0.2,
                          ),
                          Text(
                            'Owner',
                            style: kRalewayMedium.copyWith(
                              color: kGrey85,
                              fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kBorderRadius5),
                          color: kBlue.withOpacity(0.5),
                        ),
                        child: SvgPicture.asset(
                          'assets/icon_phone.svg',
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                      Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kBorderRadius5),
                          color: kBlue.withOpacity(0.5),
                        ),
                        child: SvgPicture.asset(
                          'assets/icon_message.svg',
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Row(
                children: [
                  Text(
                    'Gallery',
                    style: kRalewayMedium.copyWith(
                      color: kBlack,
                      fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: kPadding24,
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: kPadding16,
                  childAspectRatio: 1,
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius10),
                      color: kBlue,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          images[index],
                        ),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == 4 - 1 ? kBlack.withOpacity(0.3) : null,
                        borderRadius: BorderRadius.circular(kBorderRadius10),
                      ),
                      child: Center(
                        child: index == 4 - 1
                            ? Text(
                                '+5',
                                style: kRalewayMedium.copyWith(
                                  color: kWhite,
                                  fontSize: SizeConfig.blockSizeHorizontal! * 5,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: kPadding24,
              ),
              Container(
                height: 161,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadius20),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/map_sample.png',
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
                            bottomLeft: Radius.circular(kBorderRadius20),
                            bottomRight: Radius.circular(kBorderRadius20),
                          ),
                          gradient: kLinearGradientWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: kPadding24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
