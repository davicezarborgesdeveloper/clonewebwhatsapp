import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:webwhatsappsystem/modelo/usuario.dart';
import 'package:webwhatsappsystem/uteis/paleta_cores.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerNome =
      TextEditingController(text: "Jamilton Damasceno");
  TextEditingController _controllerEmail =
      TextEditingController(text: "jamilton@gmail.com");
  TextEditingController _controllerSenha =
      TextEditingController(text: "1234567");
  bool _cadastroUsuario = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uint8List? _arquivoImagemSelecionado;

  _verificarUsuarioLogado() {
    User? usuarioLogado = _auth.currentUser;

    if (usuarioLogado != null) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  _selecionarImagem() async {
    //Selecionar arquivo
    FilePickerResult? resultado =
        await FilePicker.platform.pickFiles(type: FileType.image);

    //Recuperar o arquivo
    setState(() {
      _arquivoImagemSelecionado = resultado?.files.single.bytes;
    });
  }

  _uploadImagem(Usuario usuario) {
    Uint8List? arquivoSelecionado = _arquivoImagemSelecionado;
    if (arquivoSelecionado != null) {
      Reference imagemPerfilRef =
          _storage.ref("imagens/perfil/${usuario.idUsuario}.jpg");
      UploadTask uploadTask = imagemPerfilRef.putData(arquivoSelecionado);

      uploadTask.whenComplete(() async {
        String urImagem = await uploadTask.snapshot.ref.getDownloadURL();
        usuario.urlImagem = urImagem;

        //Atualiza url e nome nos dados do usuário
        await _auth.currentUser?.updateDisplayName(usuario.nome);
        await _auth.currentUser?.updatePhotoURL(usuario.urlImagem);

        final usuariosRef = _firestore.collection("usuarios");
        usuariosRef.doc(usuario.idUsuario).set(usuario.toMap()).then((value) {
          //tela principal
          Navigator.pushReplacementNamed(context, "/home");
        });
      });
    }
  }

  _validarCampos() async {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        if (_cadastroUsuario) {
          if (_arquivoImagemSelecionado != null) {
            //Cadastro
            if (nome.isNotEmpty && nome.length >= 3) {
              await _auth
                  .createUserWithEmailAndPassword(email: email, password: senha)
                  .then((auth) {
                //Upload
                String? idUsuario = auth.user?.uid;
                if (idUsuario != null) {
                  Usuario usuario = Usuario(idUsuario, nome, email);
                  _uploadImagem(usuario);
                }
                //print("Usuario cadastrado: $idUsuario");
              });
            } else {
              print("Nome inválido, digite ao menos 3 caracteres");
            }
          } else {
            print("Selecione uma imagem");
          }
        } else {
          //Login
          await _auth
              .signInWithEmailAndPassword(email: email, password: senha)
              .then((auth) {
            //tela principal
            Navigator.pushReplacementNamed(context, "/home");
          });
        }
      } else {
        print("Senha inválida");
      }
    } else {
      print("Email inválido");
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: PaletaCores.corFundo,
        width: larguraTela,
        height: alturaTela,
        child: Stack(
          children: [
            Positioned(
                child: Container(
              width: larguraTela,
              height: alturaTela * 0.5,
              color: PaletaCores.corPrimaria,
            )),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Container(
                      padding: EdgeInsets.all(40),
                      width: 500,
                      child: Column(
                        children: [
                          //Imagem perfil com botão
                          Visibility(
                            visible: _cadastroUsuario,
                            child: ClipOval(
                              child: _arquivoImagemSelecionado != null
                                  ? Image.memory(
                                      _arquivoImagemSelecionado!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "imagens/perfil.png",
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),

                          SizedBox(
                            height: 8,
                          ),

                          Visibility(
                            visible: _cadastroUsuario,
                            child: OutlinedButton(
                                onPressed: _selecionarImagem,
                                child: Text("Selecionar foto")),
                          ),

                          SizedBox(
                            height: 8,
                          ),

                          //Caixa de texto nome
                          Visibility(
                            visible: _cadastroUsuario,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: _controllerNome,
                              decoration: InputDecoration(
                                  hintText: "Nome",
                                  labelText: "Nome",
                                  suffixIcon: Icon(Icons.person_outline)),
                            ),
                          ),

                          //Caixa de texto email
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _controllerEmail,
                            decoration: InputDecoration(
                                hintText: "Email",
                                labelText: "Email",
                                suffixIcon: Icon(Icons.mail_outline)),
                          ),

                          //Caixa de texto senha
                          TextField(
                            keyboardType: TextInputType.text,
                            controller: _controllerSenha,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Senha",
                                labelText: "Senha",
                                suffixIcon: Icon(Icons.lock_outline)),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          //Botão
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _validarCampos();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: PaletaCores.corPrimaria),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  _cadastroUsuario ? "Cadastro" : "Login",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),

                          Row(
                            children: [
                              Text("Login"),
                              Switch(
                                  value: _cadastroUsuario,
                                  onChanged: (bool valor) {
                                    setState(() {
                                      _cadastroUsuario = valor;
                                    });
                                  }),
                              Text("Cadastro"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
