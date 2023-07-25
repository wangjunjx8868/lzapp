import 'dart:convert';

import 'list_data.g.dart';



class ListData<T> {
  
  List<T>? data;

  ListData();

  factory ListData.fromJson(Map<String, dynamic> json) => $ListDataFromJson<T>(json);

  Map<String, dynamic> toJson() => $ListDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
