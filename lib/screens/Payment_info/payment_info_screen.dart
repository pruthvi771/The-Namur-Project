import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';
import '../../presenter/home_presenter.dart';

class PaymentInfo extends StatefulWidget {
  const PaymentInfo({Key? key}) : super(key: key);

  @override
  State<PaymentInfo> createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {
  HomePresenter homeData = HomePresenter();

  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var colordata =  1;

  value(){
    var i = 1;
    do{
      colordata = 1;
      i++;
    }while(i<40);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
            key: homeData.scaffoldKey,
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
      child: bodyscreen(),
    );
  }

  PreferredSize buildCustomAppBar(context) {
    return PreferredSize(
      preferredSize: Size(DeviceInfo(context).width!, 80),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff107B28), Color(0xff4C7B10)])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 30,),
                /* IconButton(
                  onPressed: () {
                    homeData.scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),*/
                Center(
                  child: Text(
                      AppLocalizations.of(context)!.payment_info_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  height: 30,
                  child: Container(
                    child: InkWell(
                      //padding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                        color: MyTheme.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bodyscreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
             Text("Log In Or Sign Up To View Your Complete Profile",
             style: TextStyle(
               fontSize: 15,
               fontWeight: FontWeight.w600,
               letterSpacing: .3
             ),),

          SizedBox(height: 20,),

          ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                 foregroundColor: MyTheme.white,
                backgroundColor: Color(0xff7BC036),
                maximumSize: Size(MediaQuery.of(context).size.width, 44),
                minimumSize: Size(MediaQuery.of(context).size.width, 44),

              ),
              child: Text(
            "Continue",
                style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins"),
          )),

          SizedBox(height: 80,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // Wallet
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Wallet()));
                },
                child: Container(
                  height: 80,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff87BE00),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Icon(Icons.wallet),
                         SizedBox(height: 5,),
                         Text("Wallet",
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           fontSize: 14,
                           fontWeight: FontWeight.w400
                         ),),
                      ],
                    ),
                  ),
                ),
              ),

              //Payment History

              Container(
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                    color: Color(0xffF83030),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallet),
                      SizedBox(height: 5,),
                      Text("Payment History",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          fontFamily: "Poppins"
                        ),),
                    ],
                  ),
                ),
              ),

              //Support
              Container(
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                    color: Color(0xff9747FF),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallet),
                      SizedBox(height: 5,),
                      Text("Support",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          fontFamily: "Poppins"
                        ),),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

