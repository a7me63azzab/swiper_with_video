import 'dart:async';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Home4Screen extends StatefulWidget {
  const Home4Screen({Key? key}) : super(key: key);

  @override
  _Home4ScreenState createState() => _Home4ScreenState();
}

class _Home4ScreenState extends State<Home4Screen> with AfterLayoutMixin {
  late StreamController<bool> timerStream;

  @override
  void afterFirstLayout(BuildContext context) {
    timerStream.add(true);

    timerStream.stream.listen((event) {
      if (event) {
        swiperController.startAutoplay();
      } else {
        swiperController.stopAutoplay();
      }
    });
  }

  // List<SliderItem> sliderItems = [
  //   SliderItem(
  //       id: 1,
  //       name: "image1",
  //       link: "https://scope-way.com/scope_way/public/storage/uploads/16380364632832.jpg",
  //       sliderType: "image",
  //       wait: const Duration(seconds: 1)),
  //   SliderItem(
  //       id: 2,
  //       name: "video1",
  //       link: "https://i.imgur.com/uVRLHOj.mp4",
  //       sliderType: "video",
  //       wait: const Duration(seconds: 1)),
  //   SliderItem(
  //       id: 3,
  //       name: "image3",
  //       link: "https://i.imgur.com/ot9CaXv.png",
  //       sliderType: "image",
  //       wait: const Duration(seconds: 1)),
  //   SliderItem(
  //       id: 4,
  //       name: "video2",
  //       link: "https://i.imgur.com/rRDvAGi.mp4",
  //       sliderType: "video",
  //       wait: const Duration(seconds: 1)),
  //   SliderItem(
  //       id: 5,
  //       name: "image3",
  //       link: "https://i.imgur.com/ot9CaXv.png",
  //       sliderType: "image",
  //       wait: const Duration(seconds: 1)),
  //       SliderItem(
  //       id: 6,
  //       name: "video3",
  //       link: "https://i.imgur.com/m5FZIbu.mp4",
  //       sliderType: "video",
  //       wait: const Duration(seconds: 1)),
  //       SliderItem(
  //       id: 7,
  //       name: "video4",
  //       link: "https://i.imgur.com/NTQcYGY.mp4",
  //       sliderType: "video",
  //       wait: const Duration(seconds: 1)),
  // ];

  List<SliderItem> sliderItems = [
    SliderItem(
        id: 1,
        name: "image1",
        link:
            "https://scope-way.com/scope_way/public/storage/uploads/16380364632832.jpg",
        sliderType: "image",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 2,
        name: "video1",
        link:
            "https://scope-way.com/scope_way/public/storage/uploads/16369682828531.mp4",
        // "https://scope-way.com/scope_way/public/storage/uploads/16369694549467.mp4",
        sliderType: "video",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 3,
        name: "image3",
        link: "https://i.imgur.com/ot9CaXv.png",
        sliderType: "image",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 4,
        name: "video2",
        link:
            "https://scope-way.com/scope_way/public/storage/uploads/16369694549467.mp4",
        sliderType: "video",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 5,
        name: "image3",
        link: "https://i.imgur.com/ot9CaXv.png",
        sliderType: "image",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 6,
        name: "video3",
        link:
            "https://scope-way.com/scope_way/public/storage/uploads/16369687929762.mp4",
        sliderType: "video",
        wait: const Duration(seconds: 1)),
  ];

