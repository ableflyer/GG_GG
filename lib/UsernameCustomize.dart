import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:username_validator/username_validator.dart';

class UsernameCustomize extends StatefulWidget {
  const UsernameCustomize({super.key});

  @override
  State<UsernameCustomize> createState() => _UsernameCustomizeState();
}

class _UsernameCustomizeState extends State<UsernameCustomize> {
  Map arg = {};
  TextEditingController nameTEC = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arg = ModalRoute.of(context)?.settings.arguments as Map;
    nameTEC.text = arg["username"];
  }

  @override
  Widget build(BuildContext context) {
    arg = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context,{
                "username": arg["username"]
              });
            },
            icon: Icon(Icons.arrow_back, size: 32.sp,)
        ),
        actions: [
          ElevatedButton(onPressed: () async{
            if (nameTEC.text.toString().isNotEmpty && UValidator.validateThis(username: nameTEC.text.toString())) {
              FirebaseAuth.instance.currentUser?.updateDisplayName(nameTEC.text.toString());
              await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").update({
                "name": nameTEC.text.toString()
              });
              Navigator.pop(context,{
                "username": nameTEC.text.toString()
              });
            }
          }, child: Text("Set"))
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: TextField(
            controller: nameTEC,
            style: TextStyle(
                color: Colors.black
            ),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: Colors.grey
              ),
              labelText: "Username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
