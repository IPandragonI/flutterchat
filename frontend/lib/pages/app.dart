import 'package:flutter/material.dart';
import 'package:flutterchat/pages/auth/login.dart';
import 'package:flutterchat/pages/auth/waiting.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'auth/authHome.dart';
import 'home/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Auth(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'DECAChat',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.blue
          ),
          home: auth.isAuth
              ? Home()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Waiting()
                          : AuthHome(),
                ),
        ),
      ),
    );
  }
}
