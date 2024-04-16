import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_project/pages/group_info.dart';
import 'package:test_project/service/database_service.dart';
import 'package:test_project/widgets/message_tile.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart'; // Include ChatGPT SDK

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  List<String> messages = [];
  final _openAI = OpenAI.instance.build(
    token: "<APIKEY>",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title:
            Text(widget.groupId == "AI_USER_ID" ? "AI Chat" : widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: widget.groupId != "AI_USER_ID"
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupInfo(
                                groupId: widget.groupId,
                                groupName: widget.groupName,
                                adminName: admin,
                              )),
                    );
                  },
                  icon: const Icon(Icons.info),
                )
              ]
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                widget.groupId == "AI_USER_ID" ? aiMessages() : chatMessages(),
          ),
          messageInputField(),
        ],
      ),
    );
  }

  Widget aiMessages() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(messages[index]),
        );
      },
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return MessageTile(
              message: doc['message'],
              sender: doc['sender'],
              sentByMe: widget.userName == doc['sender'],
            );
          },
        );
      },
    );
  }

  Widget messageInputField() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      color: Colors.grey[700],
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Send a message...",
                hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: widget.groupId == "AI_USER_ID"
                ? sendAIChatMessage
                : sendMessage,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  void sendAIChatMessage() async {
    if (messageController.text.isNotEmpty) {
      final Map<String, dynamic> chatMessage = {
        'role': 'user',
        'content': messageController.text,
      };
      final request = ChatCompleteText(
        model: GptTurbo0301ChatModel(),
        messages: [chatMessage],
        maxToken: 200,
      );
      final response = await _openAI.onChatCompletion(request: request);
      if (response != null &&
          response.choices.isNotEmpty &&
          response.choices.first.message != null) {
        setState(() {
          // Clear previous messages and add the new one
          messages.clear(); // Clear all previous messages
          messages.add(response.choices.first.message!.content);
          messageController.clear();
        });
      }
    }
  }
}
