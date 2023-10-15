import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_gg/CardCustomize.dart';
import 'package:gg_gg/Customize.dart';
import 'package:gg_gg/Settings.dart';
import 'package:gg_gg/UsernameCustomize.dart';
import 'package:gg_gg/addfriends.dart';
import 'package:gg_gg/beforeOyo.dart';
import 'package:gg_gg/challenges.dart';
import 'package:gg_gg/home.dart';
import 'package:gg_gg/loading.dart';
import 'package:gg_gg/matchfound.dart';
import 'package:gg_gg/matchqueue.dart';
import 'package:gg_gg/onlinegame.dart';
import 'package:gg_gg/searchresult.dart';
import 'package:gg_gg/signup.dart';
import 'package:gg_gg/testcam.dart';
import 'package:gg_gg/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gg_gg/youfinished.dart';
import 'exercise_list.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';



import 'ItemView.dart';
import 'friends.dart';
import 'login.dart';
import 'splash.dart';
import 'activate.dart';



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Permission.camera.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "futura",
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange, backgroundColor: Colors.white)
        ),
        routes: {
          "/": (context) => splash(),
          "/search": (context) => searchresult(),
          "/addfriends": (context) => addfriends(),
          "/oyocamera": (context) => oyoCamera(),
          "/friends": (context) => friends(),
          "/challenges": (context) => challenges(),
          "/home": (context) => home(),
          "/view": (context) => itemview(),
          "/activate": (context) => activate(),
          "/login": (context) => login(),
          "/signup": (context) => signup(),
          "/welcome": (context) => welcome(),
          "/beforeoyo": (context) => beforeOyo(),
          "/elist": (context) => elist(),
          "/finish": (context) => finish(),
          "/matchfound": (context) => matchfound(),
          "/queue": (context) => matchqueue(),
          "/online": (context) => OnlineGame(),
          "/loading": (context) => Loading(),
          "/customize": (context) => customize(),
          "/settings": (context) => settings(),
          "/cardcustomize": (context) => CardCustomize(),
          "/usernamecustomize": (context) => UsernameCustomize()
        },
      ),
    );
  }
}
