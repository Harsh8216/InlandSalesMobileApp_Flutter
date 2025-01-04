import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:inland_sales_upgrade/Utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityVisitEntry extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  const ActivityVisitEntry({
    super.key,
    required this.onThemeChange
  });


  @override
  State<StatefulWidget> createState() {
    return Activity_visit_entry_state();
  }

}

class Activity_visit_entry_state extends State<ActivityVisitEntry>{
  bool isLoading = true;
  String? CustomerType_selectedItem;
  String? SelectedDate;
  String? Selected_Purpose;
  String? Selected_Outcome;
  String? Selected_Status;
  String? Selected_CommunicationType;

  var arrCompanyName = [];
  var Controller_FromTime = TextEditingController();
  var Controller_ToTime = TextEditingController();
  var controller_CompanyName = TextEditingController();
  var Controller_NextVisitDate = TextEditingController();
  var Controller_AccompaniedBy = TextEditingController();
  var Controller_Remark = TextEditingController();

  String currentLocation = "Fetching location...";
  String currentAddress = "Fetching address...";

  List<String> arrCustDropDown = [];
  List<String> arrDateDropDown = [];
  List<String> arrPurposeDropDown = [];
  List<String> arrOutcomeDropDown = [];
  List<String> arrStatusDropDown = [];
  List<String> arrCommunicationTypeDropDown = [];
  List<String> arrAccompaniedByDropDown = [];

