import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/list_item.dart';
import '../Widgets/new_item.dart';
import '../Authentication/authentication.dart';
import '../Screens/calendar_screen.dart';
import '../Screens/notifications_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();
  User? _user;
  late final NotificationService notificationService;

  List<ListItem> _userItems = [
    ListItem(
      id: "course1",
      course: "Mobile Information System",
      date: DateTime.now(),
    ),
  ];

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
      context: ct,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {},
          child: NewItem(_addNewItemToList),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewItemToList(ListItem item) {
    setState(() {
      _userItems.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      _userItems.removeWhere((e) => e.id == id);
    });
  }

  @override
  void initState() {
    notificationService = NotificationService();
    notificationService.initialize();
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() async {
    final User? user = await _authService.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  void _signInWithEmailAndPassword(String email, String password) async {
    try {
      final User? user =
      await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        setState(() {
          _user = user;
        });
        Navigator.of(context).pop();
      }
    } catch (error) {
      setState(() {
        // Handle the error
      });
    }
  }

  void _showSignInPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController emailController = TextEditingController();
        final TextEditingController passwordController = TextEditingController();

        return AlertDialog(
          title: Text('Sign In'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String email = emailController.text.trim();
                final String password = passwordController.text;
                _signInWithEmailAndPassword(email, password);
              },
              child: Text('Sign In'),
            ),
          ],
        );
      },
    );
  }

  void _signOut() async {
    await _authService.signOut();
    setState(() {
      _user = null;
    });
  }

  void _showCalendarScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CalendarScreen(exams: _userItems))
    );
  }

  void _showNotificationsScreen() async {
    await notificationService.showNotification(
        id: 0,
        title: 'Exams session is close',
        body: 'Check your calendar');
  }

  void _editNotificationsScreen() async {
    await notificationService.showScheduledNotification(
        id: 0,
        title: 'Exams session is close',
        body: 'Check your calendar',
        seconds: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcoming exams"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () => _addItemFunction(context),
          ),
          ElevatedButton(
            onPressed: _showCalendarScreen,
            child: Icon(Icons.calendar_today),
          ),
          ElevatedButton(
              onPressed: _showNotificationsScreen,
              child: Icon(Icons.notifications_active,)
          ),
          ElevatedButton (
              onPressed: _editNotificationsScreen,
              child:  Icon(Icons.edit_notifications_outlined,)
          ),
          if (_user == null)
            ElevatedButton(
              onPressed: _showSignInPrompt,
              child: Icon(Icons.login),
            ),
          if (_user != null)
            ElevatedButton(
              onPressed: _signOut,
              child: Icon(Icons.logout),
            ),
        ],
      ),
      body: Center(
        child: _user == null
            ? ElevatedButton(
          onPressed: _showSignInPrompt,
          child: Text('Sign In'),
        )
            : _userItems.isEmpty
            ? Text("No exams")
            : ListView.builder(
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: ListTile(
                title: Text(
                  _userItems[index].course,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                subtitle: Text(
                  "Date: " +
                      _userItems[index].date.day.toString() +
                      "." +
                      _userItems[index].date.month.toString() +
                      "." +
                      _userItems[index].date.year.toString() +
                      "   Time: " +
                      _userItems[index].date.hour.toString() +
                      ":" +
                      _userItems[index].date.minute.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      _deleteItem(_userItems[index].id),
                ),
              ),
            );
          },
          itemCount: _userItems.length,
        ),
      ),
    );
  }
}
