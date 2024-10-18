import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testbdgtt/screens/login_screen.dart';
import 'package:testbdgtt/widgets/add_transactions.dart';
import 'package:testbdgtt/widgets/herocard.dart';
import 'package:testbdgtt/widgets/transactions_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoading = false;
  String username = ""; // To hold the user's username
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (doc.exists) {
          setState(() {
            username = doc['username'] ?? "User"; // Default to "User" if username is not found
          });
        } else {
          print("User document does not exist.");
        }
      } catch (e) {
        print("Error fetching username: $e");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  logOut() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView()),
    );
    setState(() {
      isLogoutLoading = false;
    });
  }

  _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: AddTransactionsForm(),
        );
      },
    );
  }

  // Function to handle opening the drawer
  _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFB8C2B),
        onPressed: () {
          _dialogBuilder(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 10,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFB8C2B),
        title: _buildAppBarTitle(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        GestureDetector(
          onTap: _openDrawer, // Open the drawer when tapped
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(width: 10), // Add space between profile and username
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(), // Listen for real-time updates
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final userDoc = snapshot.data!;
              final newUsername = userDoc['username'] ?? "User";
              return Text(
                "Hello, $newUsername",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              return Text(
                "Hello, User",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeroCard(),
            SizedBox(height: 20),
            _buildTransactionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: HeroCard(userId: userId),
      ),
    );
  }

  Widget _buildTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Transactions",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TransactionsCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFB8C2B),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Hello, $username",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Change Username'),
            onTap: () {
              Navigator.pushNamed(context, '/changeUsername').then((_) {
                fetchUserName(); // Refresh username after returning to HomeScreen
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              Navigator.pushNamed(context, '/changePassword');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              logOut();
            },
          ),
        ],
      ),
    );
  }
}
