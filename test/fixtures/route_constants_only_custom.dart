// Fixture for route_constants_only with custom method_name/constants_class and
// a string route at argument_index 0.
class Routes {
  static const home = '/home';
}

void pushRoute(dynamic route, dynamic context) {}

void go(dynamic context) {
  pushRoute('/home', context); // LINT: route_constants_only (index 0 literal)
  pushRoute(Routes.home, context); // ok: uses constant
}
