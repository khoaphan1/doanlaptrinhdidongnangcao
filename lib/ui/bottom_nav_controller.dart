import 'package:flutter/material.dart';
import 'package:myapp/ui/bottom_nav_pages/cart.dart';
import 'package:myapp/ui/bottom_nav_pages/favourite.dart';
import 'package:myapp/ui/bottom_nav_pages/home.dart';
import 'package:myapp/ui/bottom_nav_pages/profile.dart';
import 'package:myapp/const/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomNavController extends StatefulWidget {
  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {

  final _pages = [Home(),Favourite(),Cart(),Profile()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "YoLo Shop",
          style: TextStyle(color: Colors.blueAccent),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.deep_orange,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang Chủ",backgroundColor: Colors.grey),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: "Yêu Thích",backgroundColor: Colors.grey),
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label:  "Giỏ Hàng",backgroundColor: Colors.grey),
          BottomNavigationBarItem(icon: Icon(Icons.person), label:  "Cá Nhân",backgroundColor: Colors.grey),
        ],
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}