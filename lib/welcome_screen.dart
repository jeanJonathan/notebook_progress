import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/search_screen.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'kitesurf.dart';
import 'package:url_launcher/url_launcher.dart'; // Import URL launcher package

class WelcomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recommendedCamps;

  WelcomeScreen({required this.recommendedCamps});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  late PageController _imagePageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _imagePageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Image.asset(
                  'assets/logoOcean.png',
                  width: 250,
                  height: 100,
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.recommendedCamps.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> camp = widget.recommendedCamps[index];
          return GestureDetector(
            onTapDown: (TapDownDetails details) {
              double screenWidth = MediaQuery.of(context).size.width;
              if (details.localPosition.dx < screenWidth / 2) {
                if (_imagePageController.page!.toInt() > 0) {
                  _imagePageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              } else {
                if (_imagePageController.page!.toInt() < camp['image_urls'].length - 1) {
                  _imagePageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              }
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    controller: _imagePageController,
                    itemCount: camp['image_urls'].length,
                    itemBuilder: (context, imageIndex) {
                      return Image.network(
                        camp['image_urls'][imageIndex],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(camp['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(camp['description'], style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('Activités: ${camp['activities'].join(', ')}', style: TextStyle(fontSize: 16, color: Colors.white)),
                      SizedBox(height: 10),
                      MaterialButton(
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () => _launchURL(camp['booking_link']),
                        child: Text('Visitez maintenant'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      iconSize: 30,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz, color: Color(0xFF64C8C8)),
          label: 'Plus',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, color: Color(0xFF64C8C8)),
          label: 'Favoris',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Color(0xFF64C8C8)),
          label: 'Recherche',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school, color: Color(0xFF64C8C8)),
          label: 'Formations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color: Color(0xFF64C8C8)),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WishlistScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Kitesurf()),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            break;
        }
      },
    );
  }
}