  List<String> arrCustomerType = [
    'Lead',
    'Customer',
    'Suggested Visit'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchLocation();
    getVisitDropDown("10", (data){
      setState(() {
        arrDateDropDown = data;
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideNavigationDrawer(onThemeChange: widget.onThemeChange),
      appBar: Utility().Custom_AppBar(context, "Visit Entry"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: GlobalSpinnerDropdown(
                        value: CustomerType_selectedItem,
                        items: arrCustomerType,
                        hint: "Customer Type",
                        onChanged: (value){
                          setState(() {
                            CustomerType_selectedItem = value as String?;

                            final Map<String, String> customerTypeToID = {
                              "Lead": "01",
                              "Customer": "07",
                              "Suggested Visit": "08",
                            };

                            String? fetchCustomerID = customerTypeToID[CustomerType_selectedItem?? ""];
                            if(fetchCustomerID != null){
                              getVisitDropDown(fetchCustomerID, (data){
                                setState(() {
                                  arrCustDropDown = data;
                                });

                              });
                            }

                          });
                          print("Selected: $value");

                        },
                        isDense: true,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: GlobalSpinnerDropdown(
                        value: SelectedDate,
                        items: arrDateDropDown,
                        hint: "Date",
                        onChanged: (value){
                          setState(() {
                            SelectedDate = value as String?;
                          });
                          print("Selected: $value");

                        },
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: EditTextField(
                          controller: Controller_FromTime,
                          inputType: TextInputType.none,
                          label: "From Time",
                          icon: Icons.access_alarm_sharp,
                          readOnly: true,
                        onTap: (){
                            Utility().selectTime(context, Controller_FromTime);

                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: EditTextField(
                          controller: Controller_ToTime,
                          inputType: TextInputType.none,
                          label: "To Time",
                          icon: Icons.access_alarm_sharp,
                          readOnly: true,
                        onTap: (){
                          Utility().selectTime(context, Controller_ToTime);
                        },
                      ),
                    ),
                  )

                ]
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GlobalAutocomplete(
                  options: arrCustDropDown,
                  controller: controller_CompanyName,
                  label: "Company Name",
                  onSelected: (String selection){
                    setState(() {

                      getVisitDropDown("09", (data){
                        setState(() {
                          arrAccompaniedByDropDown = data;
                        });

                      });

                    });
                  },
                  isDense: true,

                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GlobalSpinnerDropdown(
                    value: Selected_Purpose,
                    items: arrPurposeDropDown,
                    hint: "Purpose",
                    onChanged: (value){
                      setState(() {

                      });
                      Selected_Purpose = value;
                    },
                    isDense: true
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GlobalSpinnerDropdown(
                    value: Selected_Outcome,
                    items: arrOutcomeDropDown,
                    hint: "Outcome",
                    onChanged: (value){
                      setState(() {

                      });
                      Selected_Outcome = value;
                    },
                    isDense: true
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GlobalSpinnerDropdown(
                    value: Selected_Status,
                    items: arrStatusDropDown,
                    hint: "Status",
                    onChanged: (value){
                      setState(() {

                      });
                      Selected_Status = value;
                    },
                    isDense: true
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GlobalSpinnerDropdown(
                    value: Selected_CommunicationType,
                    items: arrCommunicationTypeDropDown,
                    hint: "Communication Type",
                    onChanged: (value){
                      setState(() {

                      });
                      Selected_CommunicationType = value;
                    },
                    isDense: true
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: EditTextField(
                  controller: Controller_NextVisitDate,
                  inputType: TextInputType.none,
                  label: "Next Visit Date",
                  icon: Icons.calendar_month_sharp,
                  readOnly: true,
                  onTap: (){
                    Utility().selectDate(context, Controller_NextVisitDate);

                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GlobalAutocomplete(
                  options: arrAccompaniedByDropDown,
                  controller: Controller_AccompaniedBy,
                  label: "Accompanied By",
                  onSelected: (String selection){
                    setState(() {

                    });
                  },
                  isDense: true,

                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: EditTextField(
                  controller: Controller_Remark,
                  inputType: TextInputType.none,
                  label: "Remark",
                  maxLines: 2,

                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(
                  elevation: 8,
                  child: Container(
                    height: 200,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      /*boxShadow: BoxShadow(
                        blurStyle: BlurStyle.solid,
                        spreadRadius:
                      )*/
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address:",
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),


                          Text(
                            currentAddress,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green
                            ),
                          ),

                          SizedBox(height: 40),

                          Text("Current Location:",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          Text(
                            currentLocation,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green
                            ),
                          ),

                        ],
                      ),
                    ),

                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 20),
                child: Center(
                  child: ElevatedButton(onPressed: (){

                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size(180, 50),
                        /*shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )*/
                      ),
                      child: Text("SUBMIT",
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                      )
                  ),
                ),
              ),

            ],
          ),
        ),
      )

    );
  }

  void getVisitDropDown(String fetchID,Function(List<String>)updatedDropdown) async{
    var pref = await SharedPreferences.getInstance();
    String ? strEmpcd = pref.getString(Constant.Empcd);

    final Map<String,String> requestBody = {
      "Empcd": "$strEmpcd",
      "ID": "$fetchID"
    };

    try{
    Map <String,dynamic> responseData = await ApiHelper.postRequest(EndPoint.MyVisitEntryDrp, requestBody);
    print("Response Data Length: ${responseData.length}");
    if(responseData.containsKey("VisitDrp_array")) {
      List<dynamic> dropdownArray = responseData['VisitDrp_array'];

      setState(() {
        List<Map<String,String>> hmVisitDropDown = [];
        hmVisitDropDown = dropdownArray.map((e) => {
          "Drp_code" : e['Drp_code'].toString(),
          'Drp_text' : e['Drp_text'].toString(),
        }).toList();

        List<String> dropdownTexts = hmVisitDropDown.map((e) => e["Drp_text"].toString()).toList();

        updatedDropdown(dropdownTexts);

      });
    }else{
      print("Response does not contain VisitDrp_array");
      updatedDropdown([]);
    }

    }catch(e){
      print("Error fetching dropdown data: $e");
      updatedDropdown([]);

    }

  }

  Future<void> _fetchLocation() async{
    try{
      Position position = await _determinePosition();

      setState(() {
        currentLocation = "Lat: ${position.latitude},Long: ${position.longitude}";
      });

      await _fetchAddressFromCoordinates(position.latitude, position.longitude);

    }catch(e){
      setState(() {
        currentLocation = "Unable to fetch location: $e";
        currentAddress = "Unable to fetch address.";
      });

    }

  }


  Future<void> _fetchAddressFromCoordinates(double latitude, double longitude) async{
    try{
      List<Placemark> placemark = await placemarkFromCoordinates(latitude, longitude);
      if(placemark.isNotEmpty){
        Placemark place = placemark[0];
        setState(() {
          currentAddress = "${place.name},${place.locality},  ${place.administrativeArea},${place.country}";
        });
      }else{
        setState(() {
          currentAddress = "No address available for these coordinates.";
        });
      }

    }catch(e){
      setState(() {
        currentAddress = "Error fetching address: $e";
      });

    }

  }

  Future<Position> _determinePosition() async{
    bool isServiceEnabled;
    LocationPermission permission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isServiceEnabled){
      throw Exception("Location services are disabled.");

    }
    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      throw Exception("Location permissions are denied.");
    }

    if(permission == LocationPermission.deniedForever){
      throw Exception("Location permissions are permanently denied.");

    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  }

  void VisitEntryBody() async{
    Position position = await _determinePosition();
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();

    try{
      final Map<String,String> requestBody = {
        "Date" : "",
        "startTime" : "",
        "endTime" : "",
        "customerCode" : "",
        "customerName" : "",
        "visitRelated" : "",
        "ColleaguesCode" : "",
        "visitPurpose" : "",
        "visitOutCome" : "",
        "visitNextDate" : "",
        "visitRemarks" : "",
        "Status" : "",
        "activityId" : "",
        "CommunicationType" : "",
        "LocationAddress" : "",
        "Latitude" : latitude,
        "Longitude" : longitude,
        "DistanceFromOffice" : "",
        "PremisesImage" : "",
    };

      List <dynamic> responseData = await ApiHelper.postRequest(EndPoint.MYvisitEntry_Insert, requestBody);
      print(responseData.length);

      setState(() {
        isLoading = false;

      });

    }catch(e){
      setState(() {
        isLoading = false;
      });

    }

  }
}

