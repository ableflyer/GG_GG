import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<Map> leaderplayers() async {
  Map players = {};

  final usersQuery = await FirebaseFirestore.instance.collection("Users").get();
  final userDocs = usersQuery.docs;

  for (final userDoc in userDocs) {
    final ggDocs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userDoc.id)
        .collection("GG.GG")
        .get();

    for (final ggDoc in ggDocs.docs) {
      if(ggDoc.data()["StreakHigh"] != null) {
        players[userDoc.data()["name"]] = ggDoc.data()["StreakHigh"];
      }
    }
  }

  Map sortplayer = Map.fromEntries(players.entries.toList()
    ..sort((e1, e2) => e1.value.compareTo(e2.value)));
  Map leader = Map.fromEntries(sortplayer.entries.toList().reversed);
  print(leader);
  return leader;
}
class weekly extends StatelessWidget {
  const weekly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Text("No."),
          title: Text("Name"),
          trailing: Text("Count"),
        ),
        Divider(),
        SizedBox(
          height: 420.h,
          child: FutureBuilder(
            future: leaderplayers(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return snapshot.hasData? ListView.builder(
                itemCount: snapshot.data.length < 100? snapshot.data.length:100,
                itemBuilder: (BuildContext context, int index){
                  var player = snapshot.data.entries.toList()[index];
                  return ListTile(
                    leading: Text("${index+1}."),
                    title: Text(player.key),
                    trailing: Text(player.value.toString()),
                  );
                },
              ):const SpinKitRotatingPlain(
                color: Colors.black,
              );
            },
          ),
        )
      ],
    );
  }
}
