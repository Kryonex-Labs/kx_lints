// Fixture for one_widget_per_file: a second widget class in the same file
// must be flagged.

class StatelessWidget {}

class SomeOtherBase {}

class NotAWidget {}

class UnrelatedClass extends SomeOtherBase {}

class A extends StatelessWidget {}

class B extends StatelessWidget {} // LINT: one_widget_per_file
