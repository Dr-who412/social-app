
abstract class LoginStates {}
class LoginInitState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginsuccessState extends LoginStates{
  final userId;
  LoginsuccessState(this.userId);
}
class LoginErrorState extends LoginStates{
  final error;
  LoginErrorState(this.error);
}
class visibiltyChange extends LoginStates{}

class SignupLoadingState extends LoginStates{

}
class SignupsuccessState extends LoginStates {
}
class SignupErrorState extends LoginStates{
  final error;
  SignupErrorState(this.error);
}

class CreatesuccessState extends LoginStates{
  final userId;
  CreatesuccessState(this.userId);
}
class CreateErrorState extends LoginStates{
  final error;
  CreateErrorState(this.error);
}