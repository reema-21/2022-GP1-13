// ignore: duplicate_ignore
// ignore_for_file: deprecated_member_use, unused_local_variable, unused_catch_clause, unused_catch_clause, unused_catch_clause

import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'dialogue_boxes.dart';
import 'models/community.dart';

generateOTP() {
  String numbers = '0123456789';
  var otp = '';
  for (int i = 0; i < 6; i++) {
    final newDigit = numbers[Random().nextInt(10)];
    otp = otp + newDigit;
  }
  return otp;
}

sendInvitation(String receiverEmail, Community comm, String inviter) async {
  String username = 'motazenapp@gmail.com';
  String password = "nwzwtraabozrdipz";

  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'Motazen')
    ..recipients.add(receiverEmail)
    ..subject = 'Motazen Community Invitation [${comm.communityName}]'
    ..text =
        'Dear $receiverEmail,\n$inviter has invited you in the community ${comm.communityName}. Please check the app notification to accept or reject the invitation\n\nRegards,\nTeam Motazen';

  try {
    final sendReport = await send(message, smtpServer);
    AllDialogues.hideloading();
    Fluttertoast.showToast(msg: "Invite sent", toastLength: Toast.LENGTH_LONG);
  } on MailerException catch (e) {
    AllDialogues.hideloading();
    Fluttertoast.showToast(msg: "Failed sending invite mail");
  }
}
