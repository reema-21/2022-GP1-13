// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    Welcome({
       required this.id,
       required this.one,
       required this.two
    });

    String id;
    String one;
    String two;

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        id: json["id"],
        one: json["one"],
        two: json["two"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "one": one,
        "two":two,
    };

}
