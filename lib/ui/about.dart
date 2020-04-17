import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'About',
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                maxRadius: 80.0,
                backgroundImage: AssetImage('images/Kadek_Angga.jpg'),
              ),
              Text(
                'I Made Angga Darma Putra',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                ),
              ),
              Text(
                '1815051061',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                ),
              ),
              SizedBox(
                width: 180.0,
                height: 20.0,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Card(
                color: Colors.blueAccent,
                margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  title: Text(
                    '+62 878 5480 2591',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif'),
                  ),
                ),
              ),
              Card(
                color: Colors.blueAccent,
                margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  title: Text(
                    'angga.darma@undiksha.ac.id',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
