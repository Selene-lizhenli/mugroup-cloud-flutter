import 'package:flutter/widgets.dart';

class ElevatorFloor {
  const ElevatorFloor(
      {required this.name, required this.key, required this.id});

  final String id;
  final String name;
  final GlobalKey key;
}
