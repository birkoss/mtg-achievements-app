import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/playgroup.dart';

import '../models/http_exception.dart';

class AddAchievement extends StatefulWidget {
  @override
  _AddAchievementState createState() => _AddAchievementState();
}

class _AddAchievementState extends State<AddAchievement> {
  GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _formValues = {
    'name': '',
    'description': '',
    'points': '1',
  };

  void _showErrorDialog(
      [String errorMessage = 'Something went wrong. Please try again.']) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        await Provider.of<PlaygroupProvider>(
          context,
          listen: false,
        ).addAchievement(
          _formValues['name'],
          int.parse(_formValues['points']),
          _formValues['descriptions'],
        );

        Navigator.of(context).pop();
      } on HttpException catch (error) {
        switch (error.toString()) {
          case 'invalid_email':
            _showErrorDialog(
              'Invalid email! Please verify this is a valid email address!',
            );
            break;
          case 'already_in_playgroup':
            _showErrorDialog('This email is already in your playgroup!');
            break;
          default:
            _showErrorDialog();
            break;
        }
      } catch (error) {
        _showErrorDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              initialValue: _formValues['name'],
              decoration: InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value.isEmpty || value.length <= 8) {
                  return 'Invalid Name! Must be at least 8 characters!';
                }
                return null;
              },
              onSaved: (value) {
                _formValues['name'] = value;
              },
            ),
            TextFormField(
              initialValue: _formValues['points'],
              decoration: InputDecoration(labelText: 'Points'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty ||
                    int.tryParse(value) == null ||
                    int.parse(value) <= 0 ||
                    int.parse(value) > 100) {
                  return 'Must provide a valid points (1 to 100)!';
                }
                return null;
              },
              onSaved: (value) {
                _formValues['points'] = value;
              },
            ),
            TextFormField(
              maxLines: 5,
              initialValue: _formValues['description'],
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) {
                _formValues['description'] = value;
              },
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
