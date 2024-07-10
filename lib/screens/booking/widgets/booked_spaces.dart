import 'package:flutter/material.dart';
import 'package:roomflow/models/models.dart';
import 'package:roomflow/utils/app_styles.dart';
import 'package:roomflow/utils/size_config.dart';
// import 'package:roomflow/screens/product_detail_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookedSpaces extends StatefulWidget {
  const BookedSpaces({
    super.key,
    required this.spaces,
  });

  final List<Space> spaces;

  @override
  State<BookedSpaces> createState() => _BookedSpacesState();
}

class _BookedSpacesState extends State<BookedSpaces> {
  String check = "Check In";
  checkIn() {
    setState(() {
      check = "Checked In";
    });
  }

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
                'Booked Spaces',
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
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kPadding20,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.spaces.length,
            itemBuilder: (context, index) {
              var images = widget.spaces[index].images.split(',');
              String check = "Check In";
              checkIn() {
                setState(() {
                  check = "Checked In";
                });
              }

              return Container(
                height: 70,
                margin: const EdgeInsets.only(
                  bottom: kPadding24,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadius10),
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
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 4.5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.spaces[index].title,
                            style: kRalewayMedium.copyWith(
                              color: kBlack,
                              fontSize: SizeConfig.blockSizeHorizontal! * 4,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 0.5,
                          ),
                          Text(
                            '${widget.spaces[index].price} WEI / Day',
                            style: kRalewayRegular.copyWith(
                              color: Colors.yellow[900],
                              fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icon_bedroom.svg',
                                    ),
                                    SizedBox(
                                      width:
                                          SizeConfig.blockSizeHorizontal! * 0.5,
                                    ),
                                    Text(
                                      '${widget.spaces[index].rooms} Bedroom',
                                      style: kRalewayRegular.copyWith(
                                        color: kGrey85,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal! *
                                                2.5,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: SizeConfig.blockSizeHorizontal! * 1,
                                ),
                                // Row(
                                //   children: [
                                //     SvgPicture.asset(
                                //       'assets/icon_bathroom.svg',
                                //     ),
                                //     SizedBox(
                                //       width:
                                //           SizeConfig.blockSizeHorizontal! * 0.5,
                                //     ),
                                //     Text(
                                //       '4 Bathroom',
                                //       style: kRalewayRegular.copyWith(
                                //         color: kGrey85,
                                //         fontSize:
                                //             SizeConfig.blockSizeHorizontal! *
                                //                 2.5,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(onPressed: checkIn, child: Text(check))
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
