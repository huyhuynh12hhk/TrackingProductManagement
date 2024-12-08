
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app_v1/constants/domain_type.dart';

String convertPrice(double price){


  return  "${NumberFormat.currency(
    locale: 'en_Us',
    symbol: '', 
    decimalDigits: 0, // No decimal places
  ).format(price)} (VND)";
}

String toPascalCase(String text){
  final array = text.split('');
  array[0]= array[0].toUpperCase();
  return array.join('');
}

Map<String, Color> RelationshipLabelConvert(String value){
  switch (value) {
    case "follow":
      return {"Following":Colors.grey.shade900};
    // case "unfollow":
      
    case "partner":
      return {"Partner":Colors.green.shade600};
    case "customer":
      return {"Customer":Colors.blue.shade500};
    default:
      return {"Unfollowing":Colors.grey.shade600};
  }
}