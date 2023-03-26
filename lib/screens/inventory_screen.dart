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
  bool canAccessProducts = false;
  bool canAccessEdit = false;
  bool canAccessSettings = false;

  @override
  void initState() {
    super.initState();
    _loadDetailInventory();
  }

  Future<void> _loadDetailInventory() async {
    await getInventory(
      context,
      widget.accessToken,
      widget.product['id'],
    ).then(
      (inventoryDetail) async {
        await getUserInfo(context, widget.accessToken).then(
          (userInfo) {
            setState(() {
              _invDetail = inventoryDetail;
              if (_invDetail['owner'] == userInfo['pk']) {
                canAccessProducts = true;
                canAccessEdit = true;
                canAccessSettings = true;
              } else if (_invDetail['admins'].contains(userInfo['pk'])) {
                canAccessProducts = true;
                canAccessEdit = true;
              } else if (_invDetail['sellers'].contains(userInfo['pk'])) {
                canAccessProducts = true;
              }
              _isLoading = false;
            });
          },
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 0 && canAccessProducts) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 1 && canAccessEdit) {
      setState(() {
        _selectedIndex = index;
      });
    } else if (index == 2 && canAccessSettings) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes permiso para acceder a esta vista'),
        ),
      );
    }
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
    // bool accesoPermitido = (_invDetail['owner'].toString() == _userData['pk'].toString());
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
              ),
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
            titleMenu(Icons.settings, 'Ajustes de Inventario'),
            // Text(_invDetail.toString()),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Usuarios',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: Card(
                  color: const Color.fromARGB(255, 238, 238, 238),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color.fromARGB(255, 124, 124, 124),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        cardConfigSensible(
                            context,
                            'Permisos de Usuarios',
                            'Agregar, eliminar y actualizar productos',
                            'Gestionar',
                            _invDetail,
                            widget.accessToken),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Configuración Sensible',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Center(
              child: Card(
                color: const Color.fromARGB(255, 238, 238, 238),
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
                          'Eliminar inventario',
                          'Una vez eliminado, no se podrá recuperar.',
                          'Eliminar',
                          widget.product,
                          widget.accessToken),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                  if (_selectedIndex == 2) {
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
            itemCount:
                _invDetail.length == 0 ? 0 : _invDetail['products_name'].length,
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
                        icon: const Icon(Icons.remove),
                        onPressed: _invDetail['products'][i] > 0
                            ? () {
                                setState(() {
                                  _invDetail['products'][i]--;
                                });
                              }
                            : null,
                      ),
                      Text(
                        _invDetail['products'][i].toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _invDetail['products'][i]++;
                          });
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
        ElevatedButton(
          onPressed: () {
            updateCantProduct(context, widget.accessToken, _invDetail);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: const [
              Icon(Icons.save_as),
              SizedBox(width: 12),
              Text('Guardar y Actualizar lista'),
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
