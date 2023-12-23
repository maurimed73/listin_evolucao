import 'package:flutter/material.dart';
import 'package:listin_evolucao/authentication/services/auth_service.dart';

showSenhaConfimacaoDialog({
  required BuildContext context,
  required String email,
}) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController senhaConfirmacaoController =
          TextEditingController();
      return AlertDialog(
        title: Text(
          'Deseja remover a conta com o email $email ?',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Para confirmar a remoção da conta, insira sua senha:',
                style: TextStyle(fontSize: 10),
              ),
              TextFormField(
                controller: senhaConfirmacaoController,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Senha')),
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                AuthService()
                    .removerConta(senha: senhaConfirmacaoController.text)
                    .then((String? erro) {
                  if (erro == null) {
                    Navigator.pop(context);
                  }
                });
              },
              child: const Text(
                'EXCLUIR CONTA',
                style: TextStyle(fontSize: 10),
              ))
        ],
      );
    },
  );
}
