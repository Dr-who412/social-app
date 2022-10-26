import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/layou/home_layout/home.dart';
import 'package:hiddenmind/modules/homeScreens/cubit/cubit.dart';
import 'package:hiddenmind/modules/login&signup/cubit/cubit.dart';
import 'package:hiddenmind/modules/login&signup/cubit/states.dart';
import 'package:hiddenmind/modules/login&signup/register.dart';
import 'package:hiddenmind/shared/componant/componant.dart';
import 'package:hiddenmind/shared/componant/constant.dart';
import 'package:hiddenmind/shared/shared_preference/cachHelper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:hiddenmind/shared/theme/colors.dart';
import '../../shared/componant/constant.dart';

class Login extends StatelessWidget {
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var formKay = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => LoginCubit()..removeSplash(),
  child: BlocConsumer<LoginCubit,LoginStates>(
      listener: (BuildContext context, state) {
        if(state is LoginErrorState){
          showtoast(text: state.error, state: toastStates.ERROR);
        }
        if(state is LoginsuccessState){
          CacheHelper.saveData(key:"userId", value: state.userId).then((value){
                USERID=state.userId;
                showtoast(text: "login", state: toastStates.SUCESS);
                navigatfinished(context, Home());
              }).catchError((error){
            showtoast(text: error, state: toastStates.ERROR);
          });

        }

      },
      builder: (BuildContext context, LoginStates) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    key: formKay,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("LOGIN",
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: defeultColor,fontWeight: FontWeight.bold,fontSize: 24,)),
                        Text("  Login  now and get new frinds",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey,)),
                        const SizedBox(
                          height: 20.0,
                        ),
                        DefaultformFild(
                          controller: emailcontroller,
                          label: "Email",
                          isPassword: false,
                          type: TextInputType.text,
                          prefix: Icons.person,
                          validate: (value) {
                            if (value.isEmpty) {
                              return "email can't be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        DefaultformFild(
                            controller: passwordcontroller,
                            type: TextInputType.visiblePassword,
                            isPassword: LoginCubit.get(context).isVisible,
                            prefix: Icons.lock,
                            suffix: LoginCubit.get(context).passIcon,
                            suffixfun: () {
                              LoginCubit.get(context).visibalPass();
                            },
                            onsubmit: (value) {
                              if (formKay.currentState!.validate()) {
                                LoginCubit.get(context).userLogIn(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text);
                              }
                            },
                            validate: (value) {
                              if (value.isEmpty) {
                                return "Password is short";
                              }
                              return null;
                            },
                            label: "Password"),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: LoginStates is! LoginLoadingState,
                          builder: (BuildContext context) {
                            return defultButton(
                              context: context,
                              onpressed: () {
                                if (formKay.currentState!.validate()) {
                                  LoginCubit.get(context). userLogIn(
                                      email: emailcontroller.text,
                                      password: passwordcontroller.text);
                                }
                              },
                              text: "LOGIN",
                            );
                          },
                          fallback: (BuildContext context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Don't have an account ?"),
                            defultTextButton(
                                onpressed: () {
                                  navigatto(context, Register());
                                },
                                text: "SIGN UP"),
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        );
      },
    ),
);
  }
}
