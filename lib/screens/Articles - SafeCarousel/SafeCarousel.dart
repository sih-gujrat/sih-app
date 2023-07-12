import 'package:carousel_slider/carousel_slider.dart';
import 'package:coastal/screens/Articles%20-%20SafeCarousel/ArticleDesc.dart';
import 'package:coastal/screens/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SafeCarousel extends StatelessWidget {
  const SafeCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
        items: List.generate(
            imageSliders.length,
            (index) => Hero(
                  tag: articleTitle[index],
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () {
                        // WebviewScaffold(
                        //   url: "https://www.google.com",
                        //   appBar: new AppBar(
                        //     title: new Text("Widget webview"),
                        //   ),
                        // ),
                        if (index == 0) {
                          launchUrl(Uri.parse("https://www.who.int/news-room/questions-and-answers/item/how-do-i-protect-my-health-in-a-flood?gclid=Cj0KCQjwkqSlBhDaARIsAFJANkijx8wlqobW9XymjNBlhXbakvUFLjg8kQuDtd7WJf9IESSBBKyEMswaAsOMEALw_wcB#"));

//https://floodlist.com/news
//  "https://a-z-animals.com/blog/the-deadliest-floods-of-all-time/"
//https://ffs.india-water.gov.in/
                        } else if (index == 1) {
                          launchUrl(Uri.parse("https://floodlist.com/news"));

                        } else if (index == 2) {
                          launchUrl(Uri.parse("https://a-z-animals.com/blog/the-deadliest-floods-of-all-time/"));

                        } else {
                          launchUrl(Uri.parse('https://ffs.india-water.gov.in/'));


                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(imageSliders[index]),
                              fit: BoxFit.cover),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.5),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight)),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 8),
                              child: Text(
                                articleTitle[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  void navigateToRoute(
    BuildContext context,
    Widget route,
  ) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => route,
      ),
    );
  }
}
