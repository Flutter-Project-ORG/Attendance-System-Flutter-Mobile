import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

import '../res/constants.dart';

class QrCameraViewModel{

  Map<String, dynamic> decryptDate(String encryptedText){
    final key = encrypt.Key.fromUtf8(Constants.encryptKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final String decrypted = encrypter.decrypt(
        encrypt.Encrypted.fromBase64(encryptedText),
        iv: iv);
    return jsonDecode(decrypted) as Map<String, dynamic>;
  }


}