// Fixture for prefer_geometry_types: geometry types on a widget's API
// surface are not flagged.

class StatelessWidget {
  const StatelessWidget();
}

class EdgeInsetsGeometry {}

class PaddedWidget extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const PaddedWidget(this.padding);
}
