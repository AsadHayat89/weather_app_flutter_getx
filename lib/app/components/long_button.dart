
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/config/font_style.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    Key? key,
    this.text,
    this.width,
    this.height = 40.0,
    this.borderRadius=0.0,
    this.enable ,
    this.isLoading,
    this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.textColor,
    this.onPressed,
    this.buttonColor = false,
    this.isColorSame = false,
    this.color = Colors.white,
  }) : super(key: key);

  final double? width, height, borderRadius;
  final bool? enable, isLoading;
  final Color? backgroundColor, borderColor, textColor;
  final Function()? onPressed;
  final String? text;
  final Color? color;
  final bool? buttonColor;
  final bool? isColorSame;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    var size=MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: buttonColor!
          ? BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius!=0.0 ?BorderRadius.circular(borderRadius!): BorderRadius.circular(35),
        border: Border.all(
          color: borderColor!,
        ),
      )
          : BoxDecoration(
        color: Colors.blueAccent,
        // ? backgroundColor ?? colors.accentPrimary
        //         : isColorSame
        //             ? backgroundColor ?? colors.accentPrimary
        //             : colors.primaryDark.withOpacity(0.05),
        borderRadius: borderRadius!=0.0 ?BorderRadius.circular(borderRadius!): BorderRadius.circular(35),
        border: Border.all(color: borderColor!),
      ),
      child: ElevatedButton(
        onPressed: enable!=null ? onPressed : null,
        style: buttonColor!
            ? ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
        )
            : ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: isLoading ?? false
            ? Container(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            color: color,
          ),
        )
            : Text(
          text!,
          style: FontClass.displayMedium(Colors.white),
        ),
      ),
    );
  }
}
