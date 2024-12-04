import "package:flutter/material.dart";

const primaryColor = Color(0xff0cc0df);
const primaryColor2 = Color(0xff8965e9);
const primaryColor3 = Color(0xff24a7e9);

Color primaryColor4 = const Color(0xfffea33e);
const primaryColor5 = Color(0xff16b876);

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff63568f),
      surfaceTint: Color(0xff63568f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe8deff),
      onPrimaryContainer: Color(0xff1f1048),
      secondary: Color(0xff605690),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe6deff),
      onSecondaryContainer: Color(0xff1c1149),
      tertiary: Color(0xff6b538c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffeddcff),
      onTertiaryContainer: Color(0xff260e44),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff7fb),
      onSurface: Color(0xff1f1a1f),
      onSurfaceVariant: Color(0xff4f4449),
      outline: Color(0xff81737a),
      outlineVariant: Color(0xffd3c2c9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f34),
      inversePrimary: Color(0xffcdbdff),
      primaryFixed: Color(0xffe8deff),
      onPrimaryFixed: Color(0xff1f1048),
      primaryFixedDim: Color(0xffcdbdff),
      onPrimaryFixedVariant: Color(0xff4b3e76),
      secondaryFixed: Color(0xffe6deff),
      onSecondaryFixed: Color(0xff1c1149),
      secondaryFixedDim: Color(0xffcabeff),
      onSecondaryFixedVariant: Color(0xff483f77),
      tertiaryFixed: Color(0xffeddcff),
      onTertiaryFixed: Color(0xff260e44),
      tertiaryFixedDim: Color(0xffd7bafb),
      onTertiaryFixedVariant: Color(0xff533c72),
      surfaceDim: Color(0xffe1d7de),
      surfaceBright: Color(0xfffff7fb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf1f8),
      surfaceContainer: Color(0xfff6ebf2),
      surfaceContainerHigh: Color(0xfff0e5ec),
      surfaceContainerHighest: Color(0xffeae0e7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff473a72),
      surfaceTint: Color(0xff63568f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7a6ca7),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff443b72),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff776da8),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4f386e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8269a4),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7fb),
      onSurface: Color(0xff1f1a1f),
      onSurfaceVariant: Color(0xff4b4045),
      outline: Color(0xff685c62),
      outlineVariant: Color(0xff85777d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f34),
      inversePrimary: Color(0xffcdbdff),
      primaryFixed: Color(0xff7a6ca7),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff61538d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff776da8),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5e548e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8269a4),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff695189),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe1d7de),
      surfaceBright: Color(0xfffff7fb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf1f8),
      surfaceContainer: Color(0xfff6ebf2),
      surfaceContainerHigh: Color(0xfff0e5ec),
      surfaceContainerHighest: Color(0xffeae0e7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff26184f),
      surfaceTint: Color(0xff63568f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff473a72),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff23194f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff443b72),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2d154b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4f386e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7fb),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff2b2126),
      outline: Color(0xff4b4045),
      outlineVariant: Color(0xff4b4045),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff342f34),
      inversePrimary: Color(0xfff1e8ff),
      primaryFixed: Color(0xff473a72),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff31235a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff443b72),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2e245b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4f386e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff382156),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe1d7de),
      surfaceBright: Color(0xfffff7fb),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffbf1f8),
      surfaceContainer: Color(0xfff6ebf2),
      surfaceContainerHigh: Color(0xfff0e5ec),
      surfaceContainerHighest: Color(0xffeae0e7),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdbdff),
      surfaceTint: Color(0xffcdbdff),
      onPrimary: Color(0xff34275e),
      primaryContainer: Color(0xff4b3e76),
      onPrimaryContainer: Color(0xffe8deff),
      secondary: Color(0xffcabeff),
      onSecondary: Color(0xff32285f),
      secondaryContainer: Color(0xff483f77),
      onSecondaryContainer: Color(0xffe6deff),
      tertiary: Color(0xffd7bafb),
      onTertiary: Color(0xff3b255a),
      tertiaryContainer: Color(0xff533c72),
      onTertiaryContainer: Color(0xffeddcff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      // surface: Color(0xff35374B),
      surface: Color(0xFF1E2530),
      onSurface: Color(0xffeae0e7),
      onSurfaceVariant: Color(0xffd3c2c9),
      outline: Color(0xff9c8d93),
      outlineVariant: Color(0xff4f4449),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae0e7),
      inversePrimary: Color(0xff63568f),
      primaryFixed: Color(0xffe8deff),
      onPrimaryFixed: Color(0xff1f1048),
      primaryFixedDim: Color(0xffcdbdff),
      onPrimaryFixedVariant: Color(0xff4b3e76),
      secondaryFixed: Color(0xffe6deff),
      onSecondaryFixed: Color(0xff1c1149),
      secondaryFixedDim: Color(0xffcabeff),
      onSecondaryFixedVariant: Color(0xff483f77),
      tertiaryFixed: Color(0xffeddcff),
      onTertiaryFixed: Color(0xff260e44),
      tertiaryFixedDim: Color(0xffd7bafb),
      onTertiaryFixedVariant: Color(0xff533c72),
      surfaceDim: Color(0xff35374B),
      surfaceBright: Color(0xff3d373d),
      surfaceContainerLowest: Color(0xff110d11),
      surfaceContainerLow: Color(0xff1f1a1f),
      surfaceContainer: Color(0xff35374B),
      surfaceContainerHigh: Color(0xff2e282e),
      surfaceContainerHighest: Color(0xff393338),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd1c2ff),
      surfaceTint: Color(0xffcdbdff),
      onPrimary: Color(0xff1a0942),
      primaryContainer: Color(0xff9788c5),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcec3ff),
      onSecondary: Color(0xff170a43),
      secondaryContainer: Color(0xff9389c6),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffdbbfff),
      onTertiary: Color(0xff20073f),
      tertiaryContainer: Color(0xff9f85c2),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xFF1E2530),
      onSurface: Color(0xfffff9fa),
      onSurfaceVariant: Color(0xffd7c6cd),
      outline: Color(0xffae9fa6),
      outlineVariant: Color(0xff8e7f86),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae0e7),
      inversePrimary: Color(0xff4c3f77),
      primaryFixed: Color(0xffe8deff),
      onPrimaryFixed: Color(0xff14033d),
      primaryFixedDim: Color(0xffcdbdff),
      onPrimaryFixedVariant: Color(0xff3a2d64),
      secondaryFixed: Color(0xffe6deff),
      onSecondaryFixed: Color(0xff12043e),
      secondaryFixedDim: Color(0xffcabeff),
      onSecondaryFixedVariant: Color(0xff382e65),
      tertiaryFixed: Color(0xffeddcff),
      onTertiaryFixed: Color(0xff1b0239),
      tertiaryFixedDim: Color(0xffd7bafb),
      onTertiaryFixedVariant: Color(0xff412b61),
      surfaceDim: Color(0xff35374B),
      surfaceBright: Color(0xff3d373d),
      surfaceContainerLowest: Color(0xff110d11),
      surfaceContainerLow: Color(0xff1f1a1f),
      surfaceContainer: Color(0xff35374B),
      surfaceContainerHigh: Color(0xff2e282e),
      surfaceContainerHighest: Color(0xff393338),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffef9ff),
      surfaceTint: Color(0xffcdbdff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffd1c2ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffef9ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffcec3ff),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9fd),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffdbbfff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xFF1E2530),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffd7c6cd),
      outlineVariant: Color(0xffd7c6cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffeae0e7),
      inversePrimary: Color(0xff2e2057),
      primaryFixed: Color(0xffece2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffd1c2ff),
      onPrimaryFixedVariant: Color(0xff1a0942),
      secondaryFixed: Color(0xffeae3ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffcec3ff),
      onSecondaryFixedVariant: Color(0xff170a43),
      tertiaryFixed: Color(0xfff0e1ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffdbbfff),
      onTertiaryFixedVariant: Color(0xff20073f),
      surfaceDim: Color(0xff35374B),
      surfaceBright: Color(0xff3d373d),
      surfaceContainerLowest: Color(0xff110d11),
      surfaceContainerLow: Color(0xff1f1a1f),
      surfaceContainer: Color(0xff35374B),
      surfaceContainerHigh: Color(0xff2e282e),
      surfaceContainerHighest: Color(0xff393338),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
