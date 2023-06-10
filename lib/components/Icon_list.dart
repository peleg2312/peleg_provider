import 'package:flutter/material.dart';

//input: Color, int
//output: Widget Icon
Widget GetIcon(int x, Color? color) {
  Widget icon = Icon(
    Icons.sports_basketball,
    size: 45,
    color: color,
  );

  switch (x) {
    case 0:
      break;
    case 1:
      return Icon(
        Icons.sports_baseball,
        size: 45,
        color: color,
      );
    case 2:
      return Icon(
        Icons.sports_volleyball,
        size: 45,
        color: color,
      );
    case 3:
      return Icon(
        Icons.sports_football,
        size: 45,
        color: color,
      );
    case 4:
      return Icon(
        Icons.sports_soccer,
        size: 45,
        color: color,
      );
    case 5:
      Icon(
        Icons.sports_hockey,
        size: 45,
        color: color,
      );
  }

  return icon;
}

Map<int, Widget> IconsList = {
  0: Icon(
    Icons.sports_basketball,
    size: 45,
  ),
  1: Icon(
    Icons.sports_baseball,
    size: 45,
  ),
  2: Icon(
    Icons.sports_volleyball,
    size: 45,
  ),
  3: Icon(
    Icons.sports_football,
    size: 45,
  ),
  4: Icon(
    Icons.sports_soccer,
    size: 45,
  ),
  5: Icon(
    Icons.sports_hockey,
    size: 45,
  ),
};
