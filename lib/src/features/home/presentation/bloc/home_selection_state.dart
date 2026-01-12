part of 'home_selection_cubit.dart';

class HomeSelectionState extends Equatable {
  final String? selectedKey;

  const HomeSelectionState({this.selectedKey});

  factory HomeSelectionState.initial() => const HomeSelectionState();

  bool isSelected(String key) => selectedKey == key;

  HomeSelectionState copyWith({String? selectedKey}) {
    return HomeSelectionState(selectedKey: selectedKey);
  }

  @override
  List<Object?> get props => [selectedKey];
}

