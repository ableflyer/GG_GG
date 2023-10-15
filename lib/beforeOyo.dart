import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class beforeOyo extends StatefulWidget {
  const beforeOyo({Key? key}) : super(key: key);

  @override
  State<beforeOyo> createState() => _beforeOyoState();
}

class _beforeOyoState extends State<beforeOyo> {
  var arg = {};
  List<String> allexercises = [
    "pushups",
    "situps",
    "squats",
    "star jumps",
    "lunges",
    "High Jumps",
    "squat jumps",
    "high knees"
  ];
  List<String> exercises = [
    "pushups",
    "squats",
    "star jumps",
    "lunges",
    "squat jumps",
    "high knees"
  ];
  List<Map> list = [];
  List<String> difficulties = ["Easy", "Medium", "Hard", "None"];
  List<Color> diffcolor = [Colors.blue, Colors.green, Colors.amber];
  int setscount = 1;
  int secondsrest = 5;
  bool? rest = false;
  bool audio = true;
  bool music = false;
  bool time = false;
  String timeorcal = "Total time needed";
  int difficulty = 1;
  int qtype = 1;
  int age = 18;
  double weight = 92.0;
  double height = 168.0;
  bool male = true;

  double bmr(int a, double w, double h, bool g){
    double result = 0.0;
    if (g == true){
      result = (10*w)+(6.25*h)-(5*a)+5;
    }
    else{
      result = (10*w)+(6.25*h)-(5*a)-161;
    }
    print(result);
    return result;
  }

  double timetaken(List exerciselist){
    double time = 0.0;
    for(int i = 0; i < exerciselist.length; i++){
      if(exerciselist[i]["type"] == "Reps") {
        if (exerciselist[i]["exercise"] == "pushups") {
          time = time + (exerciselist[i]["count"] * 0.025) + (secondsrest / 60);
        }
        if (exerciselist[i]["exercise"] == "situps") {
          time =
              time + (exerciselist[i]["count"] * 0.0417) + (secondsrest / 60);
        }
        if (exerciselist[i]["exercise"] == "squats") {
          time =
              time + (exerciselist[i]["count"] * 0.0417) + (secondsrest / 60);
        }
        if (exerciselist[i]["exercise"] == "star jumps") {
          time = time + (exerciselist[i]["count"] * 0.025) + (secondsrest / 60);
        }
        if (exerciselist[i]["exercise"] == "lunges") {
          time = time + (exerciselist[i]["count"] * 0.033) + (secondsrest / 60);
        }
        if (exerciselist[i]["exercise"] == "High Jumps") {
          time = time + (exerciselist[i]["count"] * 0.021) + (secondsrest / 60);
        }
        if (exerciselist[i]["exercise"] == "squat jumps") {
          time = time + (exerciselist[i]["count"] * 0.0166667) +
              (secondsrest / 60);
        }
        if (exerciselist[i]["exercise"] == "high knees") {
          time = time + (exerciselist[i]["count"] * 0.012) + (secondsrest / 60);
        }
      }
      else{
        time = time + exerciselist[i]["count"]/60 + (secondsrest / 60);
      }
    }
    return time;
  }

