import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:myapp/services/localization.dart';
import 'package:myapp/views/tabs/home/controller.dart';
import 'package:myapp/views/widets/nodata.dart';
import 'package:myapp/views/widets/toast.dart';

import '../subpages/screenshot_screen/view.dart';
import 'controller.dart';

class FavQuotesPage extends StatelessWidget {
  final FavQuotesController controller = Get.put(FavQuotesController());

  FavQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.theme.colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Obx(() {
          return controller.isSearching.value
              ? TextField(
                  onChanged: (query) {
                    controller.searchQuotes(query);
                  },
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                )
              : const Text('Favorite Quotes');
        }),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                controller.isSearching.value ? Icons.clear : Icons.search,
              ),
              onPressed: () {
                if (controller.isSearching.value) {
                  controller.searchQuotes(''); // Clear search
                }
                controller.toggleSearch(); // Toggle search state
              },
            );
          }),
          PopupMenuButton<String>(
            onSelected: (value) {
              controller.sortQuotes(value);
            },
            itemBuilder: (BuildContext context) {
              return {'author', 'text'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text('Sort by $choice'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.filteredQuotes.isEmpty) {
          return const NoDataWidget();
        }
        return ListView.builder(
          itemCount: controller.filteredQuotes.length,
          itemBuilder: (context, index) {
            final quote = controller.filteredQuotes[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                tileColor: context.theme.colorScheme.surface,
                title: Text(quote.text),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quote.author?[
                            LocalizationService().currentLocaleString] ??
                        'Unknown'),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.to(() => ScreenshotScreen(
                                  selectedtheme: Get.find<HomeController>()
                                      .selectedTheme
                                      .value,
                                  data: quote));
                            },
                            icon: const Icon(FontAwesomeIcons.share)),
                        IconButton(
                            onPressed: () {
                              //copy conents
                              Clipboard.setData(
                                  ClipboardData(text: quote.text));
                              MyToast.showToast(
                                  message: "Copied", type: ToastType.success);
                            },
                            icon: const Icon(FontAwesomeIcons.copy))
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    quote.isFavorite.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () {
                    controller.toggleFavorite(quote);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
