import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  return runApp(CalendarApp());
}

/// The app which hosts the home page which contains the calendar on it.
class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Calendar Demo', home: _ContentWidget());
  }
}

class _ContentWidget extends StatefulWidget {
  const _ContentWidget({Key? key}) : super(key: key);

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  late CalendarController _calendarController;
  late _AppointmentDataSource _dataSource;
  late Appointment recurrenceApp;

  @override
  initState() {
    _calendarController = CalendarController();
    _dataSource = _getCalendarDataSource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height - 100,
      // width: MediaQuery.of(context).size.width,
      // color: Colors.red,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Container(
          width: 400,
          color: const Color(0xffF5EFE2),
          child: SfCalendar(
            view: CalendarView.day,
            controller: _calendarController,
            dataSource: _dataSource,
            allowAppointmentResize: true,
            showDatePickerButton: false,
            enableTimeRuler: true,
            showWeekNumber: false,
            allowDragAndDrop: true,
            showCurrentTimeIndicator: false,
            allowViewNavigation: false,
            initialDisplayDate: DateTime.now(),
            viewNavigationMode: ViewNavigationMode.none,
            showNavigationArrow: false,
            onViewChanged: (viewChangedDetails) {
              debugPrint("View changed");
            },
            selectionDecoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: const Color.fromARGB(255, 229, 64, 64), width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              shape: BoxShape.rectangle,
            ),
            timeSlotViewSettings: const TimeSlotViewSettings(
              // timeRulerSize: 130,

              startHour: 8,
              timeIntervalWidth: 20,

              endHour: 23,

              nonWorkingDays: <int>[],

              timeInterval: Duration(minutes: 60),
              timeIntervalHeight: 80,
              timeFormat: 'h:mm',
              dateFormat: 'd',
              dayFormat: 'EEE',
              // numberOfDaysInView: 3
              // timeRulerSize: 120,
            ),
            onTap: (CalendarTapDetails details) {
              final DateTime? date = details.date;
              final Appointment? occurrenceAppointment =
              _dataSource.getOccurrenceAppointment(
                recurrenceApp,
                date!,
                '',
              );
            },
          ),
        ),
        // itemBuilder: (context, index) => Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Container(
        //     color: Colors.blue,
        //     height: 30,
        //     width: 300,
        //   ),
        // ),
      ),
    );
  }

  _AppointmentDataSource _getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    recurrenceApp = Appointment(
      startTime: DateTime(2023, 9, 27, 9),
      endTime: DateTime(2023, 9, 27, 9).add(const Duration(hours: 2)),
      subject: 'Meeting',
      color: Colors.cyanAccent,
      startTimeZone: '',
      endTimeZone: '',
      recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=5',
    );
    appointments.add(recurrenceApp);
    appointments.add(Appointment(
        startTime: DateTime(2023, 9, 28, 5),
        endTime: DateTime(2023, 9, 30, 7),
        subject: 'Discussion',
        color: Colors.orangeAccent,
        startTimeZone: '',
        endTimeZone: '',
        isAllDay: true));

    appointments.add(Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        subject: 'Discussion',
        color: Colors.orangeAccent,
        startTimeZone: '',
        endTimeZone: '',
        isAllDay: false));
    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _Test extends StatefulWidget {
  const _Test({Key? key}) : super(key: key);

  @override
  State<_Test> createState() => _TestState();
}

class _TestState extends State<_Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.workWeek,

      allowAppointmentResize: true,
      allowDragAndDrop: true,

      dataSource: MeetingDataSource(_getDataSource()),
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 8,
        endHour: 23,
        nonWorkingDays: <int>[],
        timeInterval: Duration(minutes: 60),
        timeIntervalHeight: 80,
        timeFormat: 'h:mm',
        dateFormat: 'd',
        dayFormat: 'EEE',
        timeRulerSize: 70,
      ),

      // allowViewNavigation: true,
      // showNavigationArrow: true,
      // showWeekNumber: true,
      // showCurrentTimeIndicator: true,
      // scheduleViewSettings: ScheduleViewSettings(),
      resourceViewSettings: const ResourceViewSettings(
        showAvatar: true,
        displayNameTextStyle: TextStyle(fontSize: 14, color: Colors.red),
        visibleResourceCount: 40,
      ),
      // dragAndDropSettings: DragAndDropSettings(
      // showTimeIndicator: true,allowNavigation: true,
      // allowScroll: true,
      // ),

      onDragEnd: (appointmentDragEndDetails) {},
      onDragStart: (appointmentDragStartDetails) {},
      onDragUpdate: (appointmentDragUpdateDetails) {},
    ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
      Meeting(
        'Conference',
        startTime,
        endTime,
        const Color(0xFF0F8644),
        false,
      ),
    );
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