  // List<SliderItem> sliderItems = [
  //   SliderItem(
  //       id: 1,
  //       name: "image1",
  //       link: "https://i.imgur.com/mHESmts.png",
  //       sliderType: "image",
  //       wait: const Duration(seconds: 1)),
  //   SliderItem(
  //       id: 2,
  //       name: "image2",
  //       link: "https://i.imgur.com/ZweQw8q.png",
  //       sliderType: "image",
  //       wait: const Duration(seconds: 1)),
  //   SliderItem(
  //       id: 3,
  //       name: "image3",
  //       link: "https://i.imgur.com/ot9CaXv.png",
  //       sliderType: "image",
  //       wait: const Duration(seconds: 1)),
  //   SliderItem(
  //       id: 4,
  //       name: "video1",
  //       link: "https://i.imgur.com/0ebMZXZ.mp4",
  //       sliderType: "video",
  //       wait: const Duration(seconds: 1)),
  //   SliderItem(
  //       id: 5,
  //       name: "image3",
  //       link: "https://i.imgur.com/ot9CaXv.png",
  //       sliderType: "image",
  //       wait: const Duration(seconds: 1)),
  // ];

  List<dynamic> sliderFiles = [];

  bool loader = false;

  // int seconds = 2;

  @override
  void initState() {
    timerStream = StreamController<bool>();

    // swiperController.stopAutoplay();

//     for (var item in sliderItems) {
//       // Stream<FileResponse> fileStream =
//       //     DefaultCacheManager().getFileStream(item.link,key: item.name, withProgress: true);

//       Future<FileInfo> downloadedInfo =
//           DefaultCacheManager().downloadFile(item.link,key: item.name,);
// // DefaultCacheManager().
//       // fileStream.first.then((value) {
//       //   print("File from the stream =--> ${value.originalUrl}");
//       // });

//       downloadedInfo.then((value) {
//         print("File from the stream =--> ${value.file.path}");
//       });
//     }

    for (var item in sliderItems) {
      if (item.sliderType == "image") {
        sliderFiles.add(item.link);
        setState(() {});
      } else {
        late VideoPlayerController _controller;
        late Future<void> _initializeVideoPlayerFuture;
        _controller = VideoPlayerController.network(
          item.link,
        );

        _initializeVideoPlayerFuture = _controller.initialize();

        sliderFiles.add({
          "controller": _controller,
          "player": _initializeVideoPlayerFuture
        });
        sliderFiles.add(item.link);
        setState(() {});
      }
    }

    //    Stream<FileResponse> fileStream;

    // void _downloadFile() {
    //   setState(() {
    //     fileStream = DefaultCacheManager().getFileStream(url, withProgress: true);
    //   });
    // }

    // var futures = <Future<File>>[];
    // for (var item in sliderItems) {
    //   futures.add(_downloadFile(
    //       filename:
    //           '${item.name}sep${item.id}sep${DateTime.now()}sep${item.sliderType}sep.${item.link.split(".")[item.link.split(".").length - 1]}',
    //       url: item.link));
    // }
    // setState(() {
    //   loader = true;
    // });

    // Future.wait(futures).then((List<File> allFiles) {
    //   print("File from Future -=> ${allFiles.length}");

    //   setState(() {
    //     loader = false;
    //   });

    //   for (var sliderFile in allFiles) {
    //     if (sliderFile.path.split("sep")[3] == 'image') {
    //       sliderFiles.add(sliderFile);
    //     } else {
    //       late VideoPlayerController _controller;
    //       late Future<void> _initializeVideoPlayerFuture;
    //       _controller = VideoPlayerController.file(
    //         sliderFile,
    //       );

    //       _initializeVideoPlayerFuture = _controller.initialize();

    //       sliderFiles.add({
    //         "controller": _controller,
    //         "player": _initializeVideoPlayerFuture
    //       });
    //     }
    //   }

    //   // sliderFiles.addAll(value);
    //   setState(() {});

    //   for (var element in sliderFiles) {
    //     print("File Path [+]-> " + element.path);
    //   }
    // }).catchError((err) {
    //   setState(() {
    //     loader = false;
    //   });
    //   print("error -=-> $err");
    // });

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    // for (var element in sliderFiles) {
    //   if (element is File) {
    //   } else {
    //     (element['controller'] as VideoPlayerController).dispose();
    //   }
    // }

    super.dispose();
  }

  // Future<String> get sliderItemsDir async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   final path = await sliderItemsDir;
  //   return File('$path/counter.txt');
  // }

