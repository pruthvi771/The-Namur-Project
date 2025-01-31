import 'package:active_ecommerce_flutter/features/calendar/screens/tutorial_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';

class CultivationTipsScreen extends StatefulWidget {
  final String cropName;
  const CultivationTipsScreen({
    Key? key,
    required this.cropName,
  }) : super(key: key);

  @override
  State<CultivationTipsScreen> createState() => _CultivationTipsScreenState();
}

class _CultivationTipsScreenState extends State<CultivationTipsScreen> {
  late Future<List<dynamic>> cultivationDataFuture;
  bool showHints = false;

  @override
  void initState() {
    cultivationDataFuture =
        getCultivationTipsForCropName(cropName: widget.cropName.toLowerCase());

    if (showHints)
      Future.delayed(Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Single Tap to view PDF, Double Tap to view image",
              textAlign: TextAlign.center,
            ),
            backgroundColor: MyTheme.accent_color,
            duration: Duration(seconds: 3),
          ),
        );
      });
    super.initState();
  }

  @override
  void dispose() {
    cultivationDataFuture.then((value) {
      value.clear();
    });
    // if (showHints) ScaffoldMessenger.of(context).clearSnackBars();
    super.dispose();
  }

  void _launchPDF(String url) async {
    String pdfUrl = url;
    if (await canLaunchUrl(Uri.parse(pdfUrl))) {
      await launchUrl(Uri.parse(pdfUrl));
    } else {
      throw 'Could not launch $pdfUrl';
    }
  }

  Future<List<dynamic>> getCultivationTipsForCropName(
      {required String cropName}) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('calendar_namur')
        .doc(cropName.toLowerCase())
        .get();

    if (userSnapshot.exists) {
      if ((userSnapshot.data() as Map)['cultivation_tips'] == null) {
        return [];
      }
      List<dynamic> returnVal =
          (userSnapshot.data() as Map)['cultivation_tips'];
      showHints = true;
      return returnVal;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.cultivation_tips_ucf,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins')),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 35,
              color: MyTheme.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBody(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TutorialScreen(
                    cropName: widget.cropName,
                  ),
                ),
              );
            },
            child: Container(
              color: MyTheme.green_light,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/tutorial.png",
                    height: 65,
                    width: 65,
                  ),
                  SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.tutorial_ucf,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: "Poppins"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder buildBody() {
    return FutureBuilder(
        future: cultivationDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            List cultivationData = snapshot.data!;
            return cultivationData.length == 0
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!.no_data_is_available,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio:
                            0.9, // Adjusted to ensure content fits well
                      ),
                      itemCount: cultivationData.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 15),
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var imageLink = cultivationData[index]['logoUrl'] == ""
                            ? imageForNameCloud['placeholder']!
                            : cultivationData[index]['logoUrl'];
                        if (cultivationData[index]['logoUrl'] != null &&
                            imageLink.contains("drive.google.com")) {
                          RegExp regExp = RegExp(r'/d/([a-zA-Z0-9_-]+)');

                          // Use the regular expression to find the fileId
                          Match? match = regExp.firstMatch(imageLink);

                          if (match != null) {
                            // The fileId is in the first capture group
                            String fileId = match.group(1)!;
                            imageLink =
                                "https://drive.google.com/uc?export=view&id=$fileId";
                            print('File ID: $fileId');
                          } else {
                            print('No file ID found in the URL.');
                          }
                        }

                        var name = cultivationData[index]['title'];
                        var description = cultivationData[index]['dataUrl'];
                        return InkWell(
                          onTap: () => _launchPDF(description),
                          onDoubleTap: () {
                            showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    actionsPadding: EdgeInsets.all(0),
                                    buttonPadding: EdgeInsets.all(0),
                                    content: Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.35,
                                      padding: EdgeInsets.only(top: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // image
                                          Container(
                                            height: 200,
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                                imageUrl: imageLink,
                                                fit: BoxFit.fitHeight),
                                          ),

                                          // name
                                          Container(
                                            height: 40,
                                            margin: EdgeInsets.only(top: 20),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            color: Colors.grey.withOpacity(0.1),
                                            width: double.infinity,
                                            child: Text(
                                              name.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),

                                          // description
                                          // Expanded(
                                          //   child: SingleChildScrollView(
                                          //     physics: BouncingScrollPhysics(),
                                          //     child: Container(
                                          //       padding: EdgeInsets.symmetric(
                                          //           horizontal: 10,
                                          //           vertical: 10),
                                          //       width: double.infinity,
                                          //       child: Text(
                                          //         description.toString() == ''
                                          //             ? "No description Data Exists"
                                          //             : description.toString(),
                                          //         style: TextStyle(
                                          //           fontSize: 16,
                                          //           fontWeight: FontWeight.w600,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Text(AppLocalizations.of(
                                                    dialogContext)!
                                                .dismiss)),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: MyTheme.green_lighter.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 8.0, bottom: 8),
                                  height: 50,
                                  width: 50,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: imageLink ??
                                          imageForNameCloud['placeholder']!),
                                ),
                                Text(
                                  name.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
          }
          return Center(
            child: Text(
              AppLocalizations.of(context)!.no_data_is_available,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        });
  }

  Padding StageHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
        height: 30,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color(0xffA4CD3C)),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}


  //   {
  //     'name': 'Leaf Eaters',
  //     'image':
  //         'https://cdn-developer-wp.arc.dev/wp-content/uploads/2021/08/Adham-Dannaway-home.gif',
  //     'description':
  //         'Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves. Leaf Eaters are insects that eat leaves'
  //   },
  //   {
  //     'name': 'Fruit Worms',
  //     'image':
  //         'https://cdn-developer-wp.arc.dev/wp-content/uploads/2021/08/Adham-Dannaway-home.gif',
  //     'description':
  //         'Fruit Worms are insects that infest fruits. Fruit Worms are insects that infest fruits. Fruit Worms are insects that infest fruits. Fruit Worms are insects that infest fruits. Fruit Worms are insects that infest fruits. Fruit Worms are insects that infest fruits. Fruit Worms are insects that infest fruits. Fruit Worms are insects that infest fruits'
  //   },
  //   {
  //     'name': 'Root Nematodes',
  //     'image':
  //         'https://cdn-developer-wp.arc.dev/wp-content/uploads/2021/08/Adham-Dannaway-home.gif',
  //     'description':
  //         'Root Nematodes are microscopic worms that attack plant roots. Root Nematodes are microscopic worms that attack plant roots. Root Nematodes are microscopic worms that attack plant roots. Root Nematodes are microscopic worms that attack plant roots. Root Nematodes are microscopic worms that attack plant roots. Root Nematodes are microscopic worms that attack plant roots. Root Nematodes are microscopic worms that attack plant roots. Root Nematodes are microscopic worms that attack plant roots'
  //   },
  //   {
  //     'name': 'Aphids',
  //     'image':
  //         'https://cdn-developer-wp.arc.dev/wp-content/uploads/2021/08/Adham-Dannaway-home.gif',
  //     'description':
  //         'Aphids are small sap-sucking insects that feed on plants. Aphids are small sap-sucking insects that feed on plants. Aphids are small sap-sucking insects that feed on plants. Aphids are small sap-sucking insects that feed on plants. Aphids are small sap-sucking insects that feed on plants. Aphids are small sap-sucking insects that feed on plants. Aphids are small sap-sucking insects that feed on plants. Aphids are small sap-sucking insects that feed on plants'
  //   },
  // ];
