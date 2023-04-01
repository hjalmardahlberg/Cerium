import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage(
      {Key? key, required this.appbar, required this.bottomNavigationBar})
      : super(key: key);

  final AppBar appbar;
  final BottomAppBar bottomNavigationBar;

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  File? _imageFile;
  DateTime? _startSelectedDate;
  DateTime? _stopSelectedDate;
  TimeOfDay? _startSelectedTime;
  TimeOfDay? _stopSelectedTime;

  Future<void> _getImage() async {
    try {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: widget.appbar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (_imageFile == null) EventPickImage(height, width, _imageFile),
              if (_imageFile != null) EventImage(height, width, _imageFile),
              SizedBox(height: 16),
              AddEventTextForm('Enter your events name'),
              SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.start,children:[SizedBox(width: 16),Text('Start:',style: TextStyle(fontSize: 24),),  SizedBox(width: width/2.8-16),Text('Stop:',style: TextStyle(fontSize: 24),)],),
              SizedBox(height: 16),
              DatePickerRow(context, width),
              SizedBox(height: 16),
              TimePickerRow(context, width),
              SizedBox(height: 16),
              AddEventTextForm('Enter your events info'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  IconButton DatePicker(BuildContext context, DateTime? date, Function(DateTime)? onDateSelected) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 10),
        );
        if (pickedDate != null) {
          onDateSelected?.call(pickedDate);
        }
      },
    );
  }

  Center DatePickerRow(BuildContext context, double width) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DatePicker(context, _startSelectedDate, (date) {
            setState(() {
              _startSelectedDate = date;
            });
          }),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              _startSelectedDate != null
                  ? DateFormat('EEE, MMM d, y').format(_startSelectedDate!)
                  : 'Select date',
            ),
          ),

          DatePicker(context, _stopSelectedDate, (date) {
            setState(() {
              _stopSelectedDate = date;
            });
          }),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              _stopSelectedDate != null
                  ? DateFormat('EEE, MMM d, y').format(_stopSelectedDate!)
                  : 'Select date',
            ),
          ),
        ],
      ),
    );
  }

  IconButton TimePicker(BuildContext context,TimeOfDay time) {
    return  IconButton(
      icon: Icon(Icons.access_time),
      onPressed: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            time = pickedTime;
          });
        }
      },
    );
  }
  Center TimePickerRow(BuildContext context, double width) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: _startSelectedTime ?? TimeOfDay.now(),
              );
              if (pickedTime != null) {
                setState(() {
                  _startSelectedTime = pickedTime;
                });
              }
            },
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              _startSelectedTime != null
                  ? _startSelectedTime!.format(context)
                  : 'Select time',
            ),
          ),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: _stopSelectedTime ?? TimeOfDay.now(),
              );
              if (pickedTime != null) {
                setState(() {
                  _stopSelectedTime = pickedTime;
                });
              }
            },
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              _stopSelectedTime != null
                  ? _stopSelectedTime!.format(context)
                  : 'Select time',
            ),
          ),
        ],
      ),
    );
  }

  TextFormField AddEventTextForm(String text) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: text,
      ),
    );
  }

  SizedBox EventPickImage(double height, double width, File? _imageFile) {
    return SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: Color(0xBBABA6A6),
          ),
          child: IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _getImage,
          ),
        ));
  }

  SizedBox EventImage(double height, double width, File? _imageFile) {
    return SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff000000))),
            color: Color(0x0000000),
          ),
          child: Image.file(_imageFile!),
        ));
  }
}
