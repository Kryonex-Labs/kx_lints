// ignore_for_file: unused_local_variable
// Fixture for no_material_widgets: a project's OWN widget that merely shares a
// name with a Material default (`Scaffold`) must NOT be flagged — matching is
// scoped to the real `package:flutter/material` library, not the bare name.
class Scaffold {
  const Scaffold();
}

class FScaffold {
  const FScaffold();
}

void build() {
  final a = Scaffold(); // ok: project's own Scaffold, not Material's
  final b = FScaffold(); // ok: forui equivalent
}
