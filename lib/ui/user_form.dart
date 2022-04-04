import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/const/AppColors.dart';
import 'package:myapp/ui/bottom_nav_controller.dart';
import 'package:myapp/ui/home_screen.dart';
// import 'package:myapp/ui/bottom_nav_controller.dart';
import 'package:myapp/widgets/customButton.dart';
import 'package:myapp/widgets/myTextField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Nam", "Nữ", "Khác"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB()async{

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;

    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(currentUser!.email).set({
      "name":_nameController.text,
      "phone":_phoneController.text,
      "dob":_dobController.text,
      "gender":_genderController.text,
      "age":_ageController.text,
    }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (_)=> BottomNavController()))).catchError((error)=>print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Hoàn thành biểu mẫu và nộp để tiếp tục",
                  style:
                  TextStyle(fontSize: 22.sp, color: AppColors.deep_orange),
                ),
                Text(
                  "Các thông tin của bạn sẽ được bảo mật hoàn toàn",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                myTextField("Nhập tên của bạn",TextInputType.text,_nameController),
                myTextField("Nhập số điện thoại của bạn",TextInputType.number,_phoneController),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Ngày Sinh",
                    suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Chọn giới tính của bạn",
                    prefixIcon: DropdownButton<String>(
                      items: gender.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          onTap: () {
                            setState(() {
                              _genderController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                myTextField("Nhập tuổi của bạn",TextInputType.number,_ageController),

                SizedBox(
                  height: 50.h,
                ),


                // elevated button
            SizedBox(
            width: 1.sw,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                sendUserDataToDB();
              },
              child: Text(
                "Tiếp tục",
                style: TextStyle(
                    color: Colors.white, fontSize: 18.sp),
              ),
              style: ElevatedButton.styleFrom(
                primary: AppColors.deep_orange,
                elevation: 3,
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
}

