import 'package:flutter/material.dart';
import 'package:social_media_app/features/home/presentation/components/my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              //logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              //Divider
              Divider(color: Theme.of(context).colorScheme.secondary),
              //list
              MyDrawerTile(title: 'H O M E', icon: Icons.home, onTap: () {}),
              MyDrawerTile(
                title: 'P R O F I L E',
                icon: Icons.person,
                onTap: () {},
              ),
              MyDrawerTile(
                title: 'S E A R C H',
                icon: Icons.search,
                onTap: () {},
              ),
              MyDrawerTile(
                title: 'S E T T I N G S',
                icon: Icons.settings,
                onTap: () {},
              ),
              Spacer(),
              MyDrawerTile(
                title: 'L O G O U T',
                icon: Icons.logout,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
