import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webwhatsappsystem/components/lista_contatos.dart';
import 'package:webwhatsappsystem/telas/home_mobile.dart';
import 'package:webwhatsappsystem/telas/home_web.dart';
import 'package:webwhatsappsystem/uteis/responsivo.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsivo(
      mobile: HomeMobile(),
      tablet: HomeWeb(),
      web: HomeWeb(),
    );
  }
}
