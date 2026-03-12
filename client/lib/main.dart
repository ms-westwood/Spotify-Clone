import 'package:client/core/team/theme.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'core/providers/current_user_notifier.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: currentUser == null ? const LoginPage() : const UploadSongPage(),
    );
  }
}
