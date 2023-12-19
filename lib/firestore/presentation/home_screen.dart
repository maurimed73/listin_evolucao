import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listin_evolucao/firestore_produtos/presentation/produto_screen.dart';
import 'package:uuid/uuid.dart';
import '../models/listin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Listin> listListins = [
    // Listin(id: "L001", name: "Feira de Outubro"),
    // Listin(id: "L002", name: "Feira de Novembro"),
  ];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listin - Feira Colaborativa"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listListins.isEmpty)
          ? const Center(
              child: Text(
                "Nenhuma lista ainda.\nVamos criar a primeira?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListView(
                children: List.generate(
                  listListins.length,
                  (index) {
                    Listin model = listListins[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: const EdgeInsets.only(right: 8.0),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        remove(model);
                      },
                      key: ValueKey<Listin>(model),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProdutoScreen(listin: model)));
                        },
                        onLongPress: () {
                          showFormModal(model: model);
                        },
                        leading: const Icon(Icons.list_alt_rounded),
                        title: Text(model.name),
                        // subtitle: Text(
                        //   model.id,
                        //   style: const TextStyle(fontSize: 10),
                        // ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  showFormModal({Listin? model}) {
    // Labels à serem mostradas no Modal
    String title = "Adicionar Listin";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    // Controlador do campo que receberá o nome do Listin
    TextEditingController nameController = TextEditingController();

    // Caso esteja editando
    if (model != null) {
      title = "Editando ${model.name}";
      nameController.text = model.name;
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,

      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headline5),
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(label: Text("Nome do Listin")),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //criar um objeto Listin com as infos
                        Listin listin = Listin(
                            id: const Uuid().v1(), name: nameController.text);

                        // usar id do model
                        if (model != null) {
                          listin.id = model.id;
                        }

                        // salvar no firestore
                        firestore
                            .collection('listins')
                            .doc(listin.id)
                            .set(listin.toMap());

                        // Atualizar a lista
                        refresh();

                        // fechar o modal
                        Navigator.pop(context);
                      },
                      child: Text(confirmationButton)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    List<Listin> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('listins').get();

    for (var doc in snapshot.docs) {
      temp.add(Listin.fromMap(doc.data()));
    }

    setState(() {
      listListins = temp;
    });
  }

  void remove(Listin model) {
    firestore.collection('listins').doc(model.id).delete();
    refresh();
  }
}
