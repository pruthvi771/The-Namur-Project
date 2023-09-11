import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';
class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            // key: homeData.scaffoldKey,
            // drawer: const MainDrawer(),
            backgroundColor: Colors.transparent,
            appBar: buildCustomAppBar(context),
            body: buildBody(),
          ),
        ],
      ),
    );
  }

  RefreshIndicator buildBody() {
    return RefreshIndicator(
      color: MyTheme.white,
      backgroundColor: MyTheme.primary_color,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: bodycontent(),
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
            gradient:LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors:[Color(0xff107B28),Color(0xff4C7B10)]
            )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 18),
                  height: 30,
                  child:  Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: (){
                        Navigator.pop(context);
                      } ,child:Icon(Icons.keyboard_arrow_left,size: 35,color: MyTheme.white,), ),
                  ),
                ),

                Center(
                  child: Text(
                      AppLocalizations.of(context)!
                          .about_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                SizedBox(width: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  
  bodycontent(){
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(right: 20.0,top:40.0,left: 20),
          child: Text("About us ",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Inkaanalysis Private Limited is a Private incorporated on 11 May 2021. It is classified as Non-govt company and is registered at Registrar of Companies, Bangalore. Its authorized share capital is Rs. 80,000 and its paid up capital is Rs. 50,000. It is inolved in Manufacture of medical appliances and instruments and appliances for measuring, checking, testing, navigating and other purposes except optical instrumentsInkaanalysis Private Limited's Annual General Meeting (AGM) was last held on N/A and as per records from Ministry of Corporate Affairs (MCA), its balance sheet was last filed on N/A.Directors of Inkaanalysis Private Limited are Rohini Gopalakrishna and Pitlali Gopal Krishna Pruthvi Raj.Inkaanalysis Private Limited's Corporate Identification Number is (CIN) U33125KA2021PTC147316 and its registration number is 147316.Its Email address is inkaanalysis@gmail.com and its registered address is No. 834, 8 A Cross Vidyamanyanagar, Andrahalli Bangalore Bangalore KA 560091 IN .Current status of Inkaanalysis Private Limited is - Active. Manufacture of medical appliances and instruments and appliances for measuring, checking, testing, navigating and other purposes except optical instrumentsClick here to see other companies involved in same activity.",
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 15,letterSpacing: .5,
          height: 1),),
        ),

        Spacer(),

        Material(
          elevation: 1,
          child: Container(height: 44,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0,top: 8),
            child: Text("Privacy Policy",
            style: TextStyle(fontWeight: FontWeight.w500,
            fontSize: 15),),
          ),),
        )
      ],
    );
  }
  
}