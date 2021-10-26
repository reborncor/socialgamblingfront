


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

setOutlineBorder(borderSide, borderRadius, color){
  return
    OutlineInputBorder(
    borderSide: BorderSide(width: borderSide, color: color),
    borderRadius: BorderRadius.circular(borderRadius),
  );
}
