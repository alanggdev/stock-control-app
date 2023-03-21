import 'package:flutter/material.dart';
import 'package:stock_control/screens/components/app_bar.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    final dynamic products_name = args['products_name'];
    final dynamic products = args['products'];
    return Scaffold(
        appBar: appBarAuthScreen(args['name'].toString()),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              titleMenu(Icons.rule, 'Productos'),
              Text(args.toString()),
              Expanded(
  child: Container(
    child: ListView.builder(
      itemCount: products_name.length,
      itemBuilder: (context, i) {
        return Card(
          child: ListTile(
            leading: Icon(
              products[i].toString() != '0'
                  ? Icons.check_box
                  : Icons.disabled_by_default,
              color: products[i].toString() != '0'
                  ? Colors.green
                  : Colors.red,
            ),
            title: Text(products_name[i]),
            subtitle: Text('Cant.: ${products[i].toString()}'),
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
