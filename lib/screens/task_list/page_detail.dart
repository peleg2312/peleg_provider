import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_complete_guide/Widget/slideAction.dart';
import 'package:flutter_complete_guide/model/element.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DetailPage extends StatefulWidget {
  final int i;
  final Map<String, List<ElementTask>> currentList;
  final String color;
  final auth = FirebaseAuth.instance;

  DetailPage(
      {Key? key,
      required this.i,
      required this.currentList,
      required this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController itemController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      //key: _scaffoldKey,
      backgroundColor: Color(0xFFEEEFF5),
      body: new Stack(
        children: <Widget>[
          _getToolbar(context),
          Container(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return true;
              },
              child: new StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(widget.auth.currentUser!.uid)
                      .doc("TaskList")
                      .collection("Tasks")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return new Center(
                          child: CircularProgressIndicator(
                        backgroundColor: currentColor,
                      ));
                    return new Container(
                      child: getExpenseItems(snapshot),
                    );
                  }),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: itemController,
                      decoration: InputDecoration(
                          hintText: "Add a new todo item",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    child: Text(
                      "+",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      if (itemController.text.isNotEmpty &&
                          !widget.currentList.values
                              .contains(itemController.text.toString())) {
                        FirebaseFirestore.instance
                            .collection(widget.auth.currentUser!.uid)
                            .doc("TaskList")
                            .collection("Tasks")
                            .doc(widget.currentList.keys.elementAt(widget.i))
                            .update({itemController.text.toString(): false});

                        itemController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: currentColor,
                        minimumSize: Size(60, 60),
                        elevation: 10),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ElementTask> listElement = [];
    int nbIsDone = 0;

    if (widget.auth.currentUser!.uid.isNotEmpty) {
      snapshot.data!.docs.map<List>((f) {
        if (f.id == widget.currentList.keys.elementAt(widget.i)) {
          (f.data() as Map<String, dynamic>).forEach((a, b) {
            if (b.runtimeType == bool) {
              listElement.add(new ElementTask(a, b));
            }
          });
        }
        return listElement;
      }).toList();

      listElement.forEach((i) {
        if (i.isDone) {
          nbIsDone++;
        }
      });

      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 50.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          widget.currentList.keys.elementAt(widget.i),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 35.0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: Text("Delete: " +
                                    widget.currentList.keys
                                        .elementAt(widget.i)
                                        .toString()),
                                content: Text(
                                  "Are you sure you want to delete this list?",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                                actions: <Widget>[
                                  ButtonTheme(
                                    minWidth: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 3.0,
                                          primary: currentColor,
                                          foregroundColor:
                                              const Color(0xffffffff)),
                                    ),
                                  ),
                                  ButtonTheme(
                                    minWidth: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection(
                                                widget.auth.currentUser!.uid)
                                            .doc("TaskList")
                                            .collection("Tasks")
                                            .doc(widget.currentList.keys
                                                .elementAt(widget.i))
                                            .delete();
                                        Navigator.pop(context);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('YES'),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 3.0,
                                          primary: currentColor,
                                          foregroundColor:
                                              const Color(0xffffffff)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(
                          FontAwesomeIcons.trash,
                          size: 25.0,
                          color: currentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, left: 50.0),
                  child: Row(
                    children: <Widget>[
                      new Text(
                        nbIsDone.toString() +
                            " of " +
                            listElement.length.toString() +
                            " tasks",
                        style: TextStyle(fontSize: 18.0, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(left: 50.0),
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Color(0xFFEEEFF5),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 350,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: listElement.length,
                              itemBuilder: (BuildContext ctxt, int i) {
                                return new Dismissible(
                                  direction: DismissDirection.startToEnd,
                                  background: Container(
                                    color: Colors.red,
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(Icons.delete),
                                    ),
                                  ),
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text("item deleted")));
                                    FirebaseFirestore.instance
                                        .collection(
                                            widget.auth.currentUser!.uid)
                                        .doc("TaskList")
                                        .collection("Tasks")
                                        .doc(widget.currentList.keys
                                            .elementAt(widget.i))
                                        .update({
                                      listElement.elementAt(i).name: ""
                                    });
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection(
                                              widget.auth.currentUser!.uid)
                                          .doc("TaskList")
                                          .collection("Tasks")
                                          .doc(widget.currentList.keys
                                              .elementAt(widget.i))
                                          .update({
                                        listElement.elementAt(i).name:
                                            !listElement.elementAt(i).isDone
                                      });
                                    },
                                    child: Container(
                                      height: 50.0,
                                      color: listElement.elementAt(i).isDone
                                          ? Color(0xFFEEEFF5)
                                          : Color(0xFFEEEFF5),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 50.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              listElement.elementAt(i).isDone
                                                  ? FontAwesomeIcons.checkSquare
                                                  : FontAwesomeIcons.square,
                                              color: listElement
                                                      .elementAt(i)
                                                      .isDone
                                                  ? currentColor
                                                  : Colors.black,
                                              size: 20.0,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 30.0),
                                            ),
                                            Flexible(
                                              child: Text(
                                                listElement.elementAt(i).name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: listElement
                                                        .elementAt(i)
                                                        .isDone
                                                    ? TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: currentColor,
                                                        fontSize: 27.0,
                                                      )
                                                    : TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 27.0,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    super.initState();
    pickerColor = Color(int.parse(widget.color));
    currentColor = Color(int.parse(widget.color));
  }

  late Color pickerColor;
  late Color currentColor;

  late ValueChanged<Color> onColorChanged;

  changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Padding _getToolbar(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 12.0),
      child:
          new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        new Image(
            width: 35.0,
            height: 35.0,
            fit: BoxFit.cover,
            image: new AssetImage('assets/images/list.png')),
        ElevatedButton(
          onPressed: () {
            pickerColor = currentColor;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                      showLabel: true,
                      colorPickerWidth: 1000.0,
                      pickerAreaHeightPercent: 0.7,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Got it'),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection(widget.auth.currentUser!.uid)
                            .doc("TaskList")
                            .collection("Tasks")
                            .doc(widget.currentList.keys.elementAt(widget.i))
                            .update({"color": pickerColor.value.toString()});

                        setState(() => currentColor = pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Color'),
          style: ElevatedButton.styleFrom(
              elevation: 3.0,
              primary: currentColor,
              foregroundColor: const Color(0xffffffff)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: new Icon(
            Icons.close,
            size: 40.0,
            color: currentColor,
          ),
        ),
      ]),
    );
  }
}
