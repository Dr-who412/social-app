import 'dart:convert';
import 'dart:io';
import 'package:hiddenmind/shared/componant/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

sendNotification(
    {required String? to,
    required String? title,
      required String? imageUrl,
    required String? body}) async {
  var client = http.Client();
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  try {
    await client
        .post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "key=AAAANnMtYGU:APA91bEBM8WcEN-kG5N99fybKwC-tjOBBGYICR_JzdAbx_cH2UDfLPgBFWzy2QaPOssh3MllvXXxZsZeocR_JGjycpSd154IkkpV632CB_SF0aLjwLLi6F9TYQ2IwKFzI2eD81CXZd25",
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'title': title,
                'image':imageUrl,
                'body': body,
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              "to": '$to',
            },
          ),
        )
        .then((value) => print('done 1'));
    print('done notified');
  } catch (e) {
    print("error push notification");
  }
}

postData(
    {required String? baseUrl,
    required Map<String, dynamic>? body,
    token}) async {
  var client = http.Client();
  var url = Uri.parse('$baseUrl');
  return await client.post(
    url,
    headers: {
      'Authorization': token ?? '',
    },
    body: body,
  );
}

Future getData(
    {required String baseUrl, Map<String, dynamic>? query, token}) async {
  var client = http.Client();
  var url = Uri.parse('$baseUrl');
  return await client.get(url, headers: {
    'Authorization': token,
  });
}
