import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth.dart';
import 'providers/orders.dart';

import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_details_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/taken_orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (_) => Orders(),
          update: (ctx, auth, orders) => orders
            ..setToken(auth.token)
            ..setUserId(auth.id),
        ),
      ],
      child: MaterialApp(
        title: 'Sallaty Delivery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // canvasColor: Color(0xFF828282),
          // buttonColor: Color(0xFF333333),
          primaryColor: Color(0xFF6fb9b8),
          accentColor: Color(0xFFd4f5ee),
          primaryColorBrightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
          fontFamily: 'Gilroy',
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Color(0xFFd4f5ee),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Color(0xFFd4f5ee),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                Color(0xFFd4f5ee),
              ),
            ),
          ),
        ),

        home: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => FutureBuilder(
            future: auth.isAuth(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? SplashScreen()
                    : snapshot.data == true
                        ? HomeScreen()
                        : AuthScreen(),
          ),
        ),
        //  AuthScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          OrderDetailsScreen.routeName: (ctx) => OrderDetailsScreen(),
          TakenOrdersScreen.routeName: (ctx) => TakenOrdersScreen(),
        },
      ),
    );
  }
}
