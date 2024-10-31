import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoopingVideoPlayer extends StatefulWidget {
  final File videoFile;

  const LoopingVideoPlayer({super.key, required this.videoFile});

  @override
  LoopingVideoPlayerState createState() => LoopingVideoPlayerState();
}

class LoopingVideoPlayerState extends State<LoopingVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.file(widget.videoFile)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      }).catchError((error) {
        print('Error initializing video player: $error');
      });
  }

  @override
  void didUpdateWidget(covariant LoopingVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Dispose of the previous controller and reinitialize it for the new video
    if (oldWidget.videoFile.path != widget.videoFile.path) {
      _controller.dispose(); // Dispose of the old controller
      _initializeVideo(); // Initialize the new video
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Container(
            width: double.infinity,
            height: 350,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: FittedBox(
              fit: BoxFit
                  .contain, // Adjusts to fit while maintaining aspect ratio
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class LoopingVideoPlayer2 extends StatefulWidget {
  final String videoUrl; // Accept a video URL

  const LoopingVideoPlayer2({super.key, required this.videoUrl});

  @override
  LoopingVideoPlayer2State createState() => LoopingVideoPlayer2State();
}

class LoopingVideoPlayer2State extends State<LoopingVideoPlayer2> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final uri = Uri.parse(widget.videoUrl);
    _controller = VideoPlayerController.networkUrl(uri)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      }).catchError((error) {
        print('Error initializing video player: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Container(
            width: double.infinity,
            height: 350,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
