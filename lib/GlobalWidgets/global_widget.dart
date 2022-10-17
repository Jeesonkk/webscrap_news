import 'dart:io';

import 'package:flutter/material.dart';

enum FixedIconSize {
  EXTRASMALL,
  SMALL,
  MEDIUM,
  SEMILARGE,
  LARGE_30,
  LARGE_35,
  LARGE_45
}

class GlobalWidget {
  Widget iconCreator(img,
      {required FixedIconSize size, dynamic color, dynamic customSize}) {
    double _size = 0.0;
    if (customSize == null) {
      switch (size) {
        case FixedIconSize.LARGE_45:
          _size = 45.0;
          break;
        case FixedIconSize.LARGE_35:
          _size = 35.0;
          break;
        case FixedIconSize.LARGE_30:
          _size = 30.0;
          break;
        case FixedIconSize.SEMILARGE:
          _size = 25.0;
          break;
        case FixedIconSize.MEDIUM:
          _size = 20.0;
          break;
        case FixedIconSize.EXTRASMALL:
          _size = 10.0;
          break;
        default:
          _size = 16.0;
      }
    } else {
      _size = customSize;
    }

    if (img is File) {
      return Image.file(
        img,
        width: _size,
        height: _size,
        color: color,
      );
    } else if (img.contains("http")) {
      return Image.network(
        img,
        width: _size,
        height: _size,
        color: color,
      );
    } else {
      return Image.asset(
        img,
        height: _size,
        width: _size,
        color: color,
      );
    }
  }
}

class TextView extends StatelessWidget {
  final String text;
  final double size, _size, textScaleFactor;
  final Color color;
  final int maxLines;
  final double lineSpacing;
  final TextOverflow overflow;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration decoration;

  TextView(
    this.text, {
    Key? key,
    this.size = 0.0,
    required this.textAlign,
    required this.color,
    this.textScaleFactor = 0.0,
    required this.fontWeight,
    required this.overflow,
    this.maxLines = 1,
    this.lineSpacing = 0,
    required this.decoration,
  })  : _size = size == null ? 12.0 : size,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign != null ? textAlign : TextAlign.start,
      textScaleFactor: textScaleFactor,
      style: TextStyle(
        letterSpacing: 1.2,
        decoration: decoration,
        height: lineSpacing,
        color: color != null ? color : Colors.white,
        textBaseline: TextBaseline.alphabetic,
        fontWeight: fontWeight != null ? fontWeight : FontWeight.bold,
        fontFamily: 'Bariol',
        fontSize: _size,
      ),
    );
  }
}
