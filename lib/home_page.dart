import 'dart:async';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
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

  List<SliderItem> sliderItems = [
    SliderItem(
        id: 1,
        name: "image1",
        link: "https://i.imgur.com/mHESmts.png",
        sliderType: "image",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 2,
        name: "image2",
        link: "https://i.imgur.com/ZweQw8q.png",
        sliderType: "image",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 3,
        name: "image3",
        link: "https://i.imgur.com/ot9CaXv.png",
        sliderType: "image",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 4,
        name: "video1",
        link: "https://i.imgur.com/0ebMZXZ.mp4",
        sliderType: "video",
        wait: const Duration(seconds: 1)),
    SliderItem(
        id: 5,
        name: "image3",
        link: "https://i.imgur.com/ot9CaXv.png",
        sliderType: "image",
        wait: const Duration(seconds: 1)),
  ];

  List<dynamic> sliderFiles = [];

  bool loader = false;

  // int seconds = 2;

  @override
  void initState() {
    timerStream = StreamController<bool>();

    swiperController.stopAutoplay();

    var futures = <Future<File>>[];
    for (var item in sliderItems) {
      futures.add(_downloadFile(
          filename:
              '${item.name}sep${item.id}sep${DateTime.now()}sep${item.sliderType}sep.${item.link.split(".")[item.link.split(".").length - 1]}',
          url: item.link));
    }
    setState(() {
      loader = true;
    });
    Future.wait(futures).then((List<File> allFiles) {
      print("File from Future -=> ${allFiles.length}");

      setState(() {
        loader = false;
      });

      for (var sliderFile in allFiles) {
        if (sliderFile.path.split("sep")[3] == 'image') {
          sliderFiles.add(sliderFile);
        } else {
          late VideoPlayerController _controller;
          late Future<void> _initializeVideoPlayerFuture;
          _controller = VideoPlayerController.file(
            sliderFile,
          );

          _initializeVideoPlayerFuture = _controller.initialize();

          sliderFiles.add({
            "controller": _controller,
            "player": _initializeVideoPlayerFuture
          });
        }
      }

      // sliderFiles.addAll(value);
      setState(() {});

      for (var element in sliderFiles) {
        print("File Path [+]-> " + element.path);
      }
    }).catchError((err) {
      setState(() {
        loader = false;
      });
      print("error -=-> $err");
    });

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    for (var element in sliderFiles) {
      if (element is File) {
      } else {
        (element['controller'] as VideoPlayerController).dispose();
      }
    }

    super.dispose();
  }

  Future<String> get sliderItemsDir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await sliderItemsDir;
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }

  static var httpClient = HttpClient();
  Future<File> _downloadFile(
      {required String url, required String filename}) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

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
                  if (sliderFiles[index] is File) {
                    return Image.file(sliderFiles[index]);
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
                            child: AspectRatio(
                              aspectRatio: sliderFiles[index]["controller"]
                                  .value
                                  .aspectRatio,
                              child:
                                  VideoPlayer(sliderFiles[index]["controller"]),
                            ),
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
                onIndexChanged: (index) async {
                  print("NEW PAGE ---------- $index");
                  if (sliderFiles[index] is File) {
                    timerStream.add(true);
                  } else {
                    timerStream.add(false);

                    Future.delayed(
                        (sliderFiles[index]['controller']
                                as VideoPlayerController)
                            .value
                            .duration, () {
                      print("Video Complete");

                      timerStream.add(true);
                    });

                    print("SET NEW TIMER YA PRINCE");
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
