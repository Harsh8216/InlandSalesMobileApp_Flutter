import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inland_sales_upgrade/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity_Get_Location extends StatefulWidget{
  static final GlobalKey<Activity_Get_Location_State> locationKey = GlobalKey<Activity_Get_Location_State>();

  const Activity_Get_Location({super.key});
  @override
  State<StatefulWidget> createState() => Activity_Get_Location_State();

}

class Activity_Get_Location_State extends State<Activity_Get_Location>{
  List<Map<String,String>> hmGetLocation = [];
  List<String> arrGetLocation = [];
  var GetLocation_txt = TextEditingController();
  bool isFocusNode = false;
  String strPrefLocation = "";
  var strEmpName = "";
  var strEmpCode = "";
  var strBranchLocation = "";
  var strBranchAddress = "";
  var strBranchLat = "";
  var strBranchLong = "";
  var strBranchRadius = "";
  var strMeter = "Meter";

  @override
  void initState() {
    super.initState();
    getLocation();
    LocationSaveData();

  }

  Future<void>  LocationSaveData() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strSaveLocation = pref.getString(Constant.Selected_Location) ?? 'No Location Selected';
    var _strEmpName = pref.getString(Constant.Name) ?? '';
    var _strEmpCode = pref.getString(Constant.Empcd) ?? '';
    var _strBranchLocation = pref.getString(Constant.CurrBrcd) ?? '';
    var _strBranchAddress = pref.getString(Constant.Branch_Address) ?? '';
    var _strBranchLat = pref.getString(Constant.Branch_Lat) ?? '';
    var _strBranchLong = pref.getString(Constant.Branch_Long) ?? '';
    var _strBranchRadius = pref.getString(Constant.Branch_Radious) ?? '';

    setState(() {
      strPrefLocation = strSaveLocation;
      GetLocation_txt.text = strSaveLocation;
      strEmpName = _strEmpName;
      strEmpCode = _strEmpCode;
      strBranchLocation = _strBranchLocation;
      strBranchAddress = _strBranchAddress;
      strBranchLat = _strBranchLat;
      strBranchLong = _strBranchLong;
      strBranchRadius = _strBranchRadius;

    });
  }


  Future<void> getLocation() async{
    var pref = await SharedPreferences.getInstance();
    String ? strEmpcd = pref.getString(Constant.Empcd);

    final Map<String,String> RequestBody = {
      'empcd' : '$strEmpcd',
      'Tokenno' : Constant.TokenNo

    };

    try{
      final http.Response response = await http.post(
        Uri.parse(Constant.baseurl + EndPoint.GetLocation),
        body: jsonEncode(RequestBody),
        headers: {"Content-Type": "application/json"}

      );

      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> getLocationResult  = responseData['GetLocationResult'];

        setState(() {
          hmGetLocation = getLocationResult.map((location) => {
            'locationcode' : location['locationcode'].toString(),
            'locationname' : location['locationname'].toString()

          }).toList();
          print('GetLocation : $hmGetLocation' );

          arrGetLocation = hmGetLocation.map((location) => location['locationname']!).toList();

        });

      }else{
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        //Utility().ShowToast("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }


    }catch(e){
      print("An error occurred: $e");
      //Utility().ShowToast("An error occurred: $e");

    }
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
                pref.setString(Constant.Selected_Location, selection);
        
                setState(() {
                  strPrefLocation = selection;
                  GetLocation_txt.text = selection;
        
                });
        
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
                padding: const EdgeInsets.only(top: 30),
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
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
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("Employee Code : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
        
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(strEmpCode,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text("Branch Location : ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(strBranchLocation,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor
                                    ),
                                  ),
                                ),
        
                              ],
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
                                      fontSize: 14,
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
                                            fontSize: 14,
                                            color: Theme.of(context).primaryColor
                                        ),
        
                                      ),
                                      const Text('/',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                        ),),
        
                                      Text(strBranchLong,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
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
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text("Branch Radius : ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text("$strBranchRadius $strMeter",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                            fontSize: 14,
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
              )
            ],
          ),
        
        ),
      )
    );
  }

}