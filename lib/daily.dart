import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Map players = {"Hello": 48, "Ableflyer": 80, "crazyman": 65, "gottoosilly": 100};
Map sortplayer = Map.fromEntries(players.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));
Map leader = Map.fromEntries(sortplayer.entries.toList().reversed);
class Level extends StatelessWidget {
  const Level({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Text("No."),
          title: Text("Name"),
          trailing: Text("Level"),
        ),
        Divider(),
        SizedBox(
          height: 420.h,
          child: ListView.builder(
            itemCount: leader.length,
            itemBuilder: (BuildContext context, int index){
              var player = leader.entries.toList()[index];
              return ListTile(
                leading: Text("${index+1}."),
                title: Text(player.key),
                trailing: Text(player.value.toString()),
              );
            },
          ),
        )
      ],
    );
  }
}
