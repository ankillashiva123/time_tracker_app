import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/home/job_entries/entry_list_item.dart';
import 'package:time_tracker_flutter_course/home/job_entries/entry_page.dart';
import 'package:time_tracker_flutter_course/jobs/add_job_page.dart';
import 'package:time_tracker_flutter_course/jobs/list_ites_builder.dart';
import 'package:time_tracker_flutter_course/models/entry.dart';
import 'package:time_tracker_flutter_course/models/jobs.dart';

import 'package:time_tracker_flutter_course/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.job});
  final Database database;
  final Jobs job;

  static Future<void> show(BuildContext context, Jobs job) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Jobs>(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      AddJobPage.show(context, database: database, job: job),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => EntryPage.show(
                      context: context, database: database, job: job),
                ),
              ],
            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(BuildContext context, Jobs job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
