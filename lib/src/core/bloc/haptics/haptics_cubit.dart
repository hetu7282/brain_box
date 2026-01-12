import 'package:bloc/bloc.dart';
import 'package:brain_box/src/core/bloc/haptics/haptics_state.dart';

class HapticsCubit extends Cubit<HapticsState> {
  HapticsCubit() : super(HapticsState.initial());

  void setEnabled(bool enabled) => emit(state.copyWith(enabled: enabled));
  void toggle() => emit(state.copyWith(enabled: !state.enabled));
}
