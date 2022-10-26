import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/modules/homeScreens/chats/massages.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/shared/componant/componant.dart';
import 'package:hiddenmind/shared/theme/colors.dart';
import 'package:lottie/lottie.dart';
class Chats extends StatelessWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Builder(
      builder: (context) {
        HomeCubit.get(context).getChatsList();
        return BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              // TODO: implement listener
              if(state is GetUsersChatSuccessState){
              //  HomeCubit.get(context).chatsUsers.toSet();
              }
              print(state);
            },
            builder: (context, state) {
              var cubit=HomeCubit.get(context);
              return ConditionalBuilder(
                condition:cubit.chatsUsers.isNotEmpty ,
                builder: (BuildContext context) => ListView?.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: cubit.chatsUsers.length,
                  itemBuilder:(context,int index) =>InkWell(
                    onTap: (){
                      navigatto(context, Messages(reciver:cubit.chatsUsers[index]));
                    },
                    splashColor: defeultColor,

                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(
                                  "${cubit.chatsUsers[index]?.image}")),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${cubit.chatsUsers[index]?.userName}',
                                  style: TextStyle(
                                    height: 1.3,
                                  ),),
                                SizedBox(width: 2,),
                                Text('.7min',
                                  style: TextStyle(
                                    height: 1.3,color: Colors.black26,
                                  ),),
                              ],
                            ),
                            Text('last massage',
                              style: TextStyle(
                                height: 1.3,color: Colors.black26,
                              ),),
                          ],
                        )
                      ],
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const Divider(),),
                fallback: (BuildContext context) =>Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/empty.json',height: MediaQuery.of(context).size.height/5),
                  Text("ChatsBox empty",style: TextStyle(color: Colors.black26,fontWeight: FontWeight.bold,fontSize: 24),)
                ],
              )

              );
            },
);
      }
    );
  }
}
