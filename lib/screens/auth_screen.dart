import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../models/http_exeption.dart';

enum AuthStatus { LogIn, SingUp }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _email_focus = FocusNode();
  final _password_focus = FocusNode();
  final _confirm_focus = FocusNode();
  var auth_status = AuthStatus.LogIn;
  final global_key = GlobalKey<FormState>();
  bool isLoading = false;

  AnimationController animationController;
  Animation<Size> animation;

  String email;
  String password;

  @override
  void dispose() {
    _email_focus.dispose();
    _password_focus.dispose();
    _confirm_focus.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<Size>(
            begin: Size(double.infinity, 300), end: Size(double.infinity, 400))
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));
    animationController.addListener(() => setState(() {}));
    super.initState();
  }

  void _showAlertMassege(String massage) {
    showDialog(
        context: context,
        builder: (btx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              title: Text("Error!!!"),
              content: Text(massage),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Ok"))
              ],
            ));
  }

  Future<void> logIn() async {
    final isValid = global_key.currentState.validate();
    if (!isValid) {
      return;
    }
    global_key.currentState.save();
    var massege;
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .logIn(email, password);
      setState(() {
        isLoading = false;
      });
    } on HttpExeption catch (error) {
      massege = "Authentication failed.";
      if (error.toString().contains("EMAIL_EXISTS")) {
        massege = "E-mail already exist.";
      } else if (error.toString().contains("EMAIL_INVALID")) {
        massege = "E-mail invalid.";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        massege = "E-mail invalid.";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        massege = "E-mail invalid.";
      }
      setState(() {
        isLoading = false;
      });
      _showAlertMassege(massege);
    } catch (error) {
      var massege = "Something went wrong.";
      setState(() {
        isLoading = false;
      });
      _showAlertMassege(massege);
    }
  }

  Future<void> singUp() async {
    final isValid = global_key.currentState.validate();
    if (!isValid) {
      return;
    }
    global_key.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .singUp(email, password);
      setState(() {
        isLoading = false;
      });
    } on HttpExeption catch (error) {
      var massege = "Authentication failed.";
      if (error.toString().contains("EMAIL_EXISTS")) {
        massege = "E-mail already exist.";
      } else if (error.toString().contains("EMAIL_INVALID")) {
        massege = "E-mail invalid.";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        massege = "E-mail invalid.";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        massege = "E-mail invalid.";
      }
      setState(() {
        isLoading = false;
      });
      _showAlertMassege(massege);
    } catch (error) {
      var massege = "Something went wrong.";
      setState(() {
        isLoading = false;
      });
      _showAlertMassege(massege);
    }
  }

  void switchMode() {
    if (auth_status == AuthStatus.LogIn) {
      setState(() {
        auth_status = AuthStatus.SingUp;
      });
      animationController.forward();
    } else {
      setState(() {
        auth_status = AuthStatus.LogIn;
      });
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Form(
          key: global_key,
          child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Container(
                      height: media.height,
                      width: media.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Spacer(),
                          Text(
                            "Zujo",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 80,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Status Sharing App",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(10)),
                              height: animation.value.height,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      ),
                                      hintText: "E-mail",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 4)),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter the E-mail.";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      email = value;
                                    },
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_password_focus);
                                    },
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 4)),
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textInputAction:
                                        auth_status == AuthStatus.LogIn
                                            ? TextInputAction.done
                                            : TextInputAction.next,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter the password.";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      password = value;
                                    },
                                    focusNode: _password_focus,
                                    onFieldSubmitted: (_) {
                                      if (auth_status == AuthStatus.SingUp)
                                        FocusScope.of(context)
                                            .requestFocus(_confirm_focus);
                                    },
                                  ),
                                  if (auth_status == AuthStatus.SingUp)
                                    TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.grey,
                                        ),
                                        hintText: "Confirm password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                width: 4)),
                                      ),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Please enter the password.";
                                        }
                                        return null;
                                      },
                                      focusNode: _confirm_focus,
                                    ),
                                  if (auth_status == AuthStatus.LogIn)
                                    RaisedButton(
                                      textColor: Colors.black,
                                      color: Theme.of(context).primaryColor,
                                      onPressed: logIn,
                                      child: Text("Log In"),
                                    ),
                                  if (auth_status == AuthStatus.LogIn)
                                    FlatButton(
                                      onPressed: switchMode,
                                      child: Text(
                                        "Sing Up",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  if (auth_status == AuthStatus.SingUp)
                                    RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      textColor: Colors.black,
                                      onPressed: singUp,
                                      child: Text("Sing Up"),
                                    ),
                                  if (auth_status == AuthStatus.SingUp)
                                    FlatButton(
                                      onPressed: switchMode,
                                      child: Text(
                                        "Log In",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
