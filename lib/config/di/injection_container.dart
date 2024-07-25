import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:valuefinder/config/di/injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
