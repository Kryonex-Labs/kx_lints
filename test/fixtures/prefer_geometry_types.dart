// Fixture for prefer_geometry_types: concrete geometry types on a widget's
// API surface (fields and formal parameters) are flagged.

class StatelessWidget {
  const StatelessWidget();
}

class EdgeInsets {}

class EdgeInsetsGeometry {}

class Alignment {}

class AlignmentGeometry {}

class BorderRadius {}

class BorderRadiusGeometry {}

class PaddedWidget extends StatelessWidget {
  final EdgeInsets padding; // LINT: prefer_geometry_types
  final String label; // not flagged: type not in the geometry map

  const PaddedWidget(this.padding, this.label);

  void layout({required Alignment align, required EdgeInsetsGeometry safe}) {
    // align: LINT: prefer_geometry_types
    // safe: not flagged: already a geometry type
  }
}

void outsideWidget({required BorderRadius radius}) {
  // not flagged: not inside a widget class
}

class PlainHolder {
  final BorderRadius radius; // not flagged: PlainHolder is not a widget class

  const PlainHolder(this.radius);

  void method({required Alignment align}) {
    // not flagged: enclosing class is not a widget
  }
}
