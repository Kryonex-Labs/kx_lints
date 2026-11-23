// Fixture for route_constants_only: only route constants used.
class AppRoutes {
  static const home = '/home';
}

void navigateTo(dynamic context, dynamic route) {}

void go(dynamic context) {
  navigateTo(context, AppRoutes.home);
}
