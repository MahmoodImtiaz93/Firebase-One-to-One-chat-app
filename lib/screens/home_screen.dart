import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echat/constant/app_colors.dart';
import 'package:echat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userMap;
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String phoneNumberwithCode = '';
  bool isLoading = false;
  List<Map<String, dynamic>> chatList = [];

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await _firestore
          .collection('users')
          .where("phoneNumber", isEqualTo: phoneNumberwithCode)
          .get();

      if (result.docs.isNotEmpty) {
        setState(() {
          userMap = result.docs[0].data();
          isLoading = false;
          _phoneController.clear();
        });
      } else {
        setState(() {
          userMap = null;
          isLoading = false;
          _phoneController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with this phone number.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while searching: $e')),
        );
      });
    }
  }

  void fetchChats() async {
    final currentUserId = _auth.currentUser?.uid;

    try {
      var result = await _firestore
          .collection('chats')
          .where('user1', isEqualTo: currentUserId)
          .get();

      var result2 = await _firestore
          .collection('chats')
          .where('user2', isEqualTo: currentUserId)
          .get();

      List<Map<String, dynamic>> tempChatList = [];

      for (var doc in result.docs) {
        tempChatList.add(doc.data());
      }

      for (var doc in result2.docs) {
        tempChatList.add(doc.data());
      }

      setState(() {
        chatList = tempChatList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while fetching chats: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "E-Chat",
          style:
              TextStyle(fontFamily: 'Pacifico', color: AppColors.primaryColor),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.only(top: 250.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: IntlPhoneField(
                      cursorColor: AppColors.primaryColor,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        suffixIcon: Card(
                          color: AppColors.primaryColor,
                          child: IconButton(
                            onPressed: onSearch,
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        hintText: "Enter Phone Number",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2.0,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.warningColor,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.warningColor,
                          ),
                        ),
                      ),
                      initialCountryCode: 'BD',
                      onChanged: (phone) {
                        phoneNumberwithCode = phone.completeNumber;
                      },
                    ),
                  ),
                  userMap != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatUser: userMap!,
                                  ),
                                ));
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userMap!['profilePic']),
                              ),
                              title: Text(userMap!['name']),
                              subtitle: Text(userMap!['email']),
                            ),
                          ),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Search with Phone Number!",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  Expanded(
                    child: chatList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ListView.builder(
                              itemCount: chatList.length,
                              itemBuilder: (context, index) {
                                var chat = chatList[index];
                                var otherUserId =
                                    chat['user1'] == _auth.currentUser?.uid
                                        ? chat['user2']
                                        : chat['user1'];
                                return FutureBuilder(
                                  future: _firestore
                                      .collection('users')
                                      .doc(otherUserId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return Container();
                                    var user = snapshot.data!.data()!;
                                    return Card(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(user['profilePic']),
                                        ),
                                        title: Text(user['name']),
                                        subtitle: Text(chat['lastMessage']),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                chatUser: user,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Text(
                              'No chats available',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
