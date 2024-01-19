// translation done.

import 'package:active_ecommerce_flutter/features/sellAndBuy/screens/parent_screen.dart';
import 'package:active_ecommerce_flutter/utils/enums.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialScreen extends StatefulWidget {
  final String cropName;

  const TutorialScreen({
    Key? key,
    required this.cropName,
  }) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late Future<List> tutorialDataFuture;

  @override
  void initState() {
    tutorialDataFuture =
        getTutorialDataForCropName(cropName: widget.cropName.toLowerCase());
    super.initState();
  }

  Future<List> getTutorialDataForCropName({required String cropName}) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('calendar')
        .doc(cropName.toLowerCase())
        .get();

    if (userSnapshot.exists) {
      if ((userSnapshot.data() as Map)['tutorial'] == null) {
        return [];
      }
      List returnVal = (userSnapshot.data() as Map)['tutorial'];
      print(returnVal);
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
          bottomSheet: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ParentScreen(
                      parentEnum: ParentEnum.machine,
                      initialIndexForTabBar: 1,
                      isBuy: true,
                      isSecondHand: false,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: 110,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color(0xffD9D9D9)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/select.png"),
                        ),
                        Text(
                          "Select Site",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: MyTheme.green_light,
                        border: Border.all(color: Colors.black)),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset("assets/prepare_site.png"),
                          ),
                          Text(
                            "Prepare Site",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/weeding.png"),
                        ),
                        Text(
                          "Weeding",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
            title: Text(AppLocalizations.of(context)!.tutorial_ucf,
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

  String extractYouTubeVideoId(String youtubeLink) {
    // Define regular expressions to match YouTube video URLs
    RegExp regExp = RegExp(
      r'^https:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)',
    );

    // Use the firstMatch method of RegExp to find the match in the given link
    RegExpMatch? match = regExp.firstMatch(youtubeLink);

    // If a match is found, return the captured group (video ID), otherwise return null
    return match?.group(1) ?? '';
  }

  String getImageLinkFromVideoLink(String? youtubeLink) {
    if (youtubeLink == null) {
      return 'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fmore%2Fplaceholder.png?alt=media&token=788c151e-2624-4866-b3a2-4cb75ccb84e4';
    }
    String videoId = extractYouTubeVideoId(youtubeLink);

    if (videoId == '') {
      return 'https://firebasestorage.googleapis.com/v0/b/namur-5095e.appspot.com/o/helpers3%2Fmore%2Fplaceholder.png?alt=media&token=788c151e-2624-4866-b3a2-4cb75ccb84e4';
    }
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  _launchYouTubeVideo(url) async {
    print('clicked');
    if (url == null) {
      return;
    }
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch';
    }
  }

  FutureBuilder buildBody() {
    return FutureBuilder(
        future: tutorialDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            List pestControlData = snapshot.data!;
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
                : Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'YouTube Videos',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.only(top: 10),
                          children: List.generate(
                            pestControlData.length,
                            (index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, bottom: 15),
                                child: InkWell(
                                  onTap: () async {
                                    await _launchYouTubeVideo(
                                        pestControlData[index]['link']);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 180,
                                      color: Colors.black.withOpacity(0.1),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              color: Colors.blue,
                                              child: Image.network(
                                                getImageLinkFromVideoLink(
                                                    pestControlData[index]
                                                        ['link']),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 50,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            padding: EdgeInsets.only(left: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                pestControlData[index]['title']
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
}
