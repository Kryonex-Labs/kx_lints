// Fixture for late_controllers_not_final: non-matching late/final/type/class
// combinations are not flagged.

class State {}

class TextEditingController {}

class HomeState extends State {
  late TextEditingController controller; // not flagged: late without final
  late final String name; // not flagged: not a known controller type
}

class PlainHolder {
  late final TextEditingController
  controller; // not flagged: not a State subclass
}