  double caloriemeter(List exerciselist){
    double cal = 0.0;
    double BMR = bmr(age, weight, height, male);
    for(int i = 0; i < exerciselist.length; i++){
      if (exerciselist[i]["exercise"] == "pushups"){
        if(exerciselist[i]["type"] == "Reps") {
          cal = cal + (exerciselist[i]["count"] * 0.6);
        }
        else{
          cal = cal + (7*(exerciselist[i]["count"]/60));
        }
        // cal = cal + ((BMR*2.5*exerciselist[i]["count"])/(1440));
      }
      if (exerciselist[i]["exercise"] == "situps"){
        if(exerciselist[i]["type"] == "Reps") {
          cal = cal + (exerciselist[i]["count"] * 0.5);
        }
        else{
          cal = cal + (10*(exerciselist[i]["count"]/60));
        }
        // cal = cal + ((BMR*2*exerciselist[i]["count"])/(1440));
      }
      if (exerciselist[i]["exercise"] == "squats"){
        if(exerciselist[i]["type"] == "Reps") {
          cal = cal + (exerciselist[i]["count"] * 0.32);
        }
        else{
          cal = cal + (8*(exerciselist[i]["count"]/60));
        }
        // cal = cal + ((BMR*2.5*exerciselist[i]["count"])/(1440));
      }
      if (exerciselist[i]["exercise"] == "star jumps"){
        if(exerciselist[i]["type"] == "Reps") {
          cal = cal + exerciselist[i]["count"];
        }
        else{
          cal = cal + (9.8*(exerciselist[i]["count"]/60));
        }
        // cal = cal + ((BMR*3*exerciselist[i]["count"])/(1440));
      }
      if (exerciselist[i]["exercise"] == "lunges"){
        if(exerciselist[i]["type"] == "Reps") {
          cal = cal + (exerciselist[i]["count"] * 0.3);
        }
        else{
          cal = cal + (5.4*(exerciselist[i]["count"]/60));
        }
        // cal = cal + ((BMR*3*exerciselist[i]["count"])/(1440));
      }
      if (exerciselist[i]["exercise"] == "High Jumps"){
        if(exerciselist[i]["type"] == "Reps") {
          cal = cal + exerciselist[i]["count"] * 0.21;
        }
        else{
          cal = cal + (7*(exerciselist[i]["count"]/60));
        }
        // cal = cal + ((BMR*1.7*exerciselist[i]["count"])/(1440));
      }
      if (exerciselist[i]["exercise"] == "squat jumps"){
        if(exerciselist[i]["type"] == "Reps") {
          cal = cal + exerciselist[i]["count"] * 0.71;
        }
        else{
          cal = cal + (50*(exerciselist[i]["count"]/60));
        }
        // cal = cal + ((BMR*1ra.7*exerciselist[i]["count"])/(1440));
      }
      if (exerciselist[i]["exercise"] == "high knees"){
        if(exerciselist[i]["type"] == "Reps") {
          cal = cal + exerciselist[i]["count"] * 0.16;
        }
        else{
          cal = cal + (7*(exerciselist[i]["count"]/60));
        }
        // cal = cal + ((BMR*1.7*exerciselist[i]["count"])/(1440));
      }
    }
    return cal;
  }

  int countsfromcalories(int calories, int exercisecount, int exerciseindex){
    double BMR = bmr(age, weight, height, male);
   double calgoal = calories/exercisecount;
   int count = 0;
    if (exercises[exerciseindex] == "pushups"){
      count = (calgoal/0.6).round();
      // count = ((1440*calgoal)/(BMR*2.5)).round();
    }
    if (exercises[exerciseindex] == "situps"){
      count = (calgoal/0.5).round();
      // count = ((1440*calgoal)/(BMR*2)).round();
    }
    if (exercises[exerciseindex] == "squats"){
      count = (calgoal/0.32).round();
      // count = ((1440*calgoal)/(BMR*2.5)).round();
    }
    if (exercises[exerciseindex] == "star jumps"){
      count = (calgoal).round();
      // count = ((1440*calgoal)/(BMR*3)).round();
    }
    if (exercises[exerciseindex] == "lunges"){
      count = (calgoal/0.3).round();
      // count = ((1440*calgoal)/(BMR*3)).round();
    }
    if (exercises[exerciseindex] == "High Jumps"){
      count = (calgoal/0.21).round();
      // count = ((1440*calgoal)/(BMR*1.7)).round();
    }
    if (exercises[exerciseindex] == "squat jumps"){
      count = (calgoal/0.71).round();
      // cal = cal + ((BMR*1.7*exerciselist[i]["count"])/(1440));
    }
    if (exercises[exerciseindex] == "high knees"){
      count = (calgoal/0.16).round();
      // cal = cal + ((BMR*1.7*exerciselist[i]["count"])/(1440));
    }
    return count;
  }

