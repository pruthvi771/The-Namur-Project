import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../custom/device_info.dart';
import '../../my_theme.dart';

class MoreDetail extends StatefulWidget {
  const MoreDetail({Key? key}) : super(key: key);

  @override
  State<MoreDetail> createState() => _MoreDetailState();
}

class _MoreDetailState extends State<MoreDetail> {
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _plotSizeController = TextEditingController();
  TextEditingController _cropGrownController = TextEditingController();
  TextEditingController _machineController = TextEditingController();
  TextEditingController _animalController = TextEditingController();
  Future<void> _onPageRefresh() async {
    //reset();
    // fetchAll();
  }

  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: DeviceInfo(context).height,
      child: Stack(
        children: [
          Scaffold(
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
                SizedBox(
                  width: 30,
                ),
                Center(
                  child: Text(AppLocalizations.of(context)!.more_detail_ucf,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: .5,
                          fontFamily: 'Poppins')),
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
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

  bodycontent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                child: CircleAvatar(
                  backgroundColor: MyTheme.light_grey,
                  radius: 50,
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: ClipRRect(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/girl.png"),
                    radius: 45,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: MyTheme.light_grey,
                ),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _pincodeController,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!
                        .dist_taluk_village_pincode_ucf,
                    hintStyle: TextStyle(fontWeight: FontWeight.w500),
                    suffixIcon: Icon(
                      Icons.location_on_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),

          //
          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: MyTheme.light_grey,
                ),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _plotSizeController,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!
                        .land_details_syno_plot_size_ucf,
                    hintStyle: TextStyle(fontWeight: FontWeight.w500),
                    suffixIcon: Icon(
                      Icons.location_on_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),

          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: MyTheme.light_grey,
                ),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _cropGrownController,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!
                        .crops_grown_and_planned_ucf,
                    hintStyle: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),

          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: MyTheme.light_grey,
                ),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _machineController,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!
                        .tractor_jcb_tiller_rotovotator_ucf,
                    hintStyle: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),

          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  color: MyTheme.light_grey,
                ),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _animalController,
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        AppLocalizations.of(context)!.sheep_cow_chicken_ucf,
                    hintStyle: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),

          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.update_ucf,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
              ),
              style: ElevatedButton.styleFrom(
                  primary: MyTheme.primary_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 40)),
            ),
          )
        ],
      ),
    );
  }
}
