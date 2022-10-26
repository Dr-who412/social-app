import 'dart:convert';
import 'dart:io';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/models/messageModel.dart';
import 'package:hiddenmind/models/postModels.dart';
import 'package:hiddenmind/modules/homeScreens/chats/chats.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiddenmind/modules/homeScreens/feeds/feeds.dart';
import 'package:hiddenmind/modules/homeScreens/search/search.dart';
import 'package:hiddenmind/shared/componant/componant.dart';
import 'package:hiddenmind/shared/componant/constant.dart';
import 'package:hiddenmind/shared/network/remote/httpHelper.dart';
import 'package:hiddenmind/shared/theme/colors.dart';
import '../../../models/signUpModel.dart';
import '../notification/notification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fireStorag;

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  var currentIndex = 0;
  List<Widget> Screens = [
    Feeds(),
    Search(),
    NotificationScreen(),
    Chats(),
  ];
  TextEditingController chatsController = TextEditingController();



  void ChangeNave(index) {
    currentIndex = index;

    emit(ChangeBottomNav());
  }

  UserModel? userModel;

  void getUSerData({required String?userId}) {
    emit(GetDataLoadingHomeState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      print(value.data());
      userModel = UserModel.fromjson(value.data()!);
      print(userModel);
      saveFMCToken(fmcToken: FCMTOKEN);
      emit(GetDataSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetDAtaErrorState(error.toString()));
    });
  }

  UserModel? anyUser;
  bool toChat=false;
  bool iSFollowing=false;
  bool isFollower=false;
  void getAnyUSerData({required String?userId}) {
    emit(GetAnyUserDataLoadingHomeState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((valueUser) {
      FirebaseFirestore.instance.collection('users').doc(userId).collection("followers").doc(USERID).get().then((value) {
        iSFollowing=value.get('followers');
        print("isfollowing get ${value.get("followers")}");
        emit(GetAnyUserDataSuccess());

      }).catchError((error){
        iSFollowing=false;
      });
      FirebaseFirestore.instance.collection('users').doc(userId).collection("following").doc(USERID).get().then((value) {
        isFollower=value.get("following")??false;
        emit(GetAnyUserDataSuccess());

      }).catchError((error){
        isFollower=false;
      });
      print(valueUser.data());
      anyUser = UserModel.fromjson(valueUser.data()!);
      emit(GetAnyUserDataSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetAnyUserDAtaErrorState(error.toString()));
    });
  }

  File? profile;
  final ImagePicker picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickFile = await picker.getImage(source: ImageSource.gallery);
    if (pickFile != null) {
      profile = File(pickFile.path);
      print(pickFile.path);
      emit(PickImageSuccess());
    } else {
      print("No Image selected");
      emit(PickImageError());
    }
  }

  File? cover;

  Future<void> getCoverImage() async {
    final pickFile = await picker.getImage(source: ImageSource.gallery);
    if (pickFile != null) {
      cover = File(pickFile.path);
      print(pickFile.path);
      emit(PickCoverSuccess());
    } else {
      print("No Image selected");
      emit(PickCoverError());
    }
  }

  String? profileUrl = '';

  void uploadProfile() {
    fireStorag.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file("${profile?.path}")
        .pathSegments
        .last}')
        .putFile(profile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(UploadImageSuccess());
        profileUrl = value;
        upDateUser(name: userModel?.userName, bio: userModel?.bio,);
        print('profile');
        print(value);
      }).catchError((error) {
        emit(UpDateLinksError());
        print(error);
      });
    }).catchError((error) {
      print("upload Photo error: ${error.toString()}");
      emit(UploadImageError());
    });
  }

  String? coverUrl = '';

  void uploadCover() {
    fireStorag.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file("${cover?.path}")
        .pathSegments
        .last}')
        .putFile(cover!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(UploadCoverSuccess());
        coverUrl = value;
        upDateUser(name: userModel?.userName, bio: userModel?.bio,);
        print('cover');
        print(value);
      }).catchError((error) {
        emit(UploadCoverError());
      });
    }).catchError((error) {
      print("upload Photo error: ${error.toString()}");
      emit(UploadCoverError());
    });
  }

  void upDateUser({
    required String? name,
    required String? bio,
    // required String? image,
    // required String? backgroundImage,
  }) {
    print("user Update");
    UserModel? model = UserModel(
      userName: name,
      bio: bio,
      backgroundImage: coverUrl == '' ? userModel?.backgroundImage : coverUrl,
      image: profileUrl == '' ? userModel?.image : profileUrl,
      isVerify: userModel?.isVerify,
      phone: userModel?.phone,
      userId: userModel?.userId,
      email: userModel?.email,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc('${userModel?.userId}')
        .update(model.toMap())
        .then((value) {
      getUSerData(userId: userModel?.userId);
    }).catchError((error) {
      print(error.toString());
      emit(UpDateError());
    });
  }

  void uploadImageUrl() {
    if (profile != null && cover != null) {
      uploadCover();
      uploadProfile();
    } else if (cover != null) {
      uploadCover();
    } else if (profile != null) {
      uploadProfile();
    } else {
      print('no image to upload ');
    }
    emit(ImageProcessDone());
  }

  File? post;

  Future<void> getPostImage() async {
    final pickFile = await picker.getImage(source: ImageSource.gallery);
    if (pickFile != null) {
      post = File(pickFile.path);
      print(pickFile.path);
      emit(PickPostImageSuccess());
    } else {
      print("No Image selected");
      emit(PickPostError());
    }
  }

  void uploadPostImage({
    required String? text,
  }) {
    emit(PostingLoadingState());
    fireStorag.FirebaseStorage.instance
        .ref()
        .child('postsImage/${Uri
        .file("${post?.path}")
        .pathSegments
        .last}')
        .putFile(post!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        uploadpost(postImage: value, text: text);
        print('post');
        print(value);
      }).catchError((error) {
        emit(PostingErrorState());
      });
    }).catchError((error) {
      print("upload Post error: ${error.toString()}");
      emit(PostingErrorState());
    });
  }

  void uploadpost({
    required String? text,
    required String? postImage,
  }) {
    emit(PostingLoadingState());
    print(" post Uploaded");
    PostModel? model = PostModel(
      userName: userModel?.userName,
      userId: userModel?.userId,
      image: userModel?.image,
      text: text,
      postImage: postImage ?? '',
      postDate: '${DateTime.now()}',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      print("post done");
      getAllPost();
      emit(PostingSuccess());
    }).catchError((error) {
      print("ERROR POSTING00");
      print(error.toString());
      emit(PostingErrorState());
    });
  }

  void removePostImage() {
    post = null;
    emit(RemovePostImageSuccess());
  }

  List<PostModel?> posts = [];
  List<String?> postId = [];
  Map <String, dynamic> likes = {};
  List comments = [];
  Map <String, dynamic> postLikes = {};
  bool flag = true;

  getAllPost() async {
    flag = false;
    print('get post');
    emit(GetHomeLoadingHomeState());
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('postDate')
        .get()
        .then((value) async {

      int i = 1;
      value.docs.forEach((element) async {
        if(postId.contains(element.id)==false)
        await element.reference.collection('comments')
            .get()
            .then((value4) async {
          print('comment');
          comments.add(value4.docs.length);
          postId.add(element.id);
          posts.add(PostModel.fromjson(element.data()));
          print('post add');
          await element.reference.collection('likes')
              .get()
              .then((value2) async {
            likes.addAll({'${element.id}': value2.docs.length});
            value2.docs.forEach((element1) async {
              if (element1.id == userModel?.userId) {
                postLikes.addAll({'${element.id}': true});
              }
            });
            print(value.docs.length);
           if(value.docs.last.id==element.id){
             flag=true;
              emit(GetHomeSuccess());}

            ++i;
          })
              .catchError((error) {
            print(error);
            emit(GetHomeErrorState(error.toString()));
          });
        })
            .catchError((error) {
          print(error);
          emit(GetHomeErrorState(error.toString()));
        });
      });
    }).catchError((error) {
      print(error);

      emit(GetHomeErrorState(error.toString()));
    });
  }

  var clickedLike;

  void pushLike(String? postid, index) {
    emit(LikeLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .doc(postid)
        .collection('likes')
        .doc(userModel?.userId)
        .set({'like': true})
        .then((value) {
      clickedLike = null;
      postLikes.addAll({'$postid': true});
      print("done");
      likes['$postid'] = likes['$postid'] + 1;
      emit(LikeSuccessState());
    })
        .catchError((error) {
      emit(LikeErrorState(error.toString()));
    });
  }

  void removeLike(String? postid, index) {
    FirebaseFirestore.instance.collection('posts')
        .doc(postid)
        .collection('likes')
        .doc(userModel?.userId)
        .delete()
        .then((value) {
      postLikes.remove('$postid');
      print("deleted done");
      likes['$postid'] = likes['$postid'] - 1;
      emit(LikeSuccessState());
    })
        .catchError((error) {
      emit(LikeErrorState(error.toString()));
    });
  }

  void pushComment({
    required String? postid,
    required String? text,
    required int? postIndex,
    required String? postImage,}) async
  {
    emit(CommentLoadingState());
    PostModel? model = PostModel(
      userName: userModel?.userName,
      userId: userModel?.userId,
      image: userModel?.image,
      text: text,
      postImage: postImage ?? '',
      postDate: '${DateTime
          .now()
          .year}/${DateTime
          .now()
          .month}/${DateTime
          .now()
          .day}',
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postid)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      emit(CommentSuccessState());
      comments[postIndex!] = comments[postIndex!] + 1;
      print("done");
    })
        .catchError((error) {
      emit(CommentErrorState(error));
    });
  }

  void uploadReplayWithImage({
    required String? postId,
    required String? text,
    required int? postIndex,
  }) {
    fireStorag.FirebaseStorage.instance
        .ref()
        .child('postsImage/${Uri
        .file("${post?.path}")
        .pathSegments
        .last}')
        .putFile(post!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        pushComment(
            postid: postId, text: text, postImage: value, postIndex: postIndex);
        print('post');
        print(value);
      }).catchError((error) {});
    }).catchError((error) {
      print("upload Post error: ${error.toString()}");
    });
  }

  List <PostModel?>postComment = [];

  getPostComments(index) async {
    postComment = [];
    emit(GetCommentLoadingState());
    await FirebaseFirestore.instance.collection('posts').doc(postId[index])
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
        postComment.add(PostModel.fromjson(element.data()));
      });
      print('get post comments done ');
      emit(GetCommentSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetCommentErrorState(error));
    });
  }

  List <UserModel?>chatsUsers = [];

  void getChatsList() async {
    emit(LoadingUsersChatState());
    await FirebaseFirestore.instance.collection('users').get().then((value) {

        value.docs.forEach((element) async {
          if(chatsUsers.contains(element)==false)
          if (element.id != userModel?.userId) {
            await FirebaseFirestore.instance.collection('users').doc(USERID)
                .collection('chats').doc(element.id).collection('messages')
                .get()
                .then((value) async {
              if (value.docs.isNotEmpty) {
                await FirebaseFirestore.instance.collection('users').doc(
                    element.id).get().then((val) {
                  print('get user caht');
                  chatsUsers.removeWhere((item) =>
                  item?.userId == UserModel
                      .fromjson(val.data()!)
                      .userId);
                  chatsUsers.add(UserModel.fromjson(val.data()!));
                  print(chatsUsers.length);
                }).catchError((error) {
                  print(error);
                });
              }
            }).catchError((error) {
              print(error);
            });

            if (value.docs.last.id==element.id && chatsUsers.isNotEmpty) {
              print('chat comolete');
              emit(GetUsersChatSuccessState());
            }
            if (value.docs.last==element && chatsUsers.isEmpty)
              {
                emit(EmptyUsersChatSuccessState());
              }
          }
        });
    });
  }

  void pushMessage({
    required String? text,
    required String? reciverId,
    imageUrl,
  }) async {
    print('send1');
    var message = MessageModel(text: "$text",
      senderId: userModel?.userId,
      reciverId: '$reciverId',
      image: imageUrl??'',
      isVerify: true,
      dateTime: "${DateTime.now()}",);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(USERID)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      print(value);
      print('done fore me');
      sendNotificationTo(title: "${userModel?.userName}",imageUrl:userModel?.image??'', body: text??'');
      emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorChatState(error.toString()));
    });
    FirebaseFirestore.instance.collection('users').doc(reciverId).collection(
        'chats').doc(USERID).collection('messages')
        .add(message.toMap())
        .then((value) {
      print(value);
      print('done for reciver');
      //  emit(SendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SendMessageErrorChatState(error.toString()));
    });
  }

  List<MessageModel>messages = [];

  getMessage({ required String? reciverId,
  }) {
    emit(LoadingUsersChatState());
    FirebaseFirestore.instance.collection('users')
        .doc(userModel?.userId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        print(messages.length);
        messages.add(MessageModel.fromjson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }

  void saveFMCToken({String? fmcToken}) {
    if (fmcToken!.isNotEmpty)
      FirebaseFirestore.instance.collection('fmctoken')
          .doc(userModel?.userId)
          .set({'token': fmcToken})
          .then((value) {
        print('token fmc saved');
      });
  }
  var currentReciverFCM;
  getAnyFCM({  required String? userId,}){
    FirebaseFirestore.instance.collection('fmctoken').doc(userId).get().then((value) {

      currentReciverFCM=value.get("token");

    }).catchError((error){
      print("fcm reciver error");
    });
  }
sendNotificationTo({
  required String title,
  required String imageUrl,
  required String body}){
  print(currentReciverFCM);
  sendNotification(to:currentReciverFCM,title:title,imageUrl:imageUrl,body:body);
}

  File? chatImage;
void removeChatImage(){
  chatImage=null;
  emit(RenmovePickedChatImage());
}
  Future<void> pickChatImage() async {
    final pickFile = await picker.getImage(source: ImageSource.gallery);
    if (pickFile != null) {
      chatImage = File(pickFile.path);
      print(pickFile.path);
      emit(PickChatImageSuccess());
    } else {
      print("No Image selected");
      emit(PickChatError());
    }
  }

  void uploadChatImage({
    required String? text,
    required String? rexiverId,
  }) {
    emit(UploadChatImageLoading());
    fireStorag.FirebaseStorage.instance
        .ref()
        .child('ChatsImage/${Uri
        .file("${chatImage?.path}")
        .pathSegments
        .last}')
        .putFile(chatImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        pushMessage(text: text,reciverId: rexiverId,imageUrl:value);
      }).catchError((error) {
        emit(UploadChatImageError());
      });
    }).catchError((error) {
      print("upload Post error: ${error.toString()}");
      emit(UploadChatImageError());
    });
  }
  List <UserModel> searchResult=[];
   search({required List<UserModel>? searchList,required String? emailOrName}){
     searchResult=[];
     if(searchResult.isEmpty){
     searchList?.forEach((element) {
     if((element.email!.contains(emailOrName!)||element.userName!.contains(emailOrName))&&element.userId!=USERID){
       searchResult.add(element);
     }
     if(searchList.last==element){
       searchResult.toSet().toList();
       emit(SearchEnd());
     }
   }) ;}
 }
 void clearSearch(){
     searchResult=[];
     emit(clearSearchState());
 }
 List <UserModel> users =[];
 getAllUsers()async{
   users=[];
   if(users.isEmpty)
     await FirebaseFirestore.instance.collection('users').get().then((value) {
       value.docs.forEach((element) {
         users.add(UserModel.fromjson(element.data()));
       });
     }).catchError((error){
       print("get users error");
     });
 }
 follow({required String? followingId})async{
   print(" follow start");
   await getAnyFCM(userId: followingId);
   FirebaseFirestore.instance
       .collection('users')
       .doc(userModel?.userId??USERID)
       .collection("following").doc(followingId).set({"following":true})
       .then((value) async {


     userModel?.following=(userModel?.following??0)+1;
     anyUser?.followers=(anyUser?.followers??0)+1 ;
     iSFollowing=true;
         await FirebaseFirestore.instance.collection('users').doc(followingId)
             .collection("followers").doc(userModel?.userId).set({"followers":true})
         .then((value) {
           sendNotificationTo(title: "${userModel?.userName} . new follow ",
               imageUrl: '${userModel?.image}', body:"${userModel?.userName} .follow you now");
           emit(FollowState());

         });

   })
       .catchError((error){
     emit(FollowErrorState());
     print(error);
     print("error following");
   });
 }

