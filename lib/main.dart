import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/seller_page.dart';
import 'package:flutter_application_1/pages/setting_page.dart';
import 'package:flutter_application_1/pages/wait.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/shop_provider.dart';
import 'pages/halaman_awal.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/menu_page_new.dart';
import 'pages/shop_page_new.dart';
import 'pages/pesanan_page.dart';
import 'pages/profil-toko.dart';
import 'pages/pay_page.dart';
import 'pages/profil_user_page.dart';
import 'pages/produk_detail_page.dart';
import 'pages/password-page.dart';
import 'pages/pilih_bahasa.dart';
import 'pages/profil-admin.dart';
import 'pages/data_seller.dart';
import 'pages/verifikasi_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HalamanAwal()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(path: '/menu', builder: (context, state) => const MenuPageNew()),
      GoRoute(path: '/shop', builder: (context, state) => const ShopPageNew()),
      GoRoute(
        path: '/profil-toko',
        builder: (context, state) => const ProfilTokoPage(),
      ),
      GoRoute(path: '/wait', builder: (context, state) => const WaitPage()),
      GoRoute(path: '/seller', builder: (context, state) => const SellerPage()),
      GoRoute(
        path: '/pay',
        builder:
            (context, state) =>
                PayPage(paymentData: state.extra as Map<String, dynamic>?),
      ),
      GoRoute(
        path: '/setting',
        builder: (context, state) => const PengaturanPage(),
      ),
      GoRoute(
        path: '/profil',
        builder: (context, state) => const ProfilUserPage(),
      ),
      GoRoute(
        path: '/ubah_password',
        builder: (context, state) => const PasswordPage(),
      ),
      GoRoute(path: '/bahasa', builder: (context, state) => const BahasaPage()),
      GoRoute(
        path: '/pesanan',
        builder: (context, state) => const PesananPage(),
      ),
      GoRoute(
        path: '/produk/:id',
        builder:
            (context, state) =>
                ProdukDetailPage(productId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/profil-admin',
        builder: (context, state) => const ProfilAdmin(),
      ),
      GoRoute(
        path: '/data-seller',
        builder: (context, state) => DataSellerPage(),
      ),
      GoRoute(
        path: '/verifikasi',
        builder: (context, state) => const VerifikasiPage(),
      ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('404 Halaman Tidak Ditemukan'))),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
      ],
      child: MaterialApp.router(
        title: '2ndloop',
        theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Arial'),
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}
