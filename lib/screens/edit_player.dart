import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/playgroup.dart';

import '../models/http_exception.dart';

class EditPlayer extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditPlayerState createState() => _EditPlayerState();
}

class _EditPlayerState extends State<EditPlayer> {
  String _playerId = null;

  GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _formValues = {
    'email': '',
    'role': 'player',
  };

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoaded) {
      return;
    }

    String newPlayerId = ModalRoute.of(context).settings.arguments as String;
    if (newPlayerId != null) {
      setState(() {
        _playerId = newPlayerId;

        Provider.of<PlaygroupProvider>(context, listen: false)
            .players
            .forEach((player) {
          if (player.id == _playerId) {
            _formValues['email'] = player.email;
            _formValues['role'] = player.role;
          }
        });
      });
    }

    _isLoaded = true;
  }

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
        if (_playerId == null) {
          await Provider.of<PlaygroupProvider>(
            context,
            listen: false,
          ).addPlayer(_formValues['email'], _formValues['role']);
        } else {
          await Provider.of<PlaygroupProvider>(
            context,
            listen: false,
          ).updatePlayer(_playerId, _formValues['role']);
        }

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
    print("playerId:");
    print(_playerId);
    print(_formValues);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Player'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'General Information',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextFormField(
                enabled: (_playerId == null),
                initialValue: _formValues['email'],
                decoration: InputDecoration(labelText: 'Email'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid Email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formValues['email'] = value;
                },
              ),
              SizedBox(height: 20),
              Text('User Role', style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 20),
              ListTile(
                title: const Text('Player'),
                subtitle: const Text(
                  'Allow the player to follow his current achievements',
                ),
                leading: Radio<String>(
                  value: 'player',
                  groupValue: _formValues['role'],
                  onChanged: (String value) {
                    setState(() {
                      _formValues['role'] = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Admin'),
                subtitle: const Text(
                  'Allow the player to manage other players and achievements.',
                ),
                leading: Radio<String>(
                  value: 'admin',
                  groupValue: _formValues['role'],
                  onChanged: (String value) {
                    setState(() {
                      _formValues['role'] = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
