import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadAllAlbums();
    requestPermissions();
  }

  requestPermissions() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        loadAllAlbums();
      }
    } else if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted &&
              await Permission.videos.request().isGranted) {
        loadAllAlbums();
      }
    }
  }

  List<Album> albums = [];
  loadAllAlbums() async {
    try {
      albums = await PhotoGallery.listAlbums(newest: true);
      albums.forEach((element) {
        print(element.name);
      });
      setState(() {
        albums;
      });
    } catch (e) {
      print("Error loading albums: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = (MediaQuery.of(context).size.width - 15) / 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI GALLERY",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFF77D8E),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 3, right: 3, top: 3),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.75),
          itemBuilder: (BuildContext ctx, int index) {
            Album album = albums[index];
            return Container(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: imageWidth,
                      height: imageWidth,
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: AlbumThumbnailProvider(
                            album: album, highQuality: true),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    child: Text(
                      album.name.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    child: Text(
                      album.count.toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  )
                ],
              ),
            );
          },
          itemCount: albums.length,
        ),
      ),
    );
  }
}
