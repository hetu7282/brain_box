part of 'router.dart';

enum Routes {
  // splash
  noInternet('/noInternet'),
  splash('/splash'),
  onboarding('/onboarding'),

  // auth
  login('/login'),
  register('/register'),
  forgotPassword('/forgotPassword'),
  verifyOtp('/verifyOtp'),
  newPassword('/newPassword'),

  // main
  homeScreen('/homeScreen'),

  // settings
  settings('/settings'),
  aboutGame('/aboutGame'),
  termsConditions('/termsConditions'),
  privacyPolicy('/privacyPolicy'),
  ticTacTwist('/ticTacTwist'),
  pieceByPiece('/pieceByPiece'),
  chooseYourPuzzle('/chooseYourPuzzle'),
  selectDifficulty('/selectDifficulty'),
  puzzleCompleted('/puzzleCompleted'),
  slideMastermind('/slideMastermind'),
  jurassicJourney('/jurassicJourney'),
  kingsGambit('/kingsGambit'),
  kingsGambitSetting('/kingsGambitSetting'),
  kingsGambitPuzzle('/kingsGambitPuzzle'),
  quickTypeQuest('/quickTypeQuest'),
  quickTypeQuestResult('/quickTypeQuestResult');

  final String path;

  const Routes(this.path);
}
