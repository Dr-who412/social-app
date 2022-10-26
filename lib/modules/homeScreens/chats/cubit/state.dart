abstract class ChatState{}
class InitChatState  extends ChatState{}
class GetMessageSuccessState  extends ChatState{}
class ErrorMessageState  extends ChatState{
  final error;
  ErrorMessageState(this.error);
}

class SendMessageSuccessState  extends ChatState{}
class SendMessageErrorChatState  extends ChatState{
  final error;
  SendMessageErrorChatState(this.error);
}
class GetUsersChatSuccessState  extends ChatState{}
class LoadingUsersChatState  extends ChatState{}
class ErrorUsersChatState  extends ChatState{
  final error;
  ErrorUsersChatState(this.error);
}