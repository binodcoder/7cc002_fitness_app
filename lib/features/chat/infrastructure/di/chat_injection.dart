import 'package:fitness_app/features/chat/application/chat/chat_bloc.dart';
import 'package:fitness_app/features/chat/application/users/chat_users_bloc.dart';
import 'package:fitness_app/features/chat/data/datasources/chat_directory_remote_data_source.dart';
import 'package:fitness_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:fitness_app/features/chat/data/datasources/firebase_chat_directory_remote_data_source.dart';
import 'package:fitness_app/features/chat/data/datasources/firebase_chat_remote_data_source.dart';
import 'package:fitness_app/features/chat/data/datasources/noop_chat_directory_remote_data_source.dart';
import 'package:fitness_app/features/chat/data/datasources/noop_chat_remote_data_source.dart';
import 'package:fitness_app/features/chat/data/repositories/chat_directory_repository_impl.dart';
import 'package:fitness_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:fitness_app/features/chat/domain/repositories/chat_directory_repository.dart';
import 'package:fitness_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:fitness_app/features/chat/domain/usecases/get_chat_users.dart';
import 'package:fitness_app/features/chat/domain/usecases/mark_room_read.dart';
import 'package:fitness_app/features/chat/domain/usecases/send_message.dart';
import 'package:fitness_app/features/chat/domain/usecases/stream_messages.dart';
import 'package:get_it/get_it.dart';

void registerChatInfrastructureDependencies(GetIt sl, bool kUseFirebaseData) {
  sl.registerLazySingleton<ChatDirectoryRemoteDataSource>(() => kUseFirebaseData
      ? FirebaseChatDirectoryRemoteDataSource()
      : NoopChatDirectoryRemoteDataSource());

  sl.registerLazySingleton<ChatRemoteDataSource>(() =>
      kUseFirebaseData ? FirebaseChatRemoteDataSource() : NoopChatRemoteDataSource());

  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remote: sl()));

  sl.registerLazySingleton<ChatDirectoryRepository>(
      () => ChatDirectoryRepositoryImpl(remote: sl()));

  sl.registerLazySingleton(() => StreamMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => MarkRoomRead(sl()));
  sl.registerLazySingleton(() => GetChatUsers(sl()));

  sl.registerFactory(() => ChatBloc(streamMessages: sl(), sendMessage: sl()));
  sl.registerFactory(() => ChatUsersBloc(getChatUsers: sl(), sessionManager: sl()));
}
