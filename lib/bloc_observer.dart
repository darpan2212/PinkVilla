import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinkvilla/utils/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    Logger.printObj('${cubit.runtimeType} $change');
    super.onChange(cubit, change);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    Logger.printObj('${cubit.runtimeType} $error \n $stackTrace');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    Logger.printObj('${bloc.runtimeType} $event');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Logger.printObj('${bloc.runtimeType} $transition');
    super.onTransition(bloc, transition);
  }
}
