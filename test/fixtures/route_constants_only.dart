// Fixture for route_constants_only: a string literal route is flagged.
class AppRoutes {
  static const home = '/home';
}

void navigateTo(dynamic context, dynamic route) {}

void go(dynamic context) {
  navigateTo(context, '/home'); // LINT: route_constants_only
  navigateTo(context, AppRoutes.home); // ok: uses constant
}
