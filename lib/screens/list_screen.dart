import 'package:flutter/material.dart';
import 'package:stock_control/screens/components/app_bar.dart';
import 'package:stock_control/screens/components/label_inventory.dart';
import 'package:stock_control/services/data.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int _currentIndex = 0;
  int _selectedOptionIndex = 0;

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarAuthScreen('Menú'),
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          backgroundColor: const Color(0xffe9f2f9),
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text(
                  'Username',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  'e-mail@example.com',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 148, 205, 248),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Inventarios'),
                selected: _selectedOptionIndex == 0,
                onTap: () {
                  _onOptionSelected(0);
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_box),
                title: const Text('Cuenta'),
                selected: _selectedOptionIndex == 1,
                onTap: () {
                  _onOptionSelected(1);
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notificaciones'),
                selected: _selectedOptionIndex == 2,
                onTap: () {
                  _onOptionSelected(2);
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                selected: _selectedOptionIndex == 3,
                onTap: () {
                  _onOptionSelected(3);
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              const Spacer(),
              Container(
                color: const Color.fromARGB(255, 216, 78, 75),
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/auth_scren', (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: _buildBody(context),
        // child: _pages[_selectedOptionIndex],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return inventoryBuild(context);
      case 1:
        return accountBuild(context);
      case 2:
        return notificationBuild(context);
      case 3:
        return settingsBuild(context);
      default:
        return Container();
    }
  }

  Widget inventoryBuild(BuildContext context) {
    return Column(
      children: [
        titleMenu(Icons.inventory, 'Inventarios'),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              children: getDataInventory()
                  .map((element) => inventoryLabel(
                      context, Icons.store, "${element["name"]}", element))
                  .toList(),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              createInventory(context);
            },
            label: const Text(
              'Añadir Inventario',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xffff8e00),
            ),
          ),
        ),
      ],
    );
  }

  Widget accountBuild(BuildContext context) {
    return Column(children: [
      titleMenu(Icons.account_box, 'Cuenta'),
    ]);
  }

  Widget notificationBuild(BuildContext context) {
    return Column(children: [
      titleMenu(Icons.notifications, 'Notificaciones'),
    ]);
  }

  Widget settingsBuild(BuildContext context) {
    return Column(children: [
      titleMenu(Icons.settings, 'Configuración'),
    ]);
  }
}
