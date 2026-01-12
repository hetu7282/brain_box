part of 'piece_by_piece_cubit.dart';

const _undefined = Object();

// Puzzle piece model
class PuzzlePiece extends Equatable {
  final int id;
  final int row;
  final int col;
  final String imagePath;
  final bool isPlaced;

  const PuzzlePiece({
    required this.id,
    required this.row,
    required this.col,
    required this.imagePath,
    this.isPlaced = false,
  });

  PuzzlePiece copyWith({
    int? id,
    int? row,
    int? col,
    String? imagePath,
    bool? isPlaced,
  }) {
    return PuzzlePiece(
      id: id ?? this.id,
      row: row ?? this.row,
      col: col ?? this.col,
      imagePath: imagePath ?? this.imagePath,
      isPlaced: isPlaced ?? this.isPlaced,
    );
  }

  @override
  List<Object?> get props => [id, row, col, imagePath, isPlaced];
}

class PieceByPieceState extends Equatable {
  final List<String> categoryList; // Main list of unique category names
  final List<PieceByPieceEntity> allItems; // All items from JSON
  final List<PieceByPieceEntity>
  filteredItems; // Items filtered by selected category
  final Map<String, String>
  categoryThumbnails; // Map of category -> thumbnail image path
  final String? selectedCategory; // Currently selected category
  final PieceByPieceEntity? selectedItem; // Currently selected item
  final bool isSelected;

  // Puzzle game state
  final String? puzzleImagePath; // Path to the puzzle image
  final int? difficulty; // Difficulty level (2, 5, or 10)
  final List<PuzzlePiece> puzzlePieces; // All puzzle pieces
  final List<PuzzlePiece> availablePieces; // Pieces not yet placed
  final Map<int, PuzzlePiece?>
  grid; // Grid positions: key = row * cols + col, value = placed piece
  final PuzzlePiece? selectedPiece; // Currently selected piece
  final int gridRows; // Number of rows in grid
  final int gridCols; // Number of columns in grid
  final bool isPuzzleComplete; // Whether puzzle is completed

  const PieceByPieceState({
    required this.categoryList,
    required this.allItems,
    required this.filteredItems,
    required this.categoryThumbnails,
    this.selectedCategory,
    this.selectedItem,
    required this.isSelected,
    this.puzzleImagePath,
    this.difficulty,
    this.puzzlePieces = const [],
    this.availablePieces = const [],
    this.grid = const {},
    this.selectedPiece,
    this.gridRows = 0,
    this.gridCols = 0,
    this.isPuzzleComplete = false,
  });

  factory PieceByPieceState.initial() => const PieceByPieceState(
    categoryList: [],
    allItems: [],
    filteredItems: [],
    categoryThumbnails: {},
    selectedCategory: null,
    selectedItem: null,
    isSelected: false,
    puzzleImagePath: null,
    difficulty: null,
    puzzlePieces: [],
    availablePieces: [],
    grid: {},
    selectedPiece: null,
    gridRows: 0,
    gridCols: 0,
    isPuzzleComplete: false,
  );

  PieceByPieceState copyWith({
    List<String>? categoryList,
    List<PieceByPieceEntity>? allItems,
    List<PieceByPieceEntity>? filteredItems,
    Map<String, String>? categoryThumbnails,
    Object? selectedCategory = _undefined,
    Object? selectedItem = _undefined,
    bool? isSelected,
    Object? puzzleImagePath = _undefined,
    Object? difficulty = _undefined,
    List<PuzzlePiece>? puzzlePieces,
    List<PuzzlePiece>? availablePieces,
    Map<int, PuzzlePiece?>? grid,
    Object? selectedPiece = _undefined,
    int? gridRows,
    int? gridCols,
    bool? isPuzzleComplete,
  }) {
    return PieceByPieceState(
      categoryList: categoryList ?? this.categoryList,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      categoryThumbnails: categoryThumbnails ?? this.categoryThumbnails,
      selectedCategory: selectedCategory == _undefined
          ? this.selectedCategory
          : selectedCategory as String?,
      selectedItem: selectedItem == _undefined
          ? this.selectedItem
          : selectedItem as PieceByPieceEntity?,
      isSelected: isSelected ?? this.isSelected,
      puzzleImagePath: puzzleImagePath == _undefined
          ? this.puzzleImagePath
          : puzzleImagePath as String?,
      difficulty: difficulty == _undefined
          ? this.difficulty
          : difficulty as int?,
      puzzlePieces: puzzlePieces ?? this.puzzlePieces,
      availablePieces: availablePieces ?? this.availablePieces,
      grid: grid ?? this.grid,
      selectedPiece: selectedPiece == _undefined
          ? this.selectedPiece
          : selectedPiece as PuzzlePiece?,
      gridRows: gridRows ?? this.gridRows,
      gridCols: gridCols ?? this.gridCols,
      isPuzzleComplete: isPuzzleComplete ?? this.isPuzzleComplete,
    );
  }

  @override
  List<Object?> get props => [
    categoryList,
    allItems,
    filteredItems,
    categoryThumbnails,
    selectedCategory,
    selectedItem,
    isSelected,
    puzzleImagePath,
    difficulty,
    puzzlePieces,
    availablePieces,
    grid,
    selectedPiece,
    gridRows,
    gridCols,
    isPuzzleComplete,
  ];
}
