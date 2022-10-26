import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiddenmind/layou/home_layout/home.dart';
import 'package:hiddenmind/modules/login&signup/cubit/cubit.dart';
import 'package:hiddenmind/modules/login&signup/cubit/states.dart';
import 'package:hiddenmind/shared/componant/componant.dart';
import 'package:hiddenmind/shared/componant/constant.dart';
import 'package:hiddenmind/shared/shared_preference/cachHelper.dart';
import 'package:hiddenmind/shared/theme/colors.dart';
import 'login.dart';
import '../../shared/componant/constant.dart';

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);
  var emailcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var phonecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var formKay = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, state) {
          if (state is SignupErrorState) {
            showtoast(text: state.error, state: toastStates.ERROR);
          }
          if (state is CreatesuccessState) {
            showtoast(text: "sign up done", state: toastStates.SUCESS);
            CacheHelper.saveData(key:"userId", value: state.userId).then(
                    (value) {
                      USERID=state.userId;
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
                          Text("SIGN Up",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: defeultColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  )),
                          Text("  Sign Up now and get new frinds ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.grey,
                                  )),
                          const SizedBox(
                            height: 20.0,
                          ),
                          DefaultformFild(
                            controller: namecontroller,
                            label: "name",
                            isPassword: false,
                            type: TextInputType.text,
                            prefix: Icons.person,
                            validate: (value) {
                              if (value.isEmpty) {
                                return "name can't be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          DefaultformFild(
                            controller: emailcontroller,
                            label: "Email",
                            isPassword: false,
                            type: TextInputType.text,
                            prefix: Icons.email_outlined,
                            validate: (value) {
                              if (value.isEmpty) {
                                return "email can't be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          DefaultformFild(
                            controller: phonecontroller,
                            label: "phone",
                            isPassword: false,
                            type: TextInputType.phone,
                            prefix: Icons.phone_android,
                            validate: (value) {
                              if (value.isEmpty) {
                                return "phone number can't be empty";
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
                                  LoginCubit.get(context).userSiginUp(
                                      email: emailcontroller.text,
                                      password: passwordcontroller.text,
                                      userName: namecontroller.text,
                                      phone: phonecontroller.text);
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
                            condition: LoginStates is! SignupLoadingState,
                            builder: (BuildContext context) {
                              return defultButton(
                                context: context,
                                onpressed: () {
                                  if (formKay.currentState!.validate()) {
                                    LoginCubit.get(context).userSiginUp(
                                      email: emailcontroller.text,
                                      password: passwordcontroller.text,
                                      phone: phonecontroller.text,
                                      userName: namecontroller.text,
                                    );
                                  }
                                },
                                text: "Sign up",
                              );
                            },
                            fallback: (BuildContext context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("already have an account?"),
                              defultTextButton(
                                  onpressed: () {
                                    navigatto(context, Login());
                                  },
                                  text: "LOGIN"),
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
