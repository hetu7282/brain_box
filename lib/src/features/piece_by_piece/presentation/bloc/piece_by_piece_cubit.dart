import 'dart:convert';

import 'package:brain_box/src/core/utils/log.dart';
import 'package:brain_box/src/features/piece_by_piece/data/model/piece_by_piece_model.dart';
import 'package:brain_box/src/features/piece_by_piece/domain/entity/piece_by_piece_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'piece_by_piece_state.dart';

class PieceByPieceCubit extends Cubit<PieceByPieceState> {
  PieceByPieceCubit() : super(PieceByPieceState.initial());

  void initialize() {
    emit(PieceByPieceState.initial());
  }

  void selectCategory(String category) {
    final filteredItems = state.allItems
        .where((item) => item.categorie == category)
        .toList();

    emit(
      state.copyWith(
        selectedCategory: category,
        filteredItems: filteredItems,
        isSelected: true,
      ),
    );
  }

  void goBackToCategories() {
    emit(
      state.copyWith(
        selectedCategory: null,
        filteredItems: [],
        selectedItem: null,
        isSelected: false,
      ),
    );
  }

  void selectItem(PieceByPieceEntity item) {
    emit(state.copyWith(selectedItem: item, isSelected: true));
  }

  void fetchCategories() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/json/piece_by_piece.json',
      );
      List<dynamic> jsonResponse = json.decode(jsonString);
      List<PieceByPieceModel> models = jsonResponse
          .map((json) => PieceByPieceModel.fromJson(json))
          .toList();

      // Convert to entities
      List<PieceByPieceEntity> allItems = models
          .map(
            (e) => PieceByPieceEntity(
              categorie: e.categorie,
              name: e.name,
              path: e.path,
            ),
          )
          .toList();

      // Extract unique categories
      List<String> uniqueCategories =
          allItems
              .map((item) => item.categorie ?? '')
              .where((category) => category.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

      // Pre-compute category thumbnails (first item image for each category)
      Map<String, String> categoryThumbnails = {};
      for (final category in uniqueCategories) {
        final firstItem = allItems.firstWhere(
          (item) => item.categorie == category,
          orElse: () => const PieceByPieceEntity(),
        );
        if (firstItem.path != null) {
          categoryThumbnails[category] = firstItem.path!;
        }
      }

      Log.d(
        'Total items: ${allItems.length}, Unique categories: ${uniqueCategories.length}, Thumbnails: ${categoryThumbnails.length}',
      );

      emit(
        state.copyWith(
          categoryList: uniqueCategories,
          allItems: allItems,
          categoryThumbnails: categoryThumbnails,
        ),
      );
    } catch (e) {
      Log.e('Error fetching categories: $e');
    }
  }

  // Initialize puzzle game
  void initializePuzzle(String imagePath, int difficulty) {
    emit(
      state.copyWith(
        puzzleImagePath: imagePath,
        difficulty: difficulty,
        puzzlePieces: [],
        availablePieces: [],
        grid: {},
        gridRows: difficulty,
        gridCols: difficulty,
        selectedPiece: null,
        isPuzzleComplete: false,
      ),
    );
  }

  // Select a piece from available pieces
  void selectPiece(PuzzlePiece piece) {
    emit(state.copyWith(selectedPiece: piece));
  }

  // Place a piece on the grid
  void placePiece(int gridIndex, PuzzlePiece piece) {
    final updatedGrid = Map<int, PuzzlePiece?>.from(state.grid);
    updatedGrid[gridIndex] = piece;

    emit(state.copyWith(grid: updatedGrid, selectedPiece: null));
  }

  // Remove piece from grid
  void removePieceFromGrid(int gridIndex) {
    final updatedGrid = Map<int, PuzzlePiece?>.from(state.grid);
    updatedGrid[gridIndex] = null;

    emit(state.copyWith(grid: updatedGrid, selectedPiece: null));
  }

  // Clear selected piece
  void clearSelection() {
    emit(state.copyWith(selectedPiece: null));
  }

  // Update puzzle pieces
  void updatePuzzlePieces(List<PuzzlePiece> pieces) {
    emit(state.copyWith(puzzlePieces: pieces));
  }

  // Update available pieces
  void updateAvailablePieces(List<PuzzlePiece> pieces) {
    emit(state.copyWith(availablePieces: pieces));
  }

  // Update puzzle completion status
  void updatePuzzleComplete(bool isComplete) {
    emit(state.copyWith(isPuzzleComplete: isComplete));
  }

  // Reset grid to empty state
  void resetGrid() {
    final gridSize = state.gridRows;
    final totalPieces = gridSize * gridSize;
    final emptyGrid = <int, PuzzlePiece?>{};
    for (int i = 0; i < totalPieces; i++) {
      emptyGrid[i] = null;
    }
    emit(state.copyWith(
      grid: emptyGrid,
      selectedPiece: null,
      isPuzzleComplete: false,
    ));
  }
}
