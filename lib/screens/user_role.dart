import 'package:flutter/material.dart';
import 'package:stock_control/screens/components/app_bar.dart';
import 'package:stock_control/screens/components/input_field.dart';
import 'package:stock_control/screens/components/label_inventory.dart';
import 'package:stock_control/services/inv_request.dart';

class UserRole extends StatefulWidget {
  final String title, accessToken;
  final dynamic product;
  const UserRole(this.title, this.accessToken, this.product, {super.key});

  @override
  State<UserRole> createState() => _UserRoleState();
}

class _UserRoleState extends State<UserRole> {
  dynamic _invDetail = [];
  dynamic _usersAdmin = [];
  dynamic _usersSeller = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loaduser();
  }

  Future<void> _loaduser() async {
    await _loadDetailInventory().then(
      (value) async {
        final usersAdmin = await searchUsername(
            context, widget.accessToken, _invDetail['admins']);
        final usersSeller = await searchUsername(
            context, widget.accessToken, _invDetail['sellers']);
        setState(() {
          _usersAdmin = usersAdmin;
          _usersSeller = usersSeller;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _loadDetailInventory() async {
    final inventoryDetail = await getInventory(
      context,
      widget.accessToken,
      widget.product['id'],
    );
    setState(() {
      _invDetail = inventoryDetail;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    return Scaffold(
      appBar: appBarAuthScreen(widget.title),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            textField('Ingrese nombre de usuario', usernameController),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  searchIdByUsername(context, widget.accessToken,
                      usernameController.text, widget.product['id']);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffff8e00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search),
                    SizedBox(width: 12),
                    Text('Buscar usuario'),
                  ],
                ),
              ),
            ),
            titleMenu(Icons.account_box, 'Lista de Administradores'),
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
              ),
            _usersAdmin.isNotEmpty
                ? userAdminList()
                : const Text('No hay usuarios administradores'),
            titleMenu(Icons.account_box, 'Lista de Vendedores'),
            _usersSeller.isNotEmpty
                ? userSellerList()
                : const Text('No hay usuarios vendedores'),
            Expanded(child: Column()),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  setState(() {
                    _isLoading = true;
                  });
                  _loaduser();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 148, 148, 148),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.refresh),
                  SizedBox(width: 12),
                  Text('Actualizar lista de usuarios'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded userSellerList() {
    return Expanded(
      child: ListView.builder(
          itemCount: _usersSeller.length == 0 ? 0 : _usersSeller.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                title: Text(
                  _usersSeller[i],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Vendedor'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.highlight_off,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        confirmDialogLabel(context, widget.accessToken,
                            _invDetail['id'], _usersSeller[i], 'Seller');
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Expanded userAdminList() {
    return Expanded(
      child: ListView.builder(
          itemCount: _usersAdmin.length == 0 ? 0 : _usersAdmin.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                title: Text(
                  _usersAdmin[i],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Administrador'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.highlight_off,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        confirmDialogLabel(context, widget.accessToken,
                            _invDetail['id'], _usersAdmin[i], 'Admin');
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
