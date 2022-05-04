import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}
class _CartState extends State<Cart> {

  final List _order = [];
  int totalBill = 0;
  final _firestoreInstance = FirebaseFirestore.instance;
  fetchProducts() async {

    QuerySnapshot qn =
    await _firestoreInstance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _order.add(
            {
              "name": qn.docs[i]["name"],
              "price" : qn.docs[i]["price"]
            }

        );

      }
    });

    return qn.docs;
  }

  fetchProducts2() async {

    QuerySnapshot qn =
    await _firestoreInstance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _order.removeRange(0, 2);

      }
    });

    return qn.docs;
  }

  Future addToPayment() async {
    fetchProducts();
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-cart-items");
    var ListItem = _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).collection("items").get();
    for (int i = 0; i < _order.length; i++) {
      print(_order[i]["name"]);
      var myInt = int.parse(_order[i]["price"]);
      assert(myInt is int);
      totalBill = totalBill + myInt;

    }
    print(totalBill);
    print(_order);
    //fetchProducts2();
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // var currentUser = _auth.currentUser;
    // CollectionReference _collectionRef1 =
    // FirebaseFirestore.instance.collection("users-cart-items");
    // return _collectionRef1
    //     .doc(currentUser!.email)
    //     .collection("items")
    //     .doc()
    //     .update({
    //
    //   "status": "shipping"
    // }).then((value) => print("Added to cart1"));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Giỏ hàng",
          style: TextStyle(color: Colors.redAccent),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,


      ),
      bottomNavigationBar: SizedBox(
        width: 1,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            addToPayment();
            print("đã thanh toán");
          },
          child: Text(
            "Thanh Toán",
            style: TextStyle(
                color: Colors.white, fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.lightBlue,
            elevation: 3,
          ),
        ),
      ),
      body: SafeArea(child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Something is wrong"),);
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_,index){
                DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    leading: Text(_documentSnapshot['name']),
                    title: Text(" ${_documentSnapshot['price']} \VNĐ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                    trailing: GestureDetector(
                      child: CircleAvatar(
                        child: Icon(Icons.remove_circle),
                      ),
                      onTap: (){
                        FirebaseFirestore.instance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").doc(_documentSnapshot.id).delete();
                      },
                    ),
                  ),
                );
              }
          );



        },
      ),

      ),
    );
  }
}