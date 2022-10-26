import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hiddenmind/modules/homeScreens/chats/chatSearch.dart';
import 'package:hiddenmind/modules/homeScreens/chats/massages.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/modules/homeScreens/feeds/comment.dart';
import 'package:hiddenmind/modules/homeScreens/profile/profile.dart';
import 'package:hiddenmind/shared/componant/constant.dart';
import 'package:lottie/lottie.dart';
import '../../shared/theme/colors.dart';


void navigatfinished(context, Widget widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false);
}

void navigatto(context, Widget widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

Widget custumAppbar({context,required int index}){
  List <Widget> title = [
    Image.asset("assets/Logo.png", height: 36,),
    Container(
      height: 34,
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(24)
      ),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.bottom,
        onTap: (){
          HomeCubit.get(context).getAllUsers();
        },
        onChanged: (value){
          if(value.trim().isNotEmpty){
            HomeCubit.get(context).search(searchList: HomeCubit.get(context).users, emailOrName: value);}
          else{
            HomeCubit.get(context).clearSearch();}
        },
        decoration: InputDecoration(
          prefix: SizedBox(width: 12,),
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white60,),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.0, color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          border: InputBorder.none,
        ),
      ),
    ),
    Text("Notification", style: TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: defeultColor),),
    Container(
      height: 34,
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(24)
      ),
      child: TextFormField(
        readOnly: true,
        onTap: (){
          print("search");
          navigatto(context, ChatSearch());
        },
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          prefix: SizedBox(width: 12,),
          hintText: 'Search for chats',
          hintStyle: TextStyle(color: Colors.white60,),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.0, color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          border: InputBorder.none,
        ),
      ),
    ),
  ];
  return title[index];
}
Widget DefaultformFild({
  required TextEditingController controller,
  required TextInputType type,
  required bool isPassword,
  onsubmit,
  onChange,
  onTap,
  required validate,
  required String label,
  IconData? prefix,
  IconData? suffix,
  suffixfun,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onsubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      maxLines: 1,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        fillColor: Colors.black12,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0, color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        // label: Text(label),
        hintText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(onPressed: suffixfun, icon: Icon(suffix)),
      ),
    );
Widget defultButton({
  context,
  required onpressed,
  required String text,
}) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: defeultColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextButton(
        onPressed: onpressed,
        child: Text(text,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.white,
                )),
      ),
    );
Widget defultTextButton({
  context,
  required onpressed,
  required String text,
}) =>
    TextButton(
      onPressed: onpressed,
      child: Text(
        text,
        style: TextStyle(color: defeultColor),
      ),
    );
void showtoast({required String text, required toastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: toastColor(state: state),
        textColor: Colors.white,
        fontSize: 16.0);

enum toastStates { ERROR, WARRING, SUCESS }

Color? toastColor({toastStates? state}) {
  Color? color;
  switch (state) {
    case toastStates.ERROR:
      color = Color.fromRGBO(245, 3, 3, 0.6470588235294118).withOpacity(.4);
      break;
    case toastStates.SUCESS:
      color = defeultColor.withOpacity(.4);
      break;
    case toastStates.WARRING:
      color = Color.fromRGBO(245, 196, 1, 0.6980392156862745).withOpacity(.4);
      break;
  }
  return color;
}

Widget profilrAvater({
  required BuildContext context,
  double? redius = 6.0,
  UserId,
}) =>
    Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          navigatto(context, Profile(userId: USERID,));
        },
        child: CircleAvatar(
            radius: redius,
            backgroundImage: NetworkImage(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLi1v1tFX7Ua4zCY_Bl2Fde8zMmNLG4re9XQ&usqp=CAU")),
      ),
    );
