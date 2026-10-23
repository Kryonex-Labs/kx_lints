// Fixture for late_controllers_not_final: 'late final' controllers in a
// State subclass are flagged.

class State {}

class TextEditingController {}

class HomeState extends State {
  late final TextEditingController
  controller; // LINT: late_controllers_not_final
}
