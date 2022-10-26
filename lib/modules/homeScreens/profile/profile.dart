import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/layou/home_layout/home.dart';
import 'package:hiddenmind/models/signUpModel.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/modules/homeScreens/profile/editProfile.dart';
import 'package:hiddenmind/shared/componant/componant.dart';
import 'package:hiddenmind/shared/componant/constant.dart';
import 'package:hiddenmind/shared/theme/colors.dart';

class Profile extends StatelessWidget {
  final String? userId;

  Profile({Key? key, this.userId}) : super(key: key);
  UserModel? user;
  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {

        HomeCubit.get(context).getFollowerCount(userId: userId);

        return Builder(

          builder: (context) {
            if (userId != USERID) {

              HomeCubit.get(context).getAnyUSerData(userId: userId);
              user = HomeCubit.get(context).anyUser;
            } else {
              user = HomeCubit.get(context).userModel;
            }
            return BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  // TODO: implement listener

                  if (state is GetAnyUserDataSuccess) {
                    user = HomeCubit.get(context).anyUser;
                  }
                },
                buildWhen: (prev,state){
                  if(state is GetDataSuccess) return true;
                  return true;
                },
                builder: (context, state) {
                  var cubit = HomeCubit.get(context);
                  print("following  ${cubit.iSFollowing}");
                  return WillPopScope(
                    onWillPop: ()async{
                      navigatfinished(context, Home());
                      return true;
                    },
                    child: SafeArea(
                      top: true,
                      left: true,
                      right: true,
                      child: Scaffold(
                        body: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          '${user?.backgroundImage}'),
                                                    )),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              height: 25,
                                              margin:
                                                  EdgeInsets.symmetric(horizontal: 16.0),
                                              child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      if (user?.userId == USERID) {
                                                        HomeCubit.get(context).profile =
                                                            null;
                                                        HomeCubit.get(context).cover =
                                                            null;
                                                        navigatfinished(context, EditProfile());
                                                      } else {
                                                        //follow fun
                                                        print(userId);
                                                        print('${cubit.iSFollowing}');
                                                        print('${cubit.isFollower}');
                                                        cubit.iSFollowing==true?cubit.unFollow(followingId: userId??user?.userId)
                                                            :cubit.follow(followingId: user?.userId??userId);
                                                      }
                                                    },
                                                    child: user?.userId == USERID
                                                        ? Text("Edit Profile")
                                                        : BlocBuilder<HomeCubit,
                                                            HomeState>(
                                                            buildWhen: (prev, state) {
                                                              if (state is FollowState) {
                                                                return true;
                                                              }
                                                              if (state
                                                                  is UnFollowState) {
                                                                return true;
                                                              }
                                                              if (state
                                                                  is GetAnyUserDataSuccess) {
                                                                return true;
                                                              }
                                                              return false;
                                                            },
                                                            builder: (context, state) {
                                                              return cubit.iSFollowing
                                                                  ? Text("following")
                                                                  : Text("follow");
                                                            },
                                                          ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 8,
                                            ),
                                            child: CircleAvatar(
                                                radius: 34,
                                                backgroundColor: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                child: CircleAvatar(
                                                  radius: 33,
                                                  backgroundImage:
                                                      NetworkImage('${user?.image}'),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.zero,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //SizedBox(height: 28),
                                        Row(
                                          children: [
                                            Text(
                                              user?.userName ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(fontSize: 18),
                                            ),
                                            Spacer(),
                                      cubit.isFollower==true?Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text("follows you",style: TextStyle(color: defeultColor.withOpacity(.6),fontWeight: FontWeight.bold),),
                                            ):SizedBox(),
                                            Spacer(flex: 3,)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${user?.bio}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        BlocBuilder<HomeCubit, HomeState>(
                                          buildWhen: (prev, state) {
                                            if (state is FollowState) {
                                              return true;
                                            }
                                            if (state is UnFollowState) {
                                              return true;
                                            }
                                            return false;
                                          },
                                          builder: (context, state) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${user?.following??0}",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: defeultColor),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Following",
                                                    style: TextStyle(color: Colors.grey)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  "${user?.followers??0}",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: defeultColor),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Followers",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 26,
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white30,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  navigatfinished(context,Home());
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        );
      }
    );
  }
}
