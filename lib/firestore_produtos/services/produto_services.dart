import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listin_evolucao/firestore_produtos/helpers/enum_order.dart';
import 'package:listin_evolucao/firestore_produtos/model/produto.dart';

class ProdutoService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  adicionarProduto({required String ListinId, required Produto produto}) {
    firestore
        .collection('listins')
        .doc(ListinId)
        .collection('produtos')
        .doc(produto.id)
        .set(produto.toMap());
  }

  Future<List<Produto>> lerProdutos(
      {required String ListinId,
      required OrdemProduto ordem,
      required bool isDecrescente}) async {
    List<Produto> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('listins')
        .doc(ListinId)
        .collection('produtos')
        // .where('isComprado', isEqualTo: isComprado)
        .orderBy(ordem.name, descending: isDecrescente)
        .get();

    for (var doc in snapshot.docs) {
      Produto produto = Produto.fromMap(doc.data());
      temp.add(produto);
    }

    return temp;
  }

  Future<void> alternarProduto({
    required String ListinId,
    required Produto produto,
  }) async {
    return firestore
        .collection('listins')
        .doc(ListinId)
        .collection('produtos')
        .doc(produto.id)
        .update({'isComprado': produto.isComprado});
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      conectarStreamProdutos({
    required String ListinId,
    required OrdemProduto ordem,
    required bool isDecrescente,
    required Function refresh,
  }) {
    return firestore
        .collection('listins')
        .doc(ListinId)
        .collection('produtos')
        .orderBy(ordem.name, descending: isDecrescente)
        .snapshots()
        .listen(
      (snapshot) {
        refresh(snapshot: snapshot);
      },
    ); //stream -> canal aberto
  }

  Future<void> removerProduto(
      {required String ListinId, required Produto produto}) async {
    await firestore
        .collection('listins')
        .doc(ListinId)
        .collection('produtos')
        .doc(produto.id)
        .delete();
  }
}
