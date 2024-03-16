import 'package:flutter/material.dart';
import '../widgets/bottom_tab.dart'; 



class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality( 
      textDirection: TextDirection.ltr, 
      child: Scaffold(
        bottomNavigationBar: BottomNavigationWidget(), 
      ),
    );
  }
}
