import 'package:flutter/material.dart';

import 'main.dart';
import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Initial extends StatefulWidget {
  Initial({Key? key}) : super(key: key);

  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo[600],
        body: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.2,
            child: Container(
                decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[700]!, blurRadius: 5, spreadRadius: 5)
              ],
              borderRadius: (BorderRadius.only(
                  bottomLeft: Radius.elliptical(80, 50),
                  bottomRight: Radius.elliptical(80, 50))),
              image: DecorationImage(
                  image: NetworkImage(
                      "https://cdn.dribbble.com/users/1787323/screenshots/11024782/media/97b4d47e0b06f3e034b71af15e365c72.png?compress=1&resize=1600x1200"),
                  fit: BoxFit.cover),
            )),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (Text(
                        "Wear a mask",
                        style: TextStyle(color: Colors.grey[200], fontSize: 30),
                      )),
                      (Text(
                        "save lives",
                        style: TextStyle(
                            color: Colors.grey.shade50,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: (Text(
                          "Use proven information about the disease and take the necessary preventive measures.",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      )
                    ]),
              )),
          Padding(
              padding: EdgeInsets.all(16.6),
              child: SizedBox(
                height: 80,
                width: 80,
                child: ElevatedButton(
                  style: ButtonStyle(
                      animationDuration: Duration(seconds: 10),
                      side: MaterialStateProperty.all(
                          BorderSide(width: 3, color: Colors.grey[200]!)),
                      elevation: MaterialStateProperty.all(5),
                      shadowColor: MaterialStateProperty.all(Colors.grey[700]!),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo[400]),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      )),
                  child: FaIcon(FontAwesomeIcons.arrowRight),
                  onPressed: () {
                    Navigator.of(context).push(new AnimationPage());
                  },
                ),
              ))
        ]));
  }
}
