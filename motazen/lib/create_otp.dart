import 'dart:math';

generateOTP() {
  String numbers = '0123456789';
  var otp = '';
  for (int i = 0; i < 6; i++) {
    final newDigit = numbers[Random().nextInt(10)];
    otp = otp + newDigit;
  }
  return otp;
}
