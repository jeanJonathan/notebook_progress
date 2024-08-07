import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_authentication_screen.dart';
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

  bool? _selectedValue;
  bool _agreedToTOS = false;
  void _handleRadioValueChange(bool? value) {
    setState(() {
      _selectedValue = value;
      _agreedToTOS = value ?? false; // _agreedToTOS sera vrai si value est vrai, sinon faux
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
          // Enregistrement réussi - Naviguer vers la page de connexion
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        } on FirebaseAuthException catch (e) {
          // Gestion des erreurs d'enregistrement, par exemple en affichant un message d'erreur
        }
      } else {
        // Gérer le cas où les mots de passe ne correspondent pas
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color: Color(0xFF074868),
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
                        cursorColor: Color(0xFF64C8C8), // Définit la couleur du curseur
                        decoration: InputDecoration(
                          labelText: 'Prénom *',
                          labelStyle: TextStyle(color: Color(0xFF074868)),
                          focusedBorder: UnderlineInputBorder( // Définit la couleur de la bordure lors de la sélection du champ
                            borderSide: BorderSide(color: Color(0xFF64C8C8)),
                          ),
                          // Ajoutez également enabledBorder si vous souhaitez changer la couleur de la bordure quand le champ n'est pas sélectionné
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF64C8C8)),
                          ),
                        ),
                        validator: (value) {
                          return value!.isEmpty ? 'Veuillez renseigner votre prénom.' : null;
                        },
                      ),
                      TextFormField(
                        controller: _lastNameController,
                          cursorColor: Color(0xFF64C8C8), // Définit la couleur du curseur
                          decoration: InputDecoration(
                            labelText: 'Nom *',
                            labelStyle: TextStyle(color: Color(0xFF074868)),
                            focusedBorder: UnderlineInputBorder( // Définit la couleur de la bordure lors de la sélection du champ
                              borderSide: BorderSide(color: Color(0xFF64C8C8)),
                            ),
                            // Ajoutez également enabledBorder si vous souhaitez changer la couleur de la bordure quand le champ n'est pas sélectionné
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF64C8C8)),
                            ),
                          ),
                        validator: (value) {
                          return value!.isEmpty ? 'Veuillez renseigner votre nom.' : null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: Color(0xFF64C8C8), // Définit la couleur du curseur
                        decoration: InputDecoration(
                          labelText: 'Adresse e-mail *',
                          labelStyle: TextStyle(color: Color(0xFF074868)),
                          focusedBorder: UnderlineInputBorder( // Définit la couleur de la bordure lors de la sélection du champ
                            borderSide: BorderSide(color: Color(0xFF64C8C8)),
                          ),
                          // Ajoutez également enabledBorder si vous souhaitez changer la couleur de la bordure quand le champ n'est pas sélectionné
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF64C8C8)),
                          ),
                        ),
                        validator: (value) {
                          return value!.isEmpty ? 'Veuillez renseigner votre adresse e-mail.' : null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: Color(0xFF64C8C8), // Définit la couleur du curseur
                        decoration: InputDecoration(
                          labelText: 'Mot de passe *',
                          labelStyle: TextStyle(color: Color(0xFF074868)),
                          focusedBorder: UnderlineInputBorder( // Définit la couleur de la bordure lors de la sélection du champ
                            borderSide: BorderSide(color: Color(0xFF64C8C8)),
                          ),
                          // Ajoutez également enabledBorder si vous souhaitez changer la couleur de la bordure quand le champ n'est pas sélectionné
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF64C8C8)),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          return value!.isEmpty || value.length < 8 ? 'Le mot de passe doit contenir au moins 8 caractères.' : null;
                        },
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        cursorColor: Color(0xFF64C8C8), // Définit la couleur du curseur
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe *',
                          labelStyle: TextStyle(color: Color(0xFF074868)),
                          focusedBorder: UnderlineInputBorder( // Définit la couleur de la bordure lors de la sélection du champ
                            borderSide: BorderSide(color: Color(0xFF64C8C8)),
                          ),
                          // Ajoutez également enabledBorder si vous souhaitez changer la couleur de la bordure quand le champ n'est pas sélectionné
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF64C8C8)),
                          ),
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
                        leading: Radio<bool>(
                          value: true, // La valeur que ce bouton représente
                          groupValue: _selectedValue, // La valeur actuellement sélectionnée dans le groupe
                          onChanged: _handleRadioValueChange,
                          activeColor: Color(0xFF64C8C8),
                        ),
                        title: GestureDetector(
                          onTap: () => _handleRadioValueChange(!_agreedToTOS),
                          child: Text(
                            'Accepte conditions & confidentialité',
                            style: TextStyle(fontSize: 15, color: Color(0xFF074868)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _agreedToTOS ? _registerAccount : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey; // Couleur si le bouton est désactivé
                              }
                              return Color(0xFF64C8C8); // Couleur par défaut
                            },
                          ),
                        ),
                        child: Text(
                          'S\'inscrire',
                          style: TextStyle(
                            color: _agreedToTOS ? Color(0xFF64C8C8) : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

