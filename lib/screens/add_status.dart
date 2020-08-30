import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/status.dart';
import '../provider/all_status_provider.dart';

class AddStatusScree extends StatefulWidget {
  static final String routeName = "/add-status-screen";
  @override
  _AddStatusScreeState createState() => _AddStatusScreeState();
}

class _AddStatusScreeState extends State<AddStatusScree> {
  final _descriptionFocus = FocusNode();
  var _save = GlobalKey<FormState>();
  bool _isLoading = false;
  var storage = FirebaseStorage.instance;

  var _instanceProduct = Status(
      description: '',
      id: null,
      imageUrl: '',
      author: '',
      text: '',
      emailName: '');
  var initStat = {"text": '', "description": '', "authorName": ''};
  File image;

  Future<void> getImageFromGallery([isFromGallery = false]) async {
    if (isFromGallery) {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    setState(() {});
  }

  Future<void> saveFrom(BuildContext context) async {
    final isValid = _save.currentState.validate();
    if (!isValid) {
      return;
    }
    _save.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (image != null) {
        String fileName = image.path.split("/").last;

        StorageTaskSnapshot snapshot =
            await storage.ref().child(fileName).putFile(image).onComplete;
        if (snapshot.error == null) {
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          _instanceProduct.imageUrl = downloadUrl;
        }
      }
      await Provider.of<StatusProvider>(context, listen: false)
          .addStatus(_instanceProduct);
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("OOPs!"),
                content: Text("Some thing went wrong."),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Try Again"),
                  )
                ],
              ));
    }
  }

  @override
  void dispose() {
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Add Status"),
        actions: <Widget>[
          if (!_isLoading)
            IconButton(
                icon: Icon(Icons.assignment_turned_in),
                onPressed: () {
                  saveFrom(context);
                })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _save,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "What's your thougth?",
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 4))),
                        initialValue: initStat["text"],
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter the titile.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _instanceProduct = Status(
                              description: _instanceProduct.description,
                              id: _instanceProduct.id,
                              imageUrl: _instanceProduct.imageUrl,
                              text: value,
                              author: _instanceProduct.author,
                              emailName: _instanceProduct.emailName);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 4))),
                        initialValue: initStat["description"],
                        style: TextStyle(color: Colors.white),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: _descriptionFocus,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter the description.";
                          }
                          if (value.length < 20) {
                            return "Please enter minimum 20 charactors.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _instanceProduct = Status(
                              description: value,
                              id: _instanceProduct.id,
                              imageUrl: _instanceProduct.imageUrl,
                              text: _instanceProduct.text,
                              author: _instanceProduct.author,
                              emailName: _instanceProduct.emailName);
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2)),
                        width: double.infinity,
                        height: 300,
                        child: image == null
                            ? Center(
                                child: Text("Add Image(optional)",
                                    style: TextStyle(color: Colors.grey)))
                            : FittedBox(
                                child: Image.file(image),
                                fit: BoxFit.contain,
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.yellow,
                              onPressed: () async {
                                await getImageFromGallery();
                              },
                              child: Text("Camera"),
                            ),
                            Text(
                              "or",
                              style: TextStyle(color: Colors.grey),
                            ),
                            RaisedButton(
                              color: Colors.yellow,
                              onPressed: () async {
                                await getImageFromGallery(true);
                              },
                              child: Text("Gallery"),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
    );
  }
}
