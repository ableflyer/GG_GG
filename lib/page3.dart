import 'dart:developer';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_gg/cardGridView.dart';

class page3 extends StatefulWidget {
  const page3({Key? key}) : super(key: key);

  @override
  State<page3> createState() => _page3State();
}

class _page3State extends State<page3> {

  List<String> free_banners = ["freebanner1.jpg", "freebanner2.jpg", "freebanner3.jpg", "uae.jpg", "usa.jpg"];

  Future<List<String>> getImages() async{
    List<String> x = [];
    for(var i = 0; i<free_banners.length; i++){
      String url = await FirebaseStorage.instance.ref().child("calling_cards/").child(free_banners[i]).getDownloadURL();
      x.add(url);
    }
    return x;
  }
  int ind = 0;
  @override
  Widget build(BuildContext context) {
    String card = "https://firebasestorage.googleapis.com/v0/b/ableflyerdatabase.appspot.com/o/calling_cards%2Ffreebanner1.jpg?alt=media&token=a0a6c01c-dc02-412c-8942-60ff25215c9d";
    void checkOption(int index, String url){
      setState(() {
        ind = index;
        card = url;
        print(card);
        print(ind.toString());
      });
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: getImages(),
              builder: (BuildContext context, AsyncSnapshot snapshot){ 
                return Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 300.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                            color: Colors.red,
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data[ind].toString()),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                    ),
                    Center(child: SizedBox(height: 300.h, width: 150.w,child: Image.asset("assets/card_holder.png", fit: BoxFit.cover,)))
                  ],
                );
              }
            ),
            SizedBox(width: 30.w,),
            SizedBox(
              height: 932.h,
              width: 200.w,
              child: FutureBuilder(
                future: getImages(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return GridView.builder(
                    itemCount: free_banners.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5
                    ),
                    itemBuilder: (BuildContext context, int index){
                      return cardGridView(
                        imageURL: snapshot.data[index].toString(),
                        onTap: (){
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            setState(() {
                              ind = index;
                              card = snapshot.data[index].toString();
                              print(card);
                              print(ind.toString());
                            });
                          });
                        },
                        selected: ind == index,
                      );
                    },
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
