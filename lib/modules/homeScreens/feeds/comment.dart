import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/layou/home_layout/home.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/shared/componant/componant.dart';
import 'package:hiddenmind/shared/theme/colors.dart';
import 'package:lottie/lottie.dart';

class Comment_sc extends StatefulWidget {
  final index;
  final ownerId;
  final name;
  final image;
  final text;
  final postImage;
  final postDate;
  Comment_sc(
    this.index,
    this.ownerId,
    this.postDate,
    this.postImage,
    this.text,
    this.image,
    this.name,

  );

  @override
  State<Comment_sc> createState() => _Comment_scState();
}

class _Comment_scState extends State<Comment_sc> {
  @override

  var postController = TextEditingController();

  bool isRelease = false;

  @override
  void initState() {
    HomeCubit.get(context).getPostComments(widget.index);
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {

        // TODO: implement listener
        if (state is PickPostImageSuccess) {
          isRelease = true;
        }
        if (HomeCubit.get(context).post != null) {
          isRelease = true;
        }
        if (state is CommentSuccessState) {
          navigatfinished(context, Home());
          HomeCubit.get(context).removePostImage();
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Hidden',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            actions: [
              state is CommentLoadingState
                  ? Container(
                margin: EdgeInsets.all(12),
                    child: Lottie.asset(
                        'assets/loading.json',width: 60,),
                  )
                  :
              Container(
                      margin: EdgeInsets.all(12),
                      width: 60,
                      decoration: BoxDecoration(
                          color: isRelease
                              ? defeultColor
                              : defeultColor.withOpacity(.6),
                          borderRadius: BorderRadius.circular(18)),
                      child: isRelease
                          ? TextButton(
                              onPressed: () {
                                if (postController.text.isNotEmpty ||
                                    cubit.post !=
                                        null) if (cubit.post == null) {
                                  cubit.pushComment(
                                      postid: cubit.postId[widget.index],
                                      text: postController.text,
                                      postImage: '',
                                  postIndex: widget.index,
                                  );
                                }
                                if (cubit.post != null) {
                                  cubit.uploadReplayWithImage(
                                    postId: cubit.postId[widget.index],
                                    text: postController.text,
                                    postIndex: widget.index,

                                  );
                                }
                              },
                              child: Text(
                                'replar',
                                style: TextStyle(color: Colors.white),
                              ),
                              clipBehavior: Clip.hardEdge,
                            )
                          : Center(
                              child: Text(
                              'replay',
                              style: TextStyle(color: Colors.white),
                            ))),
            ],
          ),
          body: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 2,),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (state is CommentLoadingState)
                      LinearProgressIndicator(
                        color: defeultColor,
                      ),
                     PostDefeult(
                       context,
                       ownerId: widget.ownerId,
                       postDate: widget.postDate,
                       postImage: widget.postImage,
                       text: widget.text,
                       name: widget.name,
                       image: widget.image,
                       index: widget.index,
                     ),
                    SizedBox(height: 4,),
                    //list of replayes
                    Expanded(
                      child:ConditionalBuilder(
                        condition: (!(state is GetCommentLoadingState)?
                        cubit.postComment.length>0?true:false:false ),
                        builder: (context) =>  ListView.builder(
                              itemCount: cubit.postComment.length,
                              shrinkWrap: true,
                              itemBuilder: (context,index)=>Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: commentDefeult(  context,
                                  ownerId:cubit.postComment[index]?.userId ,
                                  postDate: cubit.postComment[index]?.postDate,
                                  postImage: cubit.postComment[index]?.postImage,
                                  text: cubit.postComment[index]?.text,
                                  name:cubit.postComment[index]?.userName,
                                  image: cubit.postComment[index]?.image,
                                  index: widget.index,
                                  postowner: widget.name,),
                              ),),

                        fallback: (context) => state is GetHomeLoadingHomeState?
                          Center(child: CircularProgressIndicator(color: defeultColor.withOpacity(.5),),):
                        cubit.postComment.length==0?Center(child: Lottie.asset('assets/empty.json')):
                        Center(child: Text("check network")),
                      ),
                    ),

                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  child: Container(
                    width: 52,
                    height: 12,
                    margin: EdgeInsets.all(10),
                    child: Card(
                      elevation: 2.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.black26,
                    ),
                  ),
                  onTap: () {
                    cubit.post=null;
                    print('Show bottom sheet');
                    showModalBottomSheet(
                        context: context,
                        elevation: 9.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                        ),
                        builder: (context) {
                          return Column(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 2, left: 4, right: 1),
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(25),
                                        onTap: () {},
                                        child: CircleAvatar(
                                            radius: 18,
                                            backgroundImage: NetworkImage(
                                                "${cubit.userModel?.image}")),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 4.0),
                                        child: SingleChildScrollView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment:Alignment.topRight,
                                                child:  state is CommentLoadingState
                                                    ? Lottie.network(
                                                    'https://assets8.lottiefiles.com/packages/lf20_fyye8szy.json')
                                                    : Container(
                                                    margin: EdgeInsets.all(12),
                                                    width: 60,
                                                    height:30,
                                                    decoration: BoxDecoration(
                                                        color: isRelease
                                                            ? defeultColor
                                                            : defeultColor.withOpacity(.6),
                                                        borderRadius: BorderRadius.circular(18)),
                                                    child: isRelease
                                                        ? TextButton(
                                                      onPressed: () {
                                                        if (postController.text.isNotEmpty ||
                                                            cubit.post !=
                                                                null) if (cubit.post == null) {
                                                          cubit.pushComment(
                                                              postid: cubit.postId[widget.index],
                                                              text: postController.text,
                                                              postImage: '',
                                                            postIndex: widget.index,
                                                          );
                                                        }
                                                        if (cubit.post != null) {
                                                          cubit.uploadReplayWithImage(
                                                            postId: cubit.postId[widget.index],
                                                            text: postController.text,
                                                            postIndex: widget.index,
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        'replar',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      clipBehavior: Clip.hardEdge,
                                                    )
                                                        : Center(
                                                        child: Text(
                                                          'replay',
                                                          style: TextStyle(color: Colors.white),
                                                        ))),
                                              ),
                                              Container(
                                                //height:250,
                                                child: TextField(
                                                  controller:
                                                      postController,
                                                  onChanged: (value) {
                                                    if (cubit.post ==
                                                        null) {
                                                      if (value
                                                              .isNotEmpty &&
                                                          value != '') {
                                                        setState(() {
                                                          isRelease = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          isRelease = false;
                                                        });
                                                      }
                                                      if (postController
                                                              .text
                                                              .length ==
                                                          0) {
                                                        isRelease = false;
                                                      }
                                                    } else {
                                                      setState(() {
                                                        isRelease = true;
                                                      });
                                                    }
                                                  },
                                                  // expands: true,
                                                  decoration:
                                                      InputDecoration(
                                                    hintText:
                                                        'what${"'"}s your heddin about this ?',
                                                    label: null,
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .only(
                                                            bottom: 195.0,
                                                            top: 20),
                                                    border:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded( child:cubit.post != null
                                  ? Stack(
                                      children: [
                                      Card(
                                      elevation: 5.5,
                                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                          minHeight: 0.0, //minimum height
                          minWidth: 0.0, // minimum width
                          maxHeight: MediaQuery.of(context).size.height / 5,
//maximum height set to 100% of vertical height
                          maxWidth: double.infinity,
//maximum width set to 100% of width
                          ),
                          child:  ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: SizedBox.fromSize(
                          child: Image.file(
                          (cubit.post)!,
                          fit: BoxFit.contain,
                          ),
                          ),
                          ),
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          ),
                          ),
                          ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.white54,
                                              child: TextButton(
                                                  onPressed: () {
                                                    cubit.removePostImage();
                                                  },
                                                  child: Text(
                                                    'X',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.black26),
                                                  ))),
                                        )
                                      ],
                                    )
                                  : SizedBox(),),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: TextButton(
                                          onPressed: () {
                                            cubit.getPostImage();
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.image),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text('add photo'),
                                            ],
                                          ))),
                                  Expanded(
                                      child: TextButton(
                                    onPressed: () {},
                                    child: Text('# tags'),
                                  )),
                                ],
                              ),
                            ],
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
