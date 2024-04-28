import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/screens/Home_Map/detail_sheet.dart';
import 'package:ctmap/pages/screens/Home_Map/filter_sheet.dart';
import 'package:ctmap/pages/screens/Home_Map/new_sheet.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/widgets/components/Animated%20Search%20Bar/anim_search_bar.dart';
import 'package:ctmap/widgets/components/Button/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ctmap/data/type.dart';

const mapboxToken =
    'pk.eyJ1IjoibGluaGNoaTIwNSIsImEiOiJjbHVjdzA0YTYwMGQ3Mm5vNDBqY2lmaWN0In0.1JRKpV8uSgIW8rjFkkFQAw';

var myPosition = LatLng(10.870137995752456, 106.8038409948349);



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
  
}

class HomeState extends State<Home> {
  final MapController _mapController = MapController();
  
  List<AccidentData> accidentDataList = [];

  @override
  void initState() {
    super.initState();
    getAccidents();
  }

  Future<void> getAccidents() async {
    List<AccidentData> accidents = await getAllAccidents();
    if (accidents.isNotEmpty) {
      print('Dữ liệu đã được lấy thành công.');
      for (var accident in accidents) {
        print('Date: ${accident.date}');
        print('Deaths: ${accident.deaths}');
        print('Injuries: ${accident.injuries}');
        print('Level: ${accident.level}');
        print('Cause: ${accident.cause}');
        print('Position: ${accident.position}');
        print('Số phương tiện liên quan: ${accident.sophuongtienlienquan}');
        print('Link: ${accident.link}');
        print('-----------------------');
      }
    } else {
      print('Không có dữ liệu.');
    }
    setState(() {
      accidentDataList = accidents;
    });
  }

