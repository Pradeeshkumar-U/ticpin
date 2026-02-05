import 'package:flutter/material.dart';
import 'package:ticpin_partner/constants/size.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.location,
    required this.press,
  });

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            minTileHeight: Sizes().height * 0.05,
            onTap: press,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            splashColor: Colors.transparent,
            selectedTileColor: Colors.transparent,
            selectedColor: Colors.transparent,
            focusColor: Colors.transparent,
            horizontalTitleGap: 0,
            leading: Icon(Icons.location_on_outlined),

            title: Padding(
              padding: EdgeInsets.only(left: Sizes().width * 0.03),
              child: Text(
                location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'Regular'),
              ),
            ),
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          indent: Sizes().width * 0.05,
          endIndent: Sizes().width * 0.05,
          // color: blackColor,
          color: Color(0xFFF5F5F5), // Use a light color for the divider
        ),
      ],
    );
  }
}
