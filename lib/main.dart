import 'package:finf_app/binding/auth_binding.dart';
import 'package:finf_app/core/binding/main_binding.dart';
import 'package:finf_app/controller/main_controller.dart';
import 'package:finf_app/core/config/env.dart';
import 'package:finf_app/core/routes/app_routes.dart';
import 'package:finf_app/screen/auth/legal/privacy_policy_page.dart';
import 'package:finf_app/screen/auth/legal/terms_of_service_page.dart';
import 'package:finf_app/screen/auth/login_page.dart';
import 'package:finf_app/screen/contents/breath_table_page.dart';
import 'package:finf_app/screen/contents/result/record_result_page.dart';
import 'package:finf_app/screen/contents/static_records_page.dart';
import 'package:finf_app/screen/contents/time_table_page.dart';
import 'package:finf_app/screen/contents/timer/contents_timer_page.dart';
import 'package:finf_app/screen/main/main_page.dart';
import 'package:finf_app/screen/record/record_list_page.dart';
import 'package:finf_app/screen/set/set_page.dart';
import 'package:finf_app/screen/splash/splash_page.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:finf_app/widget/common/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // 카카오 SDK 초기화
  KakaoSdk.init(nativeAppKey: Env.kakaoNativeAppKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialBinding: MainBinding(),
        initialRoute: AppRoutes.splash,
        builder: (context, child) {
          return AppBackground(child: child ?? const SizedBox());
        },
        routes: {
          AppRoutes.splash: (_) => const SplashPage(),
          AppRoutes.login: (_) => LoginPage(),
          AppRoutes.terms: (_) => const TermsOfServicePage(),
          AppRoutes.privacy: (_) => const PrivacyPolicyPage(),
          AppRoutes.main: (_) => GetBuilder<MainController>(
                init: MainController(),
                builder: (_) => const MainPage(),
              ),
          AppRoutes.staticRecords: (_) => const StaticRecordsPage(),
          AppRoutes.set: (_) => const SetPage(),
          AppRoutes.record: (_) => const RecordListPage(),
          AppRoutes.timetable: (_) => const TimeTablePage(),
          AppRoutes.breathtable: (_) => const BreathTablePage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
