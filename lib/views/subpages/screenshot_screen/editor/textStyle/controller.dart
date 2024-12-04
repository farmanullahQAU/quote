import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:myapp/constrants.dart';
import 'package:myapp/models/txts_style_model.dart';

import '../view.dart';
import 'text_case_selector.dart';

class TextController extends GetxController with GetTickerProviderStateMixin {
  late TabController colorsTabController;

  late Rx<TextStyleModel> textStyleModel;
  late TabController
      fontFamilysTabController; //google font families tabcontrollers

  Rxn<Color> selectedColor = Rxn<Color>();
  Rxn<String> selectedFontFamily = Rxn<String>();

  Rxn<int> selectHorizAlignmentIndex = Rxn<int>();
  RxDouble currentFontSize = RxDouble(22);
  Rx<FontCase> selectedCase = Rx<FontCase>(FontCase.titlecase);

  @override
  void onInit() {
    // Reactive TextStyleModel
    textStyleModel = TextStyleModel(
      fontSize: currentFontSize.value,
      fontFamily: selectedFontFamily.value,
      fontColor: selectedColor.value,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.normal,
    ).obs;
    initColorsTabController();
    initfontFamilyaTabController();

    super.onInit();
  }

  // Method to update font size
  void updateFontSize(double newSize) {
    currentFontSize(newSize);
    textStyleModel.value = textStyleModel.value.copyWith(fontSize: newSize);
  }

  // Method to update font family
  void updateFontFamily(int index) {
    selectedFontFamily(fontFamilies[index]);
    textStyleModel.value =
        textStyleModel.value.copyWith(fontFamily: selectedFontFamily.value);
  }

  // Method to update font color
  void updateFontColor(int index) {
    selectedColor(colors[index]);
    textStyleModel.value =
        textStyleModel.value.copyWith(fontColor: selectedColor.value);
  }

  // Method to update text alignment
  void updateTextAlign(TextAlign newAlign, int index) {
    selectHorizAlignmentIndex(index);
    textStyleModel.value = textStyleModel.value.copyWith(textAlign: newAlign);
  }

  updateTextCase(FontCase textCase) {
    selectedCase(textCase);
    textStyleModel.value = textStyleModel.value.copyWith(fontCase: textCase);
  }

  // Method to update font weight
  void updateFontWeight(FontWeight newWeight) {
    textStyleModel.value = textStyleModel.value.copyWith(fontWeight: newWeight);
  }

  void initColorsTabController() {
    colorsTabController =
        TabController(initialIndex: 1, length: colors.length, vsync: this);
  }

  void initfontFamilyaTabController() {
    fontFamilysTabController = TabController(
        initialIndex: 1, length: fontFamilies.length, vsync: this);
  }

  clearSelection(dynamic option) {
    if (option is TxtStyleOption) {
      Logger().d(option);
      //First tab (Text option is selected)

      switch (option) {
        case TxtStyleOption.fontFamily:
          {
            textStyleModel.value = textStyleModel.value
                .copyWith(fontFamily: null); //clear fontFamilhy selection
          }
          break;
        case TxtStyleOption.color:
          {
            textStyleModel.value =
                textStyleModel.value.copyWith(fontColor: null);
          } //clear color selection
        case TxtStyleOption.fontSize:
          {
            textStyleModel.value =
                textStyleModel.value.copyWith(fontSize: null);
          }
        default:
      }
    } else {}

    Logger().e(textStyleModel.value.fontFamily);
  }
}
