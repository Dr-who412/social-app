import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hiddenmind/modules/homeScreens/chats/chatSearch.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/modules/homeScreens/feeds/createPost.dart';
import 'package:hiddenmind/modules/homeScreens/profile/profile.dart';
import 'package:hiddenmind/modules/login&signup/login.dart';
import 'package:hiddenmind/shared/shared_preference/cachHelper.dart';
import 'package:hiddenmind/shared/theme/colors.dart';

import '../../shared/componant/constant.dart';
import '../../shared/componant/componant.dart';

class Home extends StatelessWidget {
   Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: Container(
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
                    radius: 6,
                    backgroundImage: NetworkImage("${cubit.userModel?.image}")),
              ),
            ),
            title:custumAppbar(context:context,index:cubit.currentIndex),
            centerTitle: true,
            titleSpacing: 2,
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14))),
            actions: [
              SizedBox(
                width: 4,
              ),
              ISVERIFY != true
                  ? Container(
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.elliptical(30, 18))),
                      padding: EdgeInsets.all(3),
                      margin: EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                      child: Text(
                        "Please verify your email",
                        style:
                            TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
                      ))
                  : SizedBox(),
              ISVERIFY != true
                  ? IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.currentUser
                            ?.sendEmailVerification()
                            .then((value) {
                          showtoast(
                              text: "Check your mail",
                              state: toastStates.SUCESS);
                        }).catchError((error) {
                          print(error.toString());
                          showtoast(
                              text: error.toString(), state: toastStates.ERROR);
                        });
                      },
                      icon: Icon(Icons.info))
                  : SizedBox(),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(

                  currentAccountPicture: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      navigatto(context, Profile());
                    },
                    child: CircleAvatar(
                        radius: 6,
                        backgroundImage: NetworkImage("${cubit.userModel?.image}")),
                  ) ,
                  accountName:
                  Text('${cubit.userModel?.userName}',style: TextStyle(fontWeight: FontWeight.bold),),

                  accountEmail:                  Text('${cubit.userModel?.email}',style: TextStyle(color: Colors.white30),),
                ),
                Spacer(),
                InkWell(
                    onTap: ()async{
                      CacheHelper.removedata(key: 'userId').then((value) {
                        CacheHelper.removedata(key: 'isVerify');
                        USERID='';

                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('log out',style: TextStyle(color: Colors.white),),
                      ),
                      color: defeultColor,
                    ))
              ],
            ),
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                  //margin: EdgeInsets.only(bottom: 50),
                  child: cubit.Screens[cubit.currentIndex]),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 66,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(colors: [
                        Colors.white24,
                        Colors.white70,
                        Colors.white70,
                        Colors.white70,
                        Colors.white24,
                      ], transform: GradientRotation(60))),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: BottomNavigationBar(
                      onTap: (index) {
    if (index == HomeCubit.get(context).currentIndex && HomeCubit.get(context).currentIndex==3) {
      cubit.getChatsList();
    }
                        if (index == HomeCubit.get(context).currentIndex && HomeCubit.get(context).currentIndex==0) {

                          if(HomeCubit.get(context).flag){

                          cubit.getAllPost();}
                        }
    else cubit.ChangeNave(index);
                      },
                      elevation: 0.0,
                      currentIndex: cubit.currentIndex,
                      backgroundColor: Colors.transparent,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.home_outlined),
                            activeIcon: Icon(Icons.home),
                            label: 'Home'),
                        BottomNavigationBarItem(
                            icon: Icon(
                              Icons.search_sharp,
                            ),
                            label: 'Search',
                            activeIcon: Icon(Icons.search_rounded)),
                        BottomNavigationBarItem(
                            icon:  Icon(Icons.notifications_none),
                            activeIcon:Icon(Icons.notifications),
                            label: 'Notification'),
                        BottomNavigationBarItem(
                          icon:   Icon(Icons.mail_outline),
                              activeIcon:Icon(Icons.mail),
                          label: 'Chats',
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 64.0),
            child: FloatingActionButton(
                onPressed: () {
                  navigatto(context, CreatePost());
                },
                child: Icon(Icons.add)),
          ),
        );
      },
    );
  }
}
