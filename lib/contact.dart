import 'call_history.dart';

class Contact {
  final String name;
  final String info;
  final List<CallHistory> callHistory;

  Contact({
    required this.name,
    required this.info,
    required this.callHistory,
  });
}
