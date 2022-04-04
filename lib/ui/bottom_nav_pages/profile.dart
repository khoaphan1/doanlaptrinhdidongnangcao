import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController ?_nameController;
  TextEditingController ?_phoneController;
  TextEditingController ?_ageController;


  setDataToTextField(data){
    return  Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              "Tên",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBBBBBB),
              ),
            ),
          ),
        ),
        TextFormField(
          controller: _nameController = TextEditingController(text: data['name']),
        ),
        SizedBox(
          height: 25,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              "Số điện thoại",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBBBBBB),
              ),
            ),
          ),
        ),
        TextFormField(
          controller: _phoneController = TextEditingController(text: data['phone']),
        ),
        SizedBox(
          height: 25,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              "Tuổi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBBBBBB),
              ),
            ),
          ),
        ),
        TextFormField(
          controller: _ageController = TextEditingController(text: data['age']),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(onPressed: ()=>updateData(), child: Text("Cập nhật"))
      ],
    );
  }

  updateData(){
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update(
        {
          "name":_nameController!.text,
          "phone":_phoneController!.text,
          "age":_ageController!.text,
        }
    ).then((value) => print("Updated Successfully"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users-form-data").doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            var data = snapshot.data;
            if(data==null){
              return Center(child: CircularProgressIndicator(),);
            }
            return setDataToTextField(data);
          },

        ),
      )),
    );
  }
}
