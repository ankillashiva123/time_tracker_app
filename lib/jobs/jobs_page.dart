import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/jobs/add_job_page.dart';
import 'package:time_tracker_flutter_course/jobs/empty_content.dart';
import 'package:time_tracker_flutter_course/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter_course/jobs/list_ites_builder.dart';
import 'package:time_tracker_flutter_course/models/jobs.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Jobs job) async {
    try {
      final databse = Provider.of<Database>(context, listen: false);
      databse.deleteJob(job);
    } catch (e) {
      print(e);
      PlatformExceptionAlertDialog(title: 'Error while deleting', exception: e)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataBase = Provider.of<Database>(context, listen: false);

    dataBase.jobsStream();
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => AddJobPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final databse = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Jobs>>(
      stream: databse.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Jobs>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
                  key: Key('job-${job.id}'),
                  background: Container(
                    color: Colors.red,
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _delete(context, job),
                  child: JobListTile(
                    job: job,
                    onTap: () => JobEntriesPage.show(context, job),
                  ),
                ));
      },
    );
  }
}
