// ignore_for_file: avoid_print

import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/routes/routes.dart';
import 'package:ctmap/pages/screens/Home_Map/detail_sheet.dart';
import 'package:ctmap/pages/screens/Home_Map/filter_sheet.dart';
import 'package:ctmap/pages/screens/Home_Map/new_sheet.dart';
import 'package:ctmap/services/api.dart';
import 'package:ctmap/state_management/accident_state.dart';
import 'package:ctmap/state_management/user_state.dart' as userState;
import 'package:ctmap/widgets/components/animated_search_bar/location_nominatim.dart';
import 'package:ctmap/widgets/components/animated_search_bar/anim_search_bar.dart';
import 'package:ctmap/widgets/components/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:ctmap/data/type.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

const mapboxToken =
    'pk.eyJ1IjoibGluaGNoaTIwNSIsImEiOiJjbHVjdzA0YTYwMGQ3Mm5vNDBqY2lmaWN0In0.1JRKpV8uSgIW8rjFkkFQAw';

const mapAPI = "https://api.mapbox.com/styles/v1/linhchi205/clue6n1k000gd01pec4ie0pcn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGluaGNoaTIwNSIsImEiOiJjbHVjdzA0YTYwMGQ3Mm5vNDBqY2lmaWN0In0.1JRKpV8uSgIW8rjFkkFQAw";
var myPosition = const LatLng(10.870137995752456, 106.8038409948349);

// sửa ở statefulwidget -> ConsumerStatefulWidget
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

// sửa ở state -> ConsumerState
class HomeState extends ConsumerState<Home> {
  final MapController _mapController = MapController();

