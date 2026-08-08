import 'package:flutter/material.dart';

const brandColor = Color(0xFF123B5D);
const accentColor = Color(0xFF2E7D9A);

void main() => runApp(const DPManagerProApp());

class Client {
  Client({required this.name, required this.phone, required this.email, required this.company});
  String name;
  String phone;
  String email;
  String company;
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
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: brandColor, elevation: 0),
        cardTheme: const CardThemeData(color: Colors.white, elevation: 0, margin: EdgeInsets.zero),
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
  final clients = <Client>[];

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
    return LayoutBuilder(builder: (context, constraints) {
      final desktop = constraints.maxWidth >= 900;
      return Scaffold(
        appBar: desktop ? null : AppBar(
          title: const Text('DP Manager Pro'),
          leading: Builder(builder: (context) => IconButton(icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer())),
        ),
        drawer: desktop ? null : _buildDrawer(),
        body: Row(children: [if (desktop) _buildSidebar(), Expanded(child: _buildContent(desktop))]),
      );
    });
  }

  Widget _buildSidebar() => Container(width: 255, color: brandColor, child: SafeArea(child: Column(children: [
    const Padding(padding: EdgeInsets.fromLTRB(22, 28, 22, 24), child: Row(children: [
      CircleAvatar(radius: 21, backgroundColor: Colors.white, child: Icon(Icons.business_center, color: brandColor)),
      SizedBox(width: 12), Expanded(child: Text('DP Manager Pro', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
    ])),
    Expanded(child: _buildMenu()),
    const Padding(padding: EdgeInsets.all(20), child: Text('Version 0.2.0', style: TextStyle(color: Colors.white60, fontSize: 12))),
  ]));

  Widget _buildDrawer() => Drawer(child: Container(color: brandColor, child: SafeArea(child: Column(children: [
    const Padding(padding: EdgeInsets.all(22), child: Row(children: [
      CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.business_center, color: brandColor)),
      SizedBox(width: 12), Text('DP Manager Pro', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
    ])),
    Expanded(child: _buildMenu()),
  ])));

  Widget _buildMenu() => ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    itemCount: menuItems.length,
    itemBuilder: (context, index) {
      final item = menuItems[index];
      return Padding(padding: const EdgeInsets.only(bottom: 4), child: ListTile(
        selected: selectedIndex == index,
        selectedTileColor: Colors.white.withValues(alpha: .14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(item.$1, color: Colors.white),
        title: Text(item.$2, style: const TextStyle(color: Colors.white)),
        onTap: () { setState(() => selectedIndex = index); if (MediaQuery.sizeOf(context).width < 900) Navigator.pop(context); },
      ));
    },
  );

  Widget _buildContent(bool desktop) {
    if (selectedIndex == 1) return ClientsPage(clients: clients, onChanged: () => setState(() {}));
    return _dashboardContent(desktop);
  }

  Widget _dashboardContent(bool desktop) => SafeArea(child: SingleChildScrollView(padding: EdgeInsets.all(desktop ? 32 : 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Tableau de bord', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: brandColor)),
      const SizedBox(height: 6),
      const Text('Bienvenue dans DP Manager Pro', style: TextStyle(color: Colors.black54, fontSize: 16)),
    ])), if (desktop) const CircleAvatar(backgroundColor: Color(0xFFE8EEF3), child: Icon(Icons.person_outline, color: brandColor))]),
    const SizedBox(height: 28),
    Wrap(spacing: 16, runSpacing: 16, children: [
      StatCard(title: 'Clients', value: '${clients.length}', icon: Icons.people_outline),
      const StatCard(title: 'Chantiers actifs', value: '0', icon: Icons.business_outlined),
      const StatCard(title: 'Devis en cours', value: '0', icon: Icons.request_quote_outlined),
      const StatCard(title: 'Factures impayées', value: '0 FCFA', icon: Icons.receipt_long_outlined),
    ]),
    const SizedBox(height: 28),
    Card(child: Padding(padding: const EdgeInsets.all(24), child: Row(children: [
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: accentColor.withValues(alpha: .12), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.auto_graph, color: accentColor, size: 30)),
      const SizedBox(width: 18), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Votre activité en un coup d’œil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        SizedBox(height: 6), Text('Les indicateurs de vos clients, chantiers, devis et factures apparaîtront ici.', style: TextStyle(color: Colors.black54)),
      ])),
    ]))),
    const SizedBox(height: 24), const Text('Démarrage rapide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), const SizedBox(height: 14),
    Wrap(spacing: 12, runSpacing: 12, children: [
      QuickAction(icon: Icons.person_add_alt_1, label: 'Nouveau client', onPressed: () => _openClientForm()),
      const QuickAction(icon: Icons.add_business, label: 'Nouveau chantier'), const QuickAction(icon: Icons.note_add_outlined, label: 'Créer un devis'), const QuickAction(icon: Icons.post_add, label: 'Créer une facture'),
    ]),
  ])));

  Future<void> _openClientForm() async {
    final client = await showDialog<Client>(context: context, builder: (_) => const ClientFormDialog());
    if (client != null) setState(() => clients.add(client));
  }
}

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key, required this.clients, required this.onChanged});
  final List<Client> clients;
  final VoidCallback onChanged;
  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  String search = '';

  List<Client> get filtered => widget.clients.where((c) {
    final q = search.toLowerCase();
    return c.name.toLowerCase().contains(q) || c.phone.toLowerCase().contains(q) || c.email.toLowerCase().contains(q) || c.company.toLowerCase().contains(q);
  }).toList();

  Future<void> _add() async {
    final client = await showDialog<Client>(context: context, builder: (_) => const ClientFormDialog());
    if (client != null) { setState(() => widget.clients.add(client)); widget.onChanged(); }
  }

  Future<void> _edit(Client client) async {
    final updated = await showDialog<Client>(context: context, builder: (_) => ClientFormDialog(client: client));
    if (updated != null) { final i = widget.clients.indexOf(client); setState(() => widget.clients[i] = updated); widget.onChanged(); }
  }

  void _delete(Client client) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Supprimer le client ?'),
      content: Text('Voulez-vous supprimer « ${client.name} » ? Cette action est irréversible.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), FilledButton(onPressed: () { setState(() => widget.clients.remove(client)); widget.onChanged(); Navigator.pop(context); }, child: const Text('Supprimer'))],
    ));
  }

  @override
  Widget build(BuildContext context) => SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(32), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Clients', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: brandColor)),
      const SizedBox(height: 6), Text('${widget.clients.length} client(s) enregistré(s)', style: const TextStyle(color: Colors.black54)),
    ])), FilledButton.icon(onPressed: _add, icon: const Icon(Icons.person_add_alt_1), label: const Text('Nouveau client'))]),
    const SizedBox(height: 24),
    TextField(onChanged: (v) => setState(() => search = v), decoration: InputDecoration(hintText: 'Rechercher par nom, téléphone, e-mail...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
    const SizedBox(height: 20),
    if (filtered.isEmpty) _emptyState() else Card(child: Column(children: [for (final client in filtered) _clientTile(client)])),
  ])));

  Widget _emptyState() => Card(child: Padding(padding: const EdgeInsets.all(40), child: Center(child: Column(children: [
    const Icon(Icons.people_outline, size: 54, color: Colors.black26), const SizedBox(height: 14),
    Text(search.isEmpty ? 'Aucun client pour le moment' : 'Aucun résultat', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
    const SizedBox(height: 8), const Text('Ajoutez votre premier client pour commencer.', style: TextStyle(color: Colors.black54)), const SizedBox(height: 18),
    if (search.isEmpty) FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add), label: const Text('Ajouter un client')),
  ]))));

  Widget _clientTile(Client client) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    leading: CircleAvatar(backgroundColor: brandColor.withValues(alpha: .1), child: Text(client.name.isEmpty ? '?' : client.name[0].toUpperCase(), style: const TextStyle(color: brandColor, fontWeight: FontWeight.bold))),
    title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text([if (client.company.isNotEmpty) client.company, if (client.phone.isNotEmpty) client.phone, if (client.email.isNotEmpty) client.email].join(' • ')),
    trailing: PopupMenuButton<String>(onSelected: (v) { if (v == 'edit') _edit(client); if (v == 'delete') _delete(client); }, itemBuilder: (_) => const [PopupMenuItem(value: 'edit', child: Text('Modifier')), PopupMenuItem(value: 'delete', child: Text('Supprimer'))]),
  );
}

