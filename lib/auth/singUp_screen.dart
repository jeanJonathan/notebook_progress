import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notebook_progress/auth/user_authentication_screen.dart';


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
      _agreedToTOS = value ?? false;
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF64C8C8), Color(0xFF074868)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 100),
                      Center(
                        child: Text(
                          'Créer un compte',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _firstNameController,
                                cursorColor: Color(0xFF64C8C8),
                                decoration: InputDecoration(
                                  labelText: 'Prénom *',
                                  labelStyle: TextStyle(color: Color(0xFF074868)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                ),
                                validator: (value) {
                                  return value!.isEmpty ? 'Veuillez renseigner votre prénom.' : null;
                                },
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                controller: _lastNameController,
                                cursorColor: Color(0xFF64C8C8),
                                decoration: InputDecoration(
                                  labelText: 'Nom *',
                                  labelStyle: TextStyle(color: Color(0xFF074868)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                ),
                                validator: (value) {
                                  return value!.isEmpty ? 'Veuillez renseigner votre nom.' : null;
                                },
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                controller: _emailController,
                                cursorColor: Color(0xFF64C8C8),
                                decoration: InputDecoration(
                                  labelText: 'Adresse e-mail *',
                                  labelStyle: TextStyle(color: Color(0xFF074868)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                ),
                                validator: (value) {
                                  return value!.isEmpty ? 'Veuillez renseigner votre adresse e-mail.' : null;
                                },
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                controller: _passwordController,
                                cursorColor: Color(0xFF64C8C8),
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe *',
                                  labelStyle: TextStyle(color: Color(0xFF074868)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  return value!.isEmpty || value.length < 8 ? 'Le mot de passe doit contenir au moins 8 caractères.' : null;
                                },
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                controller: _confirmPasswordController,
                                cursorColor: Color(0xFF64C8C8),
                                decoration: InputDecoration(
                                  labelText: 'Confirmer le mot de passe *',
                                  labelStyle: TextStyle(color: Color(0xFF074868)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF64C8C8)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
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
                              SizedBox(height: 12),
                              ListTile(
                                leading: Radio<bool>(
                                  value: true,
                                  groupValue: _selectedValue,
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
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity, // Le bouton prendra toute la largeur disponible
                                child: ElevatedButton(
                                  onPressed: _agreedToTOS ? _registerAccount : null,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: _agreedToTOS ? Color(0xFF64C8C8) : Colors.grey,
                                    padding: EdgeInsets.symmetric(vertical: 16), // Augmenter le padding vertical pour un bouton plus grand
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'S\'inscrire',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              )

                            ],
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
