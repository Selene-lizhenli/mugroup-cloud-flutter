import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:rxdart/rxdart.dart';

BroadcastReceiver receiver = BroadcastReceiver(
  names: [
    "com.android.decodewedge.decode_action",
  ],
);

final scanConroller = BehaviorSubject<String>();
