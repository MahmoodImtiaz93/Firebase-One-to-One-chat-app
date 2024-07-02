// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/constant/app_colors.dart';
import 'package:echat/widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> chatUser;

  const ChatScreen({Key? key, required this.chatUser}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String chatId = '';

  @override
  void initState() {
    super.initState();
    createChatId();
  }

  void createChatId() {
    final currentUserId = _auth.currentUser?.uid;
    final selectedUserId = widget.chatUser['uid'];

    chatId = currentUserId.hashCode <= selectedUserId.hashCode
        ? '$currentUserId-$selectedUserId'
        : '$selectedUserId-$currentUserId';
  }

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': _messageController.text.trim(),
      'senderUID': _auth.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatId).set({
      'user1': _auth.currentUser?.uid,
      'user2': widget.chatUser['uid'],
      'lastMessage': _messageController.text.trim(),
      'lastTimestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser['name']),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Container();

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    bool isCurrentUser =
                        message['senderUID'] == _auth.currentUser?.uid;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? Colors.grey
                                : AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'],
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                message['timestamp'] != null
                                    ? DateFormat('hh:mm a').format(
                                        (message['timestamp'] as Timestamp)
                                            .toDate())
                                    : '',
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
