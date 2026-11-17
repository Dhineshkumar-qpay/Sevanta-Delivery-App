import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sevanta_delivery_partner/bloc/picked_location/location_bloc.dart';
import 'package:sevanta_delivery_partner/routes/router.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
          create: (BuildContext context) => LocationBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SEVANTA DELIVERY PARTNER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          // labelLarge: GoogleFonts.poppins(
          //   fontSize: 14,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
            elevation: 3,
            minimumSize: Size(double.maxFinite, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}