  // Future<File> writeCounter(int counter) async {
  //   final file = await _localFile;

  //   // Write the file
  //   return file.writeAsString('$counter');
  // }

  // static var httpClient = HttpClient();
  // Future<File> _downloadFile(
  //     {required String url, required String filename}) async {
  //   var request = await httpClient.getUrl(Uri.parse(url));
  //   var response = await request.close();
  //   var bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = File('$dir/$filename');
  //   await file.writeAsBytes(bytes);
  //   return file;
  // }

  SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Slider App"),
      ),
      body: loader
          ? const Center(
              child: CupertinoActivityIndicator(
                animating: true,
                radius: 15,
              ),
            )
          : IgnorePointer(
              ignoring: true,
              child: Swiper(
                controller: swiperController,
                autoplay: true,
                loop: true,
                itemBuilder: (BuildContext context, int index) {
                  if (sliderFiles[index] is String) {
                    return Image.network(sliderFiles[index]);
                  } else {
                    return FutureBuilder(
                      future: sliderFiles[index]["player"],
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return VisibilityDetector(
                            key: Key("key_$index"),
                            onVisibilityChanged: (VisibilityInfo info) {
                              debugPrint(
                                  "${info.visibleFraction} of my widget is visible");
                              if (info.visibleFraction == 0) {
                                sliderFiles[index]["controller"].pause();
                              } else {
                                (sliderFiles[index]["controller"]
                                        as VideoPlayerController)
                                    .play();
                              }
                            },
                            child: LoaderOverlay(
                              child: AspectRatio(
                                aspectRatio: sliderFiles[index]["controller"]
                                    .value
                                    .aspectRatio,
                                child:
                                    VideoPlayer(sliderFiles[index]["controller"]),
                              ),
                            ),
                          );
                        } else if ((sliderFiles[index]["controller"]
                                as VideoPlayerController)
                            .value
                            .isBuffering) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  }
                },
                itemCount: sliderFiles.length,
                onIndexChanged: (index) {
                  print("NEW PAGE ---------- $index");
                  if (sliderFiles[index] is String) {
                    timerStream.add(true);
                  } else {
                    // timerStream.add(false);

                    // if ((sliderFiles[index]['controller']
                    //         as VideoPlayerController)
                    //     .value
                    //     .isInitialized) {
                    //   if ((sliderFiles[index]['controller']
                    //               as VideoPlayerController)
                    //           .value
                    //           .isPlaying ||
                    //       (sliderFiles[index]['controller']
                    //               as VideoPlayerController)
                    //           .value
                    //           .isBuffering) {
                    //     timerStream.add(false);
                    //   } else {
                    //     timerStream.add(true);
                    //   }
                    // }

                    // (sliderFiles[index]['controller'] as VideoPlayerController)
                    //     .position
                    //     .whenComplete(() {
                    //   print("Video Completed ---------");
                    // });

                    timerStream.add(false);
                    if ((sliderFiles[index]['controller']
                            as VideoPlayerController)
                        .value
                        .isInitialized) {
                      // if ((sliderFiles[index]['controller']
                      //         as VideoPlayerController)
                      //     .value
                      //     .isBuffering) {
                      //   timerStream.add(false);
                      // }

                      Future.delayed(
                          (sliderFiles[index]['controller']
                                  as VideoPlayerController)
                              .value
                              .duration, () {
                        print("Video Complete");

                        timerStream.add(true);
                      });
                    }

                    // print("SET NEW TIMER YA PRINCE");
                  }
                },
                duration: 3,
                pagination: const SwiperPagination(),
                control: const SwiperControl(),
              ),
            ),
    );
  }
}

enum SliderType { video, image }

class SliderItem {
  int id;
  String? name;
  String link;
  Duration wait;
  String sliderType;

  SliderItem({
    required this.id,
    this.name,
    required this.link,
    required this.sliderType,
    required this.wait,
  });
}
