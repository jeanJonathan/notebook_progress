import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'wave_cliper.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTOS = false;

  void _setAgreedToTOS(bool? newValue) {
    setState(() {
      _agreedToTOS = newValue ?? _agreedToTOS;
    });
  }


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerAccount() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text == _confirmPasswordController.text) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          // Enregistrement réussi - Naviguer vers la page suivante
          Navigator.of(context).pushReplacementNamed('/authentification');
        } on FirebaseAuthException catch (e) {
          // Gérer les erreurs d'enregistrement, par exemple en affichant un message d'erreur
        }
      } else {
        // Gérer le cas où les mots de passe ne correspondent pas
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: Colors.blue,
              height: 200,
              width: double.infinity,
            ),
          ),
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(), // pour empêcher le défilement de la vue
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Aligner les champs vers le bas
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.17), // Ajustez cette valeur pour déplacer les champs sous la vague
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'Prénom*',
                      ),
                      validator: (value) {
                        return value!.isEmpty ? 'Veuillez renseigner votre prénom.' : null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Nom*',
                      ),
                      validator: (value) {
                        return value!.isEmpty ? 'Veuillez renseigner votre nom.' : null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Adresse e-mail*',
                      ),
                      validator: (value) {
                        return value!.isEmpty ? 'Veuillez renseigner votre adresse e-mail.' : null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe*',
                      ),
                      obscureText: true,
                      validator: (value) {
                        return value!.isEmpty || value.length < 8 ? 'Le mot de passe doit contenir au moins 8 caractères.' : null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe*',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) return 'Veuillez confirmer votre mot de passe.';
                        if (value != _passwordController.text) return 'Les mots de passe ne correspondent pas.';
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Checkbox(
                        value: _agreedToTOS,
                        onChanged: _setAgreedToTOS,
                      ),
                      title: GestureDetector(
                        onTap: () => _setAgreedToTOS(!_agreedToTOS),
                        child: const Text(
                          'Accepte conditions & confidentialité',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _agreedToTOS ? _registerAccount : null,
                      child: Text('S\'inscrire'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

