import 'package:flutter/material.dart';
import 'package:larapush/larapush.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize LaraPush
  await initializeLaraPush();
  
  runApp(MyApp());
}

Future<void> initializeLaraPush() async {
  try {
    await LaraPush.initialize(
      panelUrl: "https://your-larapush-panel-domain/",
      applicationId: "com.example.larapush_demo",
      debug: true,
    );
    
    // Get and print token
    final token = await LaraPush.getToken();
    print("FCM Token: $token");
    
    // Set initial tags
    await LaraPush.setTags(["flutter", "demo", "larapush"]);
    
    print("LaraPush initialized successfully");
  } catch (e) {
    print("LaraPush initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaraPush Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'LaraPush Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _tags = [];
  String _token = '';
  bool _notificationsEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final tags = await LaraPush.getTags();
      final token = await LaraPush.getToken();
      final enabled = await LaraPush.areNotificationsEnabled();
      
      setState(() {
        _tags = tags;
        _token = token;
        _notificationsEnabled = enabled;
      });
    } catch (e) {
      _showErrorSnackBar('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _addTag() async {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Tag'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter tag name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (controller.text.isNotEmpty) {
                try {
                  await LaraPush.setTags([controller.text]);
                  _showSuccessSnackBar('Tag added successfully');
                  _loadData();
                } catch (e) {
                  _showErrorSnackBar('Error adding tag: $e');
                }
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeTag(String tag) async {
    try {
      await LaraPush.removeTags([tag]);
      _showSuccessSnackBar('Tag removed successfully');
      _loadData();
    } catch (e) {
      _showErrorSnackBar('Error removing tag: $e');
    }
  }

  Future<void> _clearAllTags() async {
    try {
      await LaraPush.clearTags();
      _showSuccessSnackBar('All tags cleared');
      _loadData();
    } catch (e) {
      _showErrorSnackBar('Error clearing tags: $e');
    }
  }

  Future<void> _refreshToken() async {
    try {
      await LaraPush.refreshToken();
      _showSuccessSnackBar('Token refreshed successfully');
      _loadData();
    } catch (e) {
      _showErrorSnackBar('Error refreshing token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  SizedBox(height: 16),
                  _buildTagsCard(),
                  SizedBox(height: 16),
                  _buildActionsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LaraPush Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text('Notifications Enabled: $_notificationsEnabled'),
            SizedBox(height: 8),
            Text('FCM Token:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(
              _token,
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tags (${_tags.length})',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton(
                  onPressed: _addTag,
                  child: Text('Add Tag'),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (_tags.isEmpty)
              Text('No tags set')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) => Chip(
                  label: Text(tag),
                  deleteIcon: Icon(Icons.close, size: 18),
                  onDeleted: () => _removeTag(tag),
                )).toList(),
              ),
            if (_tags.isNotEmpty) ...[
              SizedBox(height: 8),
              TextButton(
                onPressed: _clearAllTags,
                child: Text('Clear All Tags'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _refreshToken,
              child: Text('Refresh Token'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Reload Data'),
            ),
          ],
        ),
      ),
    );
  }
}