int? followers=0;
 int?following=0;
 getFollowerCount({required String? userId,}){
   FirebaseFirestore.instance.collection("users").doc(userId).collection("followers").get().then((value) {
     followers=value.docs.length;
     FirebaseFirestore.instance
         .collection('users')
         .doc(userId).update({'followers':value.docs.length}).then((value) {
       print("updated followers");
     });;
   });
   FirebaseFirestore.instance.collection("users").doc(userId).collection("following").get().then((value) {
     following=value.docs.length;
     FirebaseFirestore.instance
         .collection('users')
         .doc(userId).update({'following':value.docs.length}).then((value) {
           print("updated following");
     });
   });
 }
  unFollow({required String? followingId})async{
   print(" un follow start");
    FirebaseFirestore.instance.collection('users').doc(userModel?.userId??USERID).collection('following').doc(followingId).delete()
        .then((value) {
      FirebaseFirestore.instance.collection('users').doc(followingId).collection('followers').doc(userModel?.userId??USERID).delete()
          .then((value) {
        userModel?.following=(userModel?.following??1) -1;
        anyUser?.followers=(anyUser?.followers??1) -1;
        iSFollowing=false;
        print("unfollowing");
        emit(UnFollowState());
      }).catchError((error){
        emit(UnFollowErrorState());
        print("error unfollowing");
        print(error);
      });

    }).catchError((error){
      emit(UnFollowErrorState());
      print("error unfollowing");
      print(error);
    });
  }
  removeSplash (){
    Future.delayed(const Duration(seconds: 3));
   FlutterNativeSplash.remove();}
}