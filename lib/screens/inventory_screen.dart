import 'package:flutter/material.dart';
import 'package:stock_control/screens/components/app_bar.dart';

class InventoryScreen extends StatefulWidget {
  final dynamic product;
  const InventoryScreen(this.product, {super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarAuthScreen(widget.product['name'].toString()),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              titleMenu(Icons.rule, 'Productos'),
              Text(widget.product.toString()),
              Expanded(
                child: Container(
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
                          subtitle: Text('Cant.: ${widget.product['products'][i].toString()}'),
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
              ),
            ],
          ),
        ));
  }
}
