import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

class Home1UI extends StatefulWidget {
  @override
  Home1UIState createState() => Home1UIState();
}

class Home1UIState extends State<Home1UI> {

  getPhoto(String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(path),
    );
  }

  getAllPhotos(String yaml) {
    return FutureBuilder(
        future: rootBundle.loadString(yaml),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            var doc = loadYaml(snapshot.data);
            String photosPath = doc["photos_path"];
            List<dynamic> photos = doc["photos"];

            List<Widget> gridChildren = new List<Widget>();
            List<dynamic> carouselList = new List<dynamic>();

            for(dynamic photo in photos) {
              gridChildren.add(getPhoto("$photosPath/${photo['name']}"));
              carouselList.add(photo);
            }

            return GridView.count(
              padding: EdgeInsets.all(50),
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
                crossAxisCount: 10,
                // Generate 100 widgets that display their index in the List.
                children: gridChildren
            );
          }
          else return Container();
        }
    );
  }

  _launchURL() async {
    const url = 'https://www.instagram.com/gregoryscheemacker/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget appbar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GREGORY SCHEEMACKER', style: TextStyle(color: Colors.black)),
            Text('Photographe amateur', style: TextStyle(color: Colors.black, fontSize: 10)),
          ],
        ),
        //InkWell(child: Image.asset("images/instagram.png", width: 40), onTap: _launchURL,),
        IconButton(
          icon: Image.asset("images/instagram.png"),
          onPressed: _launchURL,
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: appbar,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: getAllPhotos("photos/photos.yaml"),
      backgroundColor: Colors.white,
    );
  }
}