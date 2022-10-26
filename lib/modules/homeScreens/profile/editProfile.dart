import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';
import 'package:hiddenmind/modules/homeScreens/profile/profile.dart';
import 'package:hiddenmind/shared/componant/constant.dart';
import '../../../shared/componant/componant.dart';

class EditProfile extends StatelessWidget {
    EditProfile({Key? key}) : super(key: key);
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        navigatfinished(context, Profile(userId:USERID));
        return true ;
      },
      child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if(state is GetDataSuccess){
              showtoast(text: 'success update', state: toastStates.SUCESS);
              HomeCubit.get(context).profile=null;
              HomeCubit.get(context).cover=null;
            }
            if(state is UpDateLinksError){
              showtoast(text: 'cant update Image link  ', state: toastStates.WARRING);
            }
            if(state is UpDateError){
              showtoast(text: 'cant update  try again', state: toastStates.ERROR);
            }

          },
          builder: (context, state) {

            var userData = HomeCubit.get(context).userModel;
            var cubit = HomeCubit.get(context);
            nameController.text = userData?.userName ?? '';
            bioController.text = userData?.bio ?? '';
            phoneController.text=userData?.phone??'';
            return SafeArea(
              top: true,
              child: Scaffold(
                  body: Stack(
                    children: [
                      Column(
                children: [
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: cubit.cover==null? NetworkImage('${cubit.userModel?.backgroundImage}')
                                                    :FileImage((cubit.cover)!) as ImageProvider,
                                            )),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white30,
                                              child: IconButton(
                                                onPressed: () {
                                                  cubit.getCoverImage();
                                                },
                                                icon: Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.black54,
                                                ),
                                              ))),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: SizedBox(
                                    height: 25,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: OutlinedButton(
                                          onPressed: ()async {
                                            cubit.uploadImageUrl();

                                              print("updated");
                                              cubit.upDateUser(name: nameController.text,bio:bioController.text);

                                            print("name and bio");
                                           // }
                                          },
                                          child: Text("Save"),
                                        )),
                                  ),
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
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 33,
                                        backgroundImage: cubit.profile == null
                                            ? NetworkImage(
                                                '${cubit.userModel?.image}')
                                            : FileImage((cubit.profile)!)
                                                as ImageProvider,
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white30,
                                              child: IconButton(
                                                onPressed: () {
                                                  cubit.getProfileImage();
                                                },
                                                icon: Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.black54,
                                                ),
                                              ))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              SizedBox(
                                height: 44,
                                child: DefaultformFild(
                                  prefix: Icons.person_outline,
                                    controller: nameController,
                                    type: TextInputType.text,
                                    isPassword: false,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return "name can't be empty";
                                      }
                                      return null;
                                    },
                                    label: nameController.text ?? "name"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 44,
                                child: DefaultformFild(
                                    prefix: Icons.short_text_outlined,
                                    controller: bioController,
                                    type: TextInputType.text,
                                    isPassword: false,
                                    validate: (value) {
                                      return null;
                                    },
                                    label: "${bioController.text}" ?? "bio"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 44,
                                child: DefaultformFild(
                                    prefix: Icons.phone,
                                    controller: phoneController,
                                    type: TextInputType.number,
                                    isPassword: false,
                                    validate: (value) {
                                      return null;
                                    },
                                    label: "${phoneController.text}" ?? "bio"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
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
                        child: IconButton(onPressed: (){
                          navigatfinished(context, Profile(userId: USERID,));
                        },icon: Icon(Icons.arrow_back_ios,color: Colors.black54,),),
                      ),
                    ],
                  ),
              ),
            );
          },
        ),
    );

  }
}

