import 'dart:io';

import 'package:plo_driver_app/globalVariables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 백그라운드 메시지 핸들러 설정
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 포그라운드 메시지 핸들러 설정 - onMessage: 대신
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      fetchRideInfo(getRideID(message.data));
    });

    // 앱이 백그라운드에서 열릴 때 - onResume: 대신
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: ${message.data}");
      fetchRideInfo(getRideID(message.data));
    });

    // 앱이 완전히 종료된 상태에서 알림을 통해 열렸는지 확인 - onLaunch: 대신
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("onLaunch: ${initialMessage.data}");
      fetchRideInfo(getRideID(initialMessage.data));
    }

    await getToken();
  }

  Future<void> getToken() async {
    String? token = await fcm.getToken();
    print('token: $token');

    // FCM 토큰과 Firebase 사용자가 모두 존재하는지 확인
    // - token이 null이면 FCM 토큰 발급 실패
    // - currentFirebaseUser가 null이면 로그인되지 않은 상태
    if (token != null && currentFirebaseUser != null) {
      DatabaseReference tokenRef = FirebaseDatabase.instance.ref().child(
        'drivers/${currentFirebaseUser!.uid}/token',
      );
      await tokenRef.set(token);

      await fcm.subscribeToTopic('alldrivers');
      await fcm.subscribeToTopic('allusers');
    }
  }

  String getRideID(Map<String, dynamic> message) {
    String rideID = '';
    if (Platform.isAndroid) {
      rideID = message['ride_id'];
    } else {
      rideID = message['ride_id'];
      print('ride_id: $rideID');
    }
    return rideID;
  }

  void fetchRideInfo(String rideID) {
    DatabaseReference rideRef = FirebaseDatabase.instance.ref().child(
      'rideRequest/$rideID',
    );
    rideRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;

        double pickupLat = double.parse(
          data['location']['latitude'].toString(),
        );
        double pickupLng = double.parse(
          data['location']['longitude'].toString(),
        );
        String pickupAddress = data['pickup_address'].toString();

        double destinationLat = double.parse(
          data['destination']['latitude'].toString(),
        );
        double destinationLng = double.parse(
          data['destination']['longitude'].toString(),
        );
        String destinationAddress = data['destination_address'].toString();
        String paymentMethod = data['payment_method'].toString();

        print(pickupAddress);
      }
    });
  }
}

// 백그라운드 메시지 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
