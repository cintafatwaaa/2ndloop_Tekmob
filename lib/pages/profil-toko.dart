import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/shop_provider.dart';
import '../pages/models/produk_model.dart';
import '../models/shop_model.dart';
import '../widgets/bottom_navigation_bar.dart';

class ProfilTokoPage extends StatefulWidget {
  const ProfilTokoPage({super.key});

  @override
  State<ProfilTokoPage> createState() => _ProfilTokoPageState();
}

class _ProfilTokoPageState extends State<ProfilTokoPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    if (!_isInitialized) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      final shopProvider = Provider.of<ShopProvider>(context, listen: false);

      if (authProvider.user != null) {
        // Load shop data for the current user
        await shopProvider.getShopByOwner(authProvider.user!.uid);

        // Load products for the current seller
        productProvider.loadProductsBySeller(authProvider.user!.uid);
      }

      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _onSearchChanged(String query) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    productProvider.searchProducts(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, ProductProvider, ShopProvider>(
      builder: (context, authProvider, productProvider, shopProvider, child) {
        final user = authProvider.user;
        final products = productProvider.products;
        final isLoading = productProvider.isLoading || shopProvider.isLoading;
        final errorMessage = productProvider.errorMessage ?? shopProvider.error;
        final shop = shopProvider.currentShop;

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Please login to view your shop profile')),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header gambar toko + foto profil
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    shop?.headerImageUrl != null
                        ? Image.network(
                          shop!.headerImageUrl!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/header-toko.png',
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                        : Image.asset(
                          'assets/images/header-toko.png',
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                    Positioned(
                      bottom: -35,
                      left: 20,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 32,
                          backgroundImage:
                              shop?.logoUrl != null
                                  ? NetworkImage(shop!.logoUrl!)
                                  : const AssetImage(
                                        'assets/images/logo-toko.png',
                                      )
                                      as ImageProvider,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Info toko
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop?.shopName ?? user.displayName ?? "My Shop",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shop?.email ?? user.email ?? "No email",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Color.fromRGBO(120, 118, 118, 100),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  shop?.address ?? "Location not set",
                                  style: const TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "⭐ ${shop?.rating.toStringAsFixed(1) ?? '4.9'}/5.0 | ${shop?.totalProducts ?? products.length} Products",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to edit profile or settings
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            166,
                            142,
                            115,
                            1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Icon(
                          Icons.settings,
                          color: Color.fromRGBO(166, 142, 115, 1),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tab menu
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Produk",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 2,
                              width: 40,
                              color: Colors.brown,
                            ),
                          ],
                        ),
                        const Text(
                          "Pesanan",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                      height: 1,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: "Cari produk",
                      filled: true,
                      fillColor: const Color.fromRGBO(166, 142, 115, 0.6),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Produk grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProductGrid(isLoading, products, errorMessage),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Nav Bar
          bottomNavigationBar: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final userRole = authProvider.userModel?.role ?? 'buyer';
              return CustomBottomNavigationBar(
                currentIndex: 3, // Profil tab selected
                userRole: userRole,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(
    bool isLoading,
    List<Produk> products,
    String? errorMessage,
  ) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(166, 142, 115, 1),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Error: $errorMessage',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final productProvider = Provider.of<ProductProvider>(
                  context,
                  listen: false,
                );
                final shopProvider = Provider.of<ShopProvider>(
                  context,
                  listen: false,
                );
                if (authProvider.user != null) {
                  shopProvider.getShopByOwner(authProvider.user!.uid);
                  productProvider.loadProductsBySeller(authProvider.user!.uid);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(166, 142, 115, 1),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No products yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first product to get started!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Produk product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail
        context.push('/produk/${product.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child:
                  product.images.isNotEmpty
                      ? Image.network(
                        product.images.first,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 140,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 48,
                            ),
                          );
                        },
                      )
                      : Container(
                        height: 140,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 48,
                        ),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Rp ${product.harga.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
