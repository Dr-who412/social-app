import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/shared/theme/colors.dart';
import 'package:lottie/lottie.dart';
class CreatePost extends StatefulWidget {
  CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
var postController=TextEditingController();
bool  isRelease=false;
  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<HomeCubit, HomeState>(
  listener: (context, state) {
    // TODO: implement listener
    if(state is PickPostImageSuccess){
      isRelease=true;
    }
    if(HomeCubit.get(context).post!=null){
      isRelease=true;
    }
    if(state is PostingSuccess){
      Navigator.pop(context);
      HomeCubit.get(context).removePostImage();
    }
  },
  builder: (context, state) {

    var cubit=HomeCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('New hidden things',style: Theme.of(context).textTheme.titleLarge,),
        actions: [
          state is PostingLoadingState
              ?Container(
            margin: EdgeInsets.all(12),
            child: Lottie.asset(
              'assets/loading.json',width: 60,),
          )
              :Container(
            margin: EdgeInsets.all(12),
              width: 60,
              decoration: BoxDecoration(color: isRelease?defeultColor:defeultColor.withOpacity(.6),
              borderRadius: BorderRadius.circular(18)
              ),
              child: isRelease?TextButton(onPressed: (){

               if(postController.text.isNotEmpty||cubit.post!=null)
                if(cubit.post==null){
                  cubit.uploadpost(text: postController.text, postImage: '');
                }
                if(cubit.post!=null){
                  cubit.uploadPostImage(text: postController.text);
                }
              },
                child: Text('release',style: TextStyle(color: Colors.white),),
                clipBehavior: Clip.hardEdge,)
                  :Center(child: Text('release',style: TextStyle(color: Colors.white),))
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 2),
          width: double.infinity,
          height: MediaQuery.of(context).size.height-130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(state is PostingLoadingState)
                LinearProgressIndicator(color: defeultColor,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 2,left: 4,right: 1),
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {

                        },
                        child: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage("${cubit.userModel?.image}")),
                      ),
                    ),
                      SizedBox(width: 5,),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height:250,
                                child: TextField(
                                  controller:postController ,
                                 onChanged: (value){
                                   if(cubit.post==null){
                                    if (value.isNotEmpty&&value!=''){
                                      setState((){
                                      isRelease=true;});
                                    }else{
                                      setState((){
                                        isRelease=false;});
                                    }
                                    if(postController.text.length==0){
                                      isRelease=false;
                                    }
                                   }else{
                                     setState((){
                                       isRelease=true;});
                                   }
                                 },
                                 // expands: true,
                                  decoration: InputDecoration(
                                    hintText: 'what${"'"}s heddin now ?',
                                    label: null,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.only(bottom: 195.0,top: 20 ),
                                    border: InputBorder.none,
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
              Expanded(
                child: cubit.post!=null?  Center(
                  child: Stack(
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
                            maxHeight: MediaQuery.of(context).size.height / 2,
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
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            backgroundColor: Colors.white54,
                            child: TextButton(onPressed: (){
                              cubit.removePostImage();

                            }, child: Text('X',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black26),))),
                      )
                    ],
                  ),
                ):SizedBox(),
              ),

            ],
          ),

        ),
      ),
      bottomNavigationBar:   Row(
        children: [
          SizedBox(width: 20,),
          Expanded(child: TextButton(
              onPressed: (){
                cubit.getPostImage();
              }, child: Row(
            children: [
              Icon(Icons.image),
              SizedBox(width: 4,),
              Text('add photo'),
            ],
          ))),

          Expanded(child: TextButton(onPressed: (){}, child:
          Text('# tags'),
          )),


        ],
      ),
    );
  },
);
  }
}
