import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

// ----------------------------------------------------------------------
// MAIN SCREEN
// ----------------------------------------------------------------------
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // 竖屏排版 (去掉了外层的 const 数组声明)
  Widget _buildPortraitView() {
    return ListView(
      children: const [
        StudentDetailsSection(),
        TitleSection(
          name: 'University of Technology Sarawak',
          location: 'Sibu, Sarawak',
          starCount: 41,
        ),
        ImageSection(imagePath: 'assets/uts.jpg'),
        InteractivePickersSection(),
      ],
    );
  }

  // 横屏排版 (修复了 const 问题)
  Widget _buildLandscapeView() {
    return Row(
      children: [
        Expanded(
          child: ListView(
            children: [
              StudentDetailsSection(),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: const [
              TitleSection(
                name: 'University of Technology Sarawak',
                location: 'Sibu, Sarawak',
                starCount: 41,
              ),
              ImageSection(imagePath: 'assets/uts.jpg'),
              InteractivePickersSection(),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------------------------
// DECOMPOSED WIDGET 3: Image Section (新增的风景图组件)
// ----------------------------------------------------------------------
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// NEW COMPONENT: Interactive Pickers (StatefulWidget)
// ----------------------------------------------------------------------
class InteractivePickersSection extends StatefulWidget {
  const InteractivePickersSection({super.key});

  @override
  State<InteractivePickersSection> createState() => _InteractivePickersSectionState();
}

class _InteractivePickersSectionState extends State<InteractivePickersSection> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';
  final List<String> _roles = ['Student', 'Developer', 'Designer'];

  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: _roles.indexOf(_selectedRole),
          ),
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = _roles[index]);
          },
          children: _roles.map((role) => Center(child: Text(role))).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interactive Pickers (Lab 2.2)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Divider(),
              Text('Selected Date: ${_selectedDate.toString().split(' ')[0]}'),
              Text('Selected Role: $_selectedRole'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Material Date Picker'),
                  onPressed: () => _selectMaterialDate(context),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(CupertinoIcons.calendar),
                  label: const Text('Cupertino Date Picker (Sheet)'),
                  onPressed: () => _showCupertinoDatePicker(context),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Material Dropdown: '),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedRole = newValue);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(CupertinoIcons.list_bullet),
                  label: const Text('Cupertino Role Wheel Picker'),
                  onPressed: () => _showCupertinoRolePicker(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// DECOMPOSED WIDGET 1: Student Details
// ----------------------------------------------------------------------
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/Reb.jpeg'),
              ),
              const SizedBox(height: 20),
              const Text(
                'REBECCA KONG LEE ZHEN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Student ID: BCS24090014',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Divider(height: 32, thickness: 1),
              const Text(
                'Personal Life Goal / Quote:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                '"Keep growing, stay curious, and turn every '
                    'obstacle into an opportunity."',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.indigo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// DECOMPOSED WIDGET 2: Title Section
// ----------------------------------------------------------------------
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0), // 老师和官方教程使用的标准边距
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(location, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}