class ClientFormDialog extends StatefulWidget {
  const ClientFormDialog({super.key, this.client});
  final Client? client;
  @override
  State<ClientFormDialog> createState() => _ClientFormDialogState();
}

class _ClientFormDialogState extends State<ClientFormDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController phone;
  late final TextEditingController email;
  late final TextEditingController company;

  @override
  void initState() { super.initState(); final c = widget.client; name = TextEditingController(text: c?.name ?? ''); phone = TextEditingController(text: c?.phone ?? ''); email = TextEditingController(text: c?.email ?? ''); company = TextEditingController(text: c?.company ?? ''); }
  @override
  void dispose() { name.dispose(); phone.dispose(); email.dispose(); company.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.client == null ? 'Nouveau client' : 'Modifier le client'),
    content: SizedBox(width: 480, child: Form(key: formKey, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Nom complet *', prefixIcon: Icon(Icons.person_outline)), validator: (v) => v == null || v.trim().isEmpty ? 'Le nom est obligatoire' : null),
      const SizedBox(height: 12), TextFormField(controller: company, decoration: const InputDecoration(labelText: 'Entreprise / société', prefixIcon: Icon(Icons.business_outlined))),
      const SizedBox(height: 12), TextFormField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Téléphone', prefixIcon: Icon(Icons.phone_outlined))),
      const SizedBox(height: 12), TextFormField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email_outlined))),
    ]))),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), FilledButton(onPressed: () { if (!formKey.currentState!.validate()) return; Navigator.pop(context, Client(name: name.text.trim(), phone: phone.text.trim(), email: email.text.trim(), company: company.text.trim())); }, child: const Text('Enregistrer'))],
  );
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.title, required this.value, required this.icon});
  final String title, value; final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(width: 245, child: Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
    Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: brandColor.withValues(alpha: .1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: brandColor)), const SizedBox(width: 14),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.black54)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: brandColor))])),
  ]))));
}

class QuickAction extends StatelessWidget {
  const QuickAction({super.key, required this.icon, required this.label, this.onPressed});
  final IconData icon; final String label; final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onPressed ?? () {}, icon: Icon(icon), label: Text(label), style: OutlinedButton.styleFrom(foregroundColor: brandColor, side: const BorderSide(color: Color(0xFFD6DEE6)), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
}
