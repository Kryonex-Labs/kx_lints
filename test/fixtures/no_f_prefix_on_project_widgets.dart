// Fixture for no_f_prefix_on_project_widgets: an F-prefixed widget is flagged.
class StatelessWidget {}

class FToggle extends StatelessWidget {} // LINT: no_f_prefix_on_project_widgets

class Toggle extends StatelessWidget {} // ok: no F prefix

class FModel {} // ok: not a widget

class Fancy extends StatelessWidget {} // ok: 'F' not followed by uppercase
