import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../provider/sign_in_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _available = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _available = await _iap.isAvailable();
    if (!_available) return;
    const Set<String> _kProductIds = {'temel_plan_subscription', 'pro_plan_subscription', 'premium_plan_subscription'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kProductIds);
    if (response.notFoundIDs.isNotEmpty) {
      print("Ürünler bulunamadı: ${response.notFoundIDs}");
    }
    setState(() {
      _products = response.productDetails;
    });
  }

  Future<String?> getCurrentSubscriptionPlan() async {
    final String? userId = context.read<SignInProvider>().uid;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists && userDoc.data() != null) {
      final subscription = userDoc['subscription'];
      if (subscription != null) {
        Timestamp endDate = subscription['endDate'];
        Timestamp now = Timestamp.now();
        if (now.seconds < endDate.seconds) {
          return subscription['plan'];
        }
      }
    }
    return null;
  }

  void _subscribe(ProductDetails product) async {
    final String? currentPlan = await getCurrentSubscriptionPlan();

    if (currentPlan != null) {
      Map<String, int> planRank = {
        'temel_plan_subscription': 1,
        'pro_plan_subscription': 2,
        'premium_plan_subscription': 3,
      };

      int currentRank = planRank[currentPlan] ?? 0;
      int newRank = planRank[product.id] ?? 0;

      if (newRank <= currentRank) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Zaten bu plana sahipsiniz veya daha düşük bir plan seçtiniz."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final String? userId = context.read<SignInProvider>().uid;
    final DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(userId);

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);

    Map<String, dynamic> updateData = {
      'subscription': {
        'plan': product.id,
        'startDate': Timestamp.now(),
        'endDate': Timestamp.now().toDate().add(Duration(days: 30)),
        'purchaseToken': "DİNAMİK OLARAK API’DEN GELECEK", // Google Play'den alınan purchaseToken
      }
    };

    // Eğer temel plan satın alınıyorsa event hakkını 3 olarak belirle
    if (product.id == 'temel_plan_subscription') {
      updateData['eventCount'] = 3;
    }

    await userRef.set(updateData, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.title} aboneliğiniz başlatıldı!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<String> _getFeatures(String productId) {
    switch (productId) {
      case 'temel_plan':
        return [
          "Aylık 3 etkinlik hakkı",
          "Reklamlı kullanım",
          "Sınırlı analiz ve etkinlik verisi",
        ];
      case 'pro_plan':
        return [
          "Sınırsız etkinlik oluşturma ve yönetim",
          "Etkinliklerin öne çıkması",
          "Kişiselleştirilmiş tavsiyeler ve hedef kitlesine özel bildirim gönderimi",
          "Özel müşteri desteği (hızlı yanıt)",
        ];
      case 'premium_plan':
        return [
          "Pro plandaki tüm özellikler",
          "Abonelere özel etkinliklere katılım",
          "Çekilişlere ücretsiz katılım hakkı",
          "Özel indirim anlaşmaları (YAKINDA)",
          "Hızlı ödeme: Etkinlik gelirleri aynı gün aktarılır",
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Abonelik Planları"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: _products.isEmpty
              ? [Center(child: CircularProgressIndicator())]
              : _products.map((product) => SubscriptionCard(
            title: product.title,
            price: product.price,
            features: _getFeatures(product.id),
            isPopular: product.id == 'pro_plan',
            onTap: () => _subscribe(product),
          )).toList(),
        ),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isPopular;
  final VoidCallback onTap;

  SubscriptionCard({
    required this.title,
    required this.price,
    required this.features,
    required this.isPopular,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isPopular ? 8 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "En Çok Tercih Edilen",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 8),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Icon(LucideIcons.checkCircle, color: Colors.green, size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text(feature)),
                ],
              ),
            )),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.blue,
              ),
              child: Center(
                child: Text("Abone Ol", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
