import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, QuerySnapshot;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../product_details_screen.dart';
import '../search_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _carouselImages = [];
  var _dotPosition = 0;
  final List _products = [];
  final _firestoreInstance = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();

  fetchCarouselImages() async {

    QuerySnapshot qn =
    await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }

  fetchProducts() async {

    QuerySnapshot qn =
    await _firestoreInstance.collection("products").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add(
            {
              "product-name": qn.docs[i]["product-name"],
              "product-description": qn.docs[i]["product-description"],
              "product-price": qn.docs[i]["product-price"],
              "product-img": qn.docs[i]["product-img"],
            }

        );

      }
    });

    return qn.docs;
  }



  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      hintText: "Nhập sản phẩm bạn muốn tìm",
                      hintStyle: TextStyle(fontSize: 15.sp),
                    ),
                    onTap: () => Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => SearchScreen())),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                AspectRatio(
                  aspectRatio: 3.5,
                  child: CarouselSlider(
                      items: _carouselImages
                          .map((item) => Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.fitWidth)),
                        ),
                      ))
                          .toList(),
                      options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          onPageChanged: (val, carouselPageChangedReason) {
                            setState(() {
                              _dotPosition = val;
                            });
                          })),
                ),
                SizedBox(
                  height: 10.h,
                ),
                DotsIndicator(
                  dotsCount:
                  _carouselImages.length == 0 ? 1 : _carouselImages.length,
                  position: _dotPosition.toDouble(),
                  decorator: DotsDecorator(
                    activeColor: AppColors.deep_orange,
                    color: AppColors.deep_orange.withOpacity(0.5),
                    spacing: EdgeInsets.all(2),
                    activeSize: Size(8, 8),
                    size: Size(8, 8),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1),
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetails(_products[index]))),
                          child: Card(
                            elevation: 3,
                            child: Column(
                              children: [
                                AspectRatio(
                                    aspectRatio: 1.5,
                                    child: Container(
                                        color: Colors.white,
                                        child: Image.network(
                                          _products[index]["product-img"][0],
                                        ))),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text("${_products[index]["product-name"]}"),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                    "${_products[index]["product-price"].toString()} \VNĐ"),
                              ],
                            ),
                          ),
                        );
                      }),
                ),


              ],
            ),
          )),
    );
  }
}