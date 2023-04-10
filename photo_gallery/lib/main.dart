import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Home/home.dart';
import 'UI_Components/splashScreen.dart';
import 'provider/imageProvider.dart';

void main() {
  //setting toolbar and system navigation bar colors to white for ui requirements
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
  ));

  runApp(const PhotoFetch());
}

class PhotoFetch extends StatelessWidget {
  const PhotoFetch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PhotoProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Photo Gallery',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        routes: {
          MyHomePage.routeName: (context) => const MyHomePage(),
        },
      ),
    );
  }
}
