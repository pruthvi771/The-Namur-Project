import 'package:active_ecommerce_flutter/screens/about_us/terms_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../my_theme.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildCustomAppBar(context),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 35,
            color: MyTheme.white,
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)]),
          ),
        ),
        title: Text(AppLocalizations.of(context)!.about_ucf,
            style: TextStyle(
                color: MyTheme.white,
                fontWeight: FontWeight.w500,
                letterSpacing: .5,
                fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        children: [
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.only(top: 20),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.grey[200]!,
                    width: 2,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TermsConditions();
                }));
              },
              child: Text(
                'View Terms and Conditions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .5,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 15),
            child: Text(
              "About us ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            "Inkaanalysis Private Limited is a Private incorporated on 11 May 2021. It is classified as Non-govt company and is registered at Registrar of Companies, Bangalore. Its authorized share capital is Rs. 80,000 and its paid up capital is Rs. 50,000. It is inolved in Manufacture of medical appliances and instruments and appliances for measuring, checking, testing, navigating and other purposes except optical instrumentsInkaanalysis Private Limited's Annual General Meeting (AGM) was last held on N/A and as per records from Ministry of Corporate Affairs (MCA), its balance sheet was last filed on N/A.Directors of Inkaanalysis Private Limited are Rohini Gopalakrishna and Pitlali Gopal Krishna Pruthvi Raj.Inkaanalysis Private Limited's Corporate Identification Number is (CIN) U33125KA2021PTC147316 and its registration number is 147316.Its Email address is inkaanalysis@gmail.com and its registered address is No. 834, 8 A Cross Vidyamanyanagar, Andrahalli Bangalore Bangalore KA 560091 IN .Current status of Inkaanalysis Private Limited is - Active. Manufacture of medical appliances and instruments and appliances for measuring, checking, testing, navigating and other purposes except optical instrumentsClick here to see other companies involved in same activity.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15, letterSpacing: .5, height: 1),
          ),
        ],
      ),
    );
  }
}