  int timefromcalories(int calories, int exercisecount, int exerciseindex){
    double BMR = bmr(age, weight, height, male);
    double calgoal = calories/exercisecount;
    int time = 0;
    if (exercises[exerciseindex] == "pushups"){
      time = ((calgoal*60)/7).round();
      // time = ((1440*calgoal)/(BMR*2.5)).round();
    }
    if (exercises[exerciseindex] == "situps"){
      time = ((calgoal*60)/10).round();
      // time = ((1440*calgoal)/(BMR*2)).round();
    }
    if (exercises[exerciseindex] == "squats"){
      time = ((calgoal*60)/8).round();
      // time = ((1440*calgoal)/(BMR*2.5)).round();
    }
    if (exercises[exerciseindex] == "star jumps"){
      time = ((calgoal*60)/9.8).round();
      // time = ((1440*calgoal)/(BMR*3)).round();
    }
    if (exercises[exerciseindex] == "lunges"){
      time = ((calgoal*60)/5.4).round();
      // time = ((1440*calgoal)/(BMR*3)).round();
    }
    if (exercises[exerciseindex] == "High Jumps"){
      time = ((calgoal*60)/7).round();
      // time = ((1440*calgoal)/(BMR*1.7)).round();
    }
    if (exercises[exerciseindex] == "squat jumps"){
      time = ((calgoal*60)/50).round();
      // cal = cal + ((BMR*1.7*exerciselist[i]["count"])/(1440));
    }
    if (exercises[exerciseindex] == "high knees"){
      time = ((calgoal*60)/7).round();
      // cal = cal + ((BMR*1.7*exerciselist[i]["count"])/(1440));
    }
    return time;
  }
  
