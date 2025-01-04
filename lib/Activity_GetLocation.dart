import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inland_sales_upgrade/Network.dart';
import 'package:inland_sales_upgrade/Utility.dart';
import 'package:inland_sales_upgrade/ZigzagClipper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity_Get_Location extends StatefulWidget{
  static final GlobalKey<Activity_Get_Location_State> locationKey = GlobalKey<Activity_Get_Location_State>();
  final Function(ThemeData) onThemeChange;
  const Activity_Get_Location({
    super.key,
    required this.onThemeChange
});

  @override
  State<StatefulWidget> createState() => Activity_Get_Location_State();

}

class Activity_Get_Location_State extends State<Activity_Get_Location>{
  List<Map<String,String>> hmGetLocation = [];
  List<String> arrGetLocation = [];
  var GetLocation_txt = TextEditingController();
  bool isFocusNode = false;

  var strAcclocName = "", strPrefLocation = "",strEmpName = "",strEmpCode = "",strCurrBrcd = "",strBranchAddress = "",strBranchLat = "",strBranchLong = "",strBranchRadius = "",
      strMeter = "Meter",strRegioncode = "",strAccloccode = "",strAcselectedlocationnameclocName = "",strLocationname = "", strSelectedLocationName,strSelectedLocationCode;
  var selectedAcclocName = "",selectedAccloccode = "", selectedRegioncode = "",selectedlocationcode = "",selectedlocationname = "";

  @override
  void initState() {
    super.initState();
    getLocation();
    LocationSaveData();

  }

  Future<void> GetUserLocationByChange() async{
    var pref = await SharedPreferences.getInstance();
    String ? strEmpcd = pref.getString(Constant.Empcd) ?? '';

    final Map<String,String> RequestBody = {
      'empcd' : '$strEmpcd',
      'Tokenno' : Constant.TokenNo,
      'BranchCode' : "$strSelectedLocationCode"

    };

    try{
      Map<String,dynamic> responseData = await ApiHelper.postRequest(EndPoint.GetUserLocationByChange, RequestBody);
      print(responseData.length);

      setState(() {
        var selected_AcclocName = responseData["AcclocName"];
        var selected_Accloccode = responseData["Accloccode"];
        var selected_Regioncode = responseData["Regioncode"];
        var selected_locationcode = responseData["locationcode"];
        var selected_locationname = responseData["locationname"];

        selectedAcclocName = selected_AcclocName;
        selectedAccloccode = selected_Accloccode;
        selectedlocationname = selected_locationname;
        selectedlocationcode = selected_locationcode;
        selectedRegioncode = selected_Regioncode;

        pref.setString(Constant.AcclocName, selectedAcclocName);
        pref.setString(Constant.Accloccode, selectedAccloccode);
        pref.setString(Constant.CurrBrcd, selectedlocationcode);
        pref.setString(Constant.Regioncode, selectedRegioncode);
        pref.setString(Constant.Locationname, selectedlocationname);

      });

    }catch(e){
      Utility().ShowToast("$e");

    }

  }

