import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/utils/imageLinks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class PestControlScreen extends StatefulWidget {
  final String cropName;

  const PestControlScreen({
    Key? key,
    required this.cropName,
  }) : super(key: key);

  @override
  State<PestControlScreen> createState() => _PestControlScreenState();
}

class _PestControlScreenState extends State<PestControlScreen> {
  late Future<List> pestControlDataFuture;
  bool showHints = false;

  @override
  void initState() {
    pestControlDataFuture =
        getPestControlDataForCropName(cropName: widget.cropName.toLowerCase());
    if (showHints)
      Future.delayed(
          Duration(milliseconds: 500),
          () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Single Tap to view PDF, Double Tap to view image",
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: MyTheme.accent_color,
                  duration: Duration(seconds: 3),
                ),
              ));
    super.initState();
  }

  @override
  void dispose() {
    pestControlDataFuture.then((value) {
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

  Future<List> getPestControlDataForCropName({required String cropName}) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('calendar_namur')
        .doc(cropName.toLowerCase())
        .get();

    if (userSnapshot.exists) {
      if ((userSnapshot.data() as Map)['stages'] == null) {
        return [];
      }
      List returnVal = (userSnapshot.data() as Map)['stages'];
      showHints = true;
      return returnVal;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
            title: Text(AppLocalizations.of(context)!.pest_control,
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
          body: buildBody(),
        ),
      ],
    );
  }

  FutureBuilder buildBody() {
    return FutureBuilder(
        future: pestControlDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            List pestControlData = snapshot.data!;
            print(pestControlData);

            return pestControlData.length == 0
                ? Container(
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.no_data_is_available,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    )),
                  )
                : ListView(
                    padding: EdgeInsets.only(top: 15),
                    children: List.generate(
                      pestControlData.length,
                      (index) {
                        return Column(
                          children: [
                            StageHeading(
                                pestControlData[index]['stageName'].toString()),
                            pestControlData[index]['pestAndDiseases'] == null ||
                                    pestControlData[index]['pestAndDiseases']
                                            .length ==
                                        0
                                ? Container(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .no_data_is_available,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                : GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio:
                                          0.8, // Adjusted to ensure content fits well
                                    ),
                                    itemCount: pestControlData[index]
                                            ['pestAndDiseases']
                                        .length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                        top: 20,
                                        left: 20,
                                        right: 20,
                                        bottom: 15),
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index2) {
                                      var imageLink = pestControlData[index]
                                                  ['pestAndDiseases'][index2]
                                              ['image'] ??
                                          imageForNameCloud['placeholder']!;
                                      if (pestControlData[index]
                                                      ['pestAndDiseases']
                                                  [index2]['image'] !=
                                              null &&
                                          imageLink
                                              .contains("drive.google.com")) {
                                        RegExp regExp =
                                            RegExp(r'/d/([a-zA-Z0-9_-]+)');

                                        // Use the regular expression to find the fileId
                                        Match? match =
                                            regExp.firstMatch(imageLink);

                                        if (match != null) {
                                          // The fileId is in the first capture group
                                          String fileId = match.group(1)!;
                                          imageLink =
                                              "https://drive.google.com/uc?export=view&id=$fileId";
                                        } else {
                                          print('No file ID found in the URL.');
                                        }
                                      }
                                      // : pestControlData[index]
                                      //         ['pestAndDiseases'][index2]
                                      //     ['image'];

                                      var name = pestControlData[index]
                                          ['pestAndDiseases'][index2]['name'];

                                      var description = pestControlData[index]
                                              ['pestAndDiseases'][index2]
                                          ['contentUrl'];

                                      return InkWell(
                                        onTap: () => _launchPDF(description),
                                        onDoubleTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (dialogContext) {
                                                return AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 10,
                                                          left: 10,
                                                          right: 10),
                                                  actionsPadding:
                                                      EdgeInsets.all(0),
                                                  buttonPadding:
                                                      EdgeInsets.all(0),
                                                  content: Container(
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.35,
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // image
                                                        Container(
                                                          height: 200,
                                                          width:
                                                              double.infinity,
                                                          child:
                                                              CachedNetworkImage(
                                                                  imageUrl:
                                                                      imageLink,
                                                                  fit: BoxFit
                                                                      .fitWidth),
                                                        ),

                                                        // name
                                                        Container(
                                                          height: 40,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            name.toString(),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),

                                                        // description
                                                        // Expanded(
                                                        //   child:
                                                        //       SingleChildScrollView(
                                                        //     physics:
                                                        //         BouncingScrollPhysics(),
                                                        //     child: Container(
                                                        //       padding: EdgeInsets
                                                        //           .symmetric(
                                                        //               horizontal:
                                                        //                   10,
                                                        //               vertical:
                                                        //                   10),
                                                        //       width: double
                                                        //           .infinity,
                                                        //       child: Text(
                                                        //         description
                                                        //             .toString(),
                                                        //         style: TextStyle(
                                                        //             fontSize:
                                                        //                 16,
                                                        //             fontWeight:
                                                        //                 FontWeight
                                                        //                     .w600),
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                dialogContext);
                                                          },
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      dialogContext)!
                                                                  .dismiss)),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                            color: MyTheme.green_lighter
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 8.0, bottom: 8),
                                                height: 50,
                                                width: 50,
                                                child: CachedNetworkImage(
                                                    imageUrl: imageLink ??
                                                        imageForNameCloud[
                                                            'placeholder']!),
                                              ),
                                              Text(
                                                name.toString(),
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ],
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
