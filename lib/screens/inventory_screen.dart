import 'package:flutter/material.dart';
import 'package:stock_control/screens/components/app_bar.dart';
import 'package:stock_control/screens/components/label_inventory.dart';
import 'package:stock_control/services/inv_request.dart';

class InventoryScreen extends StatefulWidget {
  final dynamic product;
  final String accessToken;
  const InventoryScreen(this.product, this.accessToken, {super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  dynamic _invDetail = [];

  @override
  void initState() {
    super.initState();
    _loadDetailInventory();
  }

  Future<void> _loadDetailInventory() async {
    final inventoryDetail = await getInventory(
      context,
      widget.accessToken,
      widget.product['id'],
    );
    setState(() {
      _invDetail = inventoryDetail;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarAuthScreen(widget.product['name'].toString()),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: _buildBody(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Editar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return Stack(
          children: [
            productList(context),
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
          ],
        );
      case 1:
        return Stack(
          children: [
            productEdit(context),
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
          ],
        );
      case 2:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  'Configuración Sensible',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Center(
              child: Card(
                color: const Color.fromARGB(255, 214, 214, 214),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: SizedBox(
                  child: Column(
                    children: [
                      cardConfigSensible(
                          context,
                          'Cambiar nombre',
                          'Todos los usuarios asociados sufriran cambios..',
                          'Modificar',
                          '/ruta',
                          widget.product,
                          widget.accessToken),
                      const Divider(
                        thickness: 1,
                        color: Color.fromARGB(255, 124, 124, 124),
                      ),
                      cardConfigSensible(
                          context,
                          'Eliminar inventario',
                          'Una vez eliminado, no se podrá recuperar.',
                          'Eliminar',
                          '/ruta',
                          widget.product,
                          widget.accessToken),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget productList(BuildContext context) {
    return Column(
      children: [
        titleMenu(Icons.rule, 'Productos'),
        Expanded(
          child: ListView.builder(
            itemCount: widget.product['products_name'].length,
            itemBuilder: (context, i) {
              return Card(
                child: ListTile(
                  leading: Icon(
                    widget.product['products'][i].toString() != '0'
                        ? Icons.check_box
                        : Icons.disabled_by_default,
                    color: widget.product['products'][i].toString() != '0'
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(widget.product['products_name'][i]),
                  subtitle: Text(
                      'Cant.: ${widget.product['products'][i].toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // acción al presionar el botón
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // acción al presionar el botón
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 0;
              if (_selectedIndex == 0) {
                setState(() {
                  _isLoading = true;
                });
                _loadDetailInventory();
              }
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
              Text('Actualizar lista'),
            ],
          ),
        ),
      ],
    );
  }

  Widget productEdit(BuildContext context) {
    return Column(
      children: [
        // Text(_invDetail.toString()),
        titleMenu(Icons.edit, 'Editar productos'),
        Expanded(
          child: ListView.builder(
            itemCount: _invDetail['products_name'].length,
            itemBuilder: (context, i) {
              return Card(
                child: ListTile(
                  leading: Icon(
                    _invDetail['products'][i].toString() != '0'
                        ? Icons.check_box
                        : Icons.disabled_by_default,
                    color: _invDetail['products'][i].toString() != '0'
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(
                    _invDetail['products_name'][i],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text('Cant.: ${_invDetail['products'][i].toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          removeProductLabel(
                              context,
                              widget.accessToken,
                              int.parse(_invDetail['id'].toString()),
                              _invDetail['products_name'][i]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 1;
              if (_selectedIndex == 1) {
                setState(() {
                  _isLoading = true;
                });
                _loadDetailInventory();
              }
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
              Text('Actualizar lista'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            addProductLabel(context, widget.accessToken,
                int.parse(_invDetail['id'].toString()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: const [
              Icon(Icons.add),
              SizedBox(width: 12),
              Text('Agregar producto'),
            ],
          ),
        ),
      ],
    );
  }
}
