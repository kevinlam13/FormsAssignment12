import 'package:flutter/material.dart';

void main() {
  runApp(const RedesignApp());
}

class RedesignApp extends StatelessWidget {
  const RedesignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fresh Signup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  IconData? _selectedAvatar;

  final List<IconData> _avatars = [
    Icons.pets,
    Icons.emoji_emotions,
    Icons.star,
    Icons.flight_takeoff,
    Icons.catching_pokemon,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Join the Adventure",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name field
                    _buildInputCard(
                      icon: Icons.person,
                      label: "Full Name",
                      controller: _nameCtrl,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter your name" : null,
                    ),

                    const SizedBox(height: 16),

                    // Email field
                    _buildInputCard(
                      icon: Icons.email,
                      label: "Email Address",
                      controller: _emailCtrl,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Enter your email";
                        if (!v.contains("@")) return "Enter a valid email";
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password field
                    _buildInputCard(
                      icon: Icons.lock,
                      label: "Password",
                      controller: _passCtrl,
                      obscure: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Enter a password";
                        if (v.length < 6) return "At least 6 characters";
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Confirm password
                    _buildInputCard(
                      icon: Icons.lock_outline,
                      label: "Confirm Password",
                      controller: _confirmCtrl,
                      obscure: true,
                      validator: (v) {
                        if (v != _passCtrl.text) {
                          return "Passwords don’t match";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Avatar Picker
                    const Text(
                      "Pick Your Avatar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 15,
                      children: _avatars.map((icon) {
                        final selected = _selectedAvatar == icon;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedAvatar = icon),
                          child: CircleAvatar(
                            radius: selected ? 36 : 30,
                            backgroundColor:
                                selected ? Colors.white : Colors.teal[100],
                            child: Icon(
                              icon,
                              size: 36,
                              color:
                                  selected ? Colors.teal : Colors.teal.shade900,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),

                    // Sign Up button
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      label: const Text("Sign Up"),
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedAvatar == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select an avatar."),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(
                                name: _nameCtrl.text,
                                avatar: _selectedAvatar!,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool obscure = false,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.teal),
            labelText: label,
            border: InputBorder.none,
          ),
          validator: validator,
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final String name;
  final IconData avatar;

  const WelcomeScreen({super.key, required this.name, required this.avatar});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                radius: 50,
                child: Icon(widget.avatar, size: 60, color: Colors.teal.shade800),
              ),
              const SizedBox(height: 24),
              Text(
                "Welcome, ${widget.name}!",
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              const SizedBox(height: 12),
              const Text(
                "Your journey begins here 🌟",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
