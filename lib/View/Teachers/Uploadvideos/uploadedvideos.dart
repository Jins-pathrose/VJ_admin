import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class AdminsideUploadVideos extends StatefulWidget {
  const AdminsideUploadVideos({super.key});

  @override
  State<AdminsideUploadVideos> createState() => _AdminsideUploadVideosState();
}

class _AdminsideUploadVideosState extends State<AdminsideUploadVideos> {
  late Stream<QuerySnapshot> _videosStream;

  @override
  void initState() {
    super.initState();
    _videosStream = FirebaseFirestore.instance
        .collection('videos')
        .orderBy('uploaded_at', descending: true)
        .snapshots();
  }

  Future<void> _toggleApproval(String videoId, bool currentStatus) async {
    await FirebaseFirestore.instance
        .collection('videos')
        .doc(videoId)
        .update({'isapproved': !currentStatus});
  }

  void _playVideo(String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        VideoPlayerController videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        ChewieController chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoPlay: true,
          looping: false,
        );

        return AlertDialog(
          content: AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(controller: chewieController),
          ),
          actions: [
            TextButton(
              onPressed: () {
                videoPlayerController.dispose();
                Navigator.pop(context);
              },
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Videos'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _videosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No videos available'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: GestureDetector(
                    onTap: () => _playVideo(data['video_url']),
                    child: SizedBox(
                      width: 100, // Set a fixed width
                      height: 60, // Set a fixed height
                      child: Image.network(
                        data['thumbnail_url'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 60);
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    data['chapter'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(data['description']),
                  trailing: Switch(
                    value: (data['isapproved'] as bool?) ??
                        false, // Ensure a default value of false
                    onChanged: (value) => _toggleApproval(
                        doc.id, (data['isapproved'] as bool?) ?? false),
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
