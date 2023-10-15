import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class elist extends StatefulWidget {
  const elist({Key? key}) : super(key: key);

  @override
  State<elist> createState() => _elistState();
}

class _elistState extends State<elist> {
  List<String> exercises = [
    "pushups",
    "squats",
    "star jumps",
    "lunges",
    "squat jumps",
    "high knees"
  ];
  int count = 1;
  bool? reps = true;
  bool? secs = false;

  String ExerciseType(String exercise) {
    if (exercise == "pushups" || exercise == "situps") {
      return "abs";
    }
    if (exercise == "squats" || exercise == "lunges" || exercise == "High Jumps" || exercise == "squat jumps" || exercise == "high knees") {
      return "leg";
    }
    return "all";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Choose an exercise"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 930.h,
          width: 387.36.w,
          child: ListView.separated(
            itemCount: exercises.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionTile(
                trailing: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: 24.h,
                          width: 24.h,
                          child: Image.asset(
                              "assets/${ExerciseType(exercises[index])}.png", fit: BoxFit.scaleDown,)),
                      Text(
                        "${ExerciseType(exercises[index])}",
                        style: TextStyle(fontSize: 12.sp),
                      )
                    ],
                  ),
                  height: 67.h,
                  width: 67.w,
                ),
                title: Container(
                  height: 67.h,
                  width: 387.36.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1.sp)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: Center(
                            child:
                                Image.asset("assets/${exercises[index]}.png")),
                        height: 67.h,
                        width: 120.w,
                      ),
                      SizedBox(
                        child: Center(
                            child: Text(
                          exercises[index][0].toUpperCase() +
                              exercises[index].substring(1).toLowerCase(),
                          style: TextStyle(fontSize: 20.sp),
                        )),
                        height: 67.h,
                        width: 120.w,
                      ),

                    ],
                  ),
                ),
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                reps == true ? "Reps" : "Secs",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      width: 28.h,
                                      height: 28.h,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          if ((count > 1 && reps == true) || (count > 15 && reps != true)) {
                                            setState(() {
                                              count -= reps == true? 1:15;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                        heroTag: null,
                                      )),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Container(
                                      width: 50.w,
                                      height: 28.h,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(child: Text("${count}"))),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  SizedBox(
                                      width: 28.h,
                                      height: 28.h,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          setState(() {
                                            count += reps == true? 1:15;
                                          });
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        heroTag: null,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: reps,
                                      onChanged: (boolval) {
                                        if (reps != true) {
                                          setState(() {
                                            reps = true;
                                            secs = false;
                                            count = 1;
                                          });
                                        }
                                      }),
                                  Text(
                                    "Reps",
                                    style: TextStyle(fontSize: 14.sp),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: secs,
                                      onChanged: (boolval) {
                                        if (secs != true) {
                                          setState(() {
                                            secs = true;
                                            reps = false;
                                            count = 15;
                                          });
                                        }
                                      }),
                                  Text(
                                    "Secs",
                                    style: TextStyle(fontSize: 14.sp),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      Bounce(
                        onPressed: () {
                          Navigator.pop(context, {
                            "exercise": exercises[index],
                            "count": count,
                            "type": reps == true ? "Reps" : "Secs",
                          });
                        },
                        duration: Duration(milliseconds: 50),
                        child: Container(
                          height: 53.h,
                          width: 170.w,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFF00FF0C), Colors.green]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Text(
                              "Set",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20.h,
              );
            },
          ),
        ),
      ),
    );
  }
}
