// import 'package:flutter/material.dart';

// class MoreInfo extends StatelessWidget {
//   final List _optionList = [
//     'Get Your Dispensary On The Hii-Line',
//     "FAQ's",
//     "Privacy Policy"
//   ];

//   final List _navigators = [
//     '/MoreInfo',
//     '/FAQ',
//     '/Policy',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//           // title: buddiesLogo,
//           // centerTitle: true,
//           // backgroundColor: hlGreen,
//           ),
//       body: Container(
//         height: size.height,
//         width: size.width,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Title(
//                   color: Colors.purple,
//                   child: Text(
//                     'More Info',
//                     textAlign: TextAlign.left,
//                     // style: TextStyle(
//                     //     fontFamily: theme.textTheme.headline1.fontFamily,
//                     //     color: theme.textTheme.headline1.color,
//                     //     fontSize: theme.textTheme.headline1.fontSize),
//                   )),
//             ),
//             Divider(
//               color: Colors.black,
//               thickness: 2,
//               height: 5,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: size.height / 2,
//                 width: size.width,
//                 child: ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     itemCount: _optionList.length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {},
//                         child: Container(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   _optionList[index],
//                                   maxLines: 2,
//                                   style: TextStyle(
//                                       fontFamily:
//                                           theme.textTheme.headline2.fontFamily,
//                                       color: theme.textTheme.headline2.color,
//                                       fontSize:
//                                           theme.textTheme.headline2.fontSize),
//                                 ),
//                               ),
//                               Divider(),
//                               SizedBox(
//                                 height: screenAwareSize(20, context),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
