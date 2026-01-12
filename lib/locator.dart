
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void initLocator() {
  // locator.registerFactory(() => ApiClient());
  chatInit();

}

void chatInit() {
  // data source initialize
  // locator.registerFactory(
  //   () => ApiChatDataSource(apiClient: locator<ApiClient>()),
  // );

  // // repository initialize
  // locator.registerFactory<ChatRepository>(
  //   () => ChatRepositoryImpl(dataSource: locator<ApiChatDataSource>()),
  // );

  // // use case initialize
  // locator.registerFactory(
  //   () => GetAdminChatHistoryUsecase(chatRepository: locator<ChatRepository>()),
  // );

  // // provider initialize
  // locator.registerLazySingleton(
  //   () => ChatProvider(
  //     getAdminChatHistoryUsecase: locator<GetAdminChatHistoryUsecase>(),
  //   ),
  // );
  // SocketDataProvider is already registered in rideInit()
}
