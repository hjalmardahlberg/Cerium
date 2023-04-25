import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:http/http.dart' as http;
import 'package:projecttest/Groups/GroupData.dart';
import '../refresh.dart';
import 'setDate.dart';

class AddEventPage extends StatefulWidget {
  AddEventPage({Key? key, required this.appbar, this.group}) : super(key: key);

  final AppBar appbar;
  GroupData? group;

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  //the picked image
  File? _imageFile;

  //the picked start date
  DateTime? _startSelectedDate;

  //the picked stop date
  DateTime? _stopSelectedDate;

  //the picked start time
  TimeOfDay? _startSelectedTime;

  //the picked stop time
  TimeOfDay? _stopSelectedTime;

  Duration? _durationResult = const Duration(hours: 0, minutes: 0);

  //the event name
  final TextEditingController _eventNameController = TextEditingController();

  //the event info
  final TextEditingController _eventInfoController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    DateTimeRange? dateRange = DateTimeRange(
        start: _startSelectedDate ?? DateTime.now(),
        end: _stopSelectedDate ?? DateTime.now());

    onDatesSelected(dateRange) {
      setState(() {
        _startSelectedDate = dateRange.start;
        _stopSelectedDate = dateRange.end;
      });
    }

    String? gupp = widget.group?.groupName;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: widget.appbar,
      body: Center(
        child: ListView(
          padding: const EdgeInsets.only(left: 5, right: 5),
          //mediaQueryData.viewInsets,
          children: [
            if (_imageFile == null) pickImage(height, width),
            if (_imageFile != null) addImage(height, width, _imageFile),
            const SizedBox(height: 16),
            addTextForm('Enter your events name', _eventNameController),
            const SizedBox(height: 16),
            datePickerRow(context, width, dateRange, onDatesSelected),
            const SizedBox(height: 16),
            timePickerRow(context, width),
            const SizedBox(height: 16),
            durationRow(context),
            const SizedBox(height: 16),
            addTextForm('Enter your events info', _eventInfoController),
            const SizedBox(height: 16),
            widget.group == null
                ? IconButton(
                    onPressed: () {
                      _handleAddGroupButtonPressed();
                    },
                    icon: const Icon(Icons.group_add),
                    iconSize: 40,
                  )
                : Center(
                    child: Text(
                    gupp!,
                    style: const TextStyle(fontSize: 24),
                  )),
            //ListView(scrollDirection: Axis.horizontal,)
            const SizedBox(height: 16),
            schemaSyncButton(),
            const SizedBox(height: 16),
            addEventButton(),
          ],
        ),
      ),
      //  bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Row durationPicker(BuildContext context) => Row(
        children: [
          ElevatedButton.icon(
              onPressed: () async {
                _durationResult = await showDurationPicker(
                    context: context, initialTime: const Duration(minutes: 30));
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                foregroundColor: Theme.of(context).textTheme.titleMedium?.color,
              ),
              icon: const Icon(Icons.timer),
              label: const Text('Hur långt är eventet')),
          Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                  '${_durationResult?.inHours}h ${_durationResult?.inMinutes.remainder(60)}m')),
        ],
      );

  GestureDetector durationRow(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _durationResult = await showDurationPicker(
            context: context, initialTime: const Duration(minutes: 30));
        setState(() {});
      },
      child: Material(
        elevation: 15.0,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.timer),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Hur långt är eventet:',
                ),
                const SizedBox(width: 16),
                Text(
                    '${_durationResult?.inHours}h ${_durationResult?.inMinutes.remainder(60)}m'),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permission denied');
      } else {
        print('Error picking image: $e');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _handleAddEventButtonPressed() async {
    print(widget.group);
    if (_startSelectedTime != null &&
        _stopSelectedTime != null &&
        _startSelectedDate != null &&
        _stopSelectedDate != null &&
        user.email != null &&
        _eventNameController.text != '' &&
        _eventInfoController.text != '') {
      final url =
          'http://192.121.208.57:8080/event/create/${_eventNameController.text}';
      final headers = {'Content-Type': 'application/json'};
      if (widget.group != null) {
        final groupBody = {
          'g_id': widget.group?.g_id,
          'owner': widget.group?.adminEmail,
          'image': widget.group?.image,
          'name': widget.group?.groupName,
          'u_id': widget.group?.u_id,
        };
        final body = jsonEncode(groupBody);
        final response = await http.put(Uri.parse(url), headers: headers, body: body);

        if (response.statusCode == 200) {
          print('User data sent successfully!');
        } else {
          print('Error sending user data: ${response.statusCode}');
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Snälla synca kaländrarna och fyll i alla fält.'),
            actions: [
              TextButton(
                child: const Text('OK'),
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

  Align addEventButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton.icon(
        onPressed: () async {
          _handleAddEventButtonPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue.shade300,
        ),
        icon: const Icon(
          Icons.add,
          size: 24.0,
        ),
        label: const Text('Event'),
      ),
    );
  }

  GestureDetector datePickerRow(
      BuildContext context, double width, dateRange, onDatesSelected) {
    return GestureDetector(
      onTap: () async {
        final DateTimeRange? pickedDateRange = await showDateRangePicker(
          initialEntryMode: DatePickerEntryMode.input,
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          initialDateRange: dateRange ??
              DateTimeRange(start: DateTime.now(), end: DateTime.now()),
        );

        if (pickedDateRange != null) {
          onDatesSelected?.call(pickedDateRange);
        }
      },
      child: Material(
        elevation: 15.0,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.calendar_today,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  _startSelectedDate != null
                      ? DateFormat('EEE, M/d/y').format(_startSelectedDate!) +
                          ' till ' +
                          DateFormat('EEE, M/d/y').format(_stopSelectedDate!)
                      : 'Mellan vilka datum kan eventet inträffa?',
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        helpText: 'Set a start time',
        context: context,
        initialTime: _startSelectedTime ?? TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input);
    if (pickedTime != null) {
      final TimeOfDay? pickedStopTime = await showTimePicker(
        helpText: 'Set a end time',
        context: context,
        initialTime: _stopSelectedTime ?? pickedTime,
        initialEntryMode: TimePickerEntryMode.input,
      );
      if (pickedStopTime != null) {
        setState(() {
          _startSelectedTime = pickedTime;
          _stopSelectedTime = pickedStopTime;
        });
      }
    }
  }

  GestureDetector timePickerRow(BuildContext context, double width) {
    return GestureDetector(
      onTap: () async {
        await _selectTime(context);
      },
      child: Material(
        elevation: 15.0,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.white,
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.access_time,
                    size: 30.0,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  _startSelectedTime != null
                      ? _startSelectedTime!.format(context) +
                          ' - ' +
                          _stopSelectedTime!.format(context)
                      : 'Mellan vilka tider kan eventet inträffa?',
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _startSelectedTime != null &&
                            _stopSelectedTime != null &&
                            DateTime(
                              1,
                              1,
                              1,
                              _startSelectedTime!.hour,
                              _startSelectedTime!.minute,
                            ).isAfter(
                              DateTime(
                                1,
                                1,
                                1,
                                _stopSelectedTime!.hour,
                                _stopSelectedTime!.minute,
                              ),
                            )
                        ? 'End time cannot be earlier than start time'
                        : '',
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField addTextForm(String text, TextEditingController controller) {
    return TextFormField(
      maxLength: text == 'Enter your events name' ? 26 : null,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter $text';
        }
        return null;
      },
    );
  }

  SizedBox pickImage(double height, double width) {
    return SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            color: Color(0xBBABA6A6),
          ),
          child: IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _getImage,
          ),
        ));
  }

  GestureDetector addImage(double height, double width, File? imageFile) {
    return GestureDetector(
      onTap: _getImage,
      child: SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            // border: Border(bottom: BorderSide(color: Color(0xff000000))),
            color: Color(0x00000000),
          ),
          child: Image.file(imageFile!),
        ),
      ),
    );
  }

  Future<List<Widget>> fetchData(selectedValue) async {
    print('här1');
    List<Widget> list = [];
    print(_stopSelectedDate.toString());
    print(_startSelectedDate.toString());
    print(_startSelectedTime.toString());
    print(_stopSelectedTime.toString());
    print(_durationResult.toString());
    final setDate = {
      'Start_Date': _stopSelectedDate.toString(),
      'End_Date': _startSelectedDate.toString(),
      'Start_Hour': _startSelectedTime.toString(),
      'End_Hour': _stopSelectedTime.toString(),
      'MeetDuration': _durationResult.toString(),
    };
    final body = jsonEncode(setDate);
    print('här2');
    String? groupName = widget.group?.groupName;
    String? adminEmail = widget.group?.adminEmail;
    print('här3');
    final url = 'http://192.121.208.57:8080/event/sync/' +
        groupName! +
        '&' +
        adminEmail! +
        '/' +
        _startSelectedTime.toString() +
        '&' +
        _stopSelectedTime.toString();
    print('här4');
    final headers = {'Content-Type': 'application/json'};
    print('här5');
    final response =
        await http.put(Uri.parse(url), headers: headers, body: body);
    print(response.body);
    print('här6');
    List<dynamic> responseBody = json.decode(response.body);

    for (var time in responseBody) {
      SetDate temp = SetDate(
          startTimeDate: time["startTime"], endTimeDate: time["endTime"]);
      list.add(timeBox(
          time["startTime"], time["endTime"], temp, selectedValue, setState));
    }

    return list;
  }

  Future<List<Widget>> createList(setState, selectedValue) async {
    List<Widget> list = await fetchData(selectedValue);
    print(list);
    return list;
  }

  Widget timeList(Future<List<Widget>> list) {
    return FutureBuilder<List<Widget>>(
      future: list, // wrap the list in a Future using Future.value
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final timeData = snapshot.data!;
          return listViewBuilder(timeData);
        } else {
          return const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Error..'),
          );
        }
      },
    );
  }

  ListView listViewBuilder(List<Widget> list) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return list[index];
      },
    );
  }

  Row timeBox(String startTime, String endTime, SetDate value, selectedValue,
      setState) {
    String startTimeDate = startTime.split('T')[0];
    String startTimeTime =
        startTime.characters.skipLast(3).toString().split('T')[1];
    String endTimeDate = endTime.split('T')[0];
    String endTimeTime =
        endTime.characters.skipLast(3).toString().split('T')[1];
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              startTimeDate == endTimeDate
                  ? Text(startTimeDate)
                  : Text('$startTimeDate - $endTimeDate'),
              Text('$startTimeTime - $endTimeTime'),
              const Divider(color: Colors.black),
            ],
          ),
        ),
        Radio<SetDate>(value: value, groupValue: selectedValue, onChanged: setState),
      ],
    );
  }

  void _handleSchemaSyncButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedValue = 0;
        return AlertDialog(
          title: const Text('Välj event datum.'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: 100,
                height: 160,
                child: timeList(createList((value) {
                  setState(() {
                    selectedValue = value;
                  });
                }, selectedValue)),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleNoGroupSelected(String nullParameter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedValue = 0;
        return AlertDialog(
          title: Text('Select a $nullParameter'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Row schemaSyncButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            if (widget.group == null) {
              var nullParameter = 'group';
              _handleNoGroupSelected(nullParameter);
            }  else if (_startSelectedDate == null &&
                _stopSelectedDate == null) {
              var nullParameter = 'date';
              _handleNoGroupSelected(nullParameter);
            } else if (_startSelectedTime == null &&
                _stopSelectedTime == null) {
              var nullParameter = 'time';
              _handleNoGroupSelected(nullParameter);
            }  else if (_durationResult == null) {
              var nullParameter = 'duration';
              _handleNoGroupSelected(nullParameter);
            }else {
              _handleSchemaSyncButtonPressed();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue.shade300,
          ),
          icon: const Icon(Icons.sync),
          label: const Text(
            'Sync scheman',
          ),
        ),
      ],
    );
  }

  ListView listViewGroup(List<GroupData> list, selectedValue, setState) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        var group = list[index];
        return groupBox(index, group, selectedValue, setState);
      },
    );
  }

  Row groupBox(int value, GroupData group, selectedValue, setState) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(group.groupName),
            ],
          ),
        ),
        Radio<int>(
            value: value, groupValue: selectedValue, onChanged: setState),
      ],
    );
  }

  void _handleAddGroupButtonPressed() {
    Future<List<GroupData>> groups = getGroupData();
    List<GroupData> groupData = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedValue = 0;
        return AlertDialog(
          title: const Text('Välj en grupp.'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: 100,
                height: 160,
                child: FutureBuilder<List<GroupData>>(
                    future: groups,
                    // wrap the list in a Future using Future.value
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        groupData = snapshot.data!;
                        return listViewGroup(groupData, selectedValue, (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        });
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text('Error..'),
                        );
                      }
                    }),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  widget.group = groupData[selectedValue];
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
