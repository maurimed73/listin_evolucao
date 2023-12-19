import 'package:flutter/material.dart';
import '../../model/produto.dart';

class ListTileProduto extends StatelessWidget {
  final Produto produto;
  final bool isComprado;
  final Function showModal;
  final Function iconClick;
  final Function trailingClick;
  const ListTileProduto({
    super.key,
    required this.produto,
    required this.isComprado,
    required this.showModal,
    required this.iconClick,
    required this.trailingClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModal(model: produto);
      },
      leading: IconButton(
        icon: Icon(
          (isComprado) ? Icons.shopping_basket : Icons.check,
        ),
        onPressed: () {
          iconClick(produto);
        },
      ),
      trailing: IconButton(
          onPressed: () {
            trailingClick(produto);
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          )),
      title: Text(
        (produto.amount == null)
            ? produto.name
            : "${produto.name} (x${produto.amount!.toInt()})",
      ),
      subtitle: Text(
        (produto.price == null)
            ? "Clique para adicionar preço"
            : "R\$ ${produto.price!}",
      ),
    );
  }
}
