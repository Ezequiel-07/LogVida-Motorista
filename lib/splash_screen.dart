
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/logosplash.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
        }
      });

    _navigateToLogin();
  }

  void _navigateToLogin() async {
    // Aguarda o vídeo terminar ou um tempo máximo
    await Future.delayed(const Duration(milliseconds: 4000));

    // Verificação de segurança
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            // Mostra um indicador de carregamento enquanto o vídeo inicializa
            : const CircularProgressIndicator(),
      ),
    );
  }
}
