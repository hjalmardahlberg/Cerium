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
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventInfoController = TextEditingController();

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
              const SizedBox(height: 16),
              AddEventTextForm('Enter your events name', _eventNameController),
              const SizedBox(height: 16),
              DatePickerRow(context, width),
              const SizedBox(height: 16),
              TimePickerRow(context, width),
              const SizedBox(height: 16),
              AddEventTextForm('Enter your events info', _eventInfoController),
              const SizedBox(height: 16),
              addEventButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  ElevatedButton addEventButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
      ),
      icon: const Icon(
        Icons.add,
        size: 24.0,
      ),
      label: Text('Event'),
    );
  }

  IconButton DatePicker(BuildContext context, DateTimeRange? dateRange,
      Function(DateTimeRange)? onDatesSelected) {
    return IconButton(
      icon: const Icon(Icons.calendar_today),
      onPressed: () async {
        final DateTimeRange? pickedDateRange = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          initialDateRange: dateRange ??
              DateTimeRange(start: DateTime.now(), end: DateTime.now()),
        );

        if (pickedDateRange != null) {
          onDatesSelected?.call(pickedDateRange);
        }
      },
    );
  }

  Center DatePickerRow(BuildContext context, double width) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DatePicker(
              context,
              DateTimeRange(
                  start: _startSelectedDate ?? DateTime.now(),
                  end: _stopSelectedDate ?? DateTime.now()), (dateRange) {
            setState(() {
              _startSelectedDate = dateRange.start;
              _stopSelectedDate = dateRange.end;
            });
          }),
          const SizedBox(width: 16),
          Text(
            _startSelectedDate != null
                ? DateFormat('EEE, M/d/y').format(_startSelectedDate!)
                : 'Select start date',
          ),
          const Text(' to '),
          Text(
            _startSelectedDate != null
                ? DateFormat('EEE, M/d/y').format(_stopSelectedDate!)
                : 'Select stop date',
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  IconButton TimePicker(BuildContext context, TimeOfDay time,
      Function(TimeOfDay)? onTimeSelected) {
    return IconButton(
      icon: const Icon(Icons.access_time),
      onPressed: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          onTimeSelected?.call(pickedTime);
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
            icon: const Icon(Icons.access_time),
            onPressed: () async {
              final TimeOfDay? startSelectedTime = await showTimePicker(
                context: context,
                initialTime: _startSelectedTime ?? TimeOfDay.now(),
              );
              if (startSelectedTime != null) {
                final TimeOfDay? stopSelectedTime = await showTimePicker(
                  context: context,
                  initialTime: _stopSelectedTime ?? startSelectedTime,
                );
                if (stopSelectedTime != null) {
                  setState(() {
                    _startSelectedTime = startSelectedTime;
                    _stopSelectedTime = stopSelectedTime;
                  });
                }
              }
            },
          ),
          const SizedBox(width: 16),
          Text(
            _startSelectedTime != null
                ? _startSelectedTime!.format(context)
                : 'Select start time',
          ),
          const Text(' - '),
          Text(
            _stopSelectedTime != null
                ? _stopSelectedTime!.format(context)
                : 'Select stop time',
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
                  ? 'Stop time cannot be earlier than start time'
                  : '',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  TextFormField AddEventTextForm(
      String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: text,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter last Name';
        }
        return null;
      },
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
