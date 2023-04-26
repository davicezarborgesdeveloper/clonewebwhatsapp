import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webwhatsappsystem/firebase_options.dart';
import 'package:webwhatsappsystem/provider/conversa.dart';
import 'package:webwhatsappsystem/rotas.dart';
import 'package:webwhatsappsystem/uteis/paleta_cores.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: PaletaCores.corPrimaria,
  colorScheme: ColorScheme.fromSeed(
      seedColor: PaletaCores.corPrimaria,
      primary: PaletaCores.corPrimaria,
      secondary: PaletaCores.corDestaque),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ConversaProvider(),
    child: MaterialApp(
      title: "WhatsApp Web",
      debugShowCheckedModeBanner: false,
      theme: temaPadrao,
      initialRoute: "/",
      onGenerateRoute: Rotas.gerarRota,
    ),
  ));
}
