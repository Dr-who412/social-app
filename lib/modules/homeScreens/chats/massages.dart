import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/layou/home_layout/home.dart';
import 'package:hiddenmind/models/signUpModel.dart';

import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/shared/componant/componant.dart';
import 'package:hiddenmind/shared/componant/constant.dart';
import 'package:hiddenmind/shared/network/remote/httpHelper.dart';
import 'package:hiddenmind/shared/theme/colors.dart';
import 'package:lottie/lottie.dart';

class Messages extends StatelessWidget {
  final UserModel? reciver;
  Messages({Key? key, this.reciver}) : super(key: key);
  var messageController = TextEditingController();
  var formKay = GlobalKey<FormState>();

  var _listController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (BuildContext context) {
          HomeCubit.get(context).getAnyFCM(userId: reciver?.userId);
      HomeCubit.get(context).getMessage(reciverId: reciver?.userId);
      return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is SendMessageSuccessState) {
           messageController.text = '';
            HomeCubit.get(context).removeChatImage();
          }
        },
        buildWhen: (pre, state) {
          if (state is SendMessageSuccessState) return true;
          if (state is GetMessageSuccessState) return true;
          return false;
        },
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          var count = cubit.messages.length;

          return Scaffold(
            appBar: AppBar(
              elevation: 0.3,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: defeultColor,
                ),
                onPressed: () {
                  HomeCubit.get(context).currentIndex = 3;
                  navigatfinished(context, Home());
                },
              ),
              title: Row(
                children: [
                  CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage('${reciver?.image}')),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${reciver?.userName}',
                    style: TextStyle(
                        height: 1.2,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              top: true,
              left: true,
              right: true,
              bottom: true,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ConditionalBuilder(
                            condition: cubit.messages.isNotEmpty,
                            builder: (context) => Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                ListView.builder(
                                    reverse: true,
                                    controller: _listController,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: cubit.messages.length,
                                    itemBuilder: (context, int index) {
                                      print("index $index");
                                      print(cubit.messages.length-1-index);
                                      return message(
                                        context: context,
                                        message: cubit.messages[cubit.messages.length-1-index].text,
                                        isRecived:
                                            cubit.messages[cubit.messages.length-1-index].senderId ==
                                                    reciver?.userId
                                                ? true
                                                : false,
                                        imageUrl:
                                            cubit.messages[cubit.messages.length-1-index].image ?? '',
                                      );
                                    }),
                                BlocBuilder<HomeCubit, HomeState>(
                                  buildWhen: (prev, state) {
                                    if (state is PickChatImageSuccess) {
                                      return true;
                                    }
                                    if (state is RenmovePickedChatImage) {
                                      return true;
                                    }
                                    return false;
                                  },
                                  builder: (context, state) {
                                    return cubit.chatImage != null
                                        ? Container(
                                            color: Colors.transparent,
                                            constraints: BoxConstraints(
                                              minHeight: 0.0, //minimum height
                                              minWidth: 0.0, // minimum width
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
//maximum height set to 100% of vertical height
                                              maxWidth: double.infinity,
//maximum width set to 100% of width
                                            ),
                                            child: Card(
                                              elevation: 5.5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: SizedBox.fromSize(
                                                  child: Stack(
                                                    children: [
                                                      Image.file(
                                                        cubit.chatImage!,
                                                        fit: BoxFit.contain,
                                                      ),
                                                      CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white30,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              cubit
                                                                  .removeChatImage();
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .highlight_remove_outlined,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox();
                                  },
                                )
                              ],
                            ),
                            fallback: (context) => state
                                    is GetMessageLoadingState
                                ? Center(
                                    child: Lottie.asset('assets/load.json'),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset('assets/empty.json',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5),
                                      Text(
                                        "ChatsBox empty",
                                        style: TextStyle(
                                            color: Colors.black26,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      )
                                    ],
                                  ),
                          ),
                        ),
                        Card(
                          color: Colors.black12,
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(55),
                          ),
                          elevation: 0.0,
                          shadowColor: Colors.black12.withOpacity(.7),
                          child: TextFormField(
                            controller: messageController,
                            keyboardType: TextInputType.multiline,
                            maxLength: null,
                            maxLines: null,
                            minLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              helperMaxLines: 0,
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    print(" pick image");
                                    cubit.pickChatImage();
                                  },
                                  icon: Icon(Icons.image_outlined)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    print("send message");
                                    if (cubit.chatImage == null) {
                                      if (messageController.text
                                          .trim()
                                          .isNotEmpty) {
                                        cubit.pushMessage(
                                            text: messageController.text,
                                            reciverId: reciver?.userId);
                                      }
                                    }
                                    {
                                      cubit.uploadChatImage(
                                          text: messageController.text,
                                          rexiverId: reciver?.userId);
                                    }
                                  },
                                  icon: Icon(Icons.send_outlined)),
                              hintText: 'Start a message !',
                              hintStyle: TextStyle(
                                color: Colors.black26,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0.0, color: Colors.black12),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55)),
                              ),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0.0, color: Colors.black12),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(55)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
