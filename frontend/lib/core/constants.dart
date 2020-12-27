import 'package:flutter/material.dart';

bool isLocalDebugEnabled = true;

String get api {
  if (isLocalDebugEnabled) {
    return "https://localhost:5001/";
  } else {
    throw new Exception();
  }
}

///
/// Check is mobile layout used
///
bool isMobileClient(BuildContext context) {
  return MediaQuery.of(context).size.shortestSide < 600;
}
