import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../../models/signUpModel.dart';
import 'package:bloc/bloc.dart';
import 'package:hiddenmind/modules/login&signup/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit():super(LoginInitState());
  static LoginCubit get(context)=>BlocProvider.of(context);

 IconData passIcon=Icons.visibility_outlined;
  bool isVisible=true;

  void visibalPass(){
    isVisible=!isVisible;
    passIcon= isVisible ?Icons.visibility_outlined :Icons.visibility_off_outlined;
    emit(visibiltyChange());
  }
 void userSiginUp({
  required String? userName,
   required String email ,
   required String? phone,
   required String password,
 })async{
    emit(SignupLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,)
        .then(
            (value) {
              print(value.user?.uid);
              userCreate(email: email, userName: userName, phone: phone, userId: value.user?.uid,);
            }
    ).catchError((error){
      print("error signUp${error.toString()}");
      emit(SignupErrorState(error.toString()));
    });

 }
  void userLogIn({
    required String email ,
    required String password,
  })async{
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
        .then(
            (value) {
          emit(LoginsuccessState(value.user?.uid,));
        }
    ).catchError((error){
      print("error signUp${error.toString()}");
      emit(LoginErrorState(error.toString()));
    });

  }
userCreate({
    required String? email,
  required String? userName,
  required String? phone,
  required String? userId,
}){

UserModel? userSignUp=UserModel(userName: userName,email: email,
    userId: userId,
    phone: phone,
    bio: '',
    backgroundImage: 'https://images.unsplash.com/photo-1605710345595-9929bc7912ca?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGxhaW4lMjBibGFja3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60' ,
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLi1v1tFX7Ua4zCY_Bl2Fde8zMmNLG4re9XQ&usqp=CAU',
    followers: 0,
    following: 0,
    isVerify: false);
  FirebaseFirestore.instance.collection("users").doc(userId).set(
userSignUp.toMap()
  ).then((value) {
    emit(CreatesuccessState(userId));
  }).catchError((error){
    print("error creat:${error.toString()}");
    emit(CreateErrorState(error));
  });

}
  removeSplash (){
    Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();}
}