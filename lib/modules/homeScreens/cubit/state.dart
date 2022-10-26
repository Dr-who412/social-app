import 'package:hiddenmind/modules/homeScreens/cubit/state.dart';

abstract class HomeState{}
class InitHomeState extends HomeState{}
class GetDataLoadingHomeState extends HomeState{}
class GetDataSuccess extends HomeState{}
class GetDAtaErrorState extends HomeState{
  final error;
  GetDAtaErrorState(this.error);
}

class GetAnyUserDataLoadingHomeState extends HomeState{}
class GetAnyUserDataSuccess extends HomeState{}
class GetAnyUserDAtaErrorState extends HomeState{
  final error;
  GetAnyUserDAtaErrorState(this.error);
}

class ChangeBottomNav extends HomeState{}

class PickImageSuccess extends HomeState{}
class PickImageError extends HomeState{}

class PickCoverSuccess extends HomeState{}
class PickCoverError extends HomeState{}

class PickPostImageSuccess extends HomeState{}
class PickPostError extends HomeState{}

class UploadImageSuccess extends HomeState{}
class UploadImageError extends HomeState{}

class UploadCoverSuccess extends HomeState{}
class UploadCoverError extends HomeState{}
class UpDateError extends HomeState{}
class UpDateLinksSuccess extends HomeState{}
class UpDateLinksError extends HomeState{}
class ImageProcessDone extends HomeState{}
class PostingLoadingState extends HomeState{}
class PostingSuccess extends HomeState{}
class PostingErrorState extends HomeState{}
class RemovePostImageSuccess extends HomeState{}
class GetHomeLoadingHomeState extends HomeState{}
class GetHomeSuccess extends HomeState{}
class GetHomeErrorState extends HomeState{
  final error;
  GetHomeErrorState(this.error);
}
class LikeLoadingState extends HomeState{}
class LikeSuccessState extends HomeState{}
class LikeErrorState extends HomeState{
  final error;
  LikeErrorState(this.error);
}
class CommentLoadingState extends HomeState{}
class CommentSuccessState extends HomeState{}
class CommentErrorState extends HomeState{
  final error;
  CommentErrorState(this.error);
}
class GetCommentLoadingState extends HomeState{}
class GetCommentSuccessState extends HomeState{}
class GetCommentErrorState extends HomeState{
  final error;
  GetCommentErrorState(this.error);
}
class GetMessageLoadingState extends HomeState{}
class GetMessageSuccessState  extends HomeState{}
class ErrorMessageState  extends HomeState{
  final error;
  ErrorMessageState(this.error);
}

class SendMessageSuccessState  extends HomeState{}
class SendMessageErrorChatState  extends HomeState{
  final error;
  SendMessageErrorChatState(this.error);
}
class GetUsersChatSuccessState  extends HomeState{}
class LoadingUsersChatState  extends HomeState{}
class EmptyUsersChatSuccessState  extends HomeState{}
class ErrorUsersChatState  extends HomeState{
  final error;
  ErrorUsersChatState(this.error);
}
class PickChatImageSuccess extends HomeState{}
class PickChatError extends HomeState{}

class UploadChatImageLoading extends HomeState{}
class UploadChatImageError extends HomeState{}
class RenmovePickedChatImage extends HomeState{}
class SearchEnd extends HomeState{}
class clearSearchState extends HomeState{}
class FollowState extends HomeState{}
class UnFollowState extends HomeState{}
class FollowErrorState extends HomeState{}
class UnFollowErrorState extends HomeState{}
class getStateOfFollowingState extends HomeState{}

