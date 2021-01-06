import 'package:flutter/material.dart';

///
/// Check is mobile layout used
///
bool isMobileClient(BuildContext context) {
  return MediaQuery.of(context).size.shortestSide < 600;
}
