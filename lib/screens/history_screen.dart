import 'package:absensi/components/constants.dart';
import 'package:absensi/models/date_data.dart';
import 'package:absensi/models/task.dart';
import 'package:absensi/models/user.dart';
import 'package:absensi/services/database.dart';
import 'package:absensi/widgets/list_view_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  static const String id = "/history_screen";

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String dropdownValueMonth = 'January';
  String dropdownValue = '2021';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItemsMonth = [];
    for (String month in monthList) {
      var newItem = DropdownMenuItem(
        child: Text(month),
        value: month,
      );
      dropdownItemsMonth.add(newItem);
    }

    return DropdownButton<String>(
      value: dropdownValueMonth,
      items: dropdownItemsMonth,
      onChanged: (value) {
        setState(() {
          dropdownValueMonth = value;
        });
      },
    );
  }

  DropdownButton<String> androidDropdownYear() {
    List<DropdownMenuItem<String>> dropdownItemsYear = [];
    for (String year in yearList) {
      var newItem = DropdownMenuItem(
        child: Text(year),
        value: year,
      );
      dropdownItemsYear.add(newItem);
    }

    return DropdownButton<String>(
      value: dropdownValue,
      items: dropdownItemsYear,
      onChanged: (value) {
        setState(() {
          dropdownValue = value;
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginUser = Provider.of<UserAbsen>(context);
    return loginUser == null
        ? Container(
            alignment: Alignment.center,
            child: const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          )
        : StreamProvider<List<Task>>.value(
            value: DatabaseService(uid: loginUser.uid).absenUser,
            initialData: const [],
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Histori Presensi'),
                backgroundColor: kColorMain2,
              ),
              backgroundColor: kColorMain,
              body: SafeArea(
                  child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: kColorMain3,
                                  borderRadius: BorderRadius.circular(10)),

                              // dropdown below..
                              child: androidDropdown(),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: kColorMain3,
                                  borderRadius: BorderRadius.circular(10)),

                              // dropdown below..
                              child: androidDropdownYear(),
                              //
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ListViewUser(),
                    ),
                  ),
                ],
              )),
            ),
          );
  }

  // Dropdown Menu
  // DropdownButton<String>(
  //     isExpanded: true,
  //     value: dropdownValue,
  //     underline: SizedBox(),
  //     onChanged: (String newValue) {
  //       setState(() {
  //         dropdownValue = newValue;
  //       });
  //     },
  //     items: <String>[
  //       '2019',
  //       '2020',
  //       '2021',
  //       '2022',
  //     ].map<DropdownMenuItem<String>>(
  //         (String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList()),
}
