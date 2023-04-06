import 'dart:io';
import 'package:flutter/services.dart';
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
  //the event name
  final TextEditingController _eventNameController = TextEditingController();
  //the event info
  final TextEditingController _eventInfoController = TextEditingController();

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
              if (_imageFile == null) pickImage(height, width),
              if (_imageFile != null) addImage(height, width, _imageFile),
              const SizedBox(height: 16),
              addTextForm('Enter your events name', _eventNameController),
              const SizedBox(height: 16),
              datePickerRow(context, width),
              const SizedBox(height: 16),
              timePickerRow(context, width),
              const SizedBox(height: 16),
              addTextForm('Enter your events info', _eventInfoController),
              const SizedBox(height: 16),
              addEventButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Align addEventButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton.icon(
        onPressed: () {},
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

  IconButton datePicker(BuildContext context, DateTimeRange? dateRange,
      Function(DateTimeRange)? onDatesSelected) {
    return IconButton(
      icon: const Icon(Icons.calendar_today),
      onPressed: () async {
        final DateTimeRange? pickedDateRange = await showDateRangePicker(
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
    );
  }

  Center datePickerRow(BuildContext context, double width) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          datePicker(
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

  Center timePickerRow(BuildContext context, double width) {
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

  TextFormField addTextForm(String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
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

  SizedBox addImage(double height, double width, File? imageFile) {
    return SizedBox(
        height: height / 4,
        child: Container(
          width: width,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xff000000))),
            color: Color(0x00000000),
          ),
          child: Image.file(imageFile!),
        ));
  }
}
