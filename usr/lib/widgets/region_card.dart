import 'package:flutter/material.dart';

class RegionCard extends StatelessWidget {
  final String region;
  final bool isSelected;
  final VoidCallback onTap;

  const RegionCard({
    super.key,
    required this.region,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      child: ListTile(
        title: Text(region),
        onTap: onTap,
        trailing: isSelected ? const Icon(Icons.check) : null,
      ),
    );
  }
}