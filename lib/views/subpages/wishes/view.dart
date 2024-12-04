import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller.dart';

class WishesPage extends StatelessWidget {
  final controller = Get.put(WishesController());

  WishesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildOccasionSelector(),
                      const SizedBox(height: 24),
                      _buildWishEditor(),
                      const SizedBox(height: 24),
                      _buildTextStyleOptions(),
                      const SizedBox(height: 24),
                      _buildBackgroundOptions(),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Obx(() => controller.backgroundImage.value != null
        ? Image.file(
            controller.backgroundImage.value!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: controller.selectedTheme.value.backgroundColors,
              ),
            ),
          ));
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          Text(
            'Create Wishes',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionSelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.occasions.length,
        itemBuilder: (context, index) {
          final occasion = controller.occasions[index];
          return Obx(() => GestureDetector(
                onTap: () => controller.selectOccasion(occasion),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: controller.selectedOccasion.value == occasion
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        occasion.icon,
                        color: controller.selectedOccasion.value == occasion
                            ? controller.selectedTheme.value.primaryColor
                            : Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        occasion.name,
                        style: TextStyle(
                          color: controller.selectedOccasion.value == occasion
                              ? controller.selectedTheme.value.primaryColor
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget _buildWishEditor() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller.wishTextController,
            focusNode: controller.focusNode,
            style: GoogleFonts.getFont(
              controller.selectedFont.value,
              color: controller.textColor.value,
              fontSize: controller.fontSize.value,
              fontWeight:
                  controller.isBold.value ? FontWeight.bold : FontWeight.normal,
              fontStyle: controller.isItalic.value
                  ? FontStyle.italic
                  : FontStyle.normal,
              decoration: controller.isUnderlined.value
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Type your wish here...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ));
  }

  Widget _buildTextStyleOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text Style',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFontSelector(),
            _buildColorSelector(),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFontSizeSelector(),
            _buildTextStyleButtons(),
          ],
        ),
      ],
    );
  }

  Widget _buildFontSelector() {
    return Container(
      width: Get.width * 0.45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(() => DropdownButton<String>(
              value: controller.selectedFont.value,
              onChanged: (String? newValue) {
                if (newValue != null) controller.selectedFont.value = newValue;
              },
              items:
                  controller.fonts.map<DropdownMenuItem<String>>((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child:
                      Text(font, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              dropdownColor: Colors.grey[800],
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              isExpanded: true,
            )),
      ),
    );
  }

  Widget _buildColorSelector() {
    return SizedBox(
      width: Get.width * 0.45,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.textColors.length,
        itemBuilder: (context, index) {
          final color = controller.textColors[index];
          return GestureDetector(
            onTap: () => controller.textColor.value = color,
            child: Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: controller.textColor.value == color ? 3 : 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFontSizeSelector() {
    return SizedBox(
      width: Get.width * 0.45,
      child: Row(
        children: [
          const Text('Size:', style: TextStyle(color: Colors.white)),
          Expanded(
            child: Obx(() => Slider(
                  value: controller.fontSize.value,
                  min: 12,
                  max: 32,
                  divisions: 10,
                  label: controller.fontSize.value.round().toString(),
                  onChanged: (value) => controller.fontSize.value = value,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildTextStyleButtons() {
    return SizedBox(
      width: Get.width * 0.45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStyleToggleButton(Icons.format_bold, controller.isBold),
          _buildStyleToggleButton(Icons.format_italic, controller.isItalic),
          _buildStyleToggleButton(
              Icons.format_underline, controller.isUnderlined),
        ],
      ),
    );
  }

  Widget _buildStyleToggleButton(IconData icon, RxBool isSelected) {
    return Obx(() => IconButton(
          icon: Icon(icon,
              color: isSelected.value
                  ? Colors.white
                  : Colors.white.withOpacity(0.5)),
          onPressed: () => isSelected.toggle(),
        ));
  }

  Widget _buildBackgroundOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Background',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: controller.pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Select Image'),
              style: ElevatedButton.styleFrom(),
            ),
            ElevatedButton.icon(
              onPressed: controller.removeBackgroundImage,
              icon: const Icon(Icons.delete),
              label: const Text('Remove Image'),
              style: ElevatedButton.styleFrom(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Color Themes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.colorThemes.length,
            itemBuilder: (context, index) {
              final theme = controller.colorThemes[index];
              return GestureDetector(
                onTap: () => controller.selectedTheme.value = theme,
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: theme.backgroundColors,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: controller.selectedTheme.value == theme ? 3 : 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: controller.shareWish,
          icon: const Icon(Icons.share),
          label: const Text('Share'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: controller.saveWish,
          icon: const Icon(Icons.save),
          label: const Text('Save'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('About Wishes'),
        content: const Text(
            'Create beautiful wishes for various occasions. Customize the text, font, color, and background to make your wishes unique.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
