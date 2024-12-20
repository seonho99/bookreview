import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  AppFont(
      this.text, {
        this.size = 15,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.white,
      this.textAlign = TextAlign.left,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.notoSans(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
