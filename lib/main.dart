import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/all_status_provider.dart';
import './screens/add_status.dart';
import './screens/home_screen.dart';
import './screens/my_status_screen.dart';
import './screens/all_status_screen.dart';
import './screens/splash_screen.dart';
import './provider/auth_provider.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, StatusProvider>(
          create: (btx) => StatusProvider([], "", "", ""),
          update: (btx, auth, oldStatus) => StatusProvider(
              oldStatus.statusList, auth.token, auth.userId, auth.emailName),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (btx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.yellow,
          ),
          home: auth.isAuth
              // ? AllStatusScreen()
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (btx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            AllStatusScreen.routeName: (_) => AllStatusScreen(),
            MyStatusScreen.routeName: (_) => MyStatusScreen(),
            AddStatusScree.routeName: (_) => AddStatusScree(),
          },
        ),
      ),
    );
  }
}
