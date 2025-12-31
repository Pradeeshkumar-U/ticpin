import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  String _selectedTheme = 'system'; // system, light, dark
  bool _enableAnimations = true;
  double _fontSize = 1.0; // Normal size
  Sizes size = Sizes();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTheme = prefs.getString('theme') ?? 'system';
      _enableAnimations = prefs.getBool('animations') ?? true;
      _fontSize = prefs.getDouble('fontSize') ?? 1.0;
    });
  }

  Future<void> _saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    setState(() => _selectedTheme = theme);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Theme updated. Restart app to apply changes.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _toggleAnimations(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animations', value);
    setState(() => _enableAnimations = value);
  }

  Future<void> _updateFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', value);
    setState(() => _fontSize = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Appearance',
          style: TextStyle(fontFamily: 'Regular'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSectionTitle('Theme'),
          SizedBox(height: 12),
          _buildThemeCard(
            'System Default',
            'Follow device settings',
            Icons.phone_android,
            'system',
          ),
          SizedBox(height: 12),
          _buildThemeCard(
            'Light Mode',
            'Light and bright',
            Icons.light_mode,
            'light',
          ),
          SizedBox(height: 12),
          _buildThemeCard(
            'Dark Mode',
            'Easy on the eyes',
            Icons.dark_mode,
            'dark',
          ),

          SizedBox(height: 32),

          // Font Size Section
          _buildSectionTitle('Text Size'),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Text(
                  'Sample Text',
                  style: TextStyle(
                    fontSize: 16 * _fontSize,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Adjust the text size to your preference',
                  style: TextStyle(
                    fontSize: 14 * _fontSize,
                    fontFamily: 'Regular',
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('A', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Slider(
                        value: _fontSize,
                        min: 0.8,
                        max: 1.5,
                        divisions: 7,
                        activeColor: blackColor,
                        onChanged: _updateFontSize,
                      ),
                    ),
                    Text('A', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Text(
                  '${(_fontSize * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Regular',
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Animations Section
          _buildSectionTitle('Animations'),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.animation,
                  color: _enableAnimations ? blackColor : Colors.grey,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Animations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Smooth transitions and effects',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Regular',
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _enableAnimations,
                  onChanged: _toggleAnimations,
                  activeColor: blackColor,
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Color Accent (Future Feature)
          _buildSectionTitle('Accent Color (Coming Soon)'),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildColorOption(Colors.blue, false),
              _buildColorOption(Colors.purple, false),
              _buildColorOption(Colors.green, false),
              _buildColorOption(Colors.orange, false),
              _buildColorOption(Colors.red, false),
              _buildColorOption(Colors.teal, false),
            ],
          ),

          SizedBox(height: 32),

          // Reset Button
          OutlinedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('theme');
              await prefs.remove('animations');
              await prefs.remove('fontSize');
              setState(() {
                _selectedTheme = 'system';
                _enableAnimations = true;
                _fontSize = 1.0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings reset to default'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Text(
              'Reset to Default',
              style: TextStyle(
                fontFamily: 'Regular',
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Regular',
      ),
    );
  }

  Widget _buildThemeCard(String title, String subtitle, IconData icon, String theme) {
    final isSelected = _selectedTheme == theme;
    
    return InkWell(
      onTap: () => _saveTheme(theme),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade700,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Regular',
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coming soon!'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: isSelected
            ? Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }
}