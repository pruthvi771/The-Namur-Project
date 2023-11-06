// import 'package:active_ecommerce_flutter/my_theme.dart';
// import 'package:active_ecommerce_flutter/utils/enums.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class BuyProductSubSubCategories extends StatefulWidget {
//   final SubCategoryEnum subCategoryEnum;
//   const BuyProductSubSubCategories({
//     Key? key,
//     required this.subCategoryEnum,
//   }) : super(key: key);

//   @override
//   State<BuyProductSubSubCategories> createState() =>
//       _BuyProductSubSubCategoriesState();
// }

// class _BuyProductSubSubCategoriesState
//     extends State<BuyProductSubSubCategories> {
//   Future<void> _onPageRefresh() async {
//     //reset();
//     // fetchAll();
//   }

//   initState() {
//     // fetchAll();
//     super.initState();
//     subSubCategoryList = SubSubCategoryList[widget.subCategoryEnum]!;
//   }

//   bool _switchValue = false;

//   late List<String> subSubCategoryList;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xff107B28), Color(0xff4C7B10)]),
//           ),
//         ),
//         title: Text(AppLocalizations.of(context)!.categories_ucf,
//             style: TextStyle(
//                 color: MyTheme.white,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: .5,
//                 fontFamily: 'Poppins')),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.keyboard_arrow_left,
//               size: 35,
//               color: MyTheme.white,
//             ),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//         ],
//       ),
//       body: bodycontent(),
//     );
//   }

//   // RefreshIndicator buildBody() {
//   //   return RefreshIndicator(
//   //     color: MyTheme.white,
//   //     backgroundColor: MyTheme.primary_color,
//   //     onRefresh: _onPageRefresh,
//   //     displacement: 10,
//   //     child: bodycontent(),
//   //   );
//   // }

//   bodycontent() {
//     return ListView(
//       physics: BouncingScrollPhysics(),
//       children: [
//         Container(
//           child: ListView.builder(
//               itemCount: subSubCategoryList.length,
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //       builder: (context) => BuyProductList(
//                     //             subSubCategory: subSubCategoryList[index],
//                     //           )),
//                     // );
//                   },
//                   child: BuyProductSubSubCategoriesWidget(
//                       context: context,
//                       name: subSubCategoryList[index],
//                       imagePath: "assets/graph.png"),
//                 );
//               }),
//         ),
//       ],
//     );
//   }

//   Padding BuyProductSubSubCategoriesWidget({
//     required BuildContext context,
//     required String name,
//     required String imagePath,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
//       child: Material(
//         elevation: 1,
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(width: 1, color: MyTheme.medium_grey)),
//           height: 100,
//           width: MediaQuery.of(context).size.width,
//           child: Padding(
//             padding: const EdgeInsets.all(7.0),
//             child: Row(
//               //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   // flex: 1,
//                   child: Container(height: 88, child: Image.asset(imagePath)),
//                 ),
//                 Expanded(
//                   // flex: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       name,
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