  Future<void> getLocation() async{
    var pref = await SharedPreferences.getInstance();
    String ? strEmpcd = pref.getString(Constant.Empcd);

    final Map<String,String> RequestBody = {
      'empcd' : '$strEmpcd',
      'Tokenno' : "2.4"

    };

    try{
      final http.Response response = await http.post(
          Uri.parse(Constant.baseurl + EndPoint.GetLocation),
          body: jsonEncode(RequestBody),
          headers: {"Content-Type": "application/json"}

      ).timeout(Duration(seconds: 30));

      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> getLocationResult  = responseData['GetLocationResult'];

        setState(() {
          hmGetLocation = getLocationResult.map((location) => {
            'locationcode' : location['locationcode'].toString(),
            'locationname' : location['locationname'].toString(),

          }).toList();
          print('GetLocation : $hmGetLocation' );

          arrGetLocation = hmGetLocation.map((location) => location['locationname']!).toList();

        });

      }else{
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }

    }catch(e){
      print("An error occurred: $e");

    }
  }

  Future<void>  LocationSaveData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strSaveLocation = pref.getString(Constant.Selected_Location) ?? 'No Location Selected';
    String ? _strEmpName = pref.getString(Constant.Name) ?? '';
    String ? _strEmpCode = pref.getString(Constant.Empcd) ?? '';
    String ? _strCurrBrcd = pref.getString(Constant.CurrBrcd) ?? '';
    String ? _strBranchAddress = pref.getString(Constant.Branch_Address) ?? '';
    String ? _strBranchLat = pref.getString(Constant.Branch_Lat) ?? '';
    String ? _strBranchLong = pref.getString(Constant.Branch_Long) ?? '';
    String ? _strBranchRadius = pref.getString(Constant.Branch_Radious) ?? '';
    String ? _strAccloccode = pref.getString(Constant.Accloccode) ?? '';
    String ? _strAcclocName = pref.getString(Constant.AcclocName) ?? '';
    String ? _strLocationname = pref.getString(Constant.Locationname) ?? '';
    String ? _strRegioncode = pref.getString(Constant.Regioncode) ?? '';

    setState(() {
      strPrefLocation = strSaveLocation;
      GetLocation_txt.text = strSaveLocation;
      strEmpName = _strEmpName;
      strEmpCode = _strEmpCode;

      strBranchAddress = _strBranchAddress;
      strBranchLat = _strBranchLat;
      strBranchLong = _strBranchLong;
      strBranchRadius = _strBranchRadius;

      strAccloccode = _strAccloccode;
      strAcclocName = _strAcclocName;
      strLocationname = _strLocationname;
      strRegioncode = _strRegioncode;
      strCurrBrcd = _strCurrBrcd;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Get Location",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),

          backgroundColor: Theme.of(context).primaryColor,

          iconTheme: IconThemeData(
              color: Theme.of(context).canvasColor
          )),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Autocomplete<String> (
                optionsBuilder: (TextEditingValue Textvalue){
                  print('Typed: ${Textvalue.text}');

                  if(Textvalue.text.isNotEmpty){
                    return arrGetLocation.where((location) =>
                        location.toLowerCase().contains(
                            Textvalue.text.toLowerCase()));

                  }else {
                    return const Iterable<String>.empty();

                  }

                },onSelected: (String selection) async {
                print("Selected: $selection" );

                final selectedLocation = hmGetLocation.firstWhere((location) => location['locationname'] == selection,
                    orElse: () => {'locationcode': ''});
                GetLocation_txt.text = selectedLocation['locationcode'] ?? '';

                SharedPreferences pref = await SharedPreferences.getInstance();

                setState(() {
                  final part = selection.split(" : ");
                  var choseLocationName = part[0];
                  var choseLocationCode = part.length >1 ? part[1] : '';
                  strSelectedLocationCode = choseLocationCode;
                  strPrefLocation = selection;
                  GetLocation_txt.text = selection;

                  if(strSelectedLocationCode.isNotEmpty){
                    pref.setString(Constant.Selected_LocationCode, choseLocationCode);
                    pref.setString(Constant.Selected_LocationName, choseLocationName);
                    pref.setString(Constant.Selected_Location, selection);

                  }

                });

                GetUserLocationByChange();
        
              },
                fieldViewBuilder: (context,controller,focusNode,onEditingComplete){
                  isFocusNode = focusNode.hasFocus;
                  focusNode.addListener((){
                    setState(() {
                      isFocusNode = focusNode.hasFocus;
                    });
        
                  });
        
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                        labelText: 'Select Location',
                        isDense: true,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: focusNode.hasFocus ? Theme.of(context).primaryColor : Colors.grey
                        ),
        
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                style: BorderStyle.solid,
                                color: Colors.grey
                            )
                        ),
        
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                style: BorderStyle.solid,
                                color: Theme.of(context).primaryColor
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(5))
                        )
        
                    ),
                  );
                },
        
                optionsViewBuilder: (BuildContext context,AutocompleteOnSelected<String> onSelected,Iterable<String> options){
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 8.0,
                      child: SizedBox(
                        height: 300,
                        child: ListView.separated(
                            itemCount: options.length,
                            itemBuilder: (BuildContext context,int index){
                              final String option = options.elementAt(index);
                              return GestureDetector(
                                onTap: (){
                                  onSelected(option);
                                },
                                child: ListTile(
                                  title: Text(option,
                                    style: const TextStyle(
                                    color: Colors.black
                                  ),
                                  ),
                                  tileColor: Colors.white,
        
                                ),
        
                              );
        
        
                            }, separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                              color: Colors.grey,
                              height: 1,
        
                        ),
                        ),
                      ),
                    ),
                  );
                }
        
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          ClipPath(
                            clipper: ZigzagClipper(),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(6),topRight: Radius.circular(6)),
                                color: Theme.of(context).primaryColor,
                              ),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(strEmpName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: Theme.of(context).canvasColor

                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 10,top: 10),
                            child: BuildTextView(context, "Employee Code : ", "$strEmpCode"),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10,left: 10),
                            child: BuildTextView(context, "Current Location : ",
                                selectedlocationname.isNotEmpty && selectedlocationcode.isNotEmpty ?
                                "$selectedlocationname - $selectedlocationcode" : "$strLocationname - $strCurrBrcd"
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10,left: 10),
                            child: BuildTextView(context, "ACC Location: ",
                                selectedAcclocName.isNotEmpty  && selectedAccloccode.isNotEmpty ?
                                "$selectedAcclocName - $selectedAccloccode" : "$strAcclocName - $strAccloccode"),

                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10,left: 10),
                            child: BuildTextView(context, "Region Code : ",
                                selectedRegioncode.isNotEmpty ? "$selectedRegioncode" : "$strRegioncode"
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text("Branch LatLong : ",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(strBranchLat,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Theme.of(context).primaryColor
                                        ),

                                      ),
                                      const Text(' | ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                        ),),

                                      Text(strBranchLong,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Theme.of(context).primaryColor
                                        ),

                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(top: 10,left: 10),
                            child: BuildTextView(context, "Branch Radius : ", "$strBranchRadius $strMeter"),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.5,
                                  style: BorderStyle.solid
                                ),
                                borderRadius: BorderRadius.circular(10)

                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text("Branch Address : ",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                        ),

                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                      child: Text(strBranchAddress,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Theme.of(context).primaryColor
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 10),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.my_location,
                                    color: Colors.red,
                                  )
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(strPrefLocation .isNotEmpty ? strPrefLocation : 'No Location Selected',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.green,
                                        fontSize: 14
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],

                      ),


                    ),

                  ),

                ),
              ),
              /*Padding(padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(onPressed: (){
                  //LocationSaveData();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar(onThemeChange: widget.onThemeChange)));

                }, child: Text("SAVE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: const Size(180, 50)
                  ),
                ),
              )*/
            ],

          ),

        ),

      ),
    );
  }

  Widget BuildTextView(BuildContext context,String strTxtMain,String strTxtfromJson){
    return Row(
      children: [
        Text(strTxtMain,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("$strTxtfromJson",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Theme.of(context).primaryColor
            ),
          ),
        ),
      ],
    );

  }

}