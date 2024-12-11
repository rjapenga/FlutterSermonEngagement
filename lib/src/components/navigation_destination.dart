import 'package:flutter/material.dart';

List<NavigationDestination> nD = const <NavigationDestination>[
  NavigationDestination(
    selectedIcon: Icon(Icons.record_voice_over),
    icon: Icon(Icons.record_voice_over_outlined),
    label: 'Sermons',
  ),
  NavigationDestination(
    selectedIcon: Icon(Icons.article),
    icon: Icon(Icons.article_outlined),
    label: 'Manual',
  ),
  NavigationDestination(
    selectedIcon: Icon(Icons.info),
    icon: Icon(Icons.info_outlined),
    label: 'About',
  ),
  NavigationDestination(
    selectedIcon: Icon(Icons.settings),
    icon: Icon(Icons.settings_outlined),
    label: 'Settings',
  ),
];
