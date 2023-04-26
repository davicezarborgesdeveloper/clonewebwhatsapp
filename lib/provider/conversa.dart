import 'package:flutter/material.dart';
import 'package:webwhatsappsystem/modelo/usuario.dart';

class ConversaProvider with ChangeNotifier {
  Usuario? _usuarioDestinatario;
  Usuario? get usuarioDestinatario => _usuarioDestinatario;

  set usuarioDestinatario(Usuario? value) {
    _usuarioDestinatario = value;
    notifyListeners();
  }
}
