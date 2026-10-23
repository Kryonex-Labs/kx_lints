// Fixture for callback_present_tense: violations across all three
// registration paths (field declaration, simple formal parameter, field
// formal parameter).

class Widget {
  const Widget();
}

class FieldCallbacks extends Widget {
  final void Function()? onPressed; // LINT: callback_present_tense (field)
  final String label; // not flagged: not a known callback name

  const FieldCallbacks({
    this.onPressed,
    this.label = 'static',
  }); // LINT: callback_present_tense (field formal param)
}

void registerListener(void Function()? onChanged, String other) {
  // onChanged: LINT: callback_present_tense (simple formal parameter)
  // other: not flagged
}

typedef Mapper = int Function(int); // unnamed formal parameter: not flagged

class FormalFieldCallbacks extends Widget {
  final void Function()? onClosed;

  const FormalFieldCallbacks({
    this.onClosed,
  }); // LINT: callback_present_tense (field formal param)
}
