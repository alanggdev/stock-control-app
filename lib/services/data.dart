List<Map<String, dynamic>> getDataInventory() {
  List<Map<String, dynamic>> responseData = [
    {
      "name": "Tienda Villaflores",
      "products_name": ["Coca-cola", "Sprite", "Doritos"],
      "products": [10, 20, 30],
    },
    {
      "name": "Supermercado La Colonia",
      "products_name": ["Leche", "Huevos"],
      "products": [50, 100],
    },
    {
      "name": "Panadería El Trigo",
      "products_name": ["Pan dulce", "Conchas", "Roscas", "Empanadas"],
      "products": [20, 15, 10, 0],
    },
    {
      "name": "Farmacia San Francisco",
      "products_name": ["Ibuprofeno"],
      "products": [100],
    },
    {
      "name": "Ferretería El Progreso",
      "products_name": [
        "Martillo",
        "Clavos",
        "Destornillador",
        "Llave inglesa",
        "Martillo",
        "Clavos",
        "Destornillador",
        "Llave inglesa",
        "Martillo",
        "Clavos",
        "Destornillador",
        "Llave inglesa",
      ],
      "products": [40, 0, 30, 15, 40, 0, 30, 15, 40, 200, 30, 15],
    },
    {
      "name": "Librería El Quijote",
      "products_name": ["Cuadernos", "Lápices", "Borradores"],
      "products": [50, 100, 75],
    },
  ];
  return responseData;
}
