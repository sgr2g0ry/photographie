import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

class HomeUI extends StatefulWidget {
  @override
  HomeUIState createState() => HomeUIState();
}

class HomeUIState extends State<HomeUI> {

  String yamlFile = "photos/photos.yaml";
  String yamlContent;
  String currentFullImage = "photos/IMG_6282.jpg";
  Widget column;

  /// TODO:
  /// - Livrer cette version
  /// - Mettre numéro de version sur page + "designed with flutter, inspired by html5up"
  ///
  /// - create a large default image
  /// - add arrow to navigate
  /// - add texte under image
  /// - use responsive for mobile
  /// - stream+bloc for fullimage + grid who used same data
  /// - provider get photos
  /// - hide right column
  /// - yaml file come from ?
  /// - bonus: read metadata from photos
  /// - bonus: animation on image click (fade) + https://pub.dev/packages/extended_image
  /// - bonus: meta data site web ?

  _launchURL() async {
    const url = 'https://www.instagram.com/gregoryscheemacker/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getFullImage(String path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(path),
    );
  }

  getTop() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Text('GREGORY SCHEEMACKER', style: TextStyle(color: Colors.black, fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Text('Photographe amateur', style: TextStyle(color: Colors.black, fontSize: 15)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.instagram),
              hoverColor: Color(0xff00D3B7),
              onPressed: _launchURL,
            ),
          )
        ],
      ),
    );
  }

  getBottom() {
    return Padding(
      padding: const EdgeInsets.only(top:20.0),
      child: Text("@Copyright: Grégory Scheemacker"),
    );
  }

  getPhoto(String path) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentFullImage = path;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Image.asset(path, width: 100),
      ),
    );
  }

  getColumn(String yaml) {
    print ("----- getColumn call");
    if (column != null) return column;
    print ("----- getColumn make futurebuilder");
    return FutureBuilder(
        future: rootBundle.loadString(yaml),
        initialData: yamlContent,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            var doc = loadYaml(snapshot.data);
            String photosPath = doc["photos_path"];
            List<dynamic> photos = doc["photos"];

            List<Widget> children = new List<Widget>();
            /// top
            children.add(getTop());

            /// grid
            /// TODO: failed to use grid expanded
            /// TODO: nbElementsInRow en fonction du nombre total de photos ? :)
            int nbElementsInRow = 5;
            for (var i=0; i<photos.length; i=i+nbElementsInRow) {
              List<Widget> rowChildren = new List<Widget>();
              for (var j=0; j<nbElementsInRow; j++) {
                if ((i+j) < photos.length) rowChildren.add(getPhoto("$photosPath/${photos[i+j]['name']}"));
              }
              children.add(
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: rowChildren
                  )
              );
            }

            /// bottom
            children.add(getBottom());

            column = SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children
              ),
            );
            return column;
          }
          else {
            column = Column(
                children: [
                  getTop(),
                  getBottom()
                ]
            );
            return column;
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget body = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: getFullImage(currentFullImage)),
          Expanded(child: getColumn(yamlFile))
        ],
      ),
    );

    return Scaffold(
      body: Center(child: body),
      backgroundColor: Colors.white,
    );
  }
}