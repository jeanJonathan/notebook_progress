import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/search_screen.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'kitesurf.dart';

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
                // User tapped on the left side
                if (_imagePageController.page!.toInt() > 0) {
                  _imagePageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              } else {
                // User tapped on the right side
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
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _imagePageController,
                      count: camp['image_urls'].length,
                      effect: WormEffect(activeDotColor: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(camp['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(camp['description'], style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('Activités: ${camp['activities'].join(', ')}', style: TextStyle(fontSize: 16, color: Colors.white)),
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
          // Naviguer vers la wishlist
            break;
          case 1:
          // Naviguer vers la wishlist
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WishlistScreen()),
            );
            break;
          case 2:
          // Naviguer vers la page de recherche
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
            break;
          case 3:
          // Naviguer vers la page de tutoriel
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Kitesurf()),
            );
            break;
          case 4:
          // Naviguer vers la page de profil
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
