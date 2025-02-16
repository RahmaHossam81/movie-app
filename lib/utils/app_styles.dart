import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie/utils/app_colors.dart';

class AppStyles{
  static TextStyle mediem36white = GoogleFonts.inter(
    fontSize: 36, fontWeight: FontWeight.w500, color: AppColors.white
  );

  static TextStyle bold24white = GoogleFonts.inter(
      fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white
  );

  static TextStyle bold36white = GoogleFonts.inter(
      fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.white
  );

  static TextStyle regular20white = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w400, color: AppColors.white
  );

  static TextStyle regular16white = GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.white
  );

  static TextStyle regular14white = GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.white
  );

  static TextStyle regular20gray = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w400, color: AppColors.gray
  );

  static TextStyle regular16gray = GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.gray
  );

  static TextStyle semiBold20black = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.black
  );

  static TextStyle regular20black = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w400, color: AppColors.black
  );

  static TextStyle bold20balck = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.black
  );

  static TextStyle semiBold20yallow = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.yallow
  );

  static TextStyle regular14yallow = GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.yallow
  );

  static TextStyle heavy14yallow = GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.yallow
  );

  static TextStyle regular16yallow = GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.yallow
  );

  static TextStyle bold20yallow = GoogleFonts.inter(
      fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.yallow
  );

}