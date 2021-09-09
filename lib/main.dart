import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'initial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Roboto"),
      home: Initial(),
    );
  }
}

class AnimationPage extends CupertinoPageRoute {
  AnimationPage() : super(builder: (BuildContext context) => new MyHomePage());
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new SizeTransition(sizeFactor: animation, child: new MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _indexOne = 0; //Index for Global and My Country
  int _index = 0; //Index for Total and Today
  int _indexFinal = 0; //index for Death and Affected on My Country page
  int i = 6;
  bool times =
      false; //Boolean variable to run fl_chart on My Country page only one time

  var affected, death, recovered, active, serious;

  var total = 0;
  var asia = 0;
  var europe = 0;
  var north = 0;
  var south = 0;
  var africa = 0;

  var spotListDeath = <FlSpot>[]; //List of Death on fl_chart on My Country page
  var spotListAffected =
      <FlSpot>[]; //List of Affected on fl_chart on My Country page
  var months = <String>[]; //List of Months on fl_chart on My Country page
  var listTile = <ListTile>[];

  var oneMonth, twoMonth, threeMonth;

  @override
  void initState() {
    super.initState();
    _funzione(0);
  }

  void _funzione(var choice) async {
    if (choice == 1) {
      //To run fl_chart on My Country page only one time
      setState(() {});
      return;
    }
    setState(() {
      this.affected = -1;
      this.death = -1;
      this.recovered = -1;
      this.active = -1;
      this.death = -1;
      this.serious = -1;
    });

    //*********JSON REQUEST******************** */

    //Data Global
    http.Response data = await http.get(Uri.parse("http://ip-api.com/json"));
    var resultC = await jsonDecode(data.body);
    var country = resultC["country"];

    //Data Country day for day
    http.Response dataDaysCountry = await http
        .get(Uri.parse("https://api.covid19api.com/total/country/" + country));
    var resultDaysCountry = await jsonDecode(dataDaysCountry.body);

    //Data Country
    http.Response covidRespose = await http.get(Uri.parse(
        "https://api.apify.com/v2/datasets/QqlCDZJUIOAQw7J9h/items?clean=true&format=json"));
    var result = await jsonDecode(covidRespose.body);
    var resultFinal = (result[0]["regionData"]);

    //Find the Country Number in Json file
    for (i = 6; i < 231; i++) {
      if ((resultFinal)[i]["country"] == country) {
        break;
      }
    }

    if (!mounted) return; //Check if the widget is mounted
    setState(() {
      if (this._indexOne == 0 && this._index == 0) {
        //If Global and Total
        this.affected = resultFinal[0]["totalCases"];
        this.death = resultFinal[0]["totalDeaths"];
        this.recovered = resultFinal[0]["totalRecovered"];
        this.active = resultFinal[0]["activeCases"];
        this.serious = resultFinal[0]["seriousCritical"];

        this.asia = resultFinal[1]["totalCases"];
        this.europe = resultFinal[2]["totalCases"];
        this.north = resultFinal[3]["totalCases"];
        this.south = resultFinal[5]["totalCases"];
        this.africa = resultFinal[8]["totalCases"];

        this.total =
            this.asia + this.europe + this.north + this.south + this.africa;

        this.asia = (this.asia * (100 / this.total)).round();
        this.europe = (this.europe * (100 / this.total)).round();
        this.north = (this.north * (100 / this.total)).round();
        this.south = (this.south * (100 / this.total)).round();
        this.africa = (this.africa * (100 / this.total)).round();
      }
      if (this._indexOne == 0 && this._index == 1) {
        //If Global and Today
        this.affected = resultFinal[0]["newCases"];
        this.death = resultFinal[0]["newDeaths"];
        this.recovered = resultFinal[0]["newRecovered"];
        this.active = resultFinal[0]["activeCases"];
        this.serious = resultFinal[0]["seriousCritical"];

        this.asia = resultFinal[1]["newCases"];
        this.europe = resultFinal[2]["newCases"];
        this.north = resultFinal[3]["newCases"];
        this.south = resultFinal[5]["newCases"];
        this.africa = resultFinal[8]["newCases"];

        this.total =
            this.asia + this.europe + this.north + this.south + this.africa;

        this.asia = (this.asia * (100 / this.total)).round();
        this.europe = (this.europe * (100 / this.total)).round();
        this.north = (this.north * (100 / this.total)).round();
        this.south = (this.south * (100 / this.total)).round();
        this.africa = (this.africa * (100 / this.total)).round();
      }
      if (this._indexOne == 1 && this._index == 0) {
        //If My Country and Total
        this.affected = resultFinal[i]["totalCases"];
        this.death = resultFinal[i]["totalDeaths"];
        this.recovered = resultFinal[i]["totalRecovered"];
        this.active = resultFinal[i]["activeCases"];
        this.serious = resultFinal[i]["seriousCritical"];
      }
      if (this._indexOne == 1) {
        if (!this.times) {
          double k = 0;
          for (int j = resultDaysCountry.length - 91; j < 588; j++) {
            var tmp = resultDaysCountry[j]["Deaths"] -
                resultDaysCountry[j - 1]["Deaths"];

            var el = (tmp.toDouble());

            spotListDeath.add(FlSpot(k, el));
            k++;
          }

          k = 0;
          for (int j = resultDaysCountry.length - 91; j < 588; j++) {
            var tmp = resultDaysCountry[j]["Confirmed"] -
                resultDaysCountry[j - 1]["Confirmed"];

            var el = (tmp.toDouble());

            spotListAffected.add(FlSpot(k, el));
            k++;

            for (int i = 0; i < 3; i++) {
              var date = new DateTime.now();
              var prevMonth = date.month - i;
              var g = (prevMonth).toString();

              switch (i) {
                case 0:
                  this.oneMonth = g;
                  break;
                case 1:
                  this.twoMonth = g;
                  break;
                case 2:
                  this.threeMonth = g;
                  break;
              }
              months.add(g);
            }

            this.times = true;
          }
        }
      }
      if (this._indexOne == 1 && this._index == 1) {
        //If My Country and Today
        this.affected = resultFinal[i]["newCases"];
        this.death = resultFinal[i]["newDeaths"];
        this.recovered = resultFinal[i]["newRecovered"];
        this.active = resultFinal[i]["activeCases"];
        this.serious = resultFinal[i]["seriousCritical"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[600], // status bar color
          brightness: Brightness.dark,
          //backgroundColor: Colors.indigo[600],
          elevation: 0,
        ),
        body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(color: Colors.indigo[600]),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(16.6),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Statistics",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  )),
              (ToggleSwitch(
                initialLabelIndex: _indexOne,
                borderColor: [(Colors.indigo[400])!],
                borderWidth: 5,
                totalSwitches: 2,
                labels: ["Global", "My Country"],
                minWidth: MediaQuery.of(context).size.width,
                radiusStyle: true,
                activeFgColor: Colors.black,
                inactiveFgColor: Colors.white,
                activeBgColor: [Colors.white],
                inactiveBgColor: Colors.indigo[400],
                fontSize: 16,
                cornerRadius: 20,
                animate: true,
                curve: Curves.easeOutCirc,
                onToggle: (index) {
                  _indexOne = index;
                  _funzione(2);
                },
              )),
              (ToggleSwitch(
                initialLabelIndex: _index,
                totalSwitches: 2,
                labels: ["Total", "Today"],
                minWidth: 100,
                activeFgColor: Colors.white,
                inactiveFgColor: Colors.indigo[400],
                activeBgColor: [(Colors.indigo[600])!],
                inactiveBgColor: Colors.indigo[600],
                fontSize: 12,
                dividerColor: (Colors.indigo[600])!,
                onToggle: (index) {
                  _index = index;
                  _funzione(2);
                },
              )),
              (Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (Padding(
                      padding: EdgeInsets.all(16.6),
                      child: Row(children: [
                        SizedBox(
                            width: 150,
                            height: 105,
                            child: (getCard(0, affected))),
                        SizedBox(
                            width: 150,
                            height: 105,
                            child: (getCard(1, death))),
                      ]))),
                ],
              )),
              (Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 105,
                      child: (getCard(2, recovered))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 105,
                      child: (getCard(3, active))),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 105,
                      child: (getCard(4, serious))),
                ],
              )),
              (getWidgetUnder(
                _indexOne,
                europe,
                africa,
                asia,
                south,
                north,
                spotListDeath,
                spotListAffected,
                oneMonth,
                twoMonth,
                threeMonth,
                _indexFinal,
              )),
              (_indexOne == 1
                  ? (Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (ToggleSwitch(
                          initialLabelIndex: _indexFinal,
                          totalSwitches: 2,
                          labels: ["Deaths", "Affected"],
                          minWidth: 100,
                          activeFgColor: (_indexFinal == 0
                              ? Colors.red[200]
                              : Colors.green[200]),
                          inactiveFgColor: Colors.indigo[400],
                          activeBgColor: [(Colors.indigo[600])!],
                          inactiveBgColor: Colors.indigo[600],
                          fontSize: 12,
                          dividerColor: (Colors.indigo[600])!,
                          onToggle: (index) {
                            _indexFinal = index;
                            _funzione(1);
                          },
                        )),
                      ],
                    ))
                  : Text(""))
            ])));
  }
}

