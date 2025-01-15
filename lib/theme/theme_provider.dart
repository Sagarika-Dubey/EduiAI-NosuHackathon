import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get theme => _isDarkMode ? _darkTheme : _lightTheme;

  static final _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFFF8F9FE),
    brightness: Brightness.light,
    textTheme: GoogleFonts.poppinsTextTheme(),
    cardTheme: CardTheme(
      elevation: 8,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.black87,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.withOpacity(0.1),
      thickness: 1,
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onError: Colors.white,
    ),
  );

  static final _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFF1A1A1A),
    brightness: Brightness.dark,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardTheme(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2D2D2D),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF2D2D2D),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF2D2D2D),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.withOpacity(0.2),
      thickness: 1,
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Color(0xFF2D2D2D),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
  );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
