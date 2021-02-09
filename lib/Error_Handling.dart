import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';

class Error_Handling{
  void printSuccess(String text){
    BotToast.showText(text: text);
  }
  void printError(String text){
    BotToast.showText(text: text);
  }
}