  int difficultycolor(double cal){
    if (cal > 0 && cal <= 60){
      return 1;  
    }
    if (cal >= 61 && cal <= 140){
      return 2;
    }
    if (cal >= 141){
      return 3;
    }
    return 4;
  }

  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)?.settings.arguments;
    if(args != null){
      arg = args as Map<dynamic, dynamic>;
    }
    else{
      arg = {};
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> diffcolor = [Colors.blue, Colors.green, Colors.amber, Colors.grey];
    int diffcount = difficultycolor(caloriemeter(list) * setscount);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              ),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
            ),
            height: 845.h,
            width: 430.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back, size: 28.sp, color: Colors.white,)),
                    Text("Exercise Setup", style: TextStyle(color: Colors.white, fontSize: 28.sp),),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Exercise list", style: TextStyle(color: Colors.white, fontSize: 20.sp),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Text("${difficulties[diffcount-1]}", style: TextStyle(color: diffcolor[diffcount-1], fontSize: 14.sp,),),
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: SizedBox(
                              width: 100.w,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.black38,
                                color: diffcolor[diffcount-1],
                                value: diffcount > 0? diffcount/3:0,
                              ),
                            ),
                          )
                        ],
                      ),
                      IconButton(onPressed: () async {
                        final result = await Navigator.pushNamed(context, "/elist");
                        setState(() {
                          arg = result as Map<dynamic, dynamic>;
                          list.add(arg);
                        });
                      }, icon: Icon(Icons.add, color: Colors.white, size: 28.sp,))
                    ],
                  ),
                ),
              ),
              Center(
                child: list.isNotEmpty? SizedBox(
                  height: 250.h,
                  width: 387.36.w,
                  child: ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index){
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white,),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            list.removeAt(index);
                          });
                        },
                        child: Container(
                          height: 67.h,
                          width: 387.36.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 1.sp)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                  child: Center(child: Image.asset("assets/${list[index]["exercise"]}.png")),
                                width: 120.w,
                                height: 67.h,
                              ),
                              SizedBox(
                                  child: Center(child: Text(list[index]["exercise"][0].toUpperCase() + list[index]["exercise"].substring(1).toLowerCase(), style: TextStyle(fontSize: 20.sp),)),
                                width: 120.w,
                                height: 67.h,
                              ),
                              SizedBox(
                                  child: Center(child: Text("${list[index]["count"]} ${list[index]["type"]}", style: TextStyle(fontSize: 16.sp),)),
                                width: 120.w,
                                height: 67.h,
                              )
                            ],
                          ),
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 20.h,);
                  },
                  ),
                ):SizedBox(
                  height: 250.h,
                    width: 387.36.w,
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel_outlined, size: 64.sp, color: Colors.white,),
                            Row(
                              children: [
                                Text("Press the", style: TextStyle(color: Colors.white, fontSize: 22.sp),),
                                SizedBox(width: 2.5.w,),
                                Icon(Icons.add, size: 20.sp, color: Colors.white,),
                                SizedBox(width: 2.5.w,),
                                Text("Icon to add an exercise", style: TextStyle(color: Colors.white, fontSize: 22.sp),),
                              ],
                            )
                          ],
                        )
                    )
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("How many sets?", style: TextStyle(color: Colors.white, fontSize: 20.sp,), textAlign: TextAlign.start,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 28.h,
                                  height: 28.h,
                                  child: FloatingActionButton(onPressed: () {
                                    if(setscount>1){
                                      setState(() {
                                        setscount -= 1;
                                      });
                                    }
                                  }, child: Icon(Icons.remove, color: Colors.white,), heroTag: null,)
                              ),
                              SizedBox(width: 15.w,),
                              Container(
                                width: 50.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: Colors.black
                                  )
                                ),
                                child: Center(child: Text("${setscount}"))
                              ),
                              SizedBox(width: 15.w,),
                              SizedBox(
                                  width: 28.h,
                                  height: 28.h,
                                  child: FloatingActionButton(onPressed: () {
                                    setState(() {
                                      setscount += 1;
                                      print("$setscount");
                                    });
                                  }, child: Icon(Icons.add, color: Colors.white,),heroTag: null,)
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                              child: Text("Resting Period after each exercise", style: TextStyle(color: Colors.white, fontSize: 20.sp),)
                          ),
                          SizedBox(height: 5.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Bounce(
                                duration: Duration(milliseconds: 50),
                                onPressed: () {
                                  setState(() {
                                    secondsrest = 5;
                                  });
                                },
                                child: Container(
                                  height: 53.h,
                                  width: 125.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: secondsrest == 5? Colors.blue: Colors.white,
                                      border: Border.all(color: Colors.black)
                                  ),
                                  child: Center(child: Text("5 secs", style: TextStyle(fontSize: 16.sp, color: secondsrest == 5? Colors.white: Colors.black),)),
                                ),
                              ),
                              SizedBox(width: 7.5.w,),
                              Bounce(
                                duration: Duration(milliseconds: 50),
                                onPressed: () {
                                  setState(() {
                                    secondsrest = 30;
                                  });
                                },
                                child: Container(
                                  height: 53.h,
                                  width: 125.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: secondsrest == 30? Colors.blue: Colors.white,
                                      border: Border.all(color: Colors.black)
                                  ),
                                  child: Center(child: Text("30 secs", style: TextStyle(fontSize: 16.sp, color: secondsrest == 30? Colors.white: Colors.black),)),
                                ),
                              ),
                              SizedBox(width: 7.5.w,),
                              Bounce(
                                duration: Duration(milliseconds: 50),
                                onPressed: () {
                                  setState(() {
                                    secondsrest = 60;
                                  });
                                },
                                child: Container(
                                  height: 53.h,
                                  width: 125.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: secondsrest == 60? Colors.blue: Colors.white,
                                      border: Border.all(color: Colors.black)
                                  ),
                                  child: Center(child: Text("60 secs", style: TextStyle(fontSize: 16.sp, color: secondsrest == 60? Colors.white: Colors.black),)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("audio cues", style: TextStyle(color: Colors.white, fontSize: 20.sp),),
                          Row(
                            children: [
                              Text(audio? "On":"Off", style: TextStyle(color: Colors.white, fontSize: 14.sp),),
                              Switch(
                                value: audio,
                                onChanged: (val){setState(() {
                                  audio = !audio;
                                });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("music", style: TextStyle(color: Colors.white, fontSize: 20.sp),),
                          Row(
                            children: [
                              Text(music? "On":"Off", style: TextStyle(color: Colors.white, fontSize: 14.sp),),
                              Switch(
                                value: music,
                                onChanged: (val){setState(() {
                                  music = !music;
                                });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Container(
                      width: 430.w,
                      height: 1.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Estimated Time", style: TextStyle(color: Colors.white, fontSize: 20.sp),),
                              Text("${(timetaken(list) * setscount).toStringAsFixed(2)} mins", style: TextStyle(color: Colors.white, fontSize: 28.sp),),
                              Text("Estimated Calorie burns", style: TextStyle(color: Colors.white, fontSize: 20.sp),),
                              Text("${(caloriemeter(list) * setscount).toStringAsFixed(2)} Kcal", style: TextStyle(color: Colors.white, fontSize: 28.sp),)
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Bounce(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter ss) {
                                return SizedBox(
                                  height: 336.h,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Difficulty", style: TextStyle(fontSize: 20.sp),),
                                        SizedBox(height: 10.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Bounce(
                                              duration: Duration(milliseconds: 50),
                                              onPressed: () {
                                                ss(() {
                                                  difficulty = 1;
                                                });
                                              },
                                              child: Container(
                                                height: 53.h,
                                                width: 125.w,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: difficulty == 1? diffcolor[difficulty - 1]: Colors.white,
                                                    border: Border.all(color: Colors.black)
                                                ),
                                                child: Center(child: Text("Easy", style: TextStyle(fontSize: 16.sp, color: difficulty == 1? Colors.white: Colors.black),)),
                                              ),
                                            ),
                                            SizedBox(width: 7.5.w,),
                                            Bounce(
                                              duration: Duration(milliseconds: 50),
                                              onPressed: () {
                                                ss(() {
                                                  difficulty = 2;
                                                });
                                              },
                                              child: Container(
                                                height: 53.h,
                                                width: 125.w,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: difficulty == 2? diffcolor[difficulty - 1]: Colors.white,
                                                    border: Border.all(color: Colors.black)
                                                ),
                                                child: Center(child: Text("Medium", style: TextStyle(fontSize: 16.sp, color: difficulty == 2? Colors.white: Colors.black),)),
                                              ),
                                            ),
                                            SizedBox(width: 7.5.w,),
                                            Bounce(
                                              duration: Duration(milliseconds: 50),
                                              onPressed: () {
                                                ss(() {
                                                  difficulty = 3;
                                                });
                                              },
                                              child: Container(
                                                height: 53.h,
                                                width: 125.w,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: difficulty == 3? diffcolor[difficulty - 1]: Colors.white,
                                                    border: Border.all(color: Colors.black)
                                                ),
                                                child: Center(child: Text("Hard", style: TextStyle(fontSize: 16.sp, color: difficulty == 3? Colors.white: Colors.black),)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h,),
                                        // Row(
                                        //   crossAxisAlignment: CrossAxisAlignment.center,
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text(timeorcal, style: TextStyle(fontSize: 20.sp),),
                                        //     Row(
                                        //       crossAxisAlignment: CrossAxisAlignment.center,
                                        //       mainAxisAlignment: MainAxisAlignment.end,
                                        //       children: [
                                        //         Text(!time? "Switch to calories":"Switch to time", style: TextStyle(fontSize: 12.sp),),
                                        //         Switch(
                                        //           value: time,
                                        //           onChanged: (isOn) {
                                        //             ss(() {
                                        //               time = !time;
                                        //               print(time);
                                        //               if(time == false){
                                        //                 timeorcal = "Total time needed";
                                        //               }
                                        //               else{
                                        //                 timeorcal = "Calories to burn";
                                        //               }
                                        //             });
                                        //           },
                                        //         )
                                        //       ],
                                        //     )
                                        //   ],
                                        // ),
                                        // SizedBox(height: 9.h,),
                                        // SingleChildScrollView(
                                        //   scrollDirection: Axis.horizontal,
                                        //   child: !time? Row(
                                        //     mainAxisAlignment: MainAxisAlignment.center,
                                        //     children: [
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("1 mins", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //       SizedBox(width: 7.5.w,),
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("5 mins", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //       SizedBox(width: 7.5.w,),
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("10 mins", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //       SizedBox(width: 7.5.w,),
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("30 mins", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //       SizedBox(width: 7.5.w,),
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("60 mins", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //     ],
                                        //   ):Row(
                                        //     mainAxisAlignment: MainAxisAlignment.center,
                                        //     children: [
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("100Kcal", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //       SizedBox(width: 7.5.w,),
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("200Kcal", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //       SizedBox(width: 7.5.w,),
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("500Kcal", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //       SizedBox(width: 7.5.w,),
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("1000Kcal", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //       SizedBox(width: 7.5.w,),
                                        //       Container(
                                        //         height: 53.h,
                                        //         width: 125.w,
                                        //         decoration: BoxDecoration(
                                        //             borderRadius: BorderRadius.all(Radius.circular(10)),
                                        //             color: Colors.white,
                                        //             border: Border.all(color: Colors.black)
                                        //         ),
                                        //         child: Center(child: Text("2000Kcal", style: TextStyle(fontSize: 16.sp),)),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // SizedBox(height: 20.h,),
                                        Text("Set exercise quantity by", style: TextStyle(fontSize: 20.sp),),
                                        SizedBox(height: 10.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Bounce(
                                              duration: Duration(milliseconds: 50),
                                              onPressed: () {
                                                ss(() {
                                                  qtype = 1;
                                                });
                                              },
                                              child: Container(
                                                height: 53.h,
                                                width: 125.w,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: qtype == 1? diffcolor[qtype - 1]:Colors.white,
                                                    border: Border.all(color: Colors.black)
                                                ),
                                                child: Center(child: Text("Reps", style: TextStyle(fontSize: 16.sp, color: qtype == 1? Colors.white: Colors.black),)),
                                              ),
                                            ),
                                            SizedBox(width: 7.5.w,),
                                            Bounce(
                                              duration: Duration(milliseconds: 50),
                                              onPressed: () {
                                                ss(() {
                                                  qtype = 2;
                                                });
                                              },
                                              child: Container(
                                                height: 53.h,
                                                width: 125.w,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: qtype == 2? diffcolor[qtype - 1]:Colors.white,
                                                    border: Border.all(color: Colors.black)
                                                ),
                                                child: Center(child: Text("Seconds", style: TextStyle(fontSize: 16.sp, color: qtype == 2? Colors.white: Colors.black),)),
                                              ),
                                            ),
                                            SizedBox(width: 7.5.w,),
                                            Bounce(
                                              duration: Duration(milliseconds: 50),
                                              onPressed: () {
                                                ss(() {
                                                  qtype = 3;
                                                });
                                              },
                                              child: Container(
                                                height: 53.h,
                                                width: 125.w,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: qtype == 3? diffcolor[qtype - 1]:Colors.white,
                                                    border: Border.all(color: Colors.black)
                                                ),
                                                child: Center(child: Text("Random", style: TextStyle(fontSize: 16.sp, color: qtype == 3? Colors.white: Colors.black),)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 40.h,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 53.h,
                                                width: 170.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                                ),
                                                child: Bounce(
                                                  duration: Duration(milliseconds: 50),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Center(
                                                    child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                                                  ),
                                                ),
                                              ),
                                              Bounce(
                                                duration: Duration(milliseconds: 50),
                                                onPressed: () {
                                                  int caloriecount = 0;
                                                  int exercisecount = 1 + Random().nextInt(10-1);
                                                  int minorrepcount = 0;
                                                  switch(difficulty) {
                                                    case 1:
                                                      caloriecount = 1 + Random().nextInt(30-1);
                                                      break;
                                                    case 2:
                                                      caloriecount = 31 + Random().nextInt(70-31);
                                                      break;
                                                    case 3:
                                                      caloriecount = 71 + Random().nextInt(150-71);
                                                      break;
                                                  }
                                                  list = [];
                                                  for(int i = 0; i < exercisecount; i++){
                                                    int index = Random().nextInt(exercises.length);
                                                    switch(qtype){
                                                      case 1:
                                                        minorrepcount = 1;
                                                        break;
                                                      case 2:
                                                        minorrepcount = 2;
                                                        break;
                                                      case 3:
                                                        minorrepcount = 1 + Random().nextInt(2-1);
                                                    }
                                                    setState(() {
                                                      if((minorrepcount == 1 && countsfromcalories(caloriecount, exercisecount, index)>0) || (minorrepcount == 2 && timefromcalories(caloriecount, exercisecount, index)>3)) {
                                                        list.add(
                                                          {
                                                            "exercise": exercises[index],
                                                            "count": minorrepcount == 1? countsfromcalories(caloriecount, exercisecount, index):timefromcalories(caloriecount, exercisecount, index),
                                                            "type": minorrepcount == 1? "Reps":"Secs",
                                                          }
                                                      );
                                                      }
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 53.h,
                                                  width: 170.w,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [Color(0xFF00FF0C), Colors.green]
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                                  ),
                                                  child: Center(
                                                    child: Text("Randomize", style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                      );
                    },
                    duration: Duration(milliseconds: 50),
                    child: Container(
                      height: 53.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Center(
                        child: Text("Randomise", style: TextStyle(fontSize: 16.sp)),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w,),
                  Bounce(
                    onPressed: () {
                      if(list.isNotEmpty){
                       Navigator.pushReplacementNamed(context, "/oyocamera", arguments: {
                         "elist": list,
                         "xp": timetaken(list) * setscount,
                         "sets": setscount,
                         "time": secondsrest,
                         "music": music,
                         "audio cue": audio
                       });
                      }
                    },
                    duration: Duration(milliseconds: 50),
                    child: list.isNotEmpty? Container(
                      height: 53.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF00FF0C), Colors.green]
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Center(
                        child: Text("Ready", style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                      ),
                    ):Container(
                      height: 53.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF899A8A), Color(0xFF545454)]
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Center(
                        child: Text("Ready", style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
