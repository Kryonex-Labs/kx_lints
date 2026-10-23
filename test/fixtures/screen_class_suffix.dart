// Fixture for screen_class_suffix: widget classes ending in "Page" must be
// flagged; non-widget classes ending in "Page" are ignored.

class StatelessWidget {}

class SomeOtherBase {}

class HomePage extends StatelessWidget {} // LINT: screen_class_suffix

class SettingsPage {} // not flagged: no extends clause, not a widget

class LegacyPage extends SomeOtherBase {} // not flagged: non-widget superclass
