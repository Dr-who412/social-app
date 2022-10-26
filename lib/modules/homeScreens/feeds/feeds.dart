import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/shared/componant/componant.dart';

class Feeds extends StatelessWidget {
   Feeds({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
         //HomeCubit.get(context).getAllPost();
        return BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          buildWhen: (prev,state){
            if(state is GetHomeSuccess)return true;
            if(state is PostingSuccess)return true;
            return false;
          },
          builder: (context, state) {
            var cubit = HomeCubit.get(context);
            cubit.postComment=[];
            return ConditionalBuilder(
              condition:cubit.posts.isNotEmpty ,
              builder: (context) =>  ListView.builder(
                padding: EdgeInsets.only(bottom: 80),
                  reverse: true,
                  primary: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: cubit.posts.length,
                  itemBuilder: (context,index)=>PostDefeult(context,
                    index:index,name: cubit.posts[index]?.userName,image:cubit.posts[index]?.image
                    ,text: cubit.posts[index]?.text,postImage: cubit.posts[index]?.postImage,postDate: cubit.posts[index]?.postDate,ownerId: cubit.posts[index]?.userId)
              ),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            );
          },
        );
      }
    );
  }
}
