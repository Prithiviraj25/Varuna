import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  ChatUser myself = ChatUser(id: '1', firstName: 'sarthak');
  final oururl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyCNzFMm79faJTRZ0EneUEeBF4wZCjuaKzs';
  final header = {'Content-Type': 'application/json'};
  ChatUser bot = ChatUser(id: '2', firstName: 'Gemini');

  List<ChatMessage> allMessages = [];

  Future<void> getdata(ChatMessage m) async {
    allMessages.insert(0, m);

    setState(() {});

    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(oururl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);
        ChatMessage m1 = ChatMessage(
            user: bot,
            createdAt: DateTime.now(),
            text: result['candidates'][0]['content']['parts'][0]['text']);
        allMessages.insert(0, m1);
        setState(() {});
      } else {
        print("error");
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFBBDEFB),
        title: Center(
            child: Text("GEMINI",
                style: GoogleFonts.breeSerif(
                    textStyle: TextStyle(color: Color(0xDD000000)),
                    fontWeight: FontWeight.w800))),
      ),
      backgroundColor: Color(0xFFE4F1FF),
      body: DashChat(
        currentUser: myself,
        onSend: (ChatMessage m) {
          getdata(m);
        },
        messages: allMessages,
      ),
    ));
  }
}
