import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/chatroom_logic/models/message_chat.dart';
import 'package:event_app/app/chatroom_logic/pages/full_photo_page.dart';
import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/sign_in_provider.dart';
import '../constants/color_constants.dart';
import '../constants/firestore_constants.dart';
import '../providers/chatroom_provider.dart';
import '../widgets/widgets.dart';

class ChatroomPage extends StatefulWidget {
  ChatroomPage({Key? key, required this.arguments}) : super(key: key);

  final ChatPageArguments arguments;

  @override
  ChatroomPageState createState() => ChatroomPageState();
}

class ChatroomPageState extends State<ChatroomPage> {
  late String currentUserId = sb.uid!;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatroomProvider chatProvider;
  late SignInProvider sb;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatroomProvider>();
    sb = context.read<SignInProvider>();

    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
  }

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = peerId;
    } else {
      groupChatId = peerId;
    }

    chatProvider.updateDataFirestore(
      FirestoreConstants.pathUserCollection,
      currentUserId,
      {FirestoreConstants.chattingWith: peerId},
    );
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();

    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, TypeMessage.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(
          content,
          type,
          groupChatId,
          currentUserId,
          widget.arguments.peerId,
          widget.arguments.peerNickname,
          widget.arguments.peerAvatar);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        // Right (my message)
        return Row(
          // ignore: sort_child_properties_last
          children: <Widget>[
            messageChat.type == TypeMessage.text
                // Text
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Text(
                                      widget.arguments.peerNickname,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Gilroy",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17.5),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    child: Text(
                                      messageChat.content,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontFamily: "Gilroy",
                                          fontWeight: FontWeight.w500),
                                    ),
                                    padding:
                                        EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(2),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        )),
                                    margin: EdgeInsets.only(
                                        bottom:
                                            isLastMessageRight(index) ? 10 : 10,
                                        right: 10),
                                  ),
                                  Container(
                                    child: Text(
                                      DateFormat('dd MMM kk:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(
                                                  messageChat.timestamp))),
                                      style: TextStyle(
                                          color: ColorConstants.greyColor,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 50, top: 0, bottom: 15),
                                  ),
                                ],
                              ),
                              Material(
                                // ignore: sort_child_properties_last
                                child: Image.network(
                                  widget.arguments.peerAvatar ?? '',
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: ColorConstants.themeColor,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, object, stackTrace) {
                                    return Icon(
                                      Icons.account_circle,
                                      size: 35,
                                      color: ColorConstants.greyColor,
                                    );
                                  },
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : messageChat.type == TypeMessage.image
                    // Image
                    ? Container(
                        // ignore: sort_child_properties_last
                        child: OutlinedButton(
                          // ignore: sort_child_properties_last
                          child: Material(
                            // ignore: sort_child_properties_last
                            child: Image.network(
                              messageChat.content,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  // ignore: prefer_const_constructors
                                  decoration: BoxDecoration(
                                    color: ColorConstants.greyColor2,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorConstants.themeColor,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Material(
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                );
                              },
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullPhotoPage(
                                  url: messageChat.content,
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                      )
                    // Sticker
                    : Container(
                        child: Image.asset(
                          'assets/images/${messageChat.content}.gif',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                      ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          // ignore: sort_child_properties_last
          child: Column(
            // ignore: sort_child_properties_last
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // isLastMessageLeft(index)
                  //     ? Material(
                  //         // ignore: sort_child_properties_last
                  //         child: Image.network(
                  //           messageChat.profile ?? '',
                  //           loadingBuilder: (BuildContext context, Widget child,
                  //               ImageChunkEvent? loadingProgress) {
                  //             if (loadingProgress == null) return child;
                  //             return Center(
                  //               child: CircularProgressIndicator(
                  //                 color: ColorConstants.themeColor,
                  //                 value: loadingProgress.expectedTotalBytes !=
                  //                         null
                  //                     ? loadingProgress.cumulativeBytesLoaded /
                  //                         loadingProgress.expectedTotalBytes!
                  //                     : null,
                  //               ),
                  //             );
                  //           },
                  //           errorBuilder: (context, object, stackTrace) {
                  //             return Icon(
                  //               Icons.account_circle,
                  //               size: 35,
                  //               color: ColorConstants.greyColor,
                  //             );
                  //           },
                  //           width: 35,
                  //           height: 35,
                  //           fit: BoxFit.cover,
                  //         ),
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(18),
                  //         ),
                  //         clipBehavior: Clip.hardEdge,
                  //       )
                  //     : Container(width: 35),
                  messageChat.type == TypeMessage.text
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              // ignore: sort_child_properties_last
                              child: Image.network(
                                messageChat.profile ?? '',
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: ColorConstants.themeColor,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stackTrace) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: 35,
                                    color: ColorConstants.greyColor,
                                  );
                                },
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 11.0),
                                  child: Text(
                                    messageChat.name ?? '',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Gilroy",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17.5),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  child: Text(
                                    messageChat.content,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Gilroy"),
                                  ),
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.black12.withOpacity(0.1),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(2),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      )),
                                  margin: EdgeInsets.only(left: 10),
                                ),
                                Container(
                                  child: Text(
                                    DateFormat('dd MMM kk:mm').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(messageChat.timestamp))),
                                    style: TextStyle(
                                        color: ColorConstants.greyColor,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 15, top: 10, bottom: 5),
                                )
                              ],
                            ),
                          ],
                        )
                      : messageChat.type == TypeMessage.image
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  // ignore: sort_child_properties_last
                                  child: Image.network(
                                    messageChat.profile ?? '',
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: ColorConstants.themeColor,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return Icon(
                                        Icons.account_circle,
                                        size: 35,
                                        color: ColorConstants.greyColor,
                                      );
                                    },
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 11.0),
                                      child: Text(
                                        messageChat.name ?? '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Gilroy",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17.5),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      child: TextButton(
                                        child: Material(
                                          child: Image.network(
                                            messageChat.content,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      ColorConstants.greyColor2,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                width: 200,
                                                height: 200,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: ColorConstants
                                                        .themeColor,
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, object, stackTrace) =>
                                                    Material(
                                              child: Image.asset(
                                                'images/img_not_available.jpeg',
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                            ),
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FullPhotoPage(
                                                      url: messageChat.content),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(EdgeInsets.all(0))),
                                      ),
                                      margin: EdgeInsets.only(left: 10),
                                    ),
                                    Container(
                                      child: Text(
                                        DateFormat('dd MMM kk:mm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    messageChat.timestamp))),
                                        style: TextStyle(
                                            color: ColorConstants.greyColor,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      margin: EdgeInsets.only(
                                          left: 15, top: 10, bottom: 5),
                                    )
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  // ignore: sort_child_properties_last
                                  child: Image.network(
                                    messageChat.profile ?? '',
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: ColorConstants.themeColor,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return Icon(
                                        Icons.account_circle,
                                        size: 35,
                                        color: ColorConstants.greyColor,
                                      );
                                    },
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 11.0),
                                      child: Text(
                                        messageChat.name ?? '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Gilroy",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17.5),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      child: Image.asset(
                                        'assets/images/${messageChat.content}.gif',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      margin: EdgeInsets.only(
                                          bottom: isLastMessageRight(index)
                                              ? 20
                                              : 10,
                                          right: 10),
                                    ),
                                    Container(
                                      child: Text(
                                        DateFormat('dd MMM kk:mm').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    messageChat.timestamp))),
                                        style: TextStyle(
                                            color: ColorConstants.greyColor,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      margin: EdgeInsets.only(
                                          left: 15, top: 10, bottom: 5),
                                    )
                                  ],
                                ),
                              ],
                            ),
                ],
              ),

              // Time
              // isLastMessageLeft(index)
              //     ? Container(
              //         child: Text(
              //           DateFormat('dd MMM kk:mm').format(
              //               DateTime.fromMillisecondsSinceEpoch(
              //                   int.parse(messageChat.timestamp))),
              //           style: TextStyle(
              //               color: ColorConstants.greyColor,
              //               fontSize: 12,
              //               fontStyle: FontStyle.italic),
              //         ),
              //         margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
              //       )
              //     : SizedBox.shrink()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateDataFirestore(
        FirestoreConstants.pathUserCollection,
        currentUserId,
        {FirestoreConstants.chattingWith: null},
      );
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          this.widget.arguments.peerName,
          // ignore: prefer_const_constructors
          style: TextStyle(
              color: ColorConstants.primaryColor,
              fontFamily: "Gilroy",
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Sticker
                isShowSticker ? buildSticker() : SizedBox.shrink(),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
      ),
    );
  }

  Widget buildSticker() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi1', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi1.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi2', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi2.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi3', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi3.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi4', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi4.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi5', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi5.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi6', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi6.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi7', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi7.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi8', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi8.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi9', TypeMessage.sticker),
                  child: Image.asset(
                    'assets/images/mimi9.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: ColorConstants.greyColor2, width: 0.5)),
            color: Colors.white),
        padding: EdgeInsets.all(5),
        height: 180,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? LoadingView() : SizedBox.shrink(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: ColorConstants.primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: ColorConstants.primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, TypeMessage.text);
                },
                style:
                    TextStyle(color: ColorConstants.primaryColor, fontSize: 15),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                      color: ColorConstants.greyColor,
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
                focusNode: focusNode,
                autofocus: true,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () =>
                    onSendMessage(textEditingController.text, TypeMessage.text),
                color: ColorConstants.primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: ColorConstants.greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.length > 0) {
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data?.docs[index]),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getSvg(
                          "noMessage.svg",
                          height: 250,
                          width: 250,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "No message here yet...",
                          style: TextStyle(
                              fontFamily: "Gilroy",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                      ],
                    ));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.themeColor,
                    ),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: ColorConstants.themeColor,
              ),
            ),
    );
  }
}

class ChatPageArguments {
  final String peerName;
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments(
      {required this.peerName, required this.peerId,
      required this.peerAvatar,
      required this.peerNickname});
}
