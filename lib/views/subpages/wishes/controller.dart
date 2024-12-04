import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WishesController extends GetxController {
  final occasions = [
    Occasion('Eid', Icons.light),
    Occasion('Valentine\'s Day', Icons.favorite),
    Occasion('Birthday', Icons.cake),
    Occasion('New Year', Icons.celebration),
    // Add more occasions as needed
  ];

  final colorThemes = [
    ColorTheme([const Color(0xFFFFA07A), const Color(0xFFFFD700)],
        const Color(0xFF8B4513)),
    ColorTheme([const Color(0xFF87CEEB), const Color(0xFF00CED1)],
        const Color(0xFF4682B4)),
    ColorTheme([const Color(0xFFDDA0DD), const Color(0xFFEE82EE)],
        const Color(0xFF8B008B)),
    // Add more color themes
  ];

  final fonts = ['Roboto', 'Poppins', 'Playfair Display', 'Montserrat'];

  final textColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  final selectedOccasion = Rx<Occasion?>(null);
  final selectedTheme = Rx<ColorTheme>(ColorTheme(
      [const Color(0xFFFFA07A), const Color(0xFFFFD700)],
      const Color(0xFF8B4513)));
  final selectedFont = RxString('Roboto');
  final textColor = Rx<Color>(Colors.black);
  final fontSize = RxDouble(18);
  final isBold = RxBool(false);
  final isItalic = RxBool(false);
  final isUnderlined = RxBool(false);

  final wishTextController = TextEditingController();
  final focusNode = FocusNode();

  final backgroundImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    selectedOccasion.value = occasions.first;
  }

  void selectOccasion(Occasion occasion) {
    selectedOccasion.value = occasion;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      backgroundImage.value = File(pickedFile.path);
    }
  }

  void removeBackgroundImage() {
    backgroundImage.value = null;
  }

  Future<void> shareWish() async {
    // TODO: Implement share functionality
    // This could involve generating an image of the wish and sharing it
    Get.snackbar('Share', 'Sharing functionality to be implemented');
  }

  Future<void> saveWish() async {
    // TODO: Implement save functionality
    // This could involve saving the wish as an image or to a database
    Get.snackbar('Save', 'Saving functionality to be implemented');
  }

  @override
  void onClose() {
    wishTextController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}

class Occasion {
  final String name;
  final IconData icon;

  Occasion(this.name, this.icon);
}

class ColorTheme {
  final List<Color> backgroundColors;
  final Color primaryColor;

  ColorTheme(this.backgroundColors, this.primaryColor);
}
