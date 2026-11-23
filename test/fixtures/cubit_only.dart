// Fixture for cubit_only: extending Bloc is flagged.
class Bloc<E, S> {}

class Cubit<S> {}

class CounterBloc extends Bloc<int, int> {} // LINT: cubit_only

class SettingsCubit extends Cubit<int> {} // ok: Cubit is allowed
