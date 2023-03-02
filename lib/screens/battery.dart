import 'package:flutter/material.dart';
import '../app_styles.dart';
import '../size_config.dart';

class Battery extends StatefulWidget {
  const Battery({Key? key}) : super(key: key);

  @override
  State<Battery> createState() => _BatteryState();
}

class _BatteryState extends State<Battery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal, vertical: paddingHorizontal),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Circle shall appear here',
                  style: fontSemiBold.copyWith(
                      color: black,
                      fontSize: SizeConfig.blockSizeHorizontal! * 6),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 2,
            ),
            TextField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: grey)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: grey)),
                prefixIcon: Container(
                  child: Text('fhgjhkj'),
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                ),
                hintText: 'Search folder',
                hintStyle: fontMedium.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    color: darkGrey),
              ),
              style: fontMedium.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * 4, color: darkGrey),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Recent',
                      style: fontMedium.copyWith(
                          color: lightBlack,
                          fontSize: SizeConfig.blockSizeHorizontal! * 4),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal!),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                Icon(Icons.sort_rounded)
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),

          ],
        ),
      )
    );
  }
}




/**GridView.builder(
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: SizeConfig.blockSizeHorizontal! * 2,
    mainAxisSpacing: SizeConfig.blockSizeHorizontal! * 2,
    mainAxisExtent: 107
    ),
    itemCount: 4,
    itemBuilder: (context, index) {
    return Container(
    padding: EdgeInsets.symmetric(horizontal: 0.5 * paddingHorizontal, vertical: 0.5 * paddingHorizontal),
    decoration: BoxDecoration(
    color: Colors.orange,
    borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Icon(
    Icons.folder,
    color: Colors.blue,
    size: 45.0,
    ),
    Icon(
    Icons.more_vert_sharp,
    color: Colors.blue,
    size: 30.0,
    )
    ],
    ),
    SizedBox(width: SizeConfig.blockSizeVertical!),
    Text(
    'Mobile apps',
    style: fontSemiBold.copyWith(
    fontSize: SizeConfig.blockSizeHorizontal!*4,
    color: blue
    ),
    ),
    SizedBox(width: SizeConfig.blockSizeVertical!*0.3),
    Text(
    'December 20.2020',
    style: fontRegular.copyWith(
    fontSize: SizeConfig.blockSizeHorizontal!*4,
    color: blue
    ),
    ),
    ]
    ),
    );
    })**/