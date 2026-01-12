part of 'jurassic_journey_cubit.dart';

class JurassicJourneyState extends Equatable {
  final Dino dino;
  final double runVelocity;
  final double runDistance;
  final int highScore;
  final bool isGameStarted;
  final List<Cactus> cacti;
  final List<Ground> ground;
  final List<Cloud> clouds;

  const JurassicJourneyState({
    required this.dino,
    required this.runVelocity,
    required this.runDistance,
    required this.highScore,
    required this.isGameStarted,
    required this.cacti,
    required this.ground,
    required this.clouds,
  });

  factory JurassicJourneyState.initial() {
    return JurassicJourneyState(
      dino: Dino(),
      runVelocity: initialVelocity,
      runDistance: 0,
      highScore: 0,
      isGameStarted: false,
      cacti: [Cactus(worldLocation: const Offset(200, 0))],
      ground: [
        Ground(worldLocation: const Offset(0, 0)),
        Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0)),
      ],
      clouds: [
        Cloud(worldLocation: const Offset(100, 20)),
        Cloud(worldLocation: const Offset(200, 10)),
        Cloud(worldLocation: const Offset(350, -10)),
      ],
    );
  }

  JurassicJourneyState copyWith({
    Dino? dino,
    double? runVelocity,
    double? runDistance,
    int? highScore,
    bool? isGameStarted,
    List<Cactus>? cacti,
    List<Ground>? ground,
    List<Cloud>? clouds,
  }) {
    return JurassicJourneyState(
      dino: dino ?? this.dino,
      runVelocity: runVelocity ?? this.runVelocity,
      runDistance: runDistance ?? this.runDistance,
      highScore: highScore ?? this.highScore,
      isGameStarted: isGameStarted ?? this.isGameStarted,
      cacti: cacti ?? this.cacti,
      ground: ground ?? this.ground,
      clouds: clouds ?? this.clouds,
    );
  }

  @override
  List<Object?> get props => [
    dino,
    runVelocity,
    runDistance,
    highScore,
    isGameStarted,
    cacti,
    ground,
    clouds,
  ];
}
