import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:project_bouquet_delivery/registerpage.dart';
import 'loginpage.dart';
import 'model/user.dart';

class LogoutPage extends StatefulWidget {
  final User user;
  const LogoutPage({Key? key, required this.user}) : super(key: key);
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  late double screenHeight, screenWidth, resWidth;

  final df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: screenHeight * 0.25,
              child: Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: SizedBox(
                        // height: screenWidth / 2.5,
                        child: GestureDetector(
                      onTap: null,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Icon(
                          Icons.person,
                          size: 128,
                        ),
                      ),
                    )),
                  ),
                  Flexible(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.user.name.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                            child: Divider(
                              color: Colors.blueGrey,
                              height: 2,
                              thickness: 2.0,
                            ),
                          ),
                          Table(
                            columnWidths: const {
                              0: FractionColumnWidth(0.3),
                              1: FractionColumnWidth(0.7)
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(children: [
                                const Icon(Icons.email),
                                Text(widget.user.email.toString()),
                              ]),
                              TableRow(children: [
                                const Icon(Icons.phone),
                                Text(widget.user.phone.toString()),
                              ]),
                              TableRow(children: [
                                const Icon(Icons.credit_score),
                                Text(widget.user.credit.toString()),
                              ]),
                              widget.user.regdate.toString() == ""
                                  ? TableRow(children: [
                                      const Icon(Icons.date_range),
                                      Text(df.format(DateTime.parse(
                                          widget.user.regdate.toString())))
                                    ])
                                  : TableRow(children: [
                                      const Icon(Icons.date_range),
                                      Text(widget.user.regdate.toString())
                                    ]),
                            ],
                          ),
                        ],
                      ))
                ],
              )),
        ),
        Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    alignment: Alignment.center,
                    color: Colors.pink,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                      child: Text("PROFILE SETTINGS",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Expanded(
                      child: ListView(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          shrinkWrap: true,
                          children: [
                        const MaterialButton(
                          onPressed: null,
                          child: Text("UPDATE NAME"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const MaterialButton(
                          onPressed: null,
                          child: Text("UPDATE PHONE"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const MaterialButton(
                          onPressed: null,
                          child: Text("UPDATE PASSWORD"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        MaterialButton(
                          onPressed: _registerAccountDialog,
                          child: const Text("CREATE NEW ACCOUNT"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const MaterialButton(
                          onPressed: null,
                          child: Text("BUY CREDIT"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        MaterialButton(
                          onPressed: _loginDialog,
                          child: const Text("LOGIN"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        const MaterialButton(
                          onPressed: null,
                          child: Text("LOGOUT"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                      ])),
                ],
              ),
            )),
      ],
    );
  }

  void _registerAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new Account",
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const RegisterPage()));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Go to Login Page",
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage()));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
