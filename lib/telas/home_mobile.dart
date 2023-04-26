import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webwhatsappsystem/components/lista_contatos.dart';
import 'package:webwhatsappsystem/components/lista_conversas.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({Key? key}) : super(key: key);

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("WhatsApp"),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              SizedBox(
                width: 3.0,
              ),
              IconButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  icon: Icon(Icons.logout)),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: "Conversas",
                ),
                Tab(
                  text: "Contatos",
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListaConversas(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListaContatos(),
                )
              ],
            ),
          ),
        ));
  }
}
