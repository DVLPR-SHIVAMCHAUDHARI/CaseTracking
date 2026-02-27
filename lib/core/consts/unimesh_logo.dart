import 'package:casetracking/core/consts/asset_url.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnimeshLogo2 extends StatelessWidget {
  const UnimeshLogo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       "UNIMESH",
        //       style: TextStyle(
        //         fontSize: 14, // Bigger
        //         fontWeight: FontWeight.bold,

        //         color: Colors.black,
        //       ),
        //     ),

        //     Text(
        //       "TECHNOLOGIES PVT LTD",
        //       style: TextStyle(
        //         fontSize: 8, // Smaller
        //         fontWeight: FontWeight.w400,

        //         color: Colors.black54,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class UnimeshLogo extends StatelessWidget {
  const UnimeshLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          height: 40.h,
          width: 60.w,
          child: Image.asset(AssetUrl.icUnimesh, fit: BoxFit.contain),
        ),

        const SizedBox(width: 5),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "UNIMESH",
              style: TextStyle(
                fontSize: 22, // Bigger
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.black,
              ),
            ),

            Text(
              "TECHNOLOGIES PVT LTD",
              style: TextStyle(
                fontSize: 10, // Smaller
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