getWidget(var value) {
  if (value >= 0) {
    return Text(
      NumberFormat.compact().format(value).toString(),
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    );
  } else {
    return SpinKitCircle(
      color: Colors.white,
      size: 25.0,
    );
  }
}

getWidgetUnder(
  var indexOne,
  var europe,
  var africa,
  var asia,
  var south,
  var north,
  var spotListDeath,
  var spotListAffected,
  var oneMonth,
  var twoMonth,
  var threeMonth,
  var indexFinal,
) {
  if (indexOne == 1) {
    return Container(
      child: Expanded(
          flex: 1,
          child: Column(children: [
            SizedBox(height: 20),
            Column(children: [
              SizedBox(
                height: 150,
                child: AspectRatio(
                    aspectRatio: 2.6,
                    child: LineChart(LineChartData(
                        backgroundColor: Colors.black12,
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: SideTitles(
                            reservedSize: 40,
                            margin: 5,
                            showTitles: true,
                          ),
                          rightTitles: SideTitles(
                            reservedSize: 40,
                            margin: 5,
                            showTitles: true,
                          ),
                          topTitles: SideTitles(
                            showTitles: false,
                          ),
                          bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 14,
                              getTitles: (value) {
                                switch (value.toInt()) {
                                  case 10:
                                    return getMonths(threeMonth);
                                  case 40:
                                    return getMonths(twoMonth);
                                  case 70:
                                    return getMonths(oneMonth);

                                  default:
                                    return '';
                                }
                              }),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: (indexFinal == 1
                                ? spotListAffected
                                : spotListDeath),
                            isCurved: false,
                            barWidth: 2,
                            colors: [
                              (indexFinal == 1
                                  ? Colors.green[200]!
                                  : Colors.red[200]!),
                            ],
                            dotData: FlDotData(
                              show: false,
                            ),
                          ),
                        ]))),
              ),
              (SizedBox(
                height: 20,
              )),
            ])
          ])),
    );
  } else {
    return Expanded(
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(
          child: AspectRatio(
              aspectRatio: 1,
              child: (PieChart(PieChartData(
                centerSpaceRadius: 30,
                sections: [
                  PieChartSectionData(
                    borderSide: BorderSide(width: 2, color: Colors.grey),
                    color: Colors.blueAccent,
                    title: "$europe" + "%",
                    value: europe.toDouble(),
                  ),
                  PieChartSectionData(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      color: Colors.red[500],
                      title: "$africa" + "%",
                      value: africa.toDouble()),
                  PieChartSectionData(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      color: Colors.limeAccent,
                      title: "$north" + "%",
                      value: north.toDouble()),
                  PieChartSectionData(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      color: Colors.deepOrange,
                      title: "$south" + "%",
                      value: south.toDouble()),
                  PieChartSectionData(
                      borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                      color: Colors.amber[300],
                      title: "$asia" + "%",
                      value: asia.toDouble()),
                ],
              ))))),
      (Expanded(
          child: SizedBox(
              height: 200,
              child: ListView(
                padding: EdgeInsets.all(0),
                children: getTile(asia, africa, europe, north, south),
              ))))
    ]));
  }
}

