import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/models/jobs.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key key, @required this.dataBase, this.job})
      : super(key: key);
  final Database dataBase;
  final Jobs job;

  static Future<void> show(BuildContext context,
      {Database database, Jobs job}) async {
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => AddJobPage(
        dataBase: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;
  bool _isLoading = false;
  @override
  void initState() {
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateForm()) {
      try {
        _isLoading = true;
        final jobs = await widget.dataBase.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatFormAlertDialog(
            title: 'Name already used',
            content: 'Please chose different name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? DateTime.now().toIso8601String();
          await widget.dataBase.setJob(
            Jobs(id: id, name: _name, ratePerHour: _ratePerHour),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      } finally {
        _isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New job' : 'Edit job'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        onSaved: (value) => _name = value,
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        enabled: _isLoading == false,
      ),
      TextFormField(
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        enabled: _isLoading == false,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
      ),
    ];
  }
}
