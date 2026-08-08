import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const brandColor = Color(0xFF123B5D);
const accentColor = Color(0xFF2E7D9A);

void main() => runApp(const DPManagerProApp());

class DPManagerProApp extends StatelessWidget {
  const DPManagerProApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DP Manager Pro',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: brandColor), scaffoldBackgroundColor: const Color(0xFFF5F7FA)),
        home: const HomePage(),
      );
}

class Client {
  Client({required this.name, this.phone = '', this.email = '', this.company = ''});
  String name;
  String phone;
  String email;
  String company;
  Map<String, dynamic> toJson() => {'name': name, 'phone': phone, 'email': email, 'company': company};
  factory Client.fromJson(Map<String, dynamic> json) => Client(name: json['name'] ?? '', phone: json['phone'] ?? '', email: json['email'] ?? '', company: json['company'] ?? '');
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Client> clients = [];
  bool loading = true;
  final items = const [(Icons.dashboard_outlined, 'Tableau de bord'), (Icons.people_outline, 'Clients'), (Icons.business_outlined, 'Chantiers'), (Icons.request_quote_outlined, 'Devis'), (Icons.receipt_long_outlined, 'Factures'), (Icons.payments_outlined, 'Paiements'), (Icons.shopping_cart_outlined, 'Dépenses'), (Icons.bar_chart_outlined, 'Rapports')];

  @override
  void initState() { super.initState(); _loadClients(); }

  Future<void> _loadClients() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('clients');
    if (raw != null) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      clients = decoded.map((e) => Client.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _saveClients() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('clients', jsonEncode(clients.map((c) => c.toJson()).toList()));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return LayoutBuilder(builder: (context, c) {
      final desktop = c.maxWidth >= 900;
      return Scaffold(appBar: desktop ? null : AppBar(title: const Text('DP Manager Pro')), drawer: desktop ? null : Drawer(child: _menu()), body: Row(children: [if (desktop) _sidebar(), Expanded(child: selectedIndex == 1 ? _clientsPage() : _dashboard(desktop))]));
    });
  }

  Widget _sidebar() => Container(width: 255, color: brandColor, child: SafeArea(child: Column(children: [const Padding(padding: EdgeInsets.all(22), child: Row(children: [CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.business_center, color: brandColor)), SizedBox(width: 12), Text('DP Manager Pro', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])), Expanded(child: _menu()), const Padding(padding: EdgeInsets.all(18), child: Text('Version 0.1.0', style: TextStyle(color: Colors.white60)))])));

  Widget _menu() => Container(color: brandColor, child: SafeArea(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: items.length, itemBuilder: (context, i) => ListTile(selected: selectedIndex == i, selectedTileColor: Colors.white.withValues(alpha: .14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), leading: Icon(items[i].$1, color: Colors.white), title: Text(items[i].$2, style: const TextStyle(color: Colors.white)), onTap: () { setState(() => selectedIndex = i); if (MediaQuery.sizeOf(context).width < 900) Navigator.pop(context); }))));

  Widget _dashboard(bool desktop) => SingleChildScrollView(padding: EdgeInsets.all(desktop ? 32 : 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Tableau de bord', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: brandColor)), const SizedBox(height: 6), const Text('Bienvenue dans DP Manager Pro', style: TextStyle(color: Colors.black54, fontSize: 16)), const SizedBox(height: 28), Wrap(spacing: 16, runSpacing: 16, children: [_stat('Clients', '${clients.length}', Icons.people_outline), _stat('Chantiers actifs', '0', Icons.business_outlined), _stat('Devis en cours', '0', Icons.request_quote_outlined), _stat('Factures impayées', '0 FCFA', Icons.receipt_long_outlined)]), const SizedBox(height: 28), Card(child: Padding(padding: const EdgeInsets.all(24), child: Row(children: [const CircleAvatar(backgroundColor: Color(0xFFE7F0F4), child: Icon(Icons.auto_graph, color: accentColor)), const SizedBox(width: 16), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Votre activité en un coup d’œil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 6), Text('Les indicateurs de vos clients, chantiers, devis et factures apparaîtront ici.', style: TextStyle(color: Colors.black54))]))]))), const SizedBox(height: 24), const Text('Démarrage rapide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 14), OutlinedButton.icon(onPressed: () => _openClientForm(), icon: const Icon(Icons.person_add_alt_1), label: const Text('Nouveau client'))]));

  Widget _stat(String title, String value, IconData icon) => SizedBox(width: 245, child: Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: brandColor.withValues(alpha: .1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: brandColor)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.black54)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: brandColor))]))])));

  Widget _clientsPage() => SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Clients', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: brandColor)), SizedBox(height: 5), Text('Gérez vos clients et leurs coordonnées.', style: TextStyle(color: Colors.black54))])), FilledButton.icon(onPressed: () => _openClientForm(), icon: const Icon(Icons.add), label: const Text('Nouveau client'))]), const SizedBox(height: 20), Expanded(child: clients.isEmpty ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.people_outline, size: 64, color: Colors.black26), const SizedBox(height: 12), const Text('Aucun client pour le moment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)), const SizedBox(height: 8), const Text('Ajoutez votre premier client avec le bouton ci-dessus.', style: TextStyle(color: Colors.black54))])) : ListView.separated(itemCount: clients.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (context, i) { final client = clients[i]; return Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text([client.company, client.phone, client.email].where((x) => x.isNotEmpty).join(' • ')), trailing: PopupMenuButton<String>(onSelected: (v) { if (v == 'edit') _openClientForm(client: client); if (v == 'delete') _deleteClient(client); }, itemBuilder: (_) => const [PopupMenuItem(value: 'edit', child: Text('Modifier')), PopupMenuItem(value: 'delete', child: Text('Supprimer'))]))); }))])));

  Future<void> _openClientForm({Client? client}) async { final result = await showDialog<Client>(context: context, builder: (_) => ClientFormDialog(client: client)); if (result == null) return; setState(() { if (client == null) clients.add(result); else { client.name = result.name; client.phone = result.phone; client.email = result.email; client.company = result.company; } }); await _saveClients(); }

  Future<void> _deleteClient(Client client) async { final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Supprimer le client ?'), content: Text('Voulez-vous supprimer « ${client.name} » ?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer'))])); if (ok == true) { setState(() => clients.remove(client)); await _saveClients(); } }
}

class ClientFormDialog extends StatefulWidget {
  const ClientFormDialog({super.key, this.client});
  final Client? client;
  @override State<ClientFormDialog> createState() => _ClientFormDialogState();
}
class _ClientFormDialogState extends State<ClientFormDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController name, phone, email, company;
  @override void initState() { super.initState(); final c = widget.client; name = TextEditingController(text: c?.name ?? ''); phone = TextEditingController(text: c?.phone ?? ''); email = TextEditingController(text: c?.email ?? ''); company = TextEditingController(text: c?.company ?? ''); }
  @override void dispose() { name.dispose(); phone.dispose(); email.dispose(); company.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AlertDialog(title: Text(widget.client == null ? 'Nouveau client' : 'Modifier le client'), content: SizedBox(width: 480, child: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Nom complet *'), validator: (v) => v == null || v.trim().isEmpty ? 'Le nom est obligatoire' : null), const SizedBox(height: 12), TextFormField(controller: company, decoration: const InputDecoration(labelText: 'Entreprise')), const SizedBox(height: 12), TextFormField(controller: phone, decoration: const InputDecoration(labelText: 'Téléphone'), keyboardType: TextInputType.phone), const SizedBox(height: 12), TextFormField(controller: email, decoration: const InputDecoration(labelText: 'E-mail'), keyboardType: TextInputType.emailAddress)]))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')), FilledButton(onPressed: () { if (!formKey.currentState!.validate()) return; Navigator.pop(context, Client(name: name.text.trim(), phone: phone.text.trim(), email: email.text.trim(), company: company.text.trim())); }, child: const Text('Enregistrer'))]);
}
