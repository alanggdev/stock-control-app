import 'package:flutter/material.dart';
import 'package:stock_control/screens/components/app_bar.dart';
import 'package:stock_control/screens/components/label_inventory.dart';
import 'package:stock_control/services/auth_request.dart';
import 'package:stock_control/services/inv_request.dart';

class ListScreen extends StatefulWidget {
  final String accessToken, refreshToken;
  final Map<String, dynamic> userData;
  const ListScreen(this.userData, this.accessToken, this.refreshToken,
      {super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int _currentIndex = 0;
  int _selectedOptionIndex = 0;
  List<dynamic> _listInvOwner = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final listInvOwner = await getInventoryPerOwner(
      widget.userData['pk'],
      widget.accessToken,
    );
    setState(() {
      _listInvOwner = listInvOwner;
      _isLoading = false;
    });
  }

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOptionIndex = index;
      if (_selectedOptionIndex == 0) {
        setState(() {
          _isLoading = true;
        });
        _loadInventory();
      }
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
              UserAccountsDrawerHeader(
                accountName: Text(
                  widget.userData['username'],
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  widget.userData['email'],
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                decoration: const BoxDecoration(
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
                    signOut(context, widget.accessToken);
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
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return Stack(
          children: [
            inventoryBuild(
                context), // Contenido que se mostrará cuando la respuesta de la petición esté lista
            if (_isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Cargando...'),
                  ],
                ),
              )
            // Indicador de carga mientras se espera la respuesta de la petición
          ],
        );
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
              children: _listInvOwner.isNotEmpty
                  ? [
                      for (var objeto in _listInvOwner)
                        inventoryLabel(
                            context, Icons.store, objeto["name"], objeto),
                    ]
                  : [
                      const Text('La lista está vacía'),
                    ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedOptionIndex = 0;
              if (_selectedOptionIndex == 0) {
                setState(() {
                  _isLoading = true;
                });
                _loadInventory();
              }
            });
            setState(() {
              _currentIndex = 0;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedOptionIndex == 0 ? const Color.fromARGB(255, 148, 148, 148) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: const [
              Icon(Icons.refresh),
              SizedBox(width: 12),
              Text('Actualizar Lista de Inventarios'),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              createInventory(
                  context, widget.userData['pk'], widget.accessToken);
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
