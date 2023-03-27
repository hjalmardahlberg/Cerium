import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'Event.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
     final appbar = AppBar(
        backgroundColor: Colors.red.shade800,
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                padding: EdgeInsets.all(5),
                icon: Icon(Icons.group),
                iconSize: 50,
                onPressed: () {},
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(widget.title, style: const TextStyle(fontSize: 28)),
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person),
                iconSize: 50,
                onPressed: () {},
              ),
            ),
          ],
        ),
      );

     final bottomNavigationBar = BottomAppBar(
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: <Widget>[
           IconButton(
             icon: Icon(Icons.event),
             onPressed: () {},
           ),
           IconButton(
             icon: Icon(Icons.add),
             onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (_) => NextPage()),
               );
             },
           ),
           IconButton(
             icon: Icon(Icons.navigate_next),
             onPressed: () {},
           ),
         ],
       ),
     );

    return Scaffold(
      appBar: appbar,
      body: ListView.builder(
        itemBuilder: (_, index) { return FigmaEventBox(fem, ffem,width,height, appbar, bottomNavigationBar,context);/*OldEventBox(height, width, context, appbar, bottomNavigationBar);*/},),
        bottomNavigationBar: bottomNavigationBar,
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
  }

  Container OldEventBox(double height, double width, BuildContext context, AppBar appbar, BottomAppBar bottomNavigationBar) {
        return Container(
          height: height / 3,
          width: width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>
                    EventPage(picture: 'images/Widewallsten.jpg',
                        appbar: appbar,
                        bottomNavigationBar: bottomNavigationBar)),
              );
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: SizedBox(
                  height: height / 4, // adjust as needed
                  width: width / 1.2, // adjust as needed
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.network(
                              'https://picsum.photos/300/150',
                              // replace with your image URL
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Event Name',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }

    Container FigmaEventBox(double fem, double ffem,double width,double height,appbar,bottomNavigationBar,context) {
      String eventImage = 'images/Widewallsten.jpg';
      String eventTime = '2023-03-23  kl:14:00';
      String eventName = 'Möte med Wallsten';
      return Container(
        // event3JfJ (23:33)
        margin: EdgeInsets.fromLTRB(width/12, 10*fem, 0*fem, 10*fem),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>
                  EventPage(picture: eventImage,
                      appbar: appbar,
                      bottomNavigationBar: bottomNavigationBar)),
            );
          },
          child: Container(
            width: double.infinity,
            height: 138.5*fem,
            child: Stack(
              children: [
                Positioned(
                  // eventboxQTS (23:34)
                  left: 0*fem,
                  top: 0*fem,
                  child: Align(
                    child: SizedBox(
                      width: 325*fem,
                      height: 135*fem,
                      child: Container(
                        decoration: BoxDecoration (
                          borderRadius: BorderRadius.circular(20*fem),
                          border: Border.all(color: Color(0xff000000)),
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // tidWFa (23:35)
                  left: 19*fem,
                  top: 116*fem,
                  child: Align(
                    child: SizedBox(
                      width: 85*fem,
                      height: 15*fem,
                      child: Text(
                        'Tid och datum:',
                        style: TextStyle (
                          fontSize: 12*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2125*ffem/fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // kl1400okU (23:36)
                  left: 113*fem,
                  top: 116*fem,
                  child: Align(
                    child: SizedBox(
                      width: 122*fem,
                      height: 15*fem,
                      child: Text(
                        eventTime,
                        style: TextStyle (
                          fontSize: 12*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2125*ffem/fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // mtemedwallstenuHi (23:37)
                  left: 19*fem,
                  top: 100*fem,
                  child: Align(
                    child: SizedBox(
                      width: 109*fem,
                      height: 15*fem,
                      child: Text(
                        eventName,
                        style: TextStyle (
                          fontSize: 12*ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2125*ffem/fem,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // wallstoeno8C (23:38)
                  left: 0*fem,
                  top: 0*fem,
                  child: Align(
                    child: SizedBox(
                      width: 325*fem,
                      height: 95*fem,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only (
                          topLeft: Radius.circular(20*fem),
                          topRight: Radius.circular(20*fem),
                        ),
                        child: Image.asset(
                          eventImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }



class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade800,
        title: const Text('Create'),
      ),
      body:
      const Center(child: Image(image: AssetImage('images/wallsten.jpg'))),
    );
  }
}
