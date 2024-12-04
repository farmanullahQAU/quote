import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PhotographerProfileView extends StatefulWidget {
  final String photographerName;
  final String photographerUrl;
  final String? profileImageUrl;

  const PhotographerProfileView({
    super.key,
    required this.photographerName,
    required this.photographerUrl,
    this.profileImageUrl,
  });

  @override
  _PhotographerProfilePageState createState() =>
      _PhotographerProfilePageState();
}

class _PhotographerProfilePageState extends State<PhotographerProfileView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.photographerUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),

      // CustomScrollView(
      //   slivers: [
      //     const SliverAppBar(
      //       // expandedHeight: 200.0,
      //       floating: false,
      //       pinned: true,
      // flexibleSpace: FlexibleSpaceBar(
      //   title: Text(widget.photographerName),
      //   background: widget.profileImageUrl != null
      //       ? CachedNetworkImage(
      //           imageUrl: widget.profileImageUrl!,
      //           fit: BoxFit.cover,
      //         )
      //       : Container(
      //           color: Colors.grey[300],
      //           child: Icon(Icons.person,
      //               size: 100, color: Colors.grey[600]),
      //         ),
    );
    // ),
    //  SliverToBoxAdapter(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             'Photographer Profile',
    //             style: Theme.of(context).textTheme.headlineSmall,
    //           ),
    //           const SizedBox(height: 16),
    //           ElevatedButton.icon(
    //             icon: const Icon(Icons.open_in_new),
    //             label: const Text('View on Pexels'),
    //             onPressed: () => _launchURL(widget.photographerUrl),
    //             style: ElevatedButton.styleFrom(
    //                 // primary: Colors.green,
    //                 // onPrimary: Colors.white,
    //                 ),
    //           ),
    //           const SizedBox(height: 24),
    //           Text(
    //             'Pexels Profile',
    //             style: Theme.of(context).textTheme.titleLarge,
    //           ),
    //           const SizedBox(height: 8),
    //         ],
    //       ),
    //     ),
    //   ),
    //       SliverFillRemaining(
    //         child: WebViewWidget(controller: _controller),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      Get.snackbar('Error', 'Could not launch $url');
    }
  }
}
