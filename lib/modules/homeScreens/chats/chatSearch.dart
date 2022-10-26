import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/modules/homeScreens/chats/massages.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/shared/componant/componant.dart';
import 'package:hiddenmind/shared/theme/colors.dart';
import 'package:lottie/lottie.dart';

class ChatSearch extends StatelessWidget {
  const ChatSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        HomeCubit.get(context).searchResult=[];
        return BlocConsumer<HomeCubit,HomeState>(
          listener: (context, state) {
            // TODO: implement listener

          },
          buildWhen: (prev,state){
            if(state is clearSearchState)
              return true;
            if(state is SearchEnd)
              return true;
            return false;
          },
          builder: (context, state) {
            var cubit=HomeCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: Container(
                  height: 34,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(24)
                  ),
                  child: TextFormField(
                    onTap: (){
                      cubit.getAllUsers();
                    },
                    onChanged: (value) {
                      if(value.trim().isNotEmpty){
                        print("value $value");
                        HomeCubit.get(context).search(searchList: HomeCubit.get(context).users, emailOrName: value);}
                      else{
                        HomeCubit.get(context).clearSearch();}
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
                centerTitle: true,
                actions: [
                  SizedBox(width: 80,),
                ],
                elevation: 0.0,
              ),

              body: ConditionalBuilder(
                condition:  cubit.searchResult.isNotEmpty,
                builder: (BuildContext context) => ListView?.separated(
                  physics: BouncingScrollPhysics(),
                  itemCount: cubit.searchResult.length,
                  itemBuilder:(context,int index) =>InkWell(
                    onTap: (){
                      navigatto(context, Messages(reciver:cubit.searchResult[index]));
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
                                  "${cubit.searchResult[index]?.image}")),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${cubit.searchResult[index]?.userName}',
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
                fallback: (BuildContext context) =>Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/empty.json',height: MediaQuery.of(context).size.height/5),
                      Text("can't found !",style: TextStyle(color: Colors.black26,fontWeight: FontWeight.bold,fontSize: 24),)
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
}
