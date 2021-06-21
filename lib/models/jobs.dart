import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Jobs {
  Jobs({@required this.id, @required this.name, @required this.ratePerHour});
  final String id;
  final String name;
  final int ratePerHour;
  factory Jobs.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) return null;
    final int ratePerHour = data['ratePerHour'];
    return Jobs(id: documentId, name: name, ratePerHour: ratePerHour);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }

  @override
  int get hashCode => hashValues(id, name, ratePerHour);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != this.runtimeType) return false;
    final Jobs otherJob = other;
    return id == otherJob.id &&
        name == otherJob.name &&
        ratePerHour == otherJob.ratePerHour;
  }

  @override
  String toString() => ' id: $id , name: $name , ratePerHour: $ratePerHour';
}
