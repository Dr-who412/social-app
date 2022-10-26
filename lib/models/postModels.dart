class PostModel {
  String? userName;
  String? userId;
  String? image;
  String? postImage;
  String? text;
  String? postDate;

  PostModel({
    this.userName,
    this.userId,
    this.image,
    this.postImage,
    this.text,
    this.postDate,
  });
  PostModel.fromjson(Map<String, dynamic> json) {
    userName = json['userName'];
    postDate = json['postDate'];
    userId = json['userId'];
    image = json['image'];
    postImage = json['postImage'];
    text = json['text'];
  }
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userId': userId,
      'image': image,
      'postDate': postDate,
      'text': text,
      'postImage': postImage,
    };
  }
}
