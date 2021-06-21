import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/models/jobs.dart';

void main() {
  group('From map', () {
    test('null data', () {
      final job = Jobs.fromMap(null, 'abc');
      expect(job, null);
    });

    test(' data', () {
      final job =
          Jobs.fromMap({'name': 'Programming', 'ratePerHour': 30}, 'abc');
      expect(job, Jobs(id: 'abc', name: 'programming', ratePerHour: 30));
    });
    test(' null name', () {
      final job = Jobs.fromMap({'ratePerHour': 30}, 'abc');
      expect(job, null);
    });
  });

  group('toMap', () {
    test('valid name and rateperhour', () {
      final job = Jobs(id: 'abc', name: 'programming', ratePerHour: 30);
      expect(job.toMap(), {
        'name': 'programming',
        'ratePerHour': 30,
      });
    });
  });
}
