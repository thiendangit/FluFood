import 'package:flufood/services/api_service.dart';
import 'package:flufood/utils/form_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic isLoading = false;
  dynamic hidePassword = true;
  GlobalKey<FormState> globalKey = new GlobalKey<FormState>();
  late ApiService _apiService;
  String username = '';
  String password = '';

  @override
  void initState() {
    // TODO: implement initState
    _apiService = new ApiService();
    // _customerModel = new CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _uiSetup(context);
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  SizedBox(
                    height: 45,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      "https://pitcoder.github.io/img/portfolio/thumbnails/avatar.png",
                      fit: BoxFit.contain,
                      width: 140,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context)
                                .highlightColor
                                .withOpacity(0.2),
                            offset: Offset(0, 1),
                            blurRadius: 20),
                      ]),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        Text(
                          "Login",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => {
                            if (input != null) {username = input}
                          },
                          validator: (input) => !input.toString().contains('@')
                              ? 'Email id should be valid'
                              : null,
                          decoration: new InputDecoration(
                              hintText: 'Email Address',
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => {
                            if (input != null) {password = input}
                          },
                          validator: (input) => input!.toString().length < 3
                              ? 'Password should be more than 3 characters'
                              : null,
                          obscureText: hidePassword,
                          decoration: new InputDecoration(
                              hintText: 'Password',
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).accentColor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              )),
                        ),
                        SizedBox(height: 50),
                        new Center(
                          child: FormHelper.saveButton("Login", () {
                            if (validateAndSave()) {
                              setState(() {
                                this.isLoading = true;
                              });

                              _apiService
                                  .loginCustomer(username, password)
                                  .then((res) {
                                setState(() {
                                  this.isLoading = false;
                                });
                                // ignore: unnecessary_null_comparison
                                if (res != null) {
                                  FormHelper.showMessage(
                                    context,
                                    "Welcome to FluFood",
                                    "Login Successfully !",
                                    "Ok",
                                    () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                } else {
                                  FormHelper.showMessage(
                                    context,
                                    "Oh! Sorry",
                                    "Login fail !",
                                    "Ok",
                                    () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              });
                            }
                          },
                              context: context,
                              fullWidth: true,
                              color: '',
                              textColor: '',
                              isLoading: isLoading),
                        ),
                        SizedBox(height: 0),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  dynamic validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