  List<AccidentData> accidentDataList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getInitialAccidents();
  }

  Future<void> getInitialAccidents() async {
    setState(() {
      isLoading = true; 
    });

    try {
      List<AccidentData> accidents = await getAllAccidents();
      ref.read(accidentProvider.notifier).setAccidents(accidents);

      setState(() {
        accidentDataList = accidents;
      });
      showMarkers(accidentDataList); 
    } catch (e) {
      print('Error fetching accidents: $e');
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  Future <void> getAccidents() async {
    List<AccidentData> accidents = await getAllAccidents();
    ref.read(accidentProvider.notifier).setAccidents(accidents);

    setState(() {
      accidentDataList = accidents;
    });

    showMarkers(accidentDataList); 
  }

  //Thêm zoom
  void _moveToPosition(LatLng position) {
    _mapController.move(position, 18.0);
  }

  void _onMarkerTapped(AccidentData data, BuildContext context) async{
    _moveToPosition(data.position);
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: DetailSheet(
            accId: data.id, 
          ),
        );
      },
    );
    await getAccidents();
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    btnColor: AppColors.red,
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
                    btnColor: AppColors.red,
                  ),
                ],
              ),
            ),
          );
        }).then((value) {
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
  bool isSearchPressed = false;

  // List Accidents
  List<AccidentData> filteredAccidents = [];
  List<Marker> markers = [];
  bool isFilteredMode = false;

  void onFilterApplied(List<AccidentData> filteredList) {
    setState(() {
      filteredAccidents = filteredList;
      showMarkers(filteredAccidents);
    });
  }

  void onFilterStatusChanged(bool isFilteredStatus) {
    setState(() {
      isFilteredMode = isFilteredStatus;
    });
  }

  void showMarkers(List<AccidentData> accidentList) {
    setState(() {
      markers = accidentList.map((accident) {
        return Marker(
          point: accident.position,
          child: GestureDetector(
            onTap: () {
              _onMarkerTapped(accident, context);
            },
            child: NumberedLocationIcon(
              iconData: AppIcons.location,
              number: accident.level,
            ),
          ),
        );
      }).toList();
    });
  }

  //FILTER SHEET
  bool isFilterOpened = false;
  void openFilterSheet() async {
    setState(() {
      isFilterOpened = true;
    });

    await showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: FilterSheet(
            onFilterApplied: onFilterApplied,
            onFilterStatusChanged: onFilterStatusChanged)
            ,
        );
      },
    ).then((value) {
      setState(() {
        isFilterOpened = false;
      });
    });
  }

  //ADD SHEET
  bool isNewOpened = false;
  void openNewSheet(LatLng position) async {
    setState(() {
      isNewOpened = true;
    });
    await showModalBottomSheet<dynamic>(
      context: context,
      builder: (context) {
        return NewSheet(
          addPosition: position,
        );
      },
    ).then((value) {
      setState(() {
        isNewOpened = false;
        isSelfAdd = false;
      });
    });
    await getAccidents();
  }

  late LatLng tapLatlng;

  //GET CURRENT LOCATION---------------------------------------------------------------------------
  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Truy cập vị trí đang tắt.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Quyền truy cập vị trí bị từ chối');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Quyền truy cập vị trí bị từ chối vĩnh viễn, không thể gửi yêu cầu quyền truy cập.');
    }

    var position = await Geolocator.getCurrentPosition();
    LatLng curLocation = LatLng(position.latitude, position.longitude);

    setState(() {
      myPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(myPosition, 15.0);

    openNewSheet(curLocation);

    return (curLocation);
  }

  void _handleAdd(BuildContext context, WidgetRef ref) {
    final userStateRef = ref.read(userState.userStateProvider);
    if (userStateRef.isLoggedIn) {
      showAddTypeDialog();
    } else {
      //Sửa ở đây
      context.push(RoutePaths.login).then((_) {
        if (ref.read(userState.userStateProvider).isLoggedIn) {
          showAddTypeDialog();
        }
      });
    }
  }

  //SEARCH
  LatLng? searchCenter;
  final TextEditingController searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    accidentDataList = ref.watch(accidentProvider);
    print('Accident Data List: $accidentDataList');
    return Consumer(
      builder: (context, ref, _) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: myPosition,
                  minZoom: 5,
                  maxZoom: 25,
                  initialZoom: 10,
                  interactionOptions: const InteractionOptions(
                      //cursorKeyboardRotationOptions: CursorKeyboardRotationOptions.disabled(),
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
                  onTap: (tapPosition, latLng) {
                    if (isSelfAdd == true) {
                      tapLatlng = latLng;
                      openNewSheet(latLng);
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: mapAPI,
                    additionalOptions: const {
                      'accessToken': mapboxToken,
                      'id': 'mapbox.mapbox-streets-v8',
                    },
                  ),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 45,
                      size: const Size(40, 40),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(50),
                      maxZoom: 18,
                      //markers: getMarkers(accidentDataList),
                      markers: markers,
                      builder: (context, markers) {
                        Color clusterColor;
                        if (markers.length < 10) {
                          clusterColor = AppColors.danger1;
                        } else if (markers.length < 20) {
                          clusterColor = AppColors.danger2;
                        } else {
                          clusterColor = AppColors.danger3;
                        }
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: clusterColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 0),
                                )
                              ]),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 5, //HEIGHT OF STATUS BAR
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimSearchBar(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 50,
                      textController: searchController,
                      helpText: "Tìm kiếm",
                      suffixIcon:
                          const Icon(AppIcons.close, color: AppColors.white),
                      prefixIcon:
                          const Icon(AppIcons.search, color: AppColors.red),
                      textFieldColor: Colors.red,
                      initialBackgroundColor: Colors.white,
                      initialIconColor: Colors.blue,
                      onSuffixTap: () {
                        setState(() {
                          searchController.clear();
                          searchCenter = myPosition;
                        });
                        _mapController.move(myPosition, 11.0);
                      },
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          final locations = await searchLocation(value);
                          if (locations.isNotEmpty) {
                            final location = locations.first;
                            setState(() {
                              searchCenter = LatLng(location.lat, location.lon);
                            });
                            _mapController.move(searchCenter!, 14.0);
                          }
                        }
                      },
                      searchBarOpen: (toggle) {
                        if (toggle == 0) {
                          setState(() {
                            searchController.clear();
                          });
                        }
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
                          heroTag: 'filter',
                          backgroundColor: isFilteredMode || isFilterOpened
                              ? AppColors.red
                              : AppColors.white,
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
                            color: isFilteredMode || isFilterOpened
                                ? AppColors.white
                                : AppColors.red,
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
                          heroTag: 'add new',
                          backgroundColor: isAddDialogOpened
                              ? AppColors.red
                              : AppColors.white,
                          onPressed: () {
                            _handleAdd(context, ref);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            AppIcons.addLocation,
                            size: 30,
                            color: isAddDialogOpened
                                ? AppColors.white
                                : AppColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.grey.withOpacity(0.25),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.red)
                      ), 
                    ),
                  ),
                ),
              if (isSelfAdd) 
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0), 
                    child: Container(
                      color: AppColors.red,
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bạn đang ở chế độ thêm mới!\nChọn trên bản đồ để thêm vụ tai nạn!',
                            style: TextStyle(
                              color: AppColors.white, 
                              fontSize: 14
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isSelfAdd = false;
                              });
                            }, 
                            child: const Text(
                              'Thoát',
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
