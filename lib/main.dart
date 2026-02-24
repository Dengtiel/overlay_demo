import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Holds a reference to the floating entry so we can remove it later
  OverlayEntry? _overlayEntry;

  // --- ATTRIBUTE 1: opaque ---
  // Controls whether the overlay blocks interaction with widgets beneath it.
  // false (default) = user can still tap things below the overlay.
  // true            = everything under the overlay is un-tappable.
  final bool _isOpaque = false;

  // --- ATTRIBUTE 2: maintainState ---
  // When false (default) the overlay's subtree is rebuilt each time it appears.
  // When true  the state is preserved even when the overlay is not visible.
  final bool _maintainState = false;

  void _showOverlay(BuildContext context) {
    // Grab the Overlay state that Flutter's Navigator already provides
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      // ATTRIBUTE 1 applied here
      opaque: _isOpaque,

      // ATTRIBUTE 2 applied here
      maintainState: _maintainState,

      // --- ATTRIBUTE 3: builder ---
      // A required function that returns the widget tree for this floating layer.
      // Runs every time the overlay needs to repaint.
      builder: (context) {
        return Positioned(
          top: 180,
          left: 40,
          right: 40,
          child: Material(
            // Material lifts the overlay above ink/theme inheritance issues
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: Colors.indigo.shade700,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '📦 Product Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This wireless charger delivers 15W fast charging '
                    'and is compatible with all Qi-enabled devices.',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _removeOverlay,
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Insert the entry into the Overlay stack
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay(); // clean up if user navigates away
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Listing')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.electrical_services,
                  size: 64,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Wireless Charger Pro',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '\$29.99',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showOverlay(context),
                  icon: const Icon(Icons.info_outline),
                  label: const Text('View Details'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
