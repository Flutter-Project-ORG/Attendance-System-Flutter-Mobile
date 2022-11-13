import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/text_field_theme.dart';
import '../view_model/excuse_view_model.dart';

class ExcuseView extends StatelessWidget {
  ExcuseView(
      {Key? key,
      required this.subName,
      required this.subId,
      required this.insId})
      : super(key: key);

  final String subName;
  final String subId;
  final String insId;

  final TextEditingController _excuseTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    File? image = Provider.of<ExcuseViewModel>(context).image;
    return Scaffold(
      appBar: AppBar(
        title: Text(subName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Make an excuse',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              const SizedBox(height: 8.0),
              Column(
                children: [
                  TextField(
                    controller: _excuseTextController,
                    style: Theme.of(context).textTheme.labelMedium,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 160,
                    decoration: InputDecoration(
                      helperText: "Write your excuse",
                      helperStyle: Theme.of(context).textTheme.headline5,
                      border: TextFieldTheme.border1,
                      enabledBorder: TextFieldTheme.border2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton.icon(
                    onPressed: () {
                      Provider.of<ExcuseViewModel>(context,listen: false).pickImage(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Attach a picture (optional)'),
                  ),
                  if(image != null)
                    Image.file(image),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<ExcuseViewModel>(context,listen: false).sendAnExcuse(context,insId,subId,_excuseTextController.text.trim());
                    },
                    child: const Text('Send'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
