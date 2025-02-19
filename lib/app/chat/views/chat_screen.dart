import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/chat/providers/chat_provider.dart';
import 'package:event_app/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    final String userId = args['userId']!;
    final String otherUserId = args['eventId']!;

    return ChangeNotifierProvider(
      create: (_) => ChatProvider(userId: userId, otherUserId: otherUserId),
      child: Scaffold(
        appBar: AppBar(title: Text("Chat"), iconTheme: IconThemeData(
          color: accentColor,
        ),),
        body: ChatBody(),
      ),
    );
  }
}

class ChatBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final TextEditingController messageController = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: chatProvider.getMessages(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No messages yet"));
              }
              return ListView(
                reverse: true,
                children: snapshot.data!.docs.map((doc) {
                  bool isMe = doc['senderId'] == chatProvider.userId;
                  return ListTile(
                    title: Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isMe ? accentColor : Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          doc['text'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(hintText: "Type a message"),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  chatProvider.sendMessage(messageController.text);
                  messageController.clear();
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
