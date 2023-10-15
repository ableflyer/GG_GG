import 'dart:async';
import 'dart:math';

import 'package:body_detection/models/image_result.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:flutter/material.dart';
import 'package:body_detection/body_detection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundpool/soundpool.dart';

class oyoCamera extends StatefulWidget {
  const oyoCamera({Key? key}) : super(key: key);

  @override
  _oyoCameraState createState() => _oyoCameraState();
}

class _oyoCameraState extends State<oyoCamera> {
  Map arg = {};
  List<String> exercises = [
    "pushups",
    "situps",
    "squats",
    "star jumps",
    "lunges",
    "High Jumps",
    "squat jumps",
    "high knees"
  ];
  int exindx = 0;
  Pose? _pose;
  bool ready = false;
  bool exfinish = false;
  bool hasActivated = false;
  bool start = true;
  Image? _cameraImage;
  int count = 0;
  int time = 5;
  int exerciseTime = 0;
  int sets = 1;
  late Timer timer;
  late Timer exerciseTimer;
  Soundpool pool = Soundpool.fromOptions();
  String position = "None";
  double? previous_pos = null;
  double timestarted = (DateTime.now().hour*60) + (DateTime.now().minute) + (DateTime.now().second/60);

  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)?.settings.arguments;
    if(args != null){
      arg = args as Map<dynamic, dynamic>;
      print("arg = $arg");
      sets = arg["sets"];
    }
    else{
      arg = {};
    }
    super.didChangeDependencies();
  }

  Text finishedexercise(bool end){
    if(!end){
      return Text(
        arg["elist"][exindx]["type"] == "Reps"? "Do ${arg["elist"][exindx]["count"]} ${arg["elist"][exindx]["exercise"]}":"Do ${arg["elist"][exindx]["exercise"]} for ${arg["elist"][exindx]["count"]} seconds",
        style: TextStyle(fontStyle: FontStyle.italic, fontSize: arg["elist"][exindx]["type"] == "Reps"? 36.sp:24.sp, color: Colors.white),
      );
    }
    return Text(
      "Finish",
      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 36.sp, color: Colors.green),
    );
  }

  bool areLandmarksWithinBounds(Pose pose, double frameWidth, double frameHeight) {
    for (PoseLandmark landmark in pose.landmarks) {
      if (landmark.position.x < 0 ||
          landmark.position.x > frameWidth ||
          landmark.position.y < 0 ||
          landmark.position.y > frameHeight) {
        return false; // Landmark is outside the camera frame bounds
      }
    }
    return true; // All landmarks are within the camera frame bounds
  }

  void isStandingUp(Pose pose) {
    // Define the indices of landmarks to track for standing up
    int leftHipIndex = 23;  // Example landmark index for the left hip
    int rightHipIndex = 24; // Example landmark index for the right hip
    int leftShoulderIndex = 11;
    int rightShoulderIndex = 12;
    double standingUpThreshold = 100.0; // Threshold for standing up position

    // Get the y-coordinates of the left and right hips
    double leftHipY = pose.landmarks[leftHipIndex].position.y;
    double rightHipY = pose.landmarks[rightHipIndex].position.y;
    double leftShoulderY = pose.landmarks[leftShoulderIndex].position.y;
    double rightShoulderY = pose.landmarks[rightShoulderIndex].position.y;

    bool standing = ((leftHipY - leftShoulderY).abs() >= standingUpThreshold) && ((rightHipY - rightShoulderY).abs() >= standingUpThreshold);
    if(arg.isNotEmpty){
      if(standing && (arg["elist"][exindx]["exercise"].toString() == "squats" || arg["elist"][exindx]["exercise"].toString() == "star jumps" || arg["elist"][exindx]["exercise"].toString() == "lunges" || arg["elist"][exindx]["exercise"].toString() == "High Jumps" || arg["elist"][exindx]["exercise"].toString() == "squat jumps" || arg["elist"][exindx]["exercise"].toString() == "high knees")){
        if(!ready){
          setState(() {
            ready = true;
            timercount();
            exerciseTime = -time;
            exerciseCounter();
          });
        }
      }
      if (!standing && (arg["elist"][exindx]["exercise"].toString() == "pushups" || arg["elist"][exindx]["exercise"].toString() == "situps")){
        if(!ready){
          setState(() {
            ready = true;
            timercount();
            exerciseTime = -time;
            exerciseCounter();
          });
        }
      }
    }
  }
  
  void timercount() {
    if(ready) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          time -= 1;
        });
      });
      if(time < 1){
        timer.cancel();
      }
    }
  }
  void exerciseCounter() {
    exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        exerciseTime += 1;
      });
    });
    if(exerciseTime >= arg["elist"][exindx]["count"]){
      exerciseTimer.cancel();
    }
  }

  void ting(bool canDoIt) async{
    if(canDoIt) {
      int? soundID = await rootBundle.load("assets/ting.mp3").then((value){
        return pool.load(value);
      });
      pool.play(soundID!);
      // final player = AudioPlayer();
      // player.setAsset('assets/ting.mp3');
      // player.play();
    }
  }

  void ding(bool canDoIt) async{
    if(canDoIt) {
      int? soundID = await rootBundle.load("assets/ding.mp3").then((value){
        return pool.load(value);
      });
      pool.play(soundID!);
      // final player = AudioPlayer();
      // player.setAsset('assets/ding.mp3');
      // player.play();
    }
  }
  void complete(bool canDoIt) async{
    if(canDoIt) {
      int? soundID = await rootBundle.load("assets/complete.mp3").then((value){
        return pool.load(value);
      });
      pool.play(soundID!);
      // final player = AudioPlayer();
      // player.setAsset('assets/ding.mp3');
      // player.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _startDetection();
  }

  @override
  void dispose() {
    super.dispose();
    _stopDetection();
    timer.cancel();
    exerciseTimer.cancel();
  }

  Future<void> _startDetection() async {
    await BodyDetection.enablePoseDetection();
    await BodyDetection.startCameraStream(
      onPoseAvailable: (Pose? pose) async{
        setState(() {
          _pose = pose;
          isStandingUp(_pose!);
          if (arg.isNotEmpty && areLandmarksWithinBounds(_pose!, 430.w, 932.h) && ready && (time < 1)){
          if (arg["elist"][exindx]["exercise"] == "pushups") {
            if (((_pose!.landmarks[12].position.y) -
                        (_pose!.landmarks[14].position.y)) >=
                    7 &&
                ((_pose!.landmarks[11].position.y) -
                        (_pose!.landmarks[13].position.y)) >=
                    7 && position != "down") {
              position = "down";
              ting(arg["audio cue"]);
            }
            if (((_pose!.landmarks[12].position.y) -
                        (_pose!.landmarks[14].position.y)) <=
                    5 &&
                ((_pose!.landmarks[11].position.y) -
                        (_pose!.landmarks[13].position.y)) <=
                    5 &&
                position == "down") {
              position = "up";
              count += 1;
              ding(arg["audio cue"]);
            }
          } else if (arg["elist"][exindx]["exercise"] == "squats") {
            if ((_pose!.landmarks[23].position.y -
                            _pose!.landmarks[27].position.y)
                        .abs() <
                    80 &&
                (_pose!.landmarks[24].position.y -
                            _pose!.landmarks[28].position.y)
                        .abs() <
                    80 && position != "down") {
              position = "down";
              ting(arg["audio cue"]);
            }
            if ((_pose!.landmarks[23].position.y -
                            _pose!.landmarks[27].position.y)
                        .abs() >=
                    100 &&
                (_pose!.landmarks[24].position.y -
                            _pose!.landmarks[28].position.y)
                        .abs() >=
                    100 &&
                position == "down") {
              position = "up";
              count += 1;
              ding(arg["audio cue"]);
            }
          } else if (arg["elist"][exindx]["exercise"] == "situps") {
            if ((_pose!.landmarks[11].position.y -
                            _pose!.landmarks[23].position.y)
                        .abs() >=
                    (_pose!.landmarks[11].position.y -
                            _pose!.landmarks[25].position.y)
                        .abs() &&
                (_pose!.landmarks[12].position.y -
                            _pose!.landmarks[24].position.y)
                        .abs() >=
                    (_pose!.landmarks[12].position.y -
                            _pose!.landmarks[26].position.y)
                        .abs() && position != "down") {
              position = "down";
              ting(arg["audio cue"]);
            }
            if (((_pose!.landmarks[11].position.y -
                                _pose!.landmarks[23].position.y)
                            .abs() <
                        (_pose!.landmarks[11].position.y -
                                _pose!.landmarks[25].position.y)
                            .abs() &&
                    (_pose!.landmarks[12].position.y -
                                _pose!.landmarks[24].position.y)
                            .abs() <
                        (_pose!.landmarks[12].position.y -
                                _pose!.landmarks[26].position.y)
                            .abs()) &&
                position == "down") {
              position = "up";
              count += 1;
              ding(arg["audio cue"]);
            }
          } else if (arg["elist"][exindx]["exercise"] == "star jumps") {
            if ((_pose!.landmarks[16].position.y -
                        _pose!.landmarks[12].position.y) <=
                    -40 &&
                (_pose!.landmarks[15].position.y -
                        _pose!.landmarks[11].position.y) <=
                    -40 &&
                (_pose!.landmarks[28].position.x -
                            _pose!.landmarks[27].position.x)
                        .abs() >=
                    100 && position != "1") {
              position = "1";
              ting(arg["audio cue"]);
            }
            if ((_pose!.landmarks[16].position.y -
                        _pose!.landmarks[12].position.y) >=
                    90 &&
                (_pose!.landmarks[15].position.y -
                        _pose!.landmarks[11].position.y) >=
                    90 &&
                (_pose!.landmarks[28].position.x -
                            _pose!.landmarks[27].position.x)
                        .abs() <
                    50 &&
                position == "1") {
              position = "2";
              count += 1;
              ding(arg["audio cue"]);
            }
          }
          else if (arg["elist"][exindx]["exercise"] == "lunges"){
            if((((_pose!.landmarks[26].position.y - _pose!.landmarks[24].position.y >= _pose!.landmarks[28].position.y - _pose!.landmarks[24].position.y) && (_pose!.landmarks[25].position.y - _pose!.landmarks[23].position.y <= 50) && (_pose!.landmarks[27].position.y - _pose!.landmarks[23].position.y <= 110)) || ((_pose!.landmarks[25].position.y - _pose!.landmarks[23].position.y >= _pose!.landmarks[27].position.y - _pose!.landmarks[23].position.y) && (_pose!.landmarks[26].position.y - _pose!.landmarks[24].position.y <= 50) && (_pose!.landmarks[28].position.y - _pose!.landmarks[24].position.y <= 110))) && position != "down"){
              position = "down";
              ting(arg["audio cue"]);
            }
            if((((_pose!.landmarks[26].position.y - _pose!.landmarks[24].position.y < _pose!.landmarks[28].position.y - _pose!.landmarks[24].position.y) && (_pose!.landmarks[25].position.y - _pose!.landmarks[23].position.y > 70) && (_pose!.landmarks[27].position.y - _pose!.landmarks[23].position.y > 150)) || ((_pose!.landmarks[25].position.y - _pose!.landmarks[23].position.y >= _pose!.landmarks[27].position.y - _pose!.landmarks[23].position.y) && (_pose!.landmarks[26].position.y - _pose!.landmarks[24].position.y > 70) && (_pose!.landmarks[28].position.y - _pose!.landmarks[24].position.y > 150))) && position == "down"){
              position = "up";
              count += 1;
              ding(arg["audio cue"]);
            }
          }
          else if (arg["elist"][exindx]["exercise"] == "High Jumps"){
            double current_pos = _pose!.landmarks[25].position.y;
            previous_pos ??= current_pos;
            if ((current_pos > previous_pos! + 5) && position != "up"){
              count += 1;
              position = "up";
            }
            else if (current_pos < previous_pos! + 1 && position == "up"){
              position = "down";
              previous_pos = current_pos - 1;
            }
          }
          else if (arg["elist"][exindx]["exercise"] == "squat jumps"){
            previous_pos ??= _pose!.landmarks[25].position.y;
            if((_pose!.landmarks[23].position.y - _pose!.landmarks[27].position.y).abs() < 80 && (_pose!.landmarks[24].position.y - _pose!.landmarks[28].position.y).abs() < 80 && position != "squat"){
              position = "squat";
              ting(arg["audio cue"]);
            }
            if ((_pose!.landmarks[23].position.y -
                _pose!.landmarks[27].position.y)
                .abs() >=
                100 &&
                (_pose!.landmarks[24].position.y -
                    _pose!.landmarks[28].position.y)
                    .abs() >=
                    100 &&
                position == "squat"){
              position = "stand";
            }
            if((_pose!.landmarks[25].position.y - previous_pos!).abs() > 60 && position == "stand") {
              count += 1;
              ding(arg["audio cue"]);
              position = "up";
            }
          }
          else if(arg["elist"][exindx]["exercise"] == "high knees"){
            if ((_pose!.landmarks[24].position.y - _pose!.landmarks[26].position.y).abs() < 30 && position != "L"){
              count += 1;
              ding(arg["audio cue"]);
              position = "L";
            }
            if ((_pose!.landmarks[23].position.y - _pose!.landmarks[25].position.y).abs() < 30 && position != "R"){
              count += 1;
              ding(arg["audio cue"]);
              position = "R";
            }
          }
          if(arg["elist"][exindx]["type"] == "Reps" && arg["elist"][exindx]["count"] <= count){
            if(exindx < arg["elist"].length-1) {
              setState(() {
                exindx += 1;
                count = 0;
                exerciseTime = 0;
                ready = false;
                time = arg["time"];
              });
              timer.cancel();
            }
            else if(exindx >= arg["elist"].length-1 && sets > 1){
              complete(arg["audio cue"]);
              setState(() {
                exindx = 0;
                count = 0;
                exerciseTime = 0;
                ready = false;
                time = 60;
                sets -= 1;
              });
              timer.cancel();
            }
            else{
              if(!hasActivated) {
                exfinish = true;
                final player = AudioPlayer();
                player.setAsset('assets/whistle.mp3');
                player.play();
                timer = Timer.periodic(Duration(seconds: 3), (timer) {
                  player.dispose();
                  Navigator.pushReplacementNamed(
                      context, "/finish", arguments: {
                    "time": ((DateTime
                        .now()
                        .hour * 60) + (DateTime
                        .now()
                        .minute) + (DateTime
                        .now()
                        .second / 60)) - timestarted,
                    "xp": arg["xp"],
                    "list": arg["elist"]
                  });
                });
                hasActivated = true;
              }
            }
          }
          else if(arg["elist"][exindx]["type"] == "Secs" && arg["elist"][exindx]["count"] <= exerciseTime){
            if(exindx < arg["elist"].length-1) {
              setState(() {
                exindx += 1;
                count = 0;
                exerciseTime = 0;
                ready = false;
                time = arg["time"];
              });
              timer.cancel();
            }
            else if(exindx >= arg["elist"].length-1 && sets > 1){
              complete(arg["audio cue"]);
              setState(() {
                exindx = 0;
                count = 0;
                exerciseTime = 0;
                ready = false;
                time = 60;
                sets -= 1;
              });
              timer.cancel();
            }
            else{
              if(!hasActivated) {
                exfinish = true;
                final player = AudioPlayer();
                player.setAsset('assets/whistle.mp3');
                player.play();
                timer = Timer.periodic(Duration(seconds: 3), (timer) {
                  player.dispose();
                  Navigator.pushReplacementNamed(
                      context, "/finish", arguments: {
                    "time": ((DateTime
                        .now()
                        .hour * 60) + (DateTime
                        .now()
                        .minute) + (DateTime
                        .now()
                        .second / 60)) - timestarted,
                    "xp": arg["xp"],
                    "list": arg["elist"]
                  });
                });
                hasActivated = true;
              }
            }
            exerciseTimer.cancel();
          }
          }
        });
      },
      onFrameAvailable: (ImageResult image) {
        if (!mounted) return;
        // To avoid a memory leak issue.
        // https://github.com/flutter/flutter/issues/60160
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();

        final img = Image.memory(
          image.bytes,
          gaplessPlayback: true,
          fit: BoxFit.cover,
          width: 430.w,
          height: 932.h,
        );
        setState(() {
          _cameraImage = img;
        });
      },
    );
  }

  Widget TimeRepScaffold(bool rep){
    if(rep == true){
      return Center(
        child: Stack(
          children: [
            if (_cameraImage != null)
              Container(
                width: 430.w,
                height: 932.h,
                child: _cameraImage,
              ),
            // if (_pose != null) Center(child: Text('Count: $count', style: TextStyle(color: Colors.white),)),
            areLandmarksWithinBounds(_pose!, 430.w, 932.h)? ready? time < 1? Center(
              child: Text(
                "$count",
                style: TextStyle(color: Colors.green, fontSize: 128.sp, fontStyle: FontStyle.italic),
              ),
            ):Container(
              color: Colors.black.withOpacity(0.4),
              height: 932.h,
              width: 430.w,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time.toString().length < 2? "0""${time}":"${time}",
                      style: TextStyle(color: Colors.white, fontSize: 128.sp, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      time <= 5? "Get ready":"Rest",
                      style: TextStyle(color: Colors.white, fontSize: 64.sp, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ):Center(
              child: Container(
                width: 360.w,
                height: 106.h,
                child: Center(child: Text(
                  ["squats", "star jumps", "lunges", "High Jumps", "squat jumps", "high knees"].contains(arg["elist"][exindx]["exercise"].toString())? "Please stand up for the next exercise" : "Lay down for the next exercise",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontStyle: FontStyle.italic
                  ),
                ),),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              ),
            ):Center(
              child: Container(
                width: 360.w,
                height: 106.h,
                child: Center(child: Text(
                  "fit your body in the camera to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontStyle: FontStyle.italic
                  ),
                ),),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 360.w,
                  height: 106.h,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                  ),
                  child: Center(
                      child: finishedexercise(exfinish)
                  ),
                )
            ),
          ],
        ),
      );
    }
    return Center(
      child: Stack(
        children: [
          if (_cameraImage != null)
            Container(
              width: 430.w,
              height: 932.h,
              child: _cameraImage,
            ),
          // if (_pose != null) Center(child: Text('Count: $count', style: TextStyle(color: Colors.white),)),
          areLandmarksWithinBounds(_pose!, 430.w, 932.h)? ready? time < 1? Center(
            child: Text(
              "$exerciseTime",
              style: TextStyle(color: Colors.green, fontSize: 128.sp, fontStyle: FontStyle.italic),
            ),
          ):Container(
            color: Colors.black.withOpacity(0.4),
            height: 932.h,
            width: 430.w,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    time.toString().length < 2? "0""${time}":"${time}",
                    style: TextStyle(color: Colors.white, fontSize: 128.sp, fontStyle: FontStyle.italic),
                  ),
                  Text(
                    time <= 5? "Get ready":"Rest",
                    style: TextStyle(color: Colors.white, fontSize: 64.sp, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ):Center(
            child: Container(
              width: 360.w,
              height: 106.h,
              child: Center(child: Text(
                ["squats", "star jumps", "lunges", "High Jumps", "squat jumps", "high knees"].contains(arg["elist"][exindx]["exercise"].toString())? "Please stand up for the next exercise" : "Lay down for the next exercise",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontStyle: FontStyle.italic
                ),
              ),),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ),
          ):Center(
            child: Container(
              width: 360.w,
              height: 106.h,
              child: Center(child: Text(
                "fit your body in the camera to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontStyle: FontStyle.italic
                ),
              ),),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 360.w,
                height: 106.h,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                ),
                child: Center(
                    child: Column(
                      children: [
                        Text(
                        "${count}",
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 36.sp, color: Colors.white),
                        ),
                        finishedexercise(exfinish),
                      ],
                    )
                ),
              )
          ),
        ],
      ),
    );
  }

  Future<void> _stopDetection() async {
    await BodyDetection.stopCameraStream();
    await BodyDetection.disablePoseDetection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Stack(
          children: [
            Container(
              height: 30.h,
              width: 500.w,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            Container(
              height: 30.h,
              width: ((exindx/arg["elist"].length)*500).w,
              decoration: BoxDecoration(
                color: Colors.orange,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.pause,
            color: Colors.white,
            size: 50.sp,
          ),
          onPressed: () async{
            Navigator.pop(context);
            int? soundID = await rootBundle.load("assets/click.mp3").then((value){
              return pool.load(value);
            });
            pool.play(soundID!);
          },
        ),
        backgroundColor: Colors.black.withOpacity(0.4),
      ),
      body: TimeRepScaffold(arg["elist"][exindx]["type"] == "Reps")
    );
  }
}