  void _onMarkerTapped(AccidentData data, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: DetailSheet(accidentData: data),
        );
      },
    );
  }
  
  bool isSearchPressed = false;
  // bool isFilterPressed = false;
  // bool isAddPressed = false;

  List<Marker> markers = [];
  void addMarker(LatLng tapLatLng) {
    Marker marker = Marker(
      width: 50,
      height: 50,
      point: tapLatlng, 
      child: IconButton(
          icon: const Icon(
            AppIcons.add_location,
            size: 40,
            color: Colors.red,
          ), 
          onPressed: () {
          },
        ),
    );
    markers.add(marker);
    
    openNewSheet();
    
    
    setState(() {
      
    });
  }

  //DETAIL SHEET
  bool isOpened = false;

  void openDetailSheet(AccidentData data, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return DetailSheet(accidentData: data);
        });
    setState(() {
      isOpened = !isOpened;
    });
  }

  // Add type dialog
  bool isAddDialogOpened = false;
  bool isSelfAdd = false;
  bool isCurLocation = false;
  void showAddTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            // title: const Text(
            //   "Chọn cách thêm",
            //   style: TextStyle(
            //     color: AppColors.red, 
            //     fontSize: 18, 
                
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomButton(
                  onTap: () {
                    setState(() {
                      isSelfAdd = true;
                      Navigator.of(context).pop();
                    });
                  },
                  btnText: "Tự thêm trên bản đồ",
                  btnHeight: 30,
                  borderRadius: 5,
                  btnWidth: 200,
                  fontSize: 14,
                  btnColor: AppColors.red ,
                ),
                CustomButton(
                  onTap: () {
                    getCurrentLocation();
                    setState(() {
                      isCurLocation = true;
                      Navigator.of(context).pop();
                    });
                  },
                  btnText: "Truy cập vị trí hiện tại",
                  btnHeight: 30,
                  borderRadius: 5,
                  btnWidth: 200,
                  fontSize: 14,
                  btnColor: AppColors.red ,
                ),
              ],
            ),
          ),
          
        );
      }
    ).then((value) {
      setState(() {
        isAddDialogOpened = false;
      });
    });
    setState(() {
      isAddDialogOpened = true;
    });
  }

  //SEARCH 
  TextEditingController textController = TextEditingController();

  //FILTER SHEET
  bool isFilterOpened = false;
  void openFilterSheet() {
    showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) {
        return const FilterSheet();

      },
    ).then((value) {
      setState(() {
        isFilterOpened = false;
      });
    });
    setState(() {
      isFilterOpened = true;
    });
  }

  //ADD SHEET
  bool isNewOpened = false;
  void openNewSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const NewSheet(); 
      },
    ).then((value) {
      setState(() {
        isNewOpened = false;
        isSelfAdd = false;
      });
    });
    setState(() {
      isNewOpened = true;
    });
  }

  late LatLng tapLatlng;

  //GET CURRENT LOCATION---------------------------------------------------------------------------
  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    var position = await Geolocator.getCurrentPosition();
    LatLng curLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(myPosition, 15.0);

    Marker marker = Marker(
      width: 50,
      height: 50,
      point: curLocation, 
      child: IconButton(
          icon: const Icon(
            AppIcons.add_location,
            size: 40,
            color: Colors.red,
          ), 
          onPressed: () {
          },
        ),
    );
    markers.add(marker);
    
    openNewSheet();

    //addMarker(curLocation);
    
    print(position.latitude);
    print(position);
    print(curLocation);

    return(curLocation);
  }
  
  @override
  Widget build(BuildContext context) {
    print('Accident Data List: $accidentDataList');
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: myPosition,
              minZoom: 5,
              maxZoom: 25,
              initialZoom: 11,
              onTap: (tapPosition, latLng) {
                if(isSelfAdd == true){
                  tapLatlng = latLng;
                  addMarker(tapLatlng);
                  print(tapLatlng);
                }         
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/linhchi205/clue6n1k000gd01pec4ie0pcn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGluaGNoaTIwNSIsImEiOiJjbHVjdzA0YTYwMGQ3Mm5vNDBqY2lmaWN0In0.1JRKpV8uSgIW8rjFkkFQAw",
                additionalOptions: const {
                  'accessToken': mapboxToken,
                  'id': 'mapbox.mapbox-streets-v8',
                },
              ),
              //if (accidentDataList.isNotEmpty)
                MarkerLayer(
                  markers: [
                    for (var accidentData in accidentDataList)
                      Marker(
                        point: accidentData.position,
                        child: GestureDetector(
                          onTap: () {
                            _onMarkerTapped(accidentData, context);
                          },
                          child: NumberedLocationIcon(
                            iconData: AppIcons.location,
                            number: accidentData.level,
                          ),
                        ),
                      ),
                    
                  ],
                  
                  //markers: markers,
                ),
        
            ],
          ),
          Positioned(
              top: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimSearchBar(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 32,
                    textController: textController,
                    onSuffixTap: () {
                      setState(() {
                        textController.clear();
                      });
                    },
                    onSubmitted: (String value) {
                      debugPrint("onSubmitted value: $value");
                    },
                    textInputAction: TextInputAction.search,
                    searchBarOpen: (a) {
                      a = 0;
                    },
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(0, 0, 0, 25),
                            blurRadius: 1,
                            spreadRadius: 0.0,
                            offset: Offset(0, 3),
                            blurStyle: BlurStyle.normal,

                          ),
                        ],
                      ),
                      child: FloatingActionButton( 
                        backgroundColor: isFilterOpened ? AppColors.red : AppColors.white,
                        onPressed: () {
                          setState(() {
                            if (!isFilterOpened) {
                              openFilterSheet();
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          AppIcons.filter,
                          size: 30,
                          color: isFilterOpened ? AppColors.white : AppColors.red,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(0, 0, 0, 25),
                            blurRadius: 1,
                            spreadRadius: 0.0,
                            offset: Offset(0, 3),
                            blurStyle: BlurStyle.normal,

                          ),
                        ],
                      ),
                      child: FloatingActionButton(
                        backgroundColor: isAddDialogOpened ? AppColors.red : AppColors.white,
                        onPressed: () {
                          setState(() {
                            if (!isAddDialogOpened) {
                              showAddTypeDialog();
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          AppIcons.add_location,
                          size: 30,
                          color: isAddDialogOpened ? AppColors.white : AppColors.red,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
        ],
      ),
    );
  }
}
