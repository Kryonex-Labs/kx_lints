// Fixture for callback_present_tense: present-tense callback names are not
// flagged.

class Widget {
  const Widget();
}

class CleanCallbacks extends Widget {
  final void Function()? onPress;
  final void Function()? onChange;

  const CleanCallbacks({this.onPress, this.onChange});
}

void registerListener(void Function()? onTap) {}
