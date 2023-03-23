import 'package:flutter/material.dart';
import 'package:stock_control/screens/components/app_bar.dart';
import 'package:stock_control/screens/components/label_inventory.dart';

class InventoryScreen extends StatefulWidget {
  final dynamic product;
  final String accessToken;
  const InventoryScreen(this.product, this.accessToken, {super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int _selectedIndex = 0;

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
        return Column(
          children: [
            titleMenu(Icons.rule, 'Productos'),
            Text(widget.product.toString()),
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
          ],
        );
      case 1:
        return Column(
          children: [
            titleMenu(Icons.edit, 'Editar productos'),
            Text(widget.product.toString()),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 29, 177, 74),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 12),
                  Text('Agregar producto'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 148, 148, 148),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 12),
                  Text('Guardar cambios'),
                ],
              ),
            ),
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
}
