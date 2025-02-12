import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoDetailsPage extends StatefulWidget {
  final String videoId;
  final String videoUrl;
  final String teacherUuid;

  const VideoDetailsPage({
    super.key,
    required this.videoId,
    required this.videoUrl,
    required this.teacherUuid,
  });

  @override
  State<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late Future<Map<String, dynamic>> _videoDetailsFuture;
  late Future<String> _teacherNameFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );

    // Fetch video details and teacher name
    _videoDetailsFuture = _fetchVideoDetails();
    _teacherNameFuture = _fetchTeacherName(widget.teacherUuid);
  }

  Future<Map<String, dynamic>> _fetchVideoDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(widget.videoId)
        .get();
    return doc.data() ?? {};
  }

  Future<String> _fetchTeacherName(String teacherUuid) async {
    final doc = await FirebaseFirestore.instance
        .collection('teachers_registration')
        .doc(teacherUuid)
        .get();
    return doc.data()?['name'] ?? 'Unknown Teacher';
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 10,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _videoDetailsFuture,
        builder: (context, videoSnapshot) {
          if (videoSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (videoSnapshot.hasError || !videoSnapshot.hasData) {
            return const Center(child: Text('Failed to load video details'));
          }

          final videoData = videoSnapshot.data!;
          return FutureBuilder<String>(
            future: _teacherNameFuture,
            builder: (context, teacherSnapshot) {
              if (teacherSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (teacherSnapshot.hasError || !teacherSnapshot.hasData) {
                return const Center(child: Text('Failed to load teacher details'));
              }

              final teacherName = teacherSnapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Player
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(controller: _chewieController),
                    ),
                    const SizedBox(height: 20),

                    // Video Details
                    Text(
                      'Chapter: ${videoData['chapter'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Description: ${videoData['description'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Class Category: ${videoData['classCategory'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Teacher: $teacherName',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}