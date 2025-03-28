import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  final List<Map<String, String>> resources = [
    {
      'title': 'National Women’s Helpline',
      'description': '24/7 helpline for women in distress (1091).',
      'url': 'tel:1091',
    },
    {
      'title': 'SheSays India',
      'description': 'NGO promoting gender equality and women’s rights.',
      'url': 'https://sheissafe.org/where-we-work/india/',
    },
    {
      'title': 'Safecity',
      'description': 'Report incidents of harassment anonymously.',
      'url': 'https://en.wikipedia.org/wiki/Safecity',
    },
    {
      'title': 'Cyber Crime Reporting',
      'description': 'Report cyber crimes affecting women.',
      'url': 'https://cybercrime.gov.in/',
    },
  ];

  final List<Map<String, String>> laws = [
    {
      'title': 'Protection of Women from Domestic Violence Act, 2005',
      'description': 'Protects women from domestic abuse and violence.',
    },
    {
      'title': 'Dowry Prohibition Act, 1961',
      'description': 'Prohibits the giving or receiving of dowry.',
    },
    {
      'title': 'Sexual Harassment of Women at Workplace Act, 2013',
      'description': 'Ensures safe workplaces free of harassment.',
    },
    {
      'title': 'Indian Penal Code (IPC) Section 354',
      'description': 'Punishment for outraging the modesty of a woman.',
    },
  ];

  final List<String> tips = [
    "Trust your instincts. If a situation feels unsafe, leave immediately.",
    "Always inform someone about your whereabouts when traveling alone.",
    "Use safety apps like 'bSafe' or 'My Safetipin' for live tracking.",
    "Carry a safety whistle or pepper spray for emergency situations.",
    "If harassed in public, speak loudly and seek help immediately.",
  ];

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources & Laws'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Helplines & Resources'),
              _buildResourceList(),
              _buildSectionTitle('Laws for Women’s Safety'),
              _buildLawList(),
              _buildSectionTitle('Safety Tips'),
              _buildTipsList(),
              _buildSectionTitle('Emergency Contacts'),
              _buildEmergencyContacts(),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.purple.shade50,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple),
      ),
    );
  }

  Widget _buildResourceList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        var resource = resources[index];
        return Card(
          color: Colors.purple.shade100,
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(resource['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(resource['description']!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.purple),
            onTap: () => _launchURL(resource['url']!),
          ),
        );
      },
    );
  }

  Widget _buildLawList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: laws.length,
      itemBuilder: (context, index) {
        var law = laws[index];
        return Card(
          color: Colors.purple.shade100,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(law['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(law['description']!),
          ),
        );
      },
    );
  }

  Widget _buildTipsList() {
    return Column(
      children: tips.map((tip) => Card(
        color: Colors.purple.shade100,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(tip, style: const TextStyle(fontSize: 16)),
        ),
      )).toList(),
    );
  }

  Widget _buildEmergencyContacts() {
    return Column(
      children: [
        _buildEmergencyContact('Women’s Helpline (1091)', 'tel:1091', Icons.local_police),
        _buildEmergencyContact('Emergency Medical Help (108)', 'tel:108', Icons.local_hospital),
        _buildEmergencyContact('National Commission for Women (011-26942369)', 'tel:01126942369', Icons.local_police),
      ],
    );
  }

  Widget _buildEmergencyContact(String title, String url, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () => _launchURL(url),
    );
  }
}