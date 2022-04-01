import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';

import 'data/data.dart';
import 'domain/domain.dart';
import 'presentation/presentation.dart';

void main() async {
  Intl.defaultLocale = await findSystemLocale();
  initializeDateFormatting();

  await Hive.initFlutter();
  Hive.registerAdapter(NewsEntityAdapter());
  await Hive.openBox<NewsEntity>('news');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NewsRepository>(create: (_) => NewsRepository()),
        ChangeNotifierProvider<NewsFeedProvider>(
          create: (context) => NewsFeedProvider(newsRepository: context.read<NewsRepository>()),
        ),
      ],
      child: const MaterialApp(
        home: FeedScreen(),
      ),
    );
  }
}
