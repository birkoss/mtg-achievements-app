import 'package:flutter/foundation.dart';

class Achievement {
  final String id;
  final String name;
  final int points;
  final String description;

  Achievement({
    @required this.id,
    @required this.name,
    @required this.points,
    @required this.description,
  });
}