getMonths(String month) {
  switch (month) {
    case "1":
      return 'Jan';
    case "2":
      return 'Feb';
    case "3":
      return 'Mar';
    case "4":
      return 'Apr';
    case "5":
      return 'May';
    case "6":
      return 'Jun';
    case "7":
      return 'Jul';
    case "8":
      return 'Aug';
    case "9":
      return 'Sep';
    case "10":
      return 'Oct';
    case "11":
      return 'Nov';
    case "12":
      return 'Dec';
    default:
      return '';
  }
}

getCard(var k, var value) {
  return Card(
      elevation: 10,
      color: (k == 0
          ? Colors.orange[300]!
          : k == 1
              ? Colors.red[300]!
              : k == 2
                  ? Colors.green[300]!
                  : k == 3
                      ? Colors.blue[300]!
                      : k == 4
                          ? Colors.purple[300]!
                          : Colors.orange[300]!),
      child: Padding(
          padding: EdgeInsets.only(top: 16.6, bottom: 12.6, right: 0, left: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            (Text(
              k == 0
                  ? "Affected"
                  : k == 1
                      ? "Deaths"
                      : k == 2
                          ? "Recovered"
                          : k == 3
                              ? "Active"
                              : k == 4
                                  ? "Serious"
                                  : "",
              style: TextStyle(color: Colors.white),
            )),
            (Text(" ")),
            (getWidget(value)),
          ])));
}

