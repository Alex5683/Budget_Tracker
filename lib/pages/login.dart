import 'package:expense/pages/homepage.dart';
import 'package:expense/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool isChecked = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String? emailError;
  String? passwordError;

  late Box box1;

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    await Hive.initFlutter();
    box1 = await Hive.openBox('logininfo');
    getdata();
  }

  void getdata() async {
    if (box1.get('email') != null) {
      email.text = box1.get('email');
      isChecked = true;
      setState(() {});
    }
    if (box1.get('password') != null) {
      password.text = box1.get('password');
      isChecked = true;
      setState(() {});
    }
  }

  bool validateFields() {
    bool isValid = true;

    if (email.text.isEmpty) {
      emailError = "Please enter an email";
      isValid = false;
    } else if (!_isEmailValid(email.text)) {
      emailError = "Please enter a valid email";
      isValid = false;
    } else {
      emailError = null;
    }

    if (password.text.isEmpty) {
      passwordError = "Please enter a password";
      isValid = false;
    } else {
      passwordError = null;
    }

    return isValid;
  }

  bool _isEmailValid(String email) {
    // Regular expression pattern for email validation
    final RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  void login() {
    if (isChecked) {
      box1.put('email', email.text);
      box1.put('password', password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: email,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorText: emailError,
                            ),
                          ),
                          SizedBox(height: emailError != null ? 10 : 0),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              controller: password,
                              style: TextStyle(),
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorText: passwordError,
                              ),
                            ),
                          ),
                          SizedBox(height: passwordError != null ? 10 : 0),
                          SizedBox(height: 40),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Remember Me",
                                style: TextStyle(color: Colors.black),
                              ),
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  isChecked = !isChecked;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff74e2de),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    if (validateFields()) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Homepage();
                                          },
                                        ),
                                      );
                                      login();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Validation Error'),
                                            content: Text(
                                              'Please fill in a valid email and password',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.arrow_forward,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => MyRegister(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff4c505b),
                                    fontSize: 18,
                                  ),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
