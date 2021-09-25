import 'package:flufood/models/customer.dart';
import 'package:flufood/services/api_service.dart';
import 'package:flufood/utils/form_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late ApiService _apiService;
  late CustomerModel _customerModel;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    // TODO: implement initState
    _apiService = new ApiService();
    _customerModel = new CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          automaticallyImplyLeading: true,
          title: Text('Sign Up'),
          shadowColor: Colors.transparent),
      body: _formUI(),
    );
  }

  Widget _formUI() {
    return new SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.redAccent, Colors.redAccent, Colors.white10],
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(150),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
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
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Register to FluFood",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          FormHelper.fieldLabel("First Name"),
          FormHelper.textInput(context, _customerModel.firstName,
              (value) => {this._customerModel.firstName = value},
              onValidate: (onValidateVal) {
            if (onValidateVal.toString().isEmpty) {
              return 'Email can\'t be empty.';
            }
            return null;
          }),
          FormHelper.fieldLabel("Last Name"),
          FormHelper.textInput(context, _customerModel.lastName,
              (value) => {this._customerModel.lastName = value},
              onValidate: (onValidateVal) {
            return null;
          }),
          FormHelper.fieldLabel("Email"),
          FormHelper.textInput(context, _customerModel.email,
              (value) => {this._customerModel.email = value},
              onValidate: (onValidateVal) {
            if (onValidateVal.toString().isEmpty) {
              return 'Email can\'t be empty.';
            }
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(onValidateVal);
            if (!emailValid) {
              return 'Email Invalid!';
            }
            return null;
          }),
          FormHelper.fieldLabel("Password"),
          FormHelper.textInput(
            context,
            _customerModel.password,
            (value) => {this._customerModel.password = value},
            onValidate: (onValidateVal) {
              if (onValidateVal.toString().isEmpty) {
                return 'Password can\'t be empty.';
              }
              return null;
            },
            obscureText: hidePassword,
          ),
          new Center(
            child: FormHelper.saveButton(
              "Register",
              () {
                if (validateAndSave()) {
                  setState(() {
                    this.isApiCallProcess = true;
                  });

                  _apiService.createCustomer(_customerModel).then((ret) {
                    setState(() {
                      this.isApiCallProcess = false;
                    });
                    if (ret) {
                      FormHelper.showMessage(
                        context,
                        "WooCommerce App",
                        "Register Successfully !",
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      FormHelper.showMessage(
                        context,
                        "WooCommerce App",
                        "Register fail !",
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  });
                }
              },
              fullWidth: true,
              color: '',
              textColor: '',
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