getTile(asia, africa, europe, north, south) {
  var x = <ListTile>[];
  x.add(ListTile(
    dense: true,
    contentPadding: EdgeInsets.all(0),
    horizontalTitleGap: 0,
    minLeadingWidth: asia.toDouble() / 3,
    title: Text("Asia", style: TextStyle(color: Colors.white)),
    leading: FaIcon(FontAwesomeIcons.solidCircle, color: Colors.amber[300]),
  ));

  x.add(ListTile(
    dense: true,
    contentPadding: EdgeInsets.all(0),
    horizontalTitleGap: 0,
    minLeadingWidth: europe.toDouble() / 3,
    title: Text("Europe", style: TextStyle(color: Colors.white)),
    leading: FaIcon(FontAwesomeIcons.solidCircle, color: Colors.blueAccent),
  ));
  x.add(ListTile(
    dense: true,
    contentPadding: EdgeInsets.all(0),
    horizontalTitleGap: 0,
    minLeadingWidth: africa.toDouble() / 3,
    title: Text("Africa", style: TextStyle(color: Colors.white)),
    leading: FaIcon(FontAwesomeIcons.solidCircle, color: Colors.red[500]),
  ));
  x.add(ListTile(
    dense: true,
    contentPadding: EdgeInsets.all(0),
    horizontalTitleGap: 0,
    minLeadingWidth: north.toDouble() / 3,
    title: Text("North America", style: TextStyle(color: Colors.white)),
    leading: FaIcon(
      FontAwesomeIcons.solidCircle,
      color: Colors.limeAccent,
    ),
  ));
  x.add(ListTile(
    dense: true,
    contentPadding: EdgeInsets.all(0),
    horizontalTitleGap: 0,
    minLeadingWidth: south.toDouble() / 3,
    title: Text("South America", style: TextStyle(color: Colors.white)),
    leading: FaIcon(FontAwesomeIcons.solidCircle, color: Colors.deepOrange),
  ));

  x.sort((a, b) => b.minLeadingWidth!.compareTo(a.minLeadingWidth!));

  return x;
}