Widget avater({required BuildContext context, required String? imageUrl,required String? userId })=>Container(
margin: EdgeInsets.only(top: 2, left: 4, right: 1),
padding: EdgeInsets.zero,
decoration: BoxDecoration(
shape: BoxShape.circle,
),
child: InkWell(
borderRadius: BorderRadius.circular(25),
onTap: () {
  HomeCubit.get(context).iSFollowing=false;
  HomeCubit.get(context).isFollower=false;
  HomeCubit.get(context).toChat=false;
    navigatto(context, Profile(userId:userId));

},
child: Card(
elevation: 5.0,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(25),
),
child: CircleAvatar(
radius: 18, backgroundImage: NetworkImage("${imageUrl}")),
),
),
);
Widget PostDefeult(
  BuildContext context, {
  required String? ownerId,
  required String? name,
  required String? image,
  required String? text,
  required String? postImage,
  required String? postDate,
  required int? index,
}){

return
    Container(
      margin: EdgeInsets.only(top: 2),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avater(context: context,imageUrl: image,userId: ownerId),
//  SizedBox(width: 2,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "$name",
                                          style: TextStyle(
                                            height: 1.3,
                                          ),
                                        ),
                                        Icon(
                                          Icons.verified,
                                          color: Colors.blue,
                                          size: 12,
                                        ),
                                        Spacer(),
                                        TextButton(
                                            onPressed: () {
                                              print('ok');
                                            },
                                            style: ButtonStyle(
                                              alignment: Alignment.topCenter,
                                            ),
                                            child: Icon(
                                              Icons.more_vert,
                                              size: 14,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Text("$postDate",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            ?.copyWith(
                                              height: 1.3,
                                            )),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  text != ''
                                      ? Text(
                                          '$text',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              ?.copyWith(
                                                height: 1.3,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                            fontSize: MediaQuery.of(context).size.width/36,

                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      postImage != ''
                          ? Card(
                              elevation: 5.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: 0.0, //minimum height
                                  minWidth: 0.0, // minimum width
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 2,
                                  //maximum height set to 100% of vertical height
                                  maxWidth: double.infinity,
                                  //maximum width set to 100% of width
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: SizedBox.fromSize(
                                    child: Image.network(
                                      '$postImage',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ))
                          : SizedBox(),
                    ],
                  ),

                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
            if(ownerId!=HomeCubit.get(context).userModel?.userId)  BlocListener<HomeCubit, HomeState>(
                  listener: (context, state) {
                  // TODO: implement listener}

                    if(state is GetAnyUserDataSuccess) {
                      if(HomeCubit.get(context).toChat) {
                        navigatfinished(
                            context,
                            Messages(
                              reciver: HomeCubit
                                  .get(context)
                                  .anyUser,
                            ));
                      }
                    }

                },
                child:IconButton(
                  icon: Icon(Icons.send_outlined,color: defeultColor,                        size: 16,
                  ),
                  onPressed: (){
                    print("chat this user");
                    if(ownerId!=USERID){
                      HomeCubit.get(context).toChat=true;
                      HomeCubit.get(context).getAnyUSerData(userId: ownerId);}
                  },
                )
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    // a show all comments
                    navigatto(
                        context,
                        Comment_sc(
                          index,
                          ownerId,
                          postDate,
                          postImage,
                          text,
                          image,
                          name,
                        ));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.mode_comment_outlined,
                        size: 16,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${HomeCubit.get(context).comments[index!] ?? 0}",
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                width: 60,
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  var cubit = HomeCubit.get(context);
                  return TextButton(
                      onPressed: () {
                        cubit.clickedLike = index;
                        print(cubit.postLikes['${cubit.postId[index]}']);
                        cubit.postLikes['${cubit.postId[index]}'] == true
                            ? cubit.removeLike(cubit.postId[index], index)
                            : cubit.pushLike(cubit.postId[index], index);
                      },
                      child: Container(
                        height: 32,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HomeCubit.get(context).postLikes[
                                        '${HomeCubit.get(context).postId[index]}'] ==
                                    true
                                ? Icon(
                                    Icons.favorite,
                                    size: 16,
                                    color: Colors.red,
                                  )
                                : state is LikeLoadingState &&
                                        index ==
                                            HomeCubit.get(context).clickedLike
                                    ? Lottie.asset('assets/like.json',
                                        height: 32)
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 12,
                                        color: Colors.black26,
                                      ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${HomeCubit.get(context).likes['${HomeCubit.get(context).postId[index]}'] >= 0 ? HomeCubit.get(context).likes['${HomeCubit.get(context).postId[index]}'] : 0}",
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
              SizedBox(
                width: 60,
              ),
            ],
          ),
          Divider(
            color: Colors.black26,
            height: 1,
          )
        ],
      ),
    );}
Widget commentDefeult(
  BuildContext context, {
  required ownerId,
  required String? name,
  required String? image,
  required String? text,
  required String? postowner,
  //  required String? mention,
  required String? postImage,
  required String? postDate,
  required int? index,
}) =>
    Container(
      margin: EdgeInsets.only(top: 2),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avater(context: context,imageUrl: image,userId: ownerId),
//  SizedBox(width: 2,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "$name",
                              style: TextStyle(
                                height: 1.3,
                              ),
                            ),
                            Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 12,
                            ),
                            Spacer(),
                            TextButton(
                                onPressed: () {
                                  print('ok');
                                },
                                style: ButtonStyle(
                                  alignment: Alignment.topCenter,
                                ),
                                child: Icon(
                                  Icons.more_vert,
                                  size: 14,
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "replay to ",
                              style: TextStyle(
                                height: 1.3,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "@$postowner",
                              style: TextStyle(
                                height: 1.3,
                                color: Colors.blue,
                              ),
                            ),
                            Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text("$postDate",
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      height: 1.3,
                                    )),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      text != ''
                          ? Text(
                              '$text',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    height: 1.3,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.width/36,
                                  ),
                            )
                          : SizedBox(),
                      postImage != ''
                          ? Card(
                              elevation: 5.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '$postImage',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTapDown: (v) {
                    print("object");
                  },
                  child: Container(
                    width: 25,
                    height: 12,
                    child: Card(
                      elevation: 2.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.black26,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                ),
                TextButton(
                    onPressed: () {
                      // a show all comments
                      navigatto(
                          context,
                          Comment_sc(
                            index,
                            ownerId,
                            postDate,
                            postImage,
                            text,
                            image,
                            name,
                          ));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.mode_comment_outlined,
                          size: 12,
                          color: Colors.black26,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${0}",
                          style: TextStyle(
                            color: Colors.black26,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: 60,
                ),
                TextButton(
                    onPressed: () {
                      // HomeCubit.get(context)
                      //     .pushLike(HomeCubit.get(context).postId[index]);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 12,
                          color: Colors.black26,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${'0'}",
                          style: TextStyle(
                            color: Colors.black26,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: 60,
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.black26,
            height: 1,
          )
        ],
      ),
    );
Widget message({
  required BuildContext context,
  required String? message,
  required bool isRecived,
  required String? imageUrl
}) =>
    Align(
      alignment: isRecived ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment:
            isRecived ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          SizedBox(height: 18,),
          if(imageUrl!='')defeultImage(context: context, imageUrl: imageUrl)else SizedBox(),
          if(message!.isNotEmpty)Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: isRecived ?  Colors.black12
              : defeultColor,
            ),
            constraints: BoxConstraints(
              minHeight: 0.0, //minimum height
              minWidth: 0.0, // minimum width
              //maxHeight: MediaQuery.of(context).size.height/2,
              //maximum height set to 100% of vertical height
              maxWidth: double.infinity,
              //maximum width set to 100% of width
            ),
            margin: EdgeInsets.only(
                left: isRecived ? 18 : MediaQuery.of(context).size.width / 5,
                top: 18,
                right: isRecived ? MediaQuery.of(context).size.width / 5 : 18),
            child: Text(
              '$message',
              style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height/58),
            ),
          )else SizedBox(),
          Container(
              margin: EdgeInsets.only(
                right: isRecived ? 0 : 8,
                left: isRecived ? 8 : 0,
              ),
              child: Row(
                mainAxisAlignment:
                    isRecived ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  Text(
                    '20:10 Am',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  isRecived
                      ? SizedBox()
                      : Icon(
                          Icons.check,
                          color: Colors.black38,
                          size: 14,
                        ),
                ],
              )),
        ],
      ),
    );
Widget defeultImage({required BuildContext context,required imageUrl})=>Card(
elevation: 5.5,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(15.0),
),
child: Container(
constraints: BoxConstraints(
minHeight: 0.0, //minimum height
minWidth: 0.0, // minimum width
maxHeight:
MediaQuery.of(context).size.height / 2,
//maximum height set to 100% of vertical height
maxWidth: double.infinity,
//maximum width set to 100% of width
),
child: ClipRRect(
borderRadius: BorderRadius.circular(15.0),
child: SizedBox.fromSize(
child: Image.network(
'$imageUrl',
fit: BoxFit.contain,
  errorBuilder: (BuildContext context,
      Object exception, StackTrace? stackTrace) {
    return Icon(Icons.image_outlined);
  },
  loadingBuilder: (BuildContext context, Widget child,
      ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }

    return CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes !=
          null
          ? loadingProgress
          .cumulativeBytesLoaded /
          loadingProgress.expectedTotalBytes!
          : null,
    );
  },
),
),
),
));
