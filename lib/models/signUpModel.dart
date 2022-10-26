class UserModel{
  String? email;
  String? userName;
  String? userId;
  String? image;
  String? backgroundImage;
  String? bio;
  String? phone;
  int? followers;
  int? following;
  bool? isVerify;

  UserModel({
    this.userName,
    this.email,
    this.userId,
    this.image,
    this.backgroundImage,
    this.bio,
    this.phone,
    this.followers,
    this.following,
    this.isVerify,
  });
  UserModel.fromjson(Map<String,dynamic> json){
    userName=json['userName'];
    email=json['email'];
    phone=json['phone'];
    userId=json['userId'];
    image=json['image'];
    backgroundImage=json['backgroundImage'];
    bio=json['bio'];
    followers=json['followers'];
    following=json['following'];
    isVerify=json['isVerify'];
  }
Map<String,dynamic> toMap(){
    return{
      'email':email,
      'userName':userName,
      'userId':userId,
      'image':image,
      'phone':phone,
      'bio':bio,
      'followers':followers,
      'following':following,
      'backgroundImage':backgroundImage,
      'isVerify':isVerify,
    };
}
}