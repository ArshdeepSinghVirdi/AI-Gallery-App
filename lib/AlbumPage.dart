import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

import 'ViewerPage.dart';

class AlbumPage extends StatefulWidget {
  Album album;
  AlbumPage(this.album);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMedia();
  }

  List<Medium> mediumList = [];
  loadMedia() async {
    MediaPage mediaPage = await this.widget.album.listMedia();
    mediumList = mediaPage.items;
    setState(() {
      mediumList;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = (MediaQuery.of(context).size.width - 15) / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.widget.album.name.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade400,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
            Medium medium = mediumList[index];
            return InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ViewerPage(medium);
                }));
              },
              child: Container(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: imageWidth,
                        height: imageWidth,
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: ThumbnailProvider(
                              mediumId: medium.id,
                              mediumType: medium.mediumType,
                              highQuality: true),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: mediumList.length,
        ),
      ),
    );
  }
}
