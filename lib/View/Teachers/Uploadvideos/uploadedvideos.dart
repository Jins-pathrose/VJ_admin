// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';

// class AdminsideUploadVideos extends StatefulWidget {
//   const AdminsideUploadVideos({super.key});

//   @override
//   State<AdminsideUploadVideos> createState() => _AdminsideUploadVideosState();
// }

// class _AdminsideUploadVideosState extends State<AdminsideUploadVideos> {
//   late Stream<QuerySnapshot> _videosStream;

//   @override
//   void initState() {
//     super.initState();
//     _videosStream = FirebaseFirestore.instance
//         .collection('videos')
//         .orderBy('uploaded_at', descending: true)
//         .snapshots();
//   }

//   Future<void> _toggleApproval(String videoId, bool currentStatus) async {
//     await FirebaseFirestore.instance
//         .collection('videos')
//         .doc(videoId)
//         .update({'isapproved': !currentStatus});
//   }

//   void _playVideo(String videoUrl) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         VideoPlayerController videoPlayerController =
//             VideoPlayerController.networkUrl(Uri.parse(videoUrl));
//         ChewieController chewieController = ChewieController(
//           videoPlayerController: videoPlayerController,
//           autoPlay: true,
//           looping: false,
//         );

//         return AlertDialog(
//           content: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: Chewie(controller: chewieController),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 videoPlayerController.dispose();
//                 Navigator.pop(context);
//               },
//               child: const Text("Close"),
//             )
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Uploaded Videos'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _videosStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final docs = snapshot.data?.docs ?? [];
//           if (docs.isEmpty) {
//             return const Center(child: Text('No videos available'));
//           }

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final doc = docs[index];
//               final data = doc.data() as Map<String, dynamic>;
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(10),
//                   leading: GestureDetector(
//                     onTap: () => _playVideo(data['video_url']),
//                     child: SizedBox(
//                       width: 100, // Set a fixed width
//                       height: 60, // Set a fixed height
//                       child: Image.network(
//                         data['thumbnail_url'],
//                         fit: BoxFit.cover,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         },
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(Icons.broken_image, size: 60);
//                         },
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     data['chapter'],
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   subtitle: Text(data['description']),
//                   trailing: Switch(
//                     value: (data['isapproved'] as bool?) ??
//                         false, // Ensure a default value of false
//                     onChanged: (value) => _toggleApproval(
//                         doc.id, (data['isapproved'] as bool?) ?? false),
//                     activeColor: Colors.green,
//                     inactiveThumbColor: Colors.red,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:vj_admin/View/Teachers/Uploadvideos/videodetails.dart';

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
        title: const Text('Uploaded Videos',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 10,
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
            return const Center(
                child: Text('No videos available',
                    style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoDetailsPage(
                          videoId: doc.id,
                          videoUrl: data['video_url'],
                          teacherUuid: data['teacher_uuid'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 100,
                            height: 60,
                            child: Image.network(
                              data['thumbnail_url'],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 40);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['chapter'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data['description'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: (data['isapproved'] as bool?) ?? false,
                          onChanged: (value) => _toggleApproval(
                              doc.id, (data['isapproved'] as bool?) ?? false),
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red,
                        ),
                      ],
                    ),
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
