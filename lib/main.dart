// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roomflow/screens/booking/booking_page.dart';
import 'package:roomflow/screens/home_page.dart';
import 'package:roomflow/screens/private_login.dart';
import 'package:roomflow/screens/menu_page.dart';
import 'package:roomflow/screens/rent_space/rent_space_page.dart';
import 'package:roomflow/screens/zoom_home_page.dart';
import 'package:roomflow/services/space_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
// import 'package:roomflow/screens/login/login_page.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(ChangeNotifierProvider(
    create: (context) => SpaceServices(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var spacesServices = context.watch<SpaceServices>();
    return Web3ModalTheme(
      isDarkMode: true,
      child: MaterialApp(
        title: 'RoomFlow',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          // primaryColor: const Color(0xff374151),
          fontFamily: GoogleFonts.robotoFlex().fontFamily,
          colorSchemeSeed: const Color(0xFFFFBE79),
        ),
        // darkTheme: ThemeData(
        //   useMaterial3: true,
        //   brightness: Brightness.dark,
        //   canvasColor: const Color(0xFF374151),
        //   fontFamily: GoogleFonts.robotoFlex().fontFamily,
        //   colorSchemeSeed: const Color(0xFFFFBE79),
        // ),
        // themeMode: ThemeMode.dark,
        // home:spacesServices.isConnected?  MyHomePage() :Login(),
        home: Login(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late MenuProvider menuController;

  @override
  void initState() {
    super.initState();

    menuController = MenuProvider(
      vsync: this,
    )..addListener(
        () => setState(
          () {},
        ),
      );
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => menuController,
      child: ZoomHomePage(
        menuScreen: const MenuPage(),
        contentScreen: Layout(
          contentBuilder: (cc) {
            var menu = cc.watch<MenuProvider>();
            switch (menu.navigationItem) {
              case NavigationItem.home:
                return const HomePage();
              case NavigationItem.booking:
                return const BookingPage();
              case NavigationItem.rentSpace:
                return const RentSpace();
              case NavigationItem.bookmark:
                return const HomePage();
              default:
                return const HomePage();
            }
          },
        ),
      ),
    );
  }
}
