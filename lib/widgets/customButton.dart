import 'package:flutter/material.dart';
import 'package:myapp/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customButton (String buttonText,onPressed){
  return SizedBox(
    width: 1,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: const TextStyle(
            color: Colors.white, fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        primary: AppColors.deep_orange,
        elevation: 3,
      ),
    ),
  );
}