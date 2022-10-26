class MessageModel{
  String? senderId;
  String? reciverId;
  String? image;
  String? text;
  bool? isVerify;
  String? dateTime;
  MessageModel({
    this.senderId,
    this.reciverId,
    this.image,
    this.text,
    this.dateTime,
    this.isVerify
  });
  MessageModel.fromjson(Map<String,dynamic> json){
    senderId=json['senderId'];
    reciverId=json['reciverId'];
    image=json['image'];
    text=json['text'];
    dateTime=json['dateTime'];
    isVerify=json['isVerify'];
  }
Map<String,dynamic> toMap(){
    return{
      'senderId':senderId,
      'reciverId':reciverId,
      'text':text,
      'image':image,
      'dateTime':dateTime,
      'isVerify':isVerify,
    };
}
}