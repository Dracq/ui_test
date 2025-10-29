import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Make sure flutter_svg is in pubspec.yaml
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'preview_screen.dart';
import 'widgets/image_source_dialog.dart';
import 'auth_service.dart';
import 'home_popup.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildSectionTitle('Diseases'),
            _buildCategoryButton(
              context,
              'assets/icons/fruit.svg', // Replace with your actual SVG file path
              'Fruits & Flowers',
              'Identify diseases affecting the fruit',
            ),
            _buildCategoryButton(
              context,
              'assets/icons/leaf.svg', // Replace with your actual SVG file path
              'Leaf',
              'Analyze and identify leaf diseases',
            ),
            _buildCategoryButton(
              context,
              'assets/icons/root.svg', // Corrected to existing asset file
              'Roots',
              'Check for diseases affecting the roots',
            ),
            const SizedBox(height: 10),
            _buildSectionTitle('Insects & Pests'),
            _buildCategoryButton(
              context,
              'assets/icons/insects.svg', // Replace with your actual SVG file path
              'Live & Dead Insects Images',
              'Identify common insects and pests',
            ),
            _buildCategoryButton(
              context,
              'assets/icons/mix.svg', // Use existing mixed/flowers-like icon
              'Fruits, Flowers & Leaves Images',
              'Identify pests affecting flowers',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showLanguageSelection(context),
        backgroundColor: const Color(0xFF487530),
        child: const Icon(Icons.language, color: Colors.white),
      ),
    );
  }

  // Header Widget
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 25, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF487530), Color(0xFF39794F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', height: 80),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'AnarRakshak',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFa5d6a7),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your Pomegranate Farm Guard',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ]),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService().signOut();
              // The AuthWrapper will handle navigation to the LoginScreen
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 25, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  // Category Button Widget using SVGs
  Widget _buildCategoryButton(
    BuildContext context,
    String svgAssetPath,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (title == 'Fruits & Flowers' || title == 'Leaf') {
              await showImageSourceDialog(
                context: context,
                categoryTitle: title,
                onPick: (source) => _pickImageAndGo(context, source, title),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stay tuned for more updates !')),
              );
            }
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  svgAssetPath,
                  height: 65,
                  width: 65,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF39794F),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[850],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _pickImageAndGo(
  BuildContext context,
  ImageSource source,
  String categoryTitle,
) async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: source,
      imageQuality: 95,
    );
    if (picked == null) {
      return;
    }
    if (!context.mounted) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: const Color(0xFF487530),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (croppedFile == null) {
      return;
    }

    final bytes = await croppedFile.readAsBytes();

    if (!context.mounted) return;

    String modelName;
    List<String> labels;

    if (categoryTitle == 'Leaf') {
      modelName = 'LeafModel.onnx';
      labels = ['Bacterial', 'Fungal', 'Healthy'];
    } else {
      modelName = 'KD.onnx';
      labels = [
        'Bacterial Blight',
        'Calyx Rot',
        'Cercospora Fungus',
        'Fruit Rot',
        'Healthy',
        'Scab Fungus',
      ];
    }

    // Navigate to preview screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PreviewScreen(
          imageBytes: bytes,
          title: categoryTitle,
          modelName: modelName,
          labels: labels,
        ),
      ),
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get image: $e')));
    }
  }
}
