import 'package:time_tracker_flutter_course/models/entry.dart';
import 'package:time_tracker_flutter_course/models/jobs.dart';

class EntryJob {
  EntryJob(this.entry, this.job);

  final Entry entry;
  final Jobs job;
}
