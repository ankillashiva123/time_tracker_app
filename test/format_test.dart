import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/home/job_entries/format.dart';
import 'package:intl/intl.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(12), '12h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('negative', () {
      expect(Format.hours(-12), '0h');
    });
    test('decimal', () {
      expect(Format.hours(12.55), '12.55h');
    });
  });

  group('2019-03-12', () {
    test('2019-03-12', () {
      expect(Format.date(DateTime(2019, 8, 12)), 'Aug 12, 2019');
    });
  });

  group('currency', () {
    setUp(() {
      Intl.defaultLocale = 'en_US';
    });
    test('currency test', () {
      expect(Format.currency(12.5), '\$13');
    });
    test('zero ', () {
      expect(Format.currency(0), '\$0');
    });
    test('negative', () {
      expect(Format.currency(-12.5), '-\$13');
    });
  });
}
