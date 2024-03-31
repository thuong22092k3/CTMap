
import 'dart:ffi';

import 'package:ctmap/assets/colors/colors.dart';
import 'package:ctmap/assets/icons/icons.dart';
import 'package:ctmap/pages/screens/Home_Map/detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const mapboxToken = 'pk.eyJ1IjoibGluaGNoaTIwNSIsImEiOiJjbHVjdzA0YTYwMGQ3Mm5vNDBqY2lmaWN0In0.1JRKpV8uSgIW8rjFkkFQAw';

const myPosition = LatLng(10.870137995752456, 106.8038409948349);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  bool isSearchPressed = false;
  bool isFilterPressed = false;
  bool isAddPressed = false;

  bool isOpened = false;

  void openDetailSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_) {
       return DetailSheet();
    });
    setState(() {
      isOpened = !isOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            options: const MapOptions(
              initialCenter: myPosition,
              minZoom: 5,
              maxZoom: 25,
              initialZoom: 15,
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
              const MarkerLayer(
                markers: [
                  Marker(
                    point: myPosition,
                    // width: 80,
                    // height: 80,
                    child: Icon(
                      Icons.school,
                      color: Colors.lightBlueAccent,
                      size: 40,
                    ),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: isSearchPressed? AppColors.red : AppColors.white,
                  onPressed: () {
                    setState(() {
                      isSearchPressed = !isSearchPressed;
                    });
                  },
                  child: Icon(
                    AppIcons.search,
                    size: 30,
                    color: isSearchPressed ? AppColors.white : AppColors.red, 
                  ),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  backgroundColor: isFilterPressed? AppColors.red : AppColors.white,
                  onPressed: () {
                    setState(() {
                      isFilterPressed = !isFilterPressed;
                      openDetailSheet(context);
                    });
                    
                  },
                  child: Icon(
                    AppIcons.filter,
                    size: 30,
                    color: isFilterPressed ? AppColors.white : AppColors.red, 
                  ),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  backgroundColor: isAddPressed ? AppColors.red : AppColors.white,
                  onPressed: () {
                    setState(() {
                       isAddPressed = !isAddPressed;
                    });

                  },
                  child: Icon(
                    AppIcons.add_location,
                    size: 30,
                    color: isAddPressed ? AppColors.white : AppColors.red, 
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
