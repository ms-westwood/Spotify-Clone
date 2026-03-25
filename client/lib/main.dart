import 'package:client/core/team/theme.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'core/providers/current_user_notifier.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bgaudio.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox("songs");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(authViewmodelProvider.notifier).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return MaterialApp(
      title: 'Spotify',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const LoginPage() : const HomePage(),
    );
  }
}
