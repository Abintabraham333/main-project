import 'package:flutter/material.dart';
import 'landing_page.dart'; // Import LandingPage for logout

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Management Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Navigate back to the LandingPage (Logout)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Waste Management Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text('Waste Collection Schedule'),
                  subtitle: Text('Find out when your waste will be collected.'),
                  leading: Icon(Icons.calendar_today),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Add functionality for waste collection schedule
                  },
                ),
              ),
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text('Recycling Information'),
                  subtitle: Text('Learn about recycling programs in your area.'),
                  leading: Icon(Icons.recycling),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Add functionality for recycling info
                  },
                ),
              ),
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text('Waste Disposal Tips'),
                  subtitle: Text('Tips for safe and effective waste disposal.'),
                  leading: Icon(Icons.info),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Add functionality for waste disposal tips
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the landing page (logout)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LandingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
