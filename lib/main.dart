import 'package:flutter/material.dart';

const brandColor = Color(0xFF123B5D);
const accentColor = Color(0xFF2E7D9A);

void main() {
  runApp(const DPManagerProApp());
}

class DPManagerProApp extends StatelessWidget {
  const DPManagerProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DP Manager Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: brandColor),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: brandColor,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final menuItems = const [
    (Icons.dashboard_outlined, 'Tableau de bord'),
    (Icons.people_outline, 'Clients'),
    (Icons.business_outlined, 'Chantiers'),
    (Icons.request_quote_outlined, 'Devis'),
    (Icons.receipt_long_outlined, 'Factures'),
    (Icons.payments_outlined, 'Paiements'),
    (Icons.shopping_cart_outlined, 'Dépenses'),
    (Icons.bar_chart_outlined, 'Rapports'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: isDesktop
              ? null
              : AppBar(
                  title: const Text('DP Manager Pro'),
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
          drawer: isDesktop ? null : _buildDrawer(),
          body: Row(
            children: [
              if (isDesktop) _buildSidebar(),
              Expanded(child: _buildContent(isDesktop)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 255,
      color: brandColor,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 28, 22, 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.business_center, color: brandColor),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'DP Manager Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildMenu()),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Version 0.1.0',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: brandColor,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(22),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.business_center, color: brandColor),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'DP Manager Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildMenu()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final selected = selectedIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            selected: selected,
            selectedTileColor: Colors.white.withValues(alpha: 0.14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(item.$1, color: Colors.white),
            title: Text(
              item.$2,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() => selectedIndex = index);
              if (MediaQuery.sizeOf(context).width < 900) {
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(bool isDesktop) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tableau de bord',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: brandColor,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Bienvenue dans DP Manager Pro',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                    ],
                  ),
                ),
                if (isDesktop)
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE8EEF3),
                    child: Icon(Icons.person_outline, color: brandColor),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                StatCard(
                  title: 'Clients',
                  value: '0',
                  icon: Icons.people_outline,
                ),
                StatCard(
                  title: 'Chantiers actifs',
                  value: '0',
                  icon: Icons.business_outlined,
                ),
                StatCard(
                  title: 'Devis en cours',
                  value: '0',
                  icon: Icons.request_quote_outlined,
                ),
                StatCard(
                  title: 'Factures impayées',
                  value: '0 FCFA',
                  icon: Icons.receipt_long_outlined,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.auto_graph,
                        color: accentColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Votre activité en un coup d’œil',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Les indicateurs de vos clients, chantiers, devis et factures apparaîtront ici.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Démarrage rapide',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                QuickAction(icon: Icons.person_add_alt_1, label: 'Nouveau client'),
                QuickAction(icon: Icons.add_business, label: 'Nouveau chantier'),
                QuickAction(icon: Icons.note_add_outlined, label: 'Créer un devis'),
                QuickAction(icon: Icons.post_add, label: 'Créer une facture'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 245,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: brandColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: brandColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  const QuickAction({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: brandColor,
        side: const BorderSide(color: Color(0xFFD6DEE6)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
