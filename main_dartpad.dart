import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math' as math;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NafsiApp());
}

class NafsiApp extends StatelessWidget {
  const NafsiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nafsi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia',
        useMaterial3: true,
      ),
      // Already logged in? Skip the welcome screen.
      home: FirebaseAuth.instance.currentUser != null
          ? const ProfileSelectScreen()
          : const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: navy,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.spa_outlined,
                      color: navy,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'nafsi',
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w600,
                      color: navy,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Empowering Your Journey\nto Harmony and Peace',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: navy,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AuthButton(
                        label: 'LOGIN',
                        icon: Icons.person_outline,
                        backgroundColor: Colors.white,
                        foregroundColor: navy,
                        borderColor: pinkAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: 16),

                      _AuthButton(
                        label: 'REGISTER',
                        icon: Icons.person_add_alt_1,
                        backgroundColor: pinkAccent,
                        foregroundColor: Colors.white,
                        borderColor: pinkAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  const Text(
                    'New to nafsi? Start your\npink journey today!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: navy,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Discover a personalized experience\nfor balance and well-being.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: navy,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _AuthButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(24),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: 130,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: foregroundColor,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final Color navy = Color(0xFF0F2A44);
  final Color pinkAccent = Color(0xFFC9A882);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(28),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: navy,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: navy,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.spa_outlined,
                    color: navy,
                    size: 32,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'nafsi',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w600,
                    color: navy,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  'Login to Your Account',
                  style: TextStyle(
                    fontSize: 16,
                    color: navy,
                  ),
                ),

                SizedBox(height: 35),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 7),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: navy,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 18),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      color: navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 7),

                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: navy,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileSelectScreen(),
                            ),
                            (route) => false,
                          );

                      } catch (error) {
                        print(error);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login failed'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                      color: pinkAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Country codes for the phone number on the sign-up page.
class CountryCode {
  final String flag;
  final String name;
  final String code;
  final int digits; // digits after the code
  final String example;

  const CountryCode(this.flag, this.name, this.code, this.digits, this.example);
}

const List<CountryCode> countryCodes = [
  CountryCode('🇦🇪', 'United Arab Emirates', '+971', 9, '50 123 4567'),
  CountryCode('🇸🇦', 'Saudi Arabia', '+966', 9, '50 123 4567'),
  CountryCode('🇴🇲', 'Oman', '+968', 8, '9123 4567'),
  CountryCode('🇶🇦', 'Qatar', '+974', 8, '3312 3456'),
  CountryCode('🇧🇭', 'Bahrain', '+973', 8, '3600 1234'),
  CountryCode('🇰🇼', 'Kuwait', '+965', 8, '5001 2345'),
  CountryCode('🇪🇬', 'Egypt', '+20', 10, '100 123 4567'),
  CountryCode('🇯🇴', 'Jordan', '+962', 9, '7 9012 3456'),
  CountryCode('🇱🇧', 'Lebanon', '+961', 8, '71 123 456'),
  CountryCode('🇸🇾', 'Syria', '+963', 9, '944 567 890'),
  CountryCode('🇮🇶', 'Iraq', '+964', 10, '790 123 4567'),
  CountryCode('🇸🇩', 'Sudan', '+249', 9, '91 123 1234'),
  CountryCode('🇮🇳', 'India', '+91', 10, '81234 56789'),
  CountryCode('🇵🇰', 'Pakistan', '+92', 10, '301 2345678'),
  CountryCode('🇬🇧', 'United Kingdom', '+44', 10, '7400 123456'),
  CountryCode('🇺🇸', 'United States', '+1', 10, '201 555 0123'),
];

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  String? selectedGender;
  CountryCode country = countryCodes.first;

  // For example: +971 501234567
  String get fullPhone => '${country.code} ${phoneController.text.trim()}';

  Future<void> pickCountry() async {
    final CountryCode? picked = await showModalBottomSheet<CountryCode>(
      context: context,
      backgroundColor: const Color(0xFFF7F2EA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: Text(
                'Choose your country',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F2A44),
                ),
              ),
            ),
            for (final c in countryCodes)
              ListTile(
                leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                title: Text(c.name),
                trailing: Text(
                  c.code,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                selected: c == country,
                onTap: () => Navigator.pop(sheetContext, c),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    setState(() {
      country = picked;
      // Cut the number if the new country uses fewer digits.
      if (phoneController.text.length > picked.digits) {
        phoneController.text = phoneController.text.substring(0, picked.digits);
      }
    });
  }
  final Color navy = Color(0xFF0F2A44);
  final Color pinkAccent = Color(0xFFC9A882);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();
  TextEditingController confirmPasscodeController = TextEditingController();

  bool hidePassword = true;
  bool hidePasscode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(28),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: navy,
                    ),
                  ),
                ),

                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: navy,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.spa_outlined,
                    color: navy,
                    size: 32,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'nafsi',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.w600,
                    color: navy,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 16,
                    color: navy,
                  ),
                ),

                SizedBox(height: 30),

                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter first name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: navy,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: 'Enter last name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: navy,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: navy,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country code picker
                    GestureDetector(
                      onTap: pickCountry,
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade500),
                        ),
                        child: Row(
                          children: [
                            Text(country.flag,
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 6),
                            Text(
                              country.code,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: navy,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: navy),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: country.digits,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          hintText: country.example,
                          helperText: '${country.digits} digits, without the first 0',
                          counterText: '',
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: navy,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                TextField(
                  controller: birthdayController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    hintText: 'dd/mm/yyyy',
                    prefixIcon: Icon(
                      Icons.calendar_month_outlined,
                      color: navy,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );

                    if (date != null) {
                      birthdayController.text =
                          '${date.day}/${date.month}/${date.year}';
                    }
                  },
                ),

                SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                ),

                Row(
                  children: [
                    Radio<String>(
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text(
                      'Female',
                      style: TextStyle(
                        fontSize: 16,
                        color: navy,
                      ),
                    ),
                    SizedBox(width: 25),
                    Radio<String>(
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    Text(
                      'Male',
                      style: TextStyle(
                        fontSize: 16,
                        color: navy,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Create a password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: navy,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Write the password again',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: navy,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: passcodeController,
                  obscureText: hidePasscode,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Profile Passcode',
                    hintText: '4 digits',
                    counterText: '',
                    prefixIcon: Icon(
                      Icons.pin_outlined,
                      color: navy,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePasscode = !hidePasscode;
                        });
                      },
                      icon: Icon(
                        hidePasscode
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                TextField(
                  controller: confirmPasscodeController,
                  obscureText: hidePasscode,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Confirm Passcode',
                    hintText: '4 digits',
                    counterText: '',
                    prefixIcon: Icon(
                      Icons.pin_outlined,
                      color: navy,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () async {
                      String passcode = passcodeController.text;

                      if (phoneController.text.trim().length != country.digits) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'The phone number must be ${country.digits} digits for ${country.name} (${country.code}).',
                            ),
                          ),
                        );
                        return;
                      }

                      if (passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('The passwords do not match.'),
                          ),
                        );
                        return;
                      }

                      if (passcode.length != 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('The passcode must be 4 digits.'),
                          ),
                        );
                        return;
                      }

                      if (passcode != confirmPasscodeController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('The passcodes do not match.'),
                          ),
                        );
                        return;
                      }

                      try {
                        UserCredential userCredential =
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        String userId = userCredential.user!.uid;

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .set({
                          'firstName': firstNameController.text.trim(),
                          'lastName': lastNameController.text.trim(),
                          'email': emailController.text.trim(),
                          'phone': fullPhone,
                          'birthday': birthdayController.text.trim(),
                          'gender': selectedGender,
                        });

                        String profileId = newProfileId();

                        await profilesCollection(userId).doc(profileId).set({
                          'firstName': firstNameController.text.trim(),
                          'lastName': lastNameController.text.trim(),
                          'birthday': birthdayController.text.trim(),
                          'gender': selectedGender,
                          'phone': fullPhone,
                          'relationship': 'Me',
                          'passcode': passcode,
                        });

                        print('Connected to Firebase');
                        print('Account created successfully');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Account created successfully',
                            ),
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      } catch (error) {
                        print(error);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registration failed'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinkAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'REGISTER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: pinkAccent,
                    ),
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: navy,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.spa_outlined,
                          color: navy,
                          size: 32,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'nafsi',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w600,
                          color: navy,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 35),

                      Text(
                        CurrentProfile.firstName == null
                            ? 'Welcome back'
                            : 'Welcome back, ${CurrentProfile.firstName}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'How are you feeling today?',
                        style: TextStyle(
                          fontSize: 16,
                          color: navy,
                        ),
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnxietyScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pinkAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 28,
                              ),

                              SizedBox(width: 18),

                              Text(
                                'Check Anxiety Status',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EatingDisorderScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.restaurant_outlined,
                                size: 28,
                              ),

                              SizedBox(width: 18),

                              Text(
                                'Check Eating Disorder',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LlmAssessmentScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7A9E7E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 28,
                              ),

                              SizedBox(width: 18),

                              Text(
                                'LLM Assessment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AthkarMenuScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: navy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 28,
                              ),

                              SizedBox(width: 18),

                              Text(
                                'Daily Athkar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              const Positioned(
                top: 12,
                right: 16,
                child: ProfileSwitcherButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnxietyScreen extends StatelessWidget {
  const AnxietyScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: navy,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: navy,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: navy,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Check Anxiety Status',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Choose your monitoring method',
                    style: TextStyle(
                      fontSize: 15,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 45),

                  SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManualAnxietyEntryScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: navy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(
                            color: pinkAccent,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 30,
                          ),

                          SizedBox(width: 20),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GAD Survey',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                'Answer questions',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HealthScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.watch_outlined,
                            size: 30,
                          ),

                          SizedBox(width: 20),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Health Monitoring',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                'Monitor using your Apple Watch',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EatingDisorderScreen extends StatelessWidget {
  const EatingDisorderScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: navy,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: navy,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.restaurant_outlined,
                      color: navy,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Check Eating Disorder',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Choose your monitoring method',
                    style: TextStyle(
                      fontSize: 15,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 45),

                  SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManualEatingDisorderEntryScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: navy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(
                            color: pinkAccent,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 30,
                          ),

                          SizedBox(width: 20),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EDE Survey',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                'Answer questions',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HealthScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.watch_outlined,
                            size: 30,
                          ),

                          SizedBox(width: 20),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Health Monitoring',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                'Monitor using your Apple Watch',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Firebase helpers for saving survey results.
/// -----------------------------------------------------------------------
String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

// For example: 9:05 PM
String formatTime(DateTime date) {
  final int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final String minute = date.minute.toString().padLeft(2, '0');
  final String period = date.hour < 12 ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

/// Firebase lists records by their ID, so this ID gets smaller as time
/// goes on, which puts the newest record on top.
String newestFirstId() {
  return (9999999999999 - DateTime.now().millisecondsSinceEpoch).toString();
}

/// Saves one survey attempt under
/// users/{userId}/profiles/{profileId}/{collection}
/// (gadSurveys or edeSurveys), so every attempt is a new record.
Future<void> saveSurveyResult({
  required String collection,
  required int score,
}) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final DateTime now = DateTime.now();

  await profileRecords(user.uid, collection).doc(newestFirstId()).set({
    'date': formatDate(now),
    'time': formatTime(now),
    'score': score,
  });
}

/// -----------------------------------------------------------------------
/// Shared reusable widget for a single 0..N scale question, styled to match
/// the app's cream/navy/pink look.
/// -----------------------------------------------------------------------
class ScaleQuestionCard extends StatelessWidget {
  final int number;
  final String question;
  final List<int> options;
  final int? selectedValue;
  final ValueChanged<int> onSelected;

  const ScaleQuestionCard({
    super.key,
    required this.number,
    required this.question,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  static const Color navy = Color(0xFF0F2A44);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. $question',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: navy,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((value) {
              final bool selected = selectedValue == value;
              return GestureDetector(
                onTap: () => onSelected(value),
                child: Container(
                  width: 48,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? navy : const Color(0xFFF0E9DD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '$value',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : navy,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Manual data entry — Anxiety screen
/// 9-item 0-3 questionnaire, matching the screenshots provided.
/// (Note: these items are the PHQ-9, a depression screener, reproduced
/// here exactly as shown in the screenshots and wired to the Anxiety flow
/// as requested.)
/// -----------------------------------------------------------------------
class ManualAnxietyEntryScreen extends StatefulWidget {
  const ManualAnxietyEntryScreen({super.key});

  @override
  State<ManualAnxietyEntryScreen> createState() =>
      ManualAnxietyEntryScreenState();
}

class ManualAnxietyEntryScreenState extends State<ManualAnxietyEntryScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  final List<String> questions = const [
    // GAD-7 (Spitzer et al., 2006)
    'Feeling nervous, anxious, or on edge',
    'Not being able to stop or control worrying',
    'Worrying too much about different things',
    'Trouble relaxing',
    'Being so restless that it is hard to sit still',
    'Becoming easily annoyed or irritable',
    'Feeling afraid, as if something awful might happen',
  ];

  // Extra safety question. It is NOT part of the GAD-7 score; it is only
  // used to show support numbers if the user needs them.
  final String safetyQuestion =
      'Thoughts that you would be better off dead, or of hurting yourself';

  final Map<int, int> answers = {};
  int? safetyAnswer;

  final String surveyName = 'GAD Survey';

  bool isSubmitting = false;

  static const List<int> scaleOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  /// 3-band split over the 1-10 average item score.
  String _severityLevel(double average) {
    if (average <= 4) return 'Low';
    if (average <= 7) return 'Middle';
    return 'High';
  }

  Color _severityColor(String level) {
    switch (level) {
      case 'Low':
        return const Color(0xFF3E8E5A);
      case 'Middle':
        return const Color(0xFFC98A2C);
      default:
        return const Color(0xFFB3402C);
    }
  }

  Future<void> submit() async {
    if (isSubmitting) return;

    if (answers.length < questions.length || safetyAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before submitting.'),
        ),
      );
      return;
    }

    final int total = answers.values.fold(0, (sum, v) => sum + v);
    final double average = total / answers.length;
    final String level = _severityLevel(average);
    // 1 = "not at all", so any answer above 1 is flagged.
    final bool flagSelfHarmItem = (safetyAnswer ?? 1) > 1;

    setState(() {
      isSubmitting = true;
    });

    try {
      await saveSurveyResult(
        collection: 'gadSurveys',
        score: total,
      );
    } catch (error) {
      print(error);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save your result'),
          ),
        );
      }
    }

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Assessment Submitted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Level: '),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _severityColor(level),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    level,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Your total score is $total out of ${questions.length * 10} '
                '(average ${average.toStringAsFixed(2)} on a 1-10 scale).'),
            const SizedBox(height: 10),
            const Text(
              'This is a self-report score, not a diagnosis. If you have '
              'concerns about how you\'re feeling, consider discussing this '
              'with a mental health professional.',
            ),
            if (flagSelfHarmItem) ...[
              const SizedBox(height: 14),
              const Text(
                'You indicated having thoughts of being better off dead. '
                'If you\'re in immediate danger, call 999 (UAE emergency '
                'services). You can also reach the UAE\'s free, 24/7 '
                'National Mental Support Line at 800-4673 (800-HOPE) for '
                'confidential support.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  this.context,
                  MaterialPageRoute(
                    builder: (context) => BookAppointmentScreen(
                      surveyName: surveyName,
                      severity: level,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                ),
                const Text(
                  'GAD SURVEY',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Over the last 2 weeks, how often have you been bothered by the following? '
                  '1 = "not at all" and 10 = "nearly every day".',
                  style: TextStyle(
                    fontSize: 14,
                    color: navy,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                for (int i = 0; i < questions.length; i++)
                  ScaleQuestionCard(
                    number: i + 1,
                    question: questions[i],
                    options: scaleOptions,
                    selectedValue: answers[i],
                    onSelected: (value) => setState(() => answers[i] = value),
                  ),
                const SizedBox(height: 6),
                const Text(
                  'This last question is not part of your score. We ask it '
                  'so we can show you where to get support if you need it.',
                  style: TextStyle(
                    fontSize: 13,
                    color: navy,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                ScaleQuestionCard(
                  number: questions.length + 1,
                  question: safetyQuestion,
                  options: scaleOptions,
                  selectedValue: safetyAnswer,
                  onSelected: (value) => setState(() => safetyAnswer = value),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Submit Assessment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Option-based question card: tap one labelled choice (no typing).
/// -----------------------------------------------------------------------
class OptionQuestionCard extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final String? caption;

  const OptionQuestionCard({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.caption,
  });

  static const Color navy = Color(0xFF0F2A44);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: navy,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              final bool isSelected = selected == option;
              return GestureDetector(
                onTap: () => onSelected(option),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? navy : const Color(0xFFF0E9DD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : navy,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (caption != null) ...[
            const SizedBox(height: 10),
            Text(
              caption!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B6255),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// EDE Survey — Eating Disorder screen
/// Based on the EDE-Q (Eating Disorder Examination Questionnaire),
/// Fairburn & Beglin (2008). Adapted for this app: rating items use a
/// 1-10 scale and count items use range options instead of typed numbers.
/// -----------------------------------------------------------------------
class ManualEatingDisorderEntryScreen extends StatefulWidget {
  const ManualEatingDisorderEntryScreen({super.key});

  @override
  State<ManualEatingDisorderEntryScreen> createState() =>
      ManualEatingDisorderEntryScreenState();
}

class ManualEatingDisorderEntryScreenState
    extends State<ManualEatingDisorderEntryScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  static const List<int> scaleOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // Questions 1-12: 1-10 rating scale.
  final List<String> section1to12 = const [
    'Have you been deliberately trying to limit the amount of food you eat to influence your shape or weight (whether or not you have succeeded)?',
    'Have you gone for long periods of time (8 waking hours or more) without eating anything at all in order to influence your shape or weight?',
    'Have you tried to exclude from your diet any foods that you like in order to influence your shape or weight (whether or not you have succeeded)?',
    'Have you tried to follow definite rules regarding your eating (for example, a calorie limit) in order to influence your shape or weight (whether or not you have succeeded)?',
    'Have you had a definite desire to have an empty stomach with the aim of influencing your shape or weight?',
    'Have you had a definite desire to have a totally flat stomach?',
    'Has thinking about food, eating or calories made it very difficult to concentrate on things you are interested in (for example, working, following a conversation, or reading)?',
    'Has thinking about shape or weight made it very difficult to concentrate on things you are interested in (for example, working, following a conversation, or reading)?',
    'Have you had a definite fear of losing control over eating?',
    'Have you had a definite fear that you might gain weight?',
    'Have you felt fat?',
    'Have you had a strong desire to lose weight?',
  ];

  // Questions 13-18: answered by picking a range (no typing).
  final List<String> countQuestions = const [
    'Over the past 28 days, how many times have you eaten what other people would regard as an unusually large amount of food (given the circumstances)?',
    'On how many of these times did you have a sense of having lost control over your eating (at the time that you were eating)?',
    'Over the past 28 days, on how many DAYS have such episodes of overeating occurred (i.e. you have eaten an unusually large amount of food and have had a sense of loss of control at the time)?',
    'Over the past 28 days, how many times have you made yourself sick (vomit) as a means of controlling your shape or weight?',
    'Over the past 28 days, how many times have you taken laxatives as a means of controlling your shape or weight?',
    'Over the past 28 days, how many times have you exercised in a "driven" or "compulsive" way as a means of controlling your weight, shape or amount of fat or to burn off calories?',
  ];

  // Ranges for "how many times" questions.
  static const List<String> timesOptions = [
    'None',
    '1–5',
    '6–12',
    '13–20',
    '21–28',
    'More than 28',
  ];

  // Ranges for "how many days" questions (max 28 days).
  static const List<String> daysOptions = [
    'None',
    '1–5 days',
    '6–12 days',
    '13–15 days',
    '16–22 days',
    '23–28 days',
  ];

  // Index (within countQuestions) of the question asking about DAYS.
  static const int daysQuestionIndex = 2;

  // Question 19-21: 1-10 rating scale.
  final String q19 =
      'Over the past 28 days, on how many days have you eaten in secret (i.e., furtively)? (Do not count episodes of binge eating)';
  final String q20 =
      'On what proportion of the times that you have eaten have you felt guilty (felt that you\'ve done wrong) because of its effect on your shape or weight? (Do not count episodes of binge eating)';
  final String q21 =
      'Over the past 28 days, how concerned have you been about other people seeing you eat? (Do not count episodes of binge eating)';

  // Questions 22-28: 1-10 rating scale.
  final List<String> section22to28 = const [
    'Has your weight influenced how you think about (judge) yourself as a person?',
    'Has your shape influenced how you think about (judge) yourself as a person?',
    'How much would it have upset you if you had been asked to weigh yourself once a week (no more, or less, often) for the next four weeks?',
    'How dissatisfied have you been with your weight?',
    'How dissatisfied have you been with your shape?',
    'How uncomfortable have you felt seeing your body (for example, seeing your shape in the mirror, in a shop window reflection, while undressing or taking a bath or shower)?',
    'How uncomfortable have you felt about others seeing your shape or figure (for example, in communal changing rooms, when swimming, or wearing tight clothes)?',
  ];

  // Closing questions — ranges instead of typed numbers.
  static const List<String> weightOptions = [
    'Under 40 kg',
    '40–49 kg',
    '50–59 kg',
    '60–69 kg',
    '70–79 kg',
    '80–89 kg',
    '90–99 kg',
    '100 kg or more',
  ];
  // Middle value of each weight range, used for an approximate BMI.
  static const List<double> weightMidpoints = [
    37, 45, 55, 65, 75, 85, 95, 105,
  ];

  static const List<String> heightOptions = [
    'Under 150 cm',
    '150–159 cm',
    '160–169 cm',
    '170–179 cm',
    '180–189 cm',
    '190 cm or more',
  ];
  // Middle value of each height range, used for an approximate BMI.
  static const List<double> heightMidpoints = [
    145, 155, 165, 175, 185, 195,
  ];

  static const List<String> periodsOptions = [
    '0',
    '1',
    '2',
    '3 or more',
    'Not applicable',
  ];

  static const List<String> pillOptions = [
    'Yes',
    'No',
    'Not applicable',
  ];

  // 1-10 rating answers, keyed by question id ('q1', 'q19', ...).
  final Map<String, int> scaleAnswers = {};

  // Option answers, keyed by question id ('q13'..'q18', 'weight', ...).
  final Map<String, String> choiceAnswers = {};

  final String surveyName = 'EDE Survey';

  bool isSubmitting = false;

  int get totalScaleQuestions =>
      section1to12.length + 3 + section22to28.length; // 12 + q19/20/21 + 7

  int get totalChoiceQuestions =>
      countQuestions.length + 4; // q13-18 + weight, height, periods, pill

  /// 3-band split over the 1-10 average item score.
  String _severityLevel(double average) {
    if (average <= 4) return 'Low';
    if (average <= 7) return 'Middle';
    return 'High';
  }

  Color _severityColor(String level) {
    switch (level) {
      case 'Low':
        return const Color(0xFF3E8E5A);
      case 'Middle':
        return const Color(0xFFC98A2C);
      default:
        return const Color(0xFFB3402C);
    }
  }

  /// Approximate BMI from the middle of the chosen weight and height
  /// ranges. Returns null if either wasn't answered.
  String? _bmiCategory() {
    final w = choiceAnswers['weight'];
    final h = choiceAnswers['height'];
    if (w == null || h == null) return null;
    final weight = weightMidpoints[weightOptions.indexOf(w)];
    final heightMeters = heightMidpoints[heightOptions.indexOf(h)] / 100;
    final bmi = weight / (heightMeters * heightMeters);
    final String band;
    if (bmi < 18.5) {
      band = 'Low (underweight)';
    } else if (bmi < 25) {
      band = 'Normal';
    } else {
      band = 'High (overweight/obese)';
    }
    return '$band — approx. BMI ${bmi.toStringAsFixed(1)}';
  }

  /// Missed periods → Low/Middle/High, or null if not applicable.
  String? _missedPeriodsCategory() {
    switch (choiceAnswers['periods']) {
      case '0':
        return 'Low (normal)';
      case '1':
      case '2':
        return 'Middle (irregular)';
      case '3 or more':
        return 'High (possible amenorrhea)';
      default:
        return null;
    }
  }

  Future<void> submit() async {
    if (isSubmitting) return;

    if (scaleAnswers.length < totalScaleQuestions ||
        choiceAnswers.length < totalChoiceQuestions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before submitting.'),
        ),
      );
      return;
    }

    final int total = scaleAnswers.values.fold(0, (sum, v) => sum + v);
    final double average = total / scaleAnswers.length;
    final String level = _severityLevel(average);
    final String? bmiCategory = _bmiCategory();
    final String? periodsCategory = _missedPeriodsCategory();

    setState(() {
      isSubmitting = true;
    });

    try {
      await saveSurveyResult(
        collection: 'edeSurveys',
        score: total,
      );
    } catch (error) {
      print(error);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save your result'),
          ),
        );
      }
    }

    if (!mounted) return;

    setState(() {
      isSubmitting = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Assessment Submitted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Level: '),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _severityColor(level),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    level,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Your total score is $total out of ${totalScaleQuestions * 10} '
                '(average ${average.toStringAsFixed(2)} on a 1-10 scale).'),
            if (bmiCategory != null) ...[
              const SizedBox(height: 10),
              Text('Weight/height category: $bmiCategory'),
            ],
            if (periodsCategory != null) ...[
              const SizedBox(height: 6),
              Text('Menstrual pattern: $periodsCategory'),
            ],
            const SizedBox(height: 10),
            const Text(
              'This is raw self-report data, not a diagnosis or a clinically '
              'validated subscale score. Please share these results with a '
              'qualified professional for interpretation.',
            ),
          ],
        ),
        actions: [
          ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  this.context,
                  MaterialPageRoute(
                    builder: (context) => BookAppointmentScreen(
                      surveyName: surveyName,
                      severity: level,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
              ),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget scaleQuestion(int number, String question) {
    final key = 'q$number';
    return ScaleQuestionCard(
      number: number,
      question: question,
      options: scaleOptions,
      selectedValue: scaleAnswers[key],
      onSelected: (value) => setState(() => scaleAnswers[key] = value),
    );
  }

  Widget choiceQuestion(String key, String label, List<String> options,
      {String? caption}) {
    return OptionQuestionCard(
      label: label,
      options: options,
      selected: choiceAnswers[key],
      caption: caption,
      onSelected: (value) => setState(() => choiceAnswers[key] = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                ),
                const Text(
                  'EDE SURVEY',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The following questions concern the past four weeks (28 days) only. '
                  'For rating questions, 1 = "not at all / no days" and 10 = "every day / markedly". '
                  'For the other questions, tap the option that fits best.',
                  style: TextStyle(
                    fontSize: 13,
                    color: navy,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Q1-12
                for (int i = 0; i < section1to12.length; i++)
                  scaleQuestion(i + 1, section1to12[i]),

                // Q13-18 (range options)
                for (int i = 0; i < countQuestions.length; i++)
                  choiceQuestion(
                    'q${13 + i}',
                    '${13 + i}. ${countQuestions[i]}',
                    i == daysQuestionIndex ? daysOptions : timesOptions,
                  ),

                // Q19-21
                scaleQuestion(19, q19),
                scaleQuestion(20, q20),
                scaleQuestion(21, q21),

                // Q22-28
                for (int i = 0; i < section22to28.length; i++)
                  scaleQuestion(22 + i, section22to28[i]),

                // Closing questions (range options)
                choiceQuestion(
                  'weight',
                  'What is your weight at present? (your best estimate)',
                  weightOptions,
                ),
                choiceQuestion(
                  'height',
                  'What is your height? (your best estimate)',
                  heightOptions,
                  caption:
                      'Together with weight, this gives an approximate BMI. '
                      'Low (underweight): below 18.5 · Normal: 18.5–24.9 · '
                      'High (overweight/obese): 25 and above.',
                ),
                choiceQuestion(
                  'periods',
                  'If female: over the past three-to-four months, how many menstrual periods have you missed?',
                  periodsOptions,
                  caption: 'Low (normal): 0 missed · Middle (irregular): '
                      '1–2 missed · High (possible amenorrhea): 3 or more missed.',
                ),
                choiceQuestion(
                  'pill',
                  'Have you been taking the "pill"?',
                  pillOptions,
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Submit Assessment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Daily Athkar
/// Texts from Hisn al-Muslim (Fortress of the Muslim) and the Quran.
/// -----------------------------------------------------------------------
class Dhikr {
  final String text;
  final int count;
  final String translation;
  final String reference;
  final String? note;

  const Dhikr({
    required this.text,
    required this.translation,
    required this.count,
    required this.reference,
    this.note,
  });
}

const String _ayatAlKursi =
    'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ\n'
    'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ '
    'لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ '
    'يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ '
    'وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ';

const String _alIkhlas = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
    'قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾ اللَّهُ الصَّمَدُ ﴿٢﴾ لَمْ يَلِدْ وَلَمْ يُولَدْ ﴿٣﴾ '
    'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ ﴿٤﴾';

const String _alFalaq = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
    'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ﴿١﴾ مِن شَرِّ مَا خَلَقَ ﴿٢﴾ '
    'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ﴿٣﴾ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ﴿٤﴾ '
    'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ ﴿٥﴾';

const String _anNas = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n'
    'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ﴿١﴾ مَلِكِ النَّاسِ ﴿٢﴾ إِلَٰهِ النَّاسِ ﴿٣﴾ '
    'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ﴿٤﴾ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ﴿٥﴾ '
    'مِنَ الْجِنَّةِ وَالنَّاسِ ﴿٦﴾';

const String _sayyidAlIstighfar =
    'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، '
    'وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، '
    'أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، '
    'فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ';

const String _bismillahLaYadurr =
    'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ '
    'وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ';

const String _ayatAlKursiEn =
    'I seek refuge in Allah from Satan, the accursed.\n'
    'Allah — there is no god but Him, the Ever-Living, the Self-Sustaining. '
    'Neither slumber nor sleep seizes Him. To Him belongs whatever is in the '
    'heavens and whatever is on the earth. Who could intercede with Him without '
    'His permission? He knows what lies before them and what lies behind them, '
    'and they grasp nothing of His knowledge except what He wills. His Kursi '
    'encompasses the heavens and the earth, and guarding them does not weary Him. '
    'He is the Most High, the Supreme.';

const String _alIkhlasEn =
    'In the name of Allah, the Most Merciful, the Most Compassionate.\n'
    'Say: He is Allah, the One. Allah, the Self-Sufficient upon whom all depend. '
    'He neither begets nor was He begotten, and there is none comparable to Him.';

const String _alFalaqEn =
    'In the name of Allah, the Most Merciful, the Most Compassionate.\n'
    'Say: I seek refuge in the Lord of the daybreak, from the evil of what He '
    'created, from the evil of the darkness when it settles, from the evil of '
    'those who blow on knots, and from the evil of an envier when he envies.';

const String _anNasEn =
    'In the name of Allah, the Most Merciful, the Most Compassionate.\n'
    'Say: I seek refuge in the Lord of mankind, the King of mankind, the God of '
    'mankind, from the evil of the sneaking whisperer, who whispers into the '
    'hearts of people, from among the jinn and mankind.';

const String _sayyidAlIstighfarEn =
    'O Allah, You are my Lord; there is no god but You. You created me and I am '
    'Your servant, and I keep Your covenant and promise as best I can. I seek '
    'refuge in You from the evil of what I have done. I acknowledge Your favour '
    'upon me, and I acknowledge my sin, so forgive me, for none forgives sins '
    'except You.';

const String _bismillahLaYadurrEn =
    'In the name of Allah, with whose name nothing on earth or in the heavens can '
    'cause harm, and He is the All-Hearing, the All-Knowing.';

const String _subhanAllahWaBihamdihiEn = 'Glory be to Allah and praise be to Him.';

const List<Dhikr> morningAthkar = [
  Dhikr(
    text: _ayatAlKursi,
    count: 1,
    translation: _ayatAlKursiEn,
    reference: 'Ayat al-Kursi — Al-Baqarah 2:255',
  ),
  Dhikr(text: _alIkhlas, count: 3, translation: _alIkhlasEn,
    reference: 'Surat Al-Ikhlas'),
  Dhikr(text: _alFalaq, count: 3, translation: _alFalaqEn,
    reference: 'Surat Al-Falaq'),
  Dhikr(text: _anNas, count: 3, translation: _anNasEn,
    reference: 'Surat An-Nas'),
  Dhikr(
    text: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، '
        'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ '
        'وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا الْيَوْمِ '
        'وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا الْيَوْمِ وَشَرِّ مَا بَعْدَهُ، '
        'رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ '
        'فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ',
    count: 1,
    translation: 'We have entered the morning, and all dominion has entered the morning belonging to Allah. All praise is for Allah. There is no god but Allah, alone, without partner. To Him belongs the dominion and to Him belongs all praise, and He has power over all things. My Lord, I ask You for the good of this day and the good of what comes after it, and I seek refuge in You from the evil of this day and the evil of what comes after it. My Lord, I seek refuge in You from laziness and the hardships of old age. My Lord, I seek refuge in You from punishment in the Fire and punishment in the grave.',
    reference: 'Muslim',
  ),
  Dhikr(
    text: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، '
        'وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
    count: 1,
    translation: 'O Allah, by You we enter the morning and by You we enter the evening; by You we live and by You we die, and to You is the resurrection.',
    reference: 'At-Tirmidhi',
  ),
  Dhikr(
    text: _sayyidAlIstighfar,
    count: 1,
    translation: _sayyidAlIstighfarEn,
    reference: 'Sayyid al-Istighfar — Al-Bukhari',
  ),
  Dhikr(
    text: _bismillahLaYadurr,
    count: 3,
    translation: _bismillahLaYadurrEn,
    reference: 'Abu Dawud, At-Tirmidhi',
  ),
  Dhikr(
    text: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، '
        'وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',
    count: 3,
    translation: 'I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad ﷺ as my Prophet.',
    reference: 'Abu Dawud, At-Tirmidhi',
  ),
  Dhikr(
    text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    count: 100,
    translation: _subhanAllahWaBihamdihiEn,
    reference: 'Muslim',
  ),
];

const List<Dhikr> eveningAthkar = [
  Dhikr(
    text: _ayatAlKursi,
    count: 1,
    translation: _ayatAlKursiEn,
    reference: 'Ayat al-Kursi — Al-Baqarah 2:255',
  ),
  Dhikr(text: _alIkhlas, count: 3, translation: _alIkhlasEn,
    reference: 'Surat Al-Ikhlas'),
  Dhikr(text: _alFalaq, count: 3, translation: _alFalaqEn,
    reference: 'Surat Al-Falaq'),
  Dhikr(text: _anNas, count: 3, translation: _anNasEn,
    reference: 'Surat An-Nas'),
  Dhikr(
    text: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، '
        'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ '
        'وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ '
        'وَخَيْرَ مَا بَعْدَهَا، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ وَشَرِّ مَا بَعْدَهَا، '
        'رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ '
        'فِي النَّارِ وَعَذَابٍ فِي الْقَبْرِ',
    count: 1,
    translation: 'We have entered the evening, and all dominion has entered the evening belonging to Allah. All praise is for Allah. There is no god but Allah, alone, without partner. To Him belongs the dominion and to Him belongs all praise, and He has power over all things. My Lord, I ask You for the good of this night and the good of what comes after it, and I seek refuge in You from the evil of this night and the evil of what comes after it. My Lord, I seek refuge in You from laziness and the hardships of old age. My Lord, I seek refuge in You from punishment in the Fire and punishment in the grave.',
    reference: 'Muslim',
  ),
  Dhikr(
    text: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، '
        'وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ',
    count: 1,
    translation: 'O Allah, by You we enter the evening and by You we enter the morning; by You we live and by You we die, and to You is the final return.',
    reference: 'At-Tirmidhi',
  ),
  Dhikr(
    text: _sayyidAlIstighfar,
    count: 1,
    translation: _sayyidAlIstighfarEn,
    reference: 'Sayyid al-Istighfar — Al-Bukhari',
  ),
  Dhikr(
    text: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
    count: 3,
    translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
    reference: 'Muslim',
  ),
  Dhikr(
    text: _bismillahLaYadurr,
    count: 3,
    translation: _bismillahLaYadurrEn,
    reference: 'Abu Dawud, At-Tirmidhi',
  ),
  Dhikr(
    text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    count: 100,
    translation: _subhanAllahWaBihamdihiEn,
    reference: 'Muslim',
  ),
];

const List<Dhikr> sleepAthkar = [
  Dhikr(
    text: _ayatAlKursi,
    count: 1,
    translation: _ayatAlKursiEn,
    reference: 'Ayat al-Kursi — Al-Baqarah 2:255',
  ),
  Dhikr(
    text: 'آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ ۚ '
        'كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ '
        'مِّن رُّسُلِهِ ۚ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ ﴿٢٨٥﴾ '
        'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ '
        'رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا '
        'كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ '
        'وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ ﴿٢٨٦﴾',
    count: 1,
    translation: 'The Messenger has believed in what was sent down to him from his Lord, and so have the believers. Each of them believes in Allah, His angels, His books and His messengers: “We make no distinction between any of His messengers.” And they say, “We hear and we obey. Grant us Your forgiveness, our Lord, and to You is the final return.” (285)\n'
        'Allah does not burden any soul beyond what it can bear. It gains whatever good it has earned and bears whatever evil it has committed. “Our Lord, do not hold us accountable if we forget or make a mistake. Our Lord, do not place on us a burden like the one You placed on those before us. Our Lord, do not burden us with what we have no strength to bear. Pardon us, forgive us, and have mercy on us. You are our Protector, so grant us victory over the disbelieving people.” (286)',
    reference: 'Last two verses of Al-Baqarah 2:285–286',
  ),
  Dhikr(
    text: _alIkhlas,
    count: 3,
    translation: _alIkhlasEn,
    reference: 'Surat Al-Ikhlas',
    note: 'Cup your hands, recite, blow into them, and wipe over your body.',
  ),
  Dhikr(
    text: _alFalaq,
    count: 3,
    translation: _alFalaqEn,
    reference: 'Surat Al-Falaq',
    note: 'Cup your hands, recite, blow into them, and wipe over your body.',
  ),
  Dhikr(
    text: _anNas,
    count: 3,
    translation: _anNasEn,
    reference: 'Surat An-Nas',
    note: 'Cup your hands, recite, blow into them, and wipe over your body.',
  ),
  Dhikr(
    text: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    count: 1,
    translation: 'In Your name, O Allah, I die and I live.',
    reference: 'Al-Bukhari',
  ),
  Dhikr(
    text: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
    count: 3,
    translation: 'O Allah, protect me from Your punishment on the Day You resurrect Your servants.',
    reference: 'Abu Dawud, At-Tirmidhi',
  ),
  Dhikr(text: 'سُبْحَانَ اللَّهِ', count: 33, translation: 'Glory be to Allah.',
    reference: 'Al-Bukhari, Muslim'),
  Dhikr(text: 'الْحَمْدُ لِلَّهِ', count: 33, translation: 'All praise is for Allah.',
    reference: 'Al-Bukhari, Muslim'),
  Dhikr(text: 'اللَّهُ أَكْبَرُ', count: 34, translation: 'Allah is the Greatest.',
    reference: 'Al-Bukhari, Muslim'),
];

const List<Dhikr> examDuas = [
  Dhikr(
    text: 'رَبِّ اشْرَحْ لِي صَدْرِي ﴿٢٥﴾ وَيَسِّرْ لِي أَمْرِي ﴿٢٦﴾ '
        'وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي ﴿٢٧﴾ يَفْقَهُوا قَوْلِي ﴿٢٨﴾',
    count: 1,
    translation: 'My Lord, expand my chest for me, make my task easy for me, and untie the knot from my tongue, so that they may understand my speech.',
    reference: 'Taha 20:25–28',
  ),
  Dhikr(
    text: 'رَّبِّ زِدْنِي عِلْمًا',
    count: 1,
    translation: 'My Lord, increase me in knowledge.',
    reference: 'Taha 20:114',
  ),
  Dhikr(
    text: 'رَّبِّ أَدْخِلْنِي مُدْخَلَ صِدْقٍ وَأَخْرِجْنِي مُخْرَجَ صِدْقٍ '
        'وَاجْعَل لِّي مِن لَّدُنكَ سُلْطَانًا نَّصِيرًا',
    translation: 'My Lord, let me enter in truth and let me leave in truth, '
        'and grant me from Yourself a supporting authority.',
    count: 1,
    reference: 'Al-Isra 17:80',
  ),
  Dhikr(
    text: 'اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا، '
        'وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا',
    count: 1,
    translation: 'O Allah, nothing is easy except what You make easy, and You make the difficult easy whenever You will.',
    reference: 'Ibn Hibban',
  ),
  Dhikr(
    text: 'اللَّهُمَّ انْفَعْنِي بِمَا عَلَّمْتَنِي، وَعَلِّمْنِي مَا يَنْفَعُنِي، '
        'وَزِدْنِي عِلْمًا',
    count: 1,
    translation: 'O Allah, benefit me with what You have taught me, teach me what will benefit me, and increase me in knowledge.',
    reference: 'At-Tirmidhi, Ibn Majah',
  ),
  Dhikr(
    text: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ وَالْكَسَلِ، '
        'وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ، وَغَلَبَةِ الرِّجَالِ',
    count: 1,
    translation: 'O Allah, I seek refuge in You from worry and grief, from helplessness and laziness, from miserliness and cowardice, and from the burden of debt and being overpowered by others.',
    reference: 'Al-Bukhari',
  ),
  Dhikr(
    text: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
    count: 1,
    translation: 'There is no god but You; glory be to You. Indeed, I have been among the wrongdoers.',
    reference: 'Al-Anbiya 21:87',
  ),
  Dhikr(
    text: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
    count: 1,
    translation: 'Allah is sufficient for us, and He is the best Disposer of affairs.',
    reference: 'Al Imran 3:173',
  ),
];

/// Menu with the 4 athkar categories.
class AthkarMenuScreen extends StatelessWidget {
  const AthkarMenuScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  Widget _categoryButton(
    BuildContext context, {
    required String title,
    required String arabicTitle,
    required IconData icon,
    required List<Dhikr> items,
    required Color background,
    required Color foreground,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AthkarReaderScreen(
                  title: title,
                  arabicTitle: arabicTitle,
                  items: items,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: pinkAccent, width: 1.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                arabicTitle,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: navy, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.menu_book_outlined,
                    color: navy,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Daily Athkar',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Choose your athkar',
                  style: TextStyle(fontSize: 15, color: navy),
                ),
                const SizedBox(height: 40),
                _categoryButton(
                  context,
                  title: 'Morning Athkar',
                  arabicTitle: 'أذكار الصباح',
                  icon: Icons.wb_sunny_outlined,
                  items: morningAthkar,
                  background: pinkAccent,
                  foreground: Colors.white,
                ),
                _categoryButton(
                  context,
                  title: 'Evening Athkar',
                  arabicTitle: 'أذكار المساء',
                  icon: Icons.wb_twilight_outlined,
                  items: eveningAthkar,
                  background: navy,
                  foreground: Colors.white,
                ),
                _categoryButton(
                  context,
                  title: 'Sleep Athkar',
                  arabicTitle: 'أذكار النوم',
                  icon: Icons.bedtime_outlined,
                  items: sleepAthkar,
                  background: Colors.white,
                  foreground: navy,
                ),
                _categoryButton(
                  context,
                  title: 'Exam Duas',
                  arabicTitle: 'أدعية الامتحان',
                  icon: Icons.school_outlined,
                  items: examDuas,
                  background: Colors.white,
                  foreground: navy,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Step-through reader: one dhikr per page, tap the counter to count,
/// Next / Previous buttons to move (like the Azkar app).
class AthkarReaderScreen extends StatefulWidget {
  final String title;
  final String arabicTitle;
  final List<Dhikr> items;

  const AthkarReaderScreen({
    super.key,
    required this.title,
    required this.arabicTitle,
    required this.items,
  });

  @override
  State<AthkarReaderScreen> createState() => AthkarReaderScreenState();
}

class AthkarReaderScreenState extends State<AthkarReaderScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  final PageController pageController = PageController();
  int currentIndex = 0;

  // Remaining repetitions for each dhikr.
  late final List<int> remaining =
      widget.items.map((dhikr) => dhikr.count).toList();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool get isLast => currentIndex == widget.items.length - 1;

  void goTo(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void next() {
    if (isLast) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('تقبل الله منك'),
          content: Text('You have completed ${widget.title}.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } else {
      goTo(currentIndex + 1);
    }
  }

  void count() {
    if (remaining[currentIndex] == 0) return;
    setState(() => remaining[currentIndex]--);
    // Once this dhikr is finished, move on automatically. On the last one
    // this shows the completion message, same as pressing Finish.
    if (remaining[currentIndex] == 0) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) next();
      });
    }
  }

  Widget dhikrPage(int index) {
    final dhikr = widget.items[index];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              dhikr.text,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 22,
                color: navy,
                height: 2.0,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFFEBE1D2), thickness: 1),
            const SizedBox(height: 10),
            Text(
              dhikr.translation,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF3D4F63),
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            if (dhikr.note != null) ...[
              Text(
                dhikr.note!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B6255),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              'Source: ${dhikr.reference}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'English: translation of meaning, not a word-for-word rendering',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF8A7F70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int total = widget.items.length;
    final dhikr = widget.items[currentIndex];
    final int left = remaining[currentIndex];
    final bool done = left == 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.arrow_back_ios_new, color: navy),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                    ),
                    Text(
                      widget.arabicTitle,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (currentIndex + 1) / total,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFE0D5C3),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(navy),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${currentIndex + 1} / $total',
                      style: const TextStyle(
                        color: navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Dhikr pages
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: total,
                  onPageChanged: (index) =>
                      setState(() => currentIndex = index),
                  itemBuilder: (context, index) => dhikrPage(index),
                ),
              ),

              // Counter (tap to count)
              GestureDetector(
                onTap: count,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? const Color(0xFF3E8E5A) : navy,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: done
                      ? const Icon(Icons.check, color: Colors.white, size: 40)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$left',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'of ${dhikr.count}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tap to count',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B6255)),
              ),

              // Previous / Next buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: currentIndex == 0
                              ? null
                              : () => goTo(currentIndex - 1),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: navy,
                            side: const BorderSide(
                                color: pinkAccent, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: next,
                          icon: Icon(isLast ? Icons.check : Icons.arrow_forward),
                          label: Text(isLast ? 'Finish' : 'Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pinkAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Book Appointment — shown when a survey result is High.
/// -----------------------------------------------------------------------
/// -----------------------------------------------------------------------
/// Booking: sample doctors, dates color-coded by severity, location.
/// All doctors and clinics below are made up for this university project.
/// -----------------------------------------------------------------------
class Doctor {
  final String name;
  final String title;
  final String focus;
  final List<String> specialties;
  final String clinic;
  final String address;
  final double lat; // clinic location (0 = online only)
  final double lng;
  final List<String> sessionTypes; // 'In person' and/or 'Online'
  final List<int> days;
  final List<String> times;

  const Doctor({
    required this.name,
    required this.title,
    required this.focus,
    required this.specialties,
    required this.clinic,
    required this.address,
    this.lat = 0,
    this.lng = 0,
    required this.sessionTypes,
    required this.days,
    required this.times,
  });
}

const List<String> specialtyNames = [
  'All',
  'Anxiety',
  'Eating Disorders',
  'Psychologist',
  'Psychiatrist',
  'Dietitian',
];

const List<IconData> specialtyIcons = [
  Icons.apps_rounded,
  Icons.self_improvement,
  Icons.restaurant_outlined,
  Icons.psychology_outlined,
  Icons.medical_services_outlined,
  Icons.monitor_weight_outlined,
];

const List<Doctor> doctors = [
  Doctor(
    name: 'Dr. Hessa Al Mansoori',
    title: 'Clinical Psychologist',
    focus: 'Anxiety, stress and panic (CBT)',
    specialties: ['Anxiety', 'Psychologist'],
    clinic: 'Sakina Wellbeing Clinic',
    address: 'Al Majaz 2, Sharjah',
    lat: 25.3245, lng: 55.3890,
    sessionTypes: ['In person', 'Online'],
    days: [DateTime.sunday, DateTime.tuesday, DateTime.thursday],
    times: ['9:00 AM', '10:30 AM', '12:00 PM', '4:00 PM'],
  ),
  Doctor(
    name: 'Dr. Faisal Qureshi',
    title: 'Counselling Psychologist',
    focus: 'Exam stress, sleep and worry in students',
    specialties: ['Anxiety', 'Psychologist'],
    clinic: 'Campus Mind Care Centre',
    address: 'University City, Sharjah',
    lat: 25.2880, lng: 55.4840,
    sessionTypes: ['In person', 'Online'],
    days: [DateTime.monday, DateTime.tuesday, DateTime.wednesday],
    times: ['10:00 AM', '11:30 AM', '1:00 PM', '2:30 PM'],
  ),
  Doctor(
    name: 'Dr. Omar Haddad',
    title: 'Psychiatrist',
    focus: 'Anxiety and mood disorders',
    specialties: ['Anxiety', 'Psychiatrist'],
    clinic: 'Rawda Mental Health Clinic',
    address: 'Al Nahda, Sharjah',
    lat: 25.3020, lng: 55.3720,
    sessionTypes: ['In person', 'Online'],
    days: [DateTime.monday, DateTime.wednesday, DateTime.saturday],
    times: ['9:30 AM', '11:00 AM', '3:30 PM', '5:00 PM'],
  ),
  Doctor(
    name: 'Dr. Reem Al Suwaidi',
    title: 'Eating Disorder Specialist',
    focus: 'Anorexia, bulimia and binge eating',
    specialties: ['Eating Disorders', 'Psychologist'],
    clinic: 'Nourish Mind Centre',
    address: 'Al Qusais 1, Dubai',
    lat: 25.2780, lng: 55.3800,
    sessionTypes: ['In person', 'Online'],
    days: [DateTime.sunday, DateTime.wednesday, DateTime.thursday],
    times: ['9:00 AM', '11:00 AM', '1:30 PM', '4:30 PM'],
  ),
  Doctor(
    name: 'Dr. Aisha Rahimi',
    title: 'Psychiatrist',
    focus: 'Eating disorders with anxiety',
    specialties: ['Eating Disorders', 'Psychiatrist', 'Anxiety'],
    clinic: 'Online sessions only',
    address: 'Video call',
    sessionTypes: ['Online'],
    days: [DateTime.monday, DateTime.wednesday, DateTime.friday],
    times: ['6:00 PM', '7:00 PM', '8:00 PM'],
  ),
  Doctor(
    name: 'Dr. Sara Fernandes',
    title: 'Clinical Dietitian',
    focus: 'Nutrition support in eating disorder recovery',
    specialties: ['Dietitian', 'Eating Disorders'],
    clinic: 'Balance Nutrition Clinic',
    address: 'Muwaileh Commercial, Sharjah',
    lat: 25.3060, lng: 55.4560,
    sessionTypes: ['In person', 'Online'],
    days: [DateTime.monday, DateTime.tuesday, DateTime.saturday],
    times: ['10:00 AM', '12:00 PM', '2:00 PM'],
  ),
  Doctor(
    name: 'Dr. Khalid Al Nuaimi',
    title: 'CBT Therapist',
    focus: 'Social anxiety and panic attacks',
    specialties: ['Anxiety', 'Psychologist'],
    clinic: 'Hudoo Therapy Rooms',
    address: 'Al Jurf, Ajman',
    lat: 25.4110, lng: 55.5060,
    sessionTypes: ['In person', 'Online'],
    days: [DateTime.tuesday, DateTime.thursday, DateTime.saturday],
    times: ['1:00 PM', '3:00 PM', '5:00 PM', '7:00 PM'],
  ),
  Doctor(
    name: 'Dr. Lina Saba',
    title: 'Dietitian',
    focus: 'Healthy eating habits under stress',
    specialties: ['Dietitian'],
    clinic: 'Green Plate Nutrition',
    address: 'Al Nuaimiya, Ajman',
    lat: 25.3880, lng: 55.4500,
    sessionTypes: ['In person'],
    days: [DateTime.wednesday, DateTime.thursday, DateTime.saturday],
    times: ['9:00 AM', '11:00 AM', '1:00 PM'],
  ),
  Doctor(
    name: 'Dr. Yousef Kareem',
    title: 'Child & Adolescent Psychiatrist',
    focus: 'Teens with anxiety or eating problems',
    specialties: ['Psychiatrist', 'Anxiety', 'Eating Disorders'],
    clinic: 'Bayt Al Amal Family Clinic',
    address: 'Al Khan, Sharjah',
    lat: 25.3270, lng: 55.3600,
    sessionTypes: ['In person'],
    days: [DateTime.sunday, DateTime.tuesday],
    times: ['10:00 AM', '12:30 PM', '3:00 PM'],
  ),
];

/// Priority of a date: closest dates are kept for the most severe cases.
/// Red = next 4 days (High only), Orange = days 5-10 (High and Middle),
/// Green = after 10 days (everyone).
int priorityOfDate(DateTime date) {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final int daysAway = DateTime(date.year, date.month, date.day)
      .difference(today)
      .inDays;
  if (daysAway <= 4) return 3; // red
  if (daysAway <= 10) return 2; // orange
  return 1; // green
}

int severityRank(String severity) {
  switch (severity) {
    case 'High':
      return 3;
    case 'Middle':
      return 2;
    default:
      return 1;
  }
}

/// Remembers the location answer while the app is open.
/// 'once', 'while', 'deny' or null (not asked yet).
String? locationChoice;

class BookAppointmentScreen extends StatefulWidget {
  final String surveyName;
  final String severity; // 'High', 'Middle' or 'Low'

  const BookAppointmentScreen({
    super.key,
    required this.surveyName,
    this.severity = 'High',
  });

  @override
  State<BookAppointmentScreen> createState() => BookAppointmentScreenState();
}

class BookAppointmentScreenState extends State<BookAppointmentScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);
  static const Color red = Color(0xFFB3402C);
  static const Color orange = Color(0xFFC98A2C);
  static const Color green = Color(0xFF3E8E5A);
  static const Color grey = Color(0xFF6B6255);

  static const List<String> weekdayNames = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  static const List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String specialty = 'All';
  Doctor? selectedDoctor;
  bool shareLocation = false;
  DateTime lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Start on the specialty that fits the survey.
    if (widget.surveyName.contains('EDE')) {
      specialty = 'Eating Disorders';
    } else {
      specialty = 'Anxiety';
    }
    shareLocation = locationChoice == 'while';
    if (locationChoice == null || locationChoice == 'once') {
      WidgetsBinding.instance.addPostFrameCallback((_) => askLocation());
    } else if (shareLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) => findLocation());
    }
  }

  // ---------- Location permission ----------
  Future<void> askLocation() async {
    final String? answer = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF7F2EA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        titlePadding: const EdgeInsets.fromLTRB(20, 22, 20, 6),
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        actionsPadding: EdgeInsets.zero,
        title: const Column(
          children: [
            Icon(Icons.location_on_outlined, color: navy, size: 34),
            SizedBox(height: 8),
            Text(
              'Allow "nafsi" to use your location?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
          ],
        ),
        content: const Text(
          'Your location is used to show the doctors and clinics closest to you.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: navy, height: 1.4),
        ),
        actions: [
          for (final option in const [
            ['once', 'Allow Once'],
            ['while', 'Allow While Using App'],
            ['deny', 'Don\'t Allow'],
          ])
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, option[0]),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      option[1],
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF2B6CB0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
    if (!mounted || answer == null) return;
    locationChoice = answer;
    setState(() {
      shareLocation = answer != 'deny';
    });
    if (answer != 'deny') {
      await findLocation();
    } else if (lastUserLocation == null) {
      await showChooseLocationNotice();
    }
  }

  /// Gets the real location. Outside the UAE, the user is told we
  /// can't help there yet.
  Future<void> findLocation() async {
    final UserLocation? me = await getUserLocation();
    if (!mounted) return;
    if (me == null) {
      await showChooseLocationNotice();
      return;
    }
    if (!isInsideUae(me)) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.public_off, color: Color(0xFFB3402C)),
              SizedBox(width: 8),
              Text('Outside the UAE'),
            ],
          ),
          content: const Text(
            'We\'re sorry, we don\'t offer our services outside the UAE yet. '
            'Thank you for understanding.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context);
      return;
    }
    setState(() {
      lastUserLocation = me;
      userPlaceLabel = 'Your current location';
    });
  }

  /// Shown when location is not shared: a small box with OK.
  Future<void> showChooseLocationNotice() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF7F2EA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.location_off_outlined, color: navy),
            SizedBox(width: 8),
            Text('Location not shared'),
          ],
        ),
        content: const Text(
          'If you don\'t want to share your location, please choose your '
          'location from the "Choose location" box on this page.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Pick an emirate, then an area in it.
  Future<void> chooseLocation() async {
    final String? emirate = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFFF7F2EA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                'Choose your emirate',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: navy),
              ),
            ),
            for (final e in uaePlaces.keys)
              ListTile(
                leading: const Icon(Icons.location_city, color: navy),
                title: Text(e),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pop(sheet, e),
              ),
          ],
        ),
      ),
    );
    if (emirate == null || !mounted) return;
    final Map<String, List<double>> areas = uaePlaces[emirate]!;
    final String? area = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFFF7F2EA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                'Choose your area in $emirate',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: navy),
              ),
            ),
            for (final a in areas.keys)
              ListTile(
                leading: const Icon(Icons.place_outlined, color: navy),
                title: Text(a),
                onTap: () => Navigator.pop(sheet, a),
              ),
          ],
        ),
      ),
    );
    if (area == null || !mounted) return;
    final List<double> point = areas[area]!;
    setState(() {
      lastUserLocation = UserLocation(point[0], point[1]);
      userPlaceLabel = '$area, $emirate';
    });
  }

  /// The "Your location" box at the top of the booking page.
  Widget locationBox() {
    final bool known = lastUserLocation != null;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(known ? Icons.my_location : Icons.location_searching,
              color: navy),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your location',
                    style: TextStyle(fontSize: 12, color: grey)),
                Text(
                  known ? (userPlaceLabel ?? 'Location set') : 'Not chosen yet',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: navy),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: chooseLocation,
            child: Text(
              known ? 'Change' : 'Choose location',
              style: const TextStyle(color: navy, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Pull to refresh ----------
  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      lastUpdated = DateTime.now();
    });
  }

  // ---------- Data helpers ----------
  List<Doctor> get shownDoctors {
    final List<Doctor> list = doctors
        .where((d) => specialty == 'All' || d.specialties.contains(specialty))
        .toList();
    if (lastUserLocation != null) {
      list.sort((a, b) =>
          (doctorDistance(a) ?? 9999).compareTo(doctorDistance(b) ?? 9999));
    }
    return list;
  }

  // ---------- UI pieces ----------
  Widget stepTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: navy,
        ),
      ),
    );
  }

  Widget whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget severityBanner() {
    final Color color = widget.severity == 'High'
        ? red
        : widget.severity == 'Middle'
            ? orange
            : green;
    Widget legend(Color c, String text) => Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 12, color: navy),
                ),
              ),
            ],
          ),
        );
    return whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your ${widget.surveyName} result: ',
                style: const TextStyle(fontSize: 14, color: navy),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.severity,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          legend(red, 'Red: closest dates, for high severity'),
          legend(orange, 'Orange: for middle and high severity'),
          legend(green, 'Green: open to everyone'),
        ],
      ),
    );
  }

  Widget specialtyTile(int index) {
    final String name = specialtyNames[index];
    final bool isSelected = specialty == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          specialty = name;
        });
      },
      child: Container(
        width: 82,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? navy : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? navy : gold, width: 1.2),
        ),
        child: Column(
          children: [
            Icon(
              specialtyIcons[index],
              color: isSelected ? Colors.white : navy,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : navy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doctorCard(Doctor doctor) {
    final bool isSelected = selectedDoctor == doctor;
    final String initials = profileInitials(doctor.name.replaceFirst('Dr. ', ''));

    return GestureDetector(
      onTap: () {
        setState(() => selectedDoctor = doctor);
        // Opens the full booking screen for this doctor.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorBookingScreen(
              doctor: doctor,
              surveyName: widget.surveyName,
              severity: widget.severity,
              shareLocation: shareLocation,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? navy : gold.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFEBE1D2),
              child: Text(
                initials,
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  Text(
                    doctor.title,
                    style: const TextStyle(fontSize: 13, color: navy),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.focus,
                    style: const TextStyle(fontSize: 12, color: grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: gold),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          doctorPlaceText(doctor),
                          style: const TextStyle(fontSize: 12, color: navy),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      for (final type in doctor.sessionTypes) ...[
                        Icon(
                          type == 'Online'
                              ? Icons.videocam_outlined
                              : Icons.person_pin_circle_outlined,
                          size: 14,
                          color: navy,
                        ),
                        const SizedBox(width: 3),
                        Text(type,
                            style: const TextStyle(fontSize: 11, color: navy)),
                        const SizedBox(width: 10),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: navy,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Doctor> list = shownDoctors;

    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(selectedIndex: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5EFE6), Color(0xFFEBE1D2)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: navy,
            onRefresh: refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                  ),
                  const Center(
                    child: Text(
                      'nafsi',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: navy,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'BOOK AN APPOINTMENT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: navy,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'Updated ${formatTime(lastUpdated)} · pull down to refresh',
                      style: const TextStyle(fontSize: 11, color: grey),
                    ),
                  ),
                  const SizedBox(height: 18),

                  severityBanner(),
                  locationBox(),

                  // 1. Specialty
                  stepTitle('1. Select Specialty'),
                  SizedBox(
                    height: 96,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (int i = 0; i < specialtyNames.length; i++)
                          specialtyTile(i),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 2. Doctors
                  Row(
                    children: [
                      Expanded(
                        child: stepTitle(lastUserLocation != null
                            ? '2. Doctors Near You'
                            : '2. Available Doctors'),
                      ),
                    ],
                  ),
                  if (list.isEmpty)
                    whiteCard(
                      child: const Text(
                        'No doctors for this specialty right now.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: grey),
                      ),
                    )
                  else
                    for (final d in list) doctorCard(d),
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 14),
                    child: Text(
                      'Tap a doctor to choose a date and time. Doctors and '
                      'clinics shown are sample data for this project.',
                      style: TextStyle(fontSize: 11, color: grey),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Location: the user's real position, distance to clinics, UAE check.
/// -----------------------------------------------------------------------
class UserLocation {
  final double lat;
  final double lng;
  const UserLocation(this.lat, this.lng);
}

/// The last location we got (kept while the app is open).
UserLocation? lastUserLocation;

/// Areas users can pick when they don't share their location.
const Map<String, Map<String, List<double>>> uaePlaces = {
  'Abu Dhabi': {
    'Al Reem Island': [24.4990, 54.4040],
    'Khalifa City': [24.4190, 54.5780],
    'Mussafah': [24.3480, 54.5030],
    'Al Ain': [24.2075, 55.7447],
  },
  'Dubai': {
    'Deira': [25.2710, 55.3075],
    'Al Qusais': [25.2780, 55.3800],
    'Mirdif': [25.2180, 55.4200],
    'Jumeirah': [25.2050, 55.2400],
    'Al Barsha': [25.1130, 55.1960],
  },
  'Sharjah': {
    'Al Majaz': [25.3245, 55.3890],
    'Al Nahda': [25.3020, 55.3720],
    'Al Khan': [25.3270, 55.3600],
    'Muwaileh': [25.3060, 55.4560],
    'University City': [25.2880, 55.4840],
  },
  'Ajman': {
    'Al Jurf': [25.4110, 55.5060],
    'Al Nuaimiya': [25.3880, 55.4500],
    'Al Rashidiya': [25.4000, 55.4400],
  },
  'Umm Al Quwain': {
    'Umm Al Quwain City': [25.5650, 55.5530],
  },
  'Ras Al Khaimah': {
    'Al Nakheel': [25.7900, 55.9500],
    'Al Hamra': [25.6900, 55.7800],
  },
  'Fujairah': {
    'Fujairah City': [25.1288, 56.3265],
    'Dibba': [25.6200, 56.2700],
  },
};

/// What the location box shows: "Your current location" or "Al Nahda, Sharjah".
String? userPlaceLabel;

/// Simple location card used where a map can't be shown.
Widget mapPreviewCard(String label) {
  return Container(
    color: const Color(0xFFEBE1D2),
    alignment: Alignment.center,
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.map_outlined, size: 40, color: Color(0xFF0F2A44)),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F2A44),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap "Open in Google Maps" for directions.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Color(0xFF6B6255)),
        ),
      ],
    ),
  );
}

/// Rough box around the UAE.
bool isInsideUae(UserLocation l) =>
    l.lat >= 22.4 && l.lat <= 26.5 && l.lng >= 51.0 && l.lng <= 56.6;

/// Distance in km between two points (haversine formula).
double kmBetween(double lat1, double lng1, double lat2, double lng2) {
  const double r = 6371;
  double rad(double d) => d * math.pi / 180;
  final double dLat = rad(lat2 - lat1);
  final double dLng = rad(lng2 - lng1);
  final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

/// Distance from the user to a doctor's clinic, or null if unknown.
double? doctorDistance(Doctor d) {
  final UserLocation? me = lastUserLocation;
  if (me == null || d.lat == 0) return null;
  return kmBetween(me.lat, me.lng, d.lat, d.lng);
}

String doctorPlaceText(Doctor d, {bool clinicName = false}) {
  if (d.lat == 0) return 'Online only';
  final String place = clinicName ? d.clinic : d.address;
  final double? km = doctorDistance(d);
  return km == null ? place : '${km.toStringAsFixed(1)} km · $place';
}

/// A Google Map with a pin on the clinic, plus a button to open Google Maps.
Widget clinicMapCard(double lat, double lng, String label) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(height: 180, child: clinicMap(lat, lng, label)),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () => openInGoogleMaps(lat, lng, label),
        icon: const Icon(Icons.directions, color: Color(0xFF0F2A44)),
        label: const Text(
          'Open in Google Maps',
          style: TextStyle(
            color: Color(0xFF0F2A44),
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFC9A882)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ],
  );
}

/// DartPad version: browser location and an embedded Google Map.
Future<UserLocation?> getUserLocation() async {
  final Completer<UserLocation?> done = Completer<UserLocation?>();
  try {
    final JSObject? nav = globalContext['navigator'] as JSObject?;
    final JSObject? geo = nav?['geolocation'] as JSObject?;
    if (geo == null) return null;
    geo.callMethod(
      'getCurrentPosition'.toJS,
      ((JSObject position) {
        final JSObject coords = position['coords'] as JSObject;
        if (!done.isCompleted) {
          done.complete(UserLocation(
            (coords['latitude'] as JSNumber).toDartDouble,
            (coords['longitude'] as JSNumber).toDartDouble,
          ));
        }
      }).toJS,
      ((JSAny? error) {
        if (!done.isCompleted) done.complete(null);
      }).toJS,
    );
  } catch (e) {
    return null;
  }
  return done.future
      .timeout(const Duration(seconds: 10), onTimeout: () => null);
}

final Set<String> _mapViews = {};

Widget clinicMap(double lat, double lng, String label) {
  final String viewType = 'nafsi-map-$lat-$lng';
  if (!_mapViews.contains(viewType)) {
    _mapViews.add(viewType);
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final JSObject document = globalContext['document'] as JSObject;
      final JSObject frame =
          document.callMethod('createElement'.toJS, 'iframe'.toJS) as JSObject;
      frame['src'] =
          'https://maps.google.com/maps?q=$lat,$lng&z=15&output=embed'.toJS;
      final JSObject style = frame['style'] as JSObject;
      style['border'] = '0'.toJS;
      style['width'] = '100%'.toJS;
      style['height'] = '100%'.toJS;
      return frame;
    });
  }
  return HtmlElementView(viewType: viewType);
}

Future<void> openInGoogleMaps(double lat, double lng, String label) async {
  globalContext.callMethod(
    'open'.toJS,
    'https://www.google.com/maps/search/?api=1&query=$lat,$lng'.toJS,
    '_blank'.toJS,
  );
}

/// -----------------------------------------------------------------------
/// Full-screen booking for one doctor: calendar pop-up (color-coded by
/// severity), time pop-up (booked times in grey), then online / in person.
/// -----------------------------------------------------------------------
const List<String> shortWeekdays = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];
const List<String> shortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const List<String> longMonths = [
  'January', 'February', 'March', 'April', 'May', 'June', 'July',
  'August', 'September', 'October', 'November', 'December',
];

const Color priorityRed = Color(0xFFB3402C);
const Color priorityOrange = Color(0xFFC98A2C);
const Color priorityGreen = Color(0xFF3E8E5A);

Color priorityColor(int priority) {
  if (priority == 3) return priorityRed;
  if (priority == 2) return priorityOrange;
  return priorityGreen;
}

String longDateText(DateTime date) =>
    '${shortWeekdays[date.weekday - 1]}, ${shortMonths[date.month - 1]} '
    '${date.day}, ${date.year}';

/// The doctor's working days in the next 3 weeks.
List<DateTime> doctorDates(Doctor doctor) {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final List<DateTime> dates = [];
  for (int i = 1; i <= 21; i++) {
    final DateTime day = today.add(Duration(days: i));
    if (doctor.days.contains(day.weekday)) dates.add(day);
  }
  return dates;
}

/// Some slots are already taken by other patients (sample data).
bool isSlotTaken(Doctor doctor, DateTime date, String time) {
  final int seed = doctor.name.length * 31 +
      date.day * 7 +
      time.length * 3 +
      date.month +
      time.codeUnitAt(0);
  return seed % 4 == 0;
}

void showPriorityMessage(BuildContext context, DateTime date) {
  final int priority = priorityOfDate(date);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          Icon(Icons.lock_outline, color: priorityColor(priority)),
          const SizedBox(width: 8),
          const Text('Priority date'),
        ],
      ),
      content: Text(
        priority == 3
            ? 'We\'re sorry, but the closest dates are kept for patients '
                'with high severity. Thank you for understanding.'
            : 'We\'re sorry, but these dates are kept for patients with '
                'middle or high severity. Thank you for understanding.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// Calendar pop-up, like the birthday picker but with colored dates.
class ColoredCalendarDialog extends StatefulWidget {
  final List<DateTime> availableDates;
  final String severity;
  final DateTime? selected;

  const ColoredCalendarDialog({
    super.key,
    required this.availableDates,
    required this.severity,
    this.selected,
  });

  @override
  State<ColoredCalendarDialog> createState() => ColoredCalendarDialogState();
}

class ColoredCalendarDialogState extends State<ColoredCalendarDialog> {
  static const Color navy = Color(0xFF0F2A44);
  late DateTime month;

  @override
  void initState() {
    super.initState();
    final DateTime first = widget.availableDates.isEmpty
        ? DateTime.now()
        : widget.availableDates.first;
    month = DateTime(first.year, first.month);
  }

  bool isAvailable(DateTime day) => widget.availableDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day);

  bool get canGoBack {
    final DateTime now = DateTime.now();
    return month.isAfter(DateTime(now.year, now.month));
  }

  bool get canGoForward {
    if (widget.availableDates.isEmpty) return false;
    final DateTime last = widget.availableDates.last;
    return month.isBefore(DateTime(last.year, last.month));
  }

  Widget dayCell(DateTime day) {
    final bool available = isAvailable(day);
    if (!available) {
      return Center(
        child: Text(
          '${day.day}',
          style: const TextStyle(fontSize: 14, color: Color(0xFFBDB5A8)),
        ),
      );
    }
    final int priority = priorityOfDate(day);
    final Color color = priorityColor(priority);
    final bool allowed = severityRank(widget.severity) >= priority;
    final DateTime? sel = widget.selected;
    final bool isSelected = sel != null &&
        sel.year == day.year &&
        sel.month == day.month &&
        sel.day == day.day;

    return GestureDetector(
      onTap: () {
        if (!allowed) {
          showPriorityMessage(context, day);
          return;
        }
        Navigator.pop(context, day);
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color : color.withValues(alpha: 0.15),
          border: Border.all(color: color, width: 1.6),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : navy,
              ),
            ),
            if (!allowed)
              Positioned(
                bottom: 2,
                child: Icon(Icons.lock, size: 9, color: color),
              ),
          ],
        ),
      ),
    );
  }

  Widget legend(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 11, color: navy)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final int firstWeekday = DateTime(month.year, month.month, 1).weekday;
    final List<Widget> cells = [
      for (final w in shortWeekdays)
        Center(
          child: Text(
            w.substring(0, 2),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B6255),
            ),
          ),
        ),
      for (int i = 1; i < firstWeekday; i++) const SizedBox(),
      for (int d = 1; d <= daysInMonth; d++)
        dayCell(DateTime(month.year, month.month, d)),
    ];

    return Dialog(
      backgroundColor: const Color(0xFFF7F2EA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SELECT DATE',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1,
                color: Color(0xFF6B6255),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '${longMonths[month.month - 1]} ${month.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: canGoBack
                      ? () => setState(() =>
                          month = DateTime(month.year, month.month - 1))
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                IconButton(
                  onPressed: canGoForward
                      ? () => setState(() =>
                          month = DateTime(month.year, month.month + 1))
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 320,
              child: GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: cells,
              ),
            ),
            const SizedBox(height: 8),
            legend(priorityRed, 'Closest dates: high severity only'),
            legend(priorityOrange, 'Middle and high severity'),
            legend(priorityGreen, 'Open to everyone'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorBookingScreen extends StatefulWidget {
  final Doctor doctor;
  final String surveyName;
  final String severity;
  final bool shareLocation;

  const DoctorBookingScreen({
    super.key,
    required this.doctor,
    required this.surveyName,
    required this.severity,
    required this.shareLocation,
  });

  @override
  State<DoctorBookingScreen> createState() => DoctorBookingScreenState();
}

class DoctorBookingScreenState extends State<DoctorBookingScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);
  static const Color grey = Color(0xFF6B6255);

  DateTime? selectedDate;
  String? selectedTime;
  String? sessionType;
  bool isSaving = false;

  Doctor get doctor => widget.doctor;

  @override
  void initState() {
    super.initState();
    if (doctor.sessionTypes.length == 1) {
      sessionType = doctor.sessionTypes.first;
    }
  }

  Future<void> pickDate() async {
    final DateTime? date = await showDialog<DateTime>(
      context: context,
      builder: (context) => ColoredCalendarDialog(
        availableDates: doctorDates(doctor),
        severity: widget.severity,
        selected: selectedDate,
      ),
    );
    if (date == null || !mounted) return;
    setState(() {
      selectedDate = date;
      selectedTime = null;
    });
    // Times pop up right after the date is chosen.
    await pickTime();
  }

  Future<void> pickTime() async {
    if (selectedDate == null) {
      await pickDate();
      return;
    }
    final DateTime date = selectedDate!;
    final String? time = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFFF7F2EA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8CCB8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Available times',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            Text(
              longDateText(date),
              style: const TextStyle(fontSize: 13, color: grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final t in doctor.times)
                  Builder(builder: (_) {
                    final bool taken = isSlotTaken(doctor, date, t);
                    return GestureDetector(
                      onTap: () {
                        if (taken) {
                          showDialog(
                            context: sheetContext,
                            builder: (c) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              title: const Text('Time booked'),
                              content: const Text(
                                  'Sorry, this time is booked. Please choose a different time.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(c),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        Navigator.pop(sheetContext, t);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: taken
                              ? const Color(0xFFE2DED8)
                              : selectedTime == t
                                  ? navy
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: taken ? const Color(0xFFCFC9C0) : gold,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              taken ? Icons.block : Icons.access_time,
                              size: 15,
                              color: taken
                                  ? Colors.grey
                                  : selectedTime == t
                                      ? Colors.white
                                      : navy,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              taken ? '$t · Booked' : t,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: taken
                                    ? Colors.grey
                                    : selectedTime == t
                                        ? Colors.white
                                        : navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ],
        ),
      ),
    );
    if (time == null || !mounted) return;
    setState(() => selectedTime = time);
  }

  String get locationText {
    if (sessionType == 'Online') {
      return 'Online video call (link sent by email)';
    }
    return '${doctor.clinic}, ${doctor.address}';
  }

  bool get canBook =>
      selectedDate != null && selectedTime != null && sessionType != null;

  Future<void> confirm() async {
    if (!canBook) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a date, time and session type.'),
        ),
      );
      return;
    }
    setState(() => isSaving = true);

    final User? user = FirebaseAuth.instance.currentUser;
    final DateTime now = DateTime.now();
    final String date = longDateText(selectedDate!);

    try {
      await profileRecords(user!.uid, 'appointments')
          .doc(newestFirstId())
          .set({
        'doctor': doctor.name,
        'specialty': doctor.title,
        'sessionType': sessionType,
        'location': locationText,
        'date': date,
        'time': selectedTime,
        'survey': widget.surveyName,
        'severity': widget.severity,
        'bookedOn': '${formatDate(now)} ${formatTime(now)}',
      });

      if (!mounted) return;

      showTopNotification(
        context,
        'Appointment booked',
        'With ${doctor.name} on $date at $selectedTime. '
            'A confirmation email is on its way.',
      );

      sendBookingEmail(
        doctor: doctor.name,
        sessionType: '$sessionType - $locationText',
        date: date,
        time: selectedTime!,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentSuccessScreen(
            doctorName: doctor.name,
            specialty: doctor.title,
            sessionType: sessionType!,
            date: date,
            time: selectedTime!,
            location: locationText,
            isOnline: sessionType == 'Online',
            lat: doctor.lat,
            lng: doctor.lng,
            clinic: doctor.clinic,
          ),
        ),
        (route) => route.isFirst,
      );
    } catch (error) {
      print(error);
      if (!mounted) return;
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking failed. Please try again.')),
      );
    }
  }

  Widget stepButton({
    required int number,
    required String title,
    required String value,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final bool done = value.isNotEmpty;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF2EEE8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: done ? navy : gold.withValues(alpha: 0.6),
            width: done ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: done ? navy : const Color(0xFFEBE1D2),
              child: done
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : Text(
                      '$number',
                      style: const TextStyle(
                        color: navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    done ? value : hint,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: done ? navy : const Color(0xFFA89C8A),
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, color: enabled ? navy : Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget sessionOption(String label) {
    final bool offered = doctor.sessionTypes.contains(label);
    final bool isSelected = sessionType == label;
    final bool online = label == 'Online';
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!offered) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${doctor.name} does not offer $label sessions.'),
              ),
            );
            return;
          }
          setState(() => sessionType = label);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: !offered
                ? const Color(0xFFE2DED8)
                : isSelected
                    ? navy
                    : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? navy : gold),
          ),
          child: Column(
            children: [
              Icon(
                online ? Icons.videocam_outlined : Icons.person_pin_circle_outlined,
                size: 28,
                color: !offered
                    ? Colors.grey
                    : isSelected
                        ? Colors.white
                        : navy,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !offered
                      ? Colors.grey
                      : isSelected
                          ? Colors.white
                          : navy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                !offered
                    ? 'Not offered'
                    : online
                        ? 'Link sent by email'
                        : doctor.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white : grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String initials = profileInitials(doctor.name.replaceFirst('Dr. ', ''));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5EFE6), Color(0xFFEBE1D2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: navy),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: navy,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    doctor.title,
                    style: const TextStyle(fontSize: 15, color: navy),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    doctor.focus,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: grey),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 15, color: gold),
                      const SizedBox(width: 4),
                      Text(
                        doctorPlaceText(doctor, clinicName: true),
                        style: const TextStyle(fontSize: 13, color: navy),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                stepButton(
                  number: 1,
                  title: 'Date',
                  value: selectedDate == null ? '' : longDateText(selectedDate!),
                  hint: 'Choose a date',
                  icon: Icons.calendar_month_outlined,
                  onTap: pickDate,
                ),
                stepButton(
                  number: 2,
                  title: 'Time',
                  value: selectedTime ?? '',
                  hint: selectedDate == null
                      ? 'Choose a date first'
                      : 'Choose a time',
                  icon: Icons.access_time,
                  onTap: pickTime,
                  enabled: selectedDate != null,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 10, top: 6),
                  child: Text(
                    '3. Session type',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                ),
                Row(
                  children: [
                    sessionOption('In person'),
                    const SizedBox(width: 12),
                    sessionOption('Online'),
                  ],
                ),
                if (sessionType != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          sessionType == 'Online'
                              ? Icons.mail_outline
                              : Icons.location_on,
                          color: gold,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            sessionType == 'Online'
                                ? 'The video call link will be sent to your email.'
                                : locationText,
                            style: const TextStyle(fontSize: 13, color: navy),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (sessionType == 'In person' && doctor.lat != 0) ...[
                    const SizedBox(height: 12),
                    clinicMapCard(doctor.lat, doctor.lng, doctor.clinic),
                  ],
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canBook ? navy : const Color(0xFFB8A894),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'BOOK NOW',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Appointment Success — shown after booking, with the location.
/// -----------------------------------------------------------------------
class AppointmentSuccessScreen extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String sessionType;
  final String date;
  final String time;
  final String location;
  final bool isOnline;
  final double lat;
  final double lng;
  final String clinic;

  const AppointmentSuccessScreen({
    super.key,
    required this.doctorName,
    this.specialty = '',
    required this.sessionType,
    required this.date,
    required this.time,
    this.location = '',
    this.isOnline = false,
    this.lat = 0,
    this.lng = 0,
    this.clinic = '',
  });

  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B6255)),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5EFE6), Color(0xFFEBE1D2)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD4F3E4),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF3E8E5A),
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Appointment booked successfully',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          detailRow('Doctor', doctorName),
                          if (specialty.isNotEmpty)
                            detailRow('Specialty', specialty),
                          detailRow('Session', sessionType),
                          detailRow('Date', date),
                          detailRow('Time', time),
                        ],
                      ),
                    ),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: gold.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEBE1D2),
                              ),
                              child: Icon(
                                isOnline
                                    ? Icons.videocam_outlined
                                    : Icons.location_on,
                                color: navy,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isOnline ? 'Where' : 'Location',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B6255),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    location,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: navy,
                                    ),
                                  ),
                                  if (!isOnline)
                                    const Text(
                                      'Please arrive 10 minutes early.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: navy,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (!isOnline && lat != 0) ...[
                      const SizedBox(height: 16),
                      clinicMapCard(lat, lng, clinic),
                    ],
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Return to Home',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
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
}

class NafsiBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const NafsiBottomNavigationBar({
    super.key,
    required this.selectedIndex,
  });

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: navy,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        }

        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HealthScreen(),
            ),
          );
        }

        if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monitor_heart_outlined),
          label: 'Health',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: ProfileSwitcherButton(),
                ),
                const Icon(Icons.settings_outlined, color: navy, size: 50),
                const SizedBox(height: 12),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 30),
                StreamBuilder<DocumentSnapshot>(
                  stream: user == null
                      ? null
                      : FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .snapshots(),
                  builder: (context, snapshot) {
                    String name = '';

                    if (snapshot.hasData && snapshot.data!.exists) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      String firstName = data['firstName'] ?? '';
                      String lastName = data['lastName'] ?? '';
                      name = '$firstName $lastName'.trim();
                    }

                    if (!CurrentProfile.isOwner) {
                      name = CurrentProfile.fullName;
                    }

                    return Column(
                      children: [
                        const CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_outline,
                            color: navy,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (snapshot.connectionState == ConnectionState.waiting)
                          const CircularProgressIndicator()
                        else
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: navy,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                if (CurrentProfile.isOwner) ...[
                  SettingsButton(
                    icon: Icons.person_outline,
                    title: 'Profile Information',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfileInformationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  SettingsButton(
                    icon: Icons.family_restroom,
                    title: 'Family Members',
                    onPressed: () {
                      openFamilyMembers(context);
                    },
                  ),
                  const SizedBox(height: 15),
                ],
                SettingsButton(
                  icon: Icons.monitor_weight_outlined,
                  title: 'Height & Weight',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BodyInfoScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                SettingsButton(
                  icon: Icons.info_outline,
                  title: 'About Nafsi',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutNafsiScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                SettingsButton(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onPressed: () async {
                    bool? answer = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Log Out'),
                          content: const Text(
                            'Are you sure you want to log out?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );

                    if (answer == true) {
                      await FirebaseAuth.instance.signOut();
                      CurrentProfile.clear();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const SettingsButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  static const Color navy = Color(0xFF0F2A44);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 18),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// About Nafsi
/// -----------------------------------------------------------------------
class AboutNafsiScreen extends StatelessWidget {
  const AboutNafsiScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);
  static const Color grey = Color(0xFF6B6255);

  static const List<String> developers = [
    'Noora Alshamsi',
    'Mariam Al Ali',
    'Hend Fikri',
  ];

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: navy,
        ),
      ),
    );
  }

  Widget infoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget featureRow(IconData icon, String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF0E9DD),
            ),
            child: Icon(
              icon,
              color: navy,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: navy,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'About Nafsi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                    ),
                    // Keeps the title centered.
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: navy,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.spa_outlined,
                          color: navy,
                          size: 32,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'nafsi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w600,
                        color: navy,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const Text(
                      'Version 1.0.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: grey,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // About
                    sectionTitle('About Nafsi'),
                    infoCard(
                      child: const Text(
                        'Nafsi (نفسي) means "my soul". It is a safe space made '
                        'for adolescents, to help you check in with yourself, '
                        'understand how you feel, and find support when you '
                        'need it. You are not alone, and taking care of your '
                        'mind is a sign of strength.',
                        style: TextStyle(
                          fontSize: 14,
                          color: navy,
                          height: 1.5,
                        ),
                      ),
                    ),

                    // Features
                    sectionTitle('What Nafsi offers'),
                    infoCard(
                      child: Column(
                        children: [
                          featureRow(
                            Icons.favorite_border,
                            'Anxiety check',
                            'Spot early signs of anxiety with a simple survey '
                                'or smart AI tracking.',
                          ),
                          featureRow(
                            Icons.restaurant_outlined,
                            'Eating habits check',
                            'Reflect on your eating habits with a simple survey '
                                'or smart AI tracking, privately and safely.',
                          ),
                          featureRow(
                            Icons.menu_book_outlined,
                            'Daily Athkar',
                            'Find peace with morning, evening, sleep and exam '
                                'athkar.',
                          ),
                          featureRow(
                            Icons.calendar_month_outlined,
                            'Book an appointment',
                            'Talk to a specialist in person or online, '
                                'whenever you\'re ready.',
                          ),
                        ],
                      ),
                    ),

                    // Please remember
                    sectionTitle('Please remember'),
                    infoCard(
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nafsi does not give a medical diagnosis. Your '
                            'results help you understand yourself better, but '
                            'a specialist can give you the right advice.',
                            style: TextStyle(
                              fontSize: 14,
                              color: navy,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'If you are in immediate danger, please call 999.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: navy,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'For free, private support anytime, call the '
                            'National Mental Support Line: 800-HOPE (800-4673).',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: navy,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Developed by
                    sectionTitle('Developed by'),
                    infoCard(
                      child: Column(
                        children: [
                          for (String name in developers)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    color: pinkAccent,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: navy,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Contact
                    sectionTitle('Contact us'),
                    infoCard(
                      child: const Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: pinkAccent,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'nafsi.senior@gmail.com',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: navy,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Made with care in the UAE 🇦🇪',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      '© 2026 Nafsi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInformationScreen extends StatefulWidget {
  const ProfileInformationScreen({super.key});

  @override
  State<ProfileInformationScreen> createState() =>
      ProfileInformationScreenState();
}

class ProfileInformationScreenState extends State<ProfileInformationScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);
  static const Color cream = Color(0xFFF7F2EA);

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  String gender = '';
  bool isEditing = false;
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    emailController.text = user.email ?? '';

    if (document.exists) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      firstNameController.text = data['firstName'] ?? '';
      lastNameController.text = data['lastName'] ?? '';
      emailController.text = data['email'] ?? user.email ?? '';
      phoneController.text = data['phone'] ?? '';
      birthdayController.text = data['birthday'] ?? '';
      gender = data['gender'] ?? '';
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': user.email ?? emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'birthday': birthdayController.text.trim(),
        'gender': gender,
      }, SetOptions(merge: true));

      if (!mounted) return;

      setState(() {
        isEditing = false;
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } catch (error) {
      print(error);

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update profile'),
        ),
      );
    }
  }

  void cancelEditing() {
    setState(() {
      isEditing = false;
    });
    // Put the saved values back in the fields.
    loadProfile();
  }

  Future<void> pickBirthday() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        birthdayController.text = '${date.day}/${date.month}/${date.year}';
      });
    }
  }

  String get initials {
    String first = firstNameController.text.trim();
    String last = lastNameController.text.trim();
    String result = '';
    if (first.isNotEmpty) result += first[0];
    if (last.isNotEmpty) result += last[0];
    return result.toUpperCase();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String fullName =
        '${firstNameController.text} ${lastNameController.text}'.trim();

    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: navy,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Profile Information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                    ),
                    // Keeps the title centered.
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
                        children: [
                          // Avatar
                          Center(
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: pinkAccent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: initials.isEmpty
                                  ? const Icon(
                                      Icons.person_outline,
                                      color: navy,
                                      size: 44,
                                    )
                                  : Text(
                                      initials,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: navy,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            fullName.isEmpty ? 'Your Name' : fullName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: navy,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            emailController.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B6255),
                            ),
                          ),

                          const SizedBox(height: 28),

                          const Padding(
                            padding: EdgeInsets.only(left: 6, bottom: 10),
                            child: Text(
                              'Personal Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: navy,
                              ),
                            ),
                          ),

                          // Details card
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ProfileTextField(
                                  label: 'First Name',
                                  icon: Icons.person_outline,
                                  controller: firstNameController,
                                  enabled: isEditing,
                                ),
                                ProfileTextField(
                                  label: 'Last Name',
                                  icon: Icons.person_outline,
                                  controller: lastNameController,
                                  enabled: isEditing,
                                ),
                                ProfileTextField(
                                  label: 'Email',
                                  icon: Icons.email_outlined,
                                  controller: emailController,
                                  enabled: false,
                                ),
                                ProfileTextField(
                                  label: 'Phone',
                                  icon: Icons.phone_outlined,
                                  controller: phoneController,
                                  enabled: isEditing,
                                ),
                                ProfileTextField(
                                  label: 'Birthday',
                                  icon: Icons.calendar_month_outlined,
                                  controller: birthdayController,
                                  enabled: isEditing,
                                  readOnly: true,
                                  onTap: pickBirthday,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  padding: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: cream,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isEditing
                                          ? pinkAccent
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: gender.isEmpty ? null : gender,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: navy,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Gender',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF6B6255),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.wc_outlined,
                                        color: navy,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Female',
                                        child: Text('Female'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Male',
                                        child: Text('Male'),
                                      ),
                                    ],
                                    onChanged: isEditing
                                        ? (value) {
                                            setState(() {
                                              gender = value ?? '';
                                            });
                                          }
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 26),

                          // Buttons
                          if (isEditing)
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 54,
                                    child: OutlinedButton(
                                      onPressed:
                                          isSaving ? null : cancelEditing,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: navy,
                                        side: const BorderSide(
                                          color: pinkAccent,
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28),
                                        ),
                                      ),
                                      child: const Text(
                                        'CANCEL',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: SizedBox(
                                    height: 54,
                                    child: ElevatedButton(
                                      onPressed: isSaving ? null : saveProfile,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: navy,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(28),
                                        ),
                                      ),
                                      child: isSaving
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              'SAVE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            SizedBox(
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    isEditing = true;
                                  });
                                },
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text(
                                  'EDIT PROFILE',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: pinkAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.enabled,
    this.readOnly = false,
    this.onTap,
  });

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);
  static const Color cream = Color(0xFFF7F2EA);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        enabled: enabled,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: navy,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF6B6255),
          ),
          prefixIcon: Icon(
            icon,
            color: navy,
          ),
          filled: true,
          fillColor: cream,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: pinkAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: navy, width: 1.5),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// LLM Assessment (Mariam)
/// -----------------------------------------------------------------------
class LlmQuestion {
  final String text;
  final List<String> options;
  LlmQuestion(this.text, this.options);
}

class LlmAssessmentScreen extends StatefulWidget {
  const LlmAssessmentScreen({super.key});

  @override
  State<LlmAssessmentScreen> createState() => LlmAssessmentScreenState();
}

class LlmAssessmentScreenState extends State<LlmAssessmentScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  final List<LlmQuestion> questions = [
    LlmQuestion("How have you been sleeping lately?",
        ["Sleeping well", "Trouble falling asleep", "Waking up often", "Sleeping too much"]),
    LlmQuestion("How often do you feel worried or nervous?",
        ["Rarely", "Sometimes", "Often", "Almost every day"]),
    LlmQuestion("How is your concentration?",
        ["Good", "Sometimes distracted", "Hard to focus"]),
    LlmQuestion("Do you notice physical signs (fast heartbeat, sweating, tight chest)?",
        ["Never", "Sometimes", "Often"]),
    LlmQuestion("How stressed are you about studies or work?",
        ["Not stressed", "Somewhat stressed", "Very stressed"]),
    LlmQuestion("Do you avoid social situations?",
        ["No", "Sometimes", "Often"]),
  ];

  late List<String?> selected;
  late List<TextEditingController> otherControllers;
  bool loading = false;
  String result = "";
  bool gotAnswer = false;
  String saveStatus = "";

  @override
  void initState() {
    super.initState();
    selected = List.filled(questions.length, null);
    otherControllers =
        List.generate(questions.length, (i) => TextEditingController());
  }

  @override
  void dispose() {
    for (var c in otherControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // Returns the final answer for a question (option or typed text)
  String getAnswer(int i) {
    if (selected[i] == "Other") {
      return otherControllers[i].text.trim();
    }
    return selected[i] ?? "";
  }

  Future<void> sendToLLM() async {
    for (int i = 0; i < questions.length; i++) {
      if (getAnswer(i).isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please answer all questions before submitting.'),
          ),
        );
        return;
      }
    }

    String text = "";
    for (int i = 0; i < questions.length; i++) {
      text += "Q${i + 1}: ${questions[i].text}\n";
      text += "Answer: ${getAnswer(i)}\n\n";
    }

    setState(() {
      loading = true;
      result = "";
      gotAnswer = false;
      saveStatus = "";
    });

    String reply = await GeminiService.askLLM(text);

    if (!mounted) return;
    setState(() {
      loading = false;
      result = reply;
      gotAnswer =
          reply.split("\n").first.contains("Possible signs of anxiety");
    });

    // Save to Firebase only if the LLM really answered
    if (reply.startsWith("Assessment")) {
      await saveToFirebase(reply);
    }
  }

  // Saves under users/{userId}/profiles/{profileId}/llmResults,
  // like the other surveys
  Future<void> saveToFirebase(String reply) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        saveStatus = "Not saved: please log in first.";
      });
      return;
    }

    List<Map<String, String>> answers = [];
    for (int i = 0; i < questions.length; i++) {
      answers.add({
        "question": questions[i].text,
        "answer": getAnswer(i),
      });
    }

    DateTime now = DateTime.now();

    try {
      await profileRecords(user.uid, 'llmResults')
          .doc(newestFirstId())
          .set({
        'date': formatDate(now),
        'time': formatTime(now),
        'answers': answers,
        'llm_response': reply,
        'has_anxiety': gotAnswer,
      });
      if (!mounted) return;
      setState(() {
        saveStatus = "Result saved to Firebase.";
      });
    } catch (e) {
      print("Firebase error: $e");
      if (!mounted) return;
      setState(() {
        saveStatus = "Could not save to Firebase.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5EFE6),
              Color(0xFFEBE1D2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                ),
                const Text(
                  'LLM ASSESSMENT',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Answer the questions. If no option fits you, choose "Other" and write your answer.',
                  style: TextStyle(fontSize: 14, color: navy, height: 1.4),
                ),
                const SizedBox(height: 20),
                for (int i = 0; i < questions.length; i++) buildQuestion(i),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: loading ? null : sendToLLM,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Get Result',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (loading)
                  const Center(child: CircularProgressIndicator(color: navy)),
                if (result.isNotEmpty) buildResultCard(),
                if (saveStatus.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 10),
                    child: Text(saveStatus,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                if (gotAnswer) buildRecommendations(),
                const SizedBox(height: 16),
                const Text(
                  "This is a university project screening tool, not a medical diagnosis.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildQuestion(int i) {
    List<String> allOptions = [...questions[i].options, "Other"];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${i + 1}. ${questions[i].text}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: navy,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          for (var option in allOptions)
            GestureDetector(
              onTap: () {
                setState(() {
                  selected[i] = option;
                });
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  color: selected[i] == option
                      ? navy
                      : const Color(0xFFF5EFE6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected[i] == option
                        ? navy
                        : const Color(0xFFE3D7C5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected[i] == option
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: selected[i] == option ? Colors.white : pinkAccent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected[i] == option ? Colors.white : navy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (selected[i] == "Other")
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextField(
                controller: otherControllers[i],
                decoration: InputDecoration(
                  hintText: "Write your answer",
                  filled: true,
                  fillColor: const Color(0xFFF5EFE6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: pinkAccent, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LLM response",
            style: TextStyle(fontWeight: FontWeight.bold, color: navy),
          ),
          const SizedBox(height: 8),
          Text(result, style: const TextStyle(color: navy, height: 1.4)),
        ],
      ),
    );
  }

  Widget buildRecommendations() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("General recommendations",
              style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
          const SizedBox(height: 8),
          const Text(
            "- Try slow deep breathing for 5 minutes (breathe in for 4 seconds, out for 6).\n"
            "- Do light exercise such as a 20-30 minute walk, stretching, or yoga.\n"
            "- Keep a regular sleep schedule and limit caffeine, especially at night.\n"
            "- Talk to a friend or family member you trust about how you feel.",
            style: TextStyle(color: navy, height: 1.5),
          ),
          const SizedBox(height: 10),
          const Text(
            "If these feelings continue or affect your daily life, we recommend seeing a doctor or a mental health professional.",
            style: TextStyle(fontWeight: FontWeight.w600, color: navy),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BookAppointmentScreen(
                          surveyName: 'LLM Assessment',
                          severity: 'Middle',
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// LLM connection (Gemini API)
/// -----------------------------------------------------------------------
class GeminiService {
  // Put the API key here (do not share it in the group chat)
  static String myApiKey = "AQ.Ab8RN6KZXISrBy4rPTf4bLvHGJk3vRwAw7swwJuYGLDiE4Lj_g";

  static Future<String> askLLM(String problem) async {
    String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key=$myApiKey';
    Uri url = Uri.parse(apiUrl);

    String myPrompt =
        "You are a supportive assistant inside a university student mental-health app (a class project, not a medical service).\n";
    myPrompt += "A user answered a short questionnaire:\n";
    myPrompt += "$problem\n\n";
    myPrompt += "Reply in exactly this format:\n";
    myPrompt += "Assessment: Possible signs of anxiety OR No clear signs of anxiety\n";
    myPrompt += "Explanation: one or two short sentences.\n";
    myPrompt += "Only if the assessment is Possible signs of anxiety, also add: What you can try: two or three short practical suggestions. If the assessment is No clear signs of anxiety, do NOT add any suggestions.\n\n";
    myPrompt +=
        "If the user mentions self-harm or feeling unsafe, do not use the format. Instead, kindly encourage them to contact local emergency services or someone they trust right now.";

    int lastCode = 0;

    for (int attempt = 1; attempt <= 4; attempt++) {
      try {
        var response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                "contents": [
                  {
                    "parts": [
                      {"text": myPrompt}
                    ]
                  }
                ]
              }),
            )
            .timeout(const Duration(seconds: 40));

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          return data['candidates'][0]['content']['parts'][0]['text']
              .toString()
              .trim();
        }

        lastCode = response.statusCode;
        print("LLM status code: $lastCode");

        if (lastCode == 429) break; // daily limit: don't retry
        if (lastCode == 503) {
          await Future.delayed(const Duration(seconds: 6));
        } else {
          break;
        }
      } catch (e) {
        print("LLM error: $e");
        if (attempt == 4) {
          return "No response from the LLM. Please check your internet connection and try again.";
        }
      }
    }

    if (lastCode == 429) {
      return "The free daily limit for the LLM has been reached. Please try again later today or tomorrow. (Error code: 429)";
    }
    if (lastCode == 503) {
      return "The LLM service is busy right now. Please try again in a minute. (Error code: 503)";
    }
    return "Something went wrong. Error code: $lastCode";
  }

  /// Asks Gemini for a short wellbeing summary and 10 recipes for one meal,
  /// based on weight group, stress, sleep, meals and eating warning signs.
  /// Throws if Gemini doesn't answer.
  /// Gemini works out daily calories, macros, vitamins and minerals.
  /// Under 18: general guidance only, no numbers.
  static Future<NutritionTargets> calculateDailyNeeds({
    required int age,
    required String sex,
    required double heightCm,
    required double weightKg,
    required String activity,
  }) async {
    final Uri url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key=$myApiKey');
    final bool under18 = age < 18;

    String prompt =
        'You are a nutrition calculator inside a university student wellbeing app '
        '(a class project, not medical advice).\n'
        'Person: age $age, sex $sex, height ${heightCm.round()} cm, '
        'weight ${weightKg.round()} kg, activity level: $activity.\n\n';
    if (under18) {
      prompt += 'This person is under 18 and still growing, so do NOT give calorie '
          'or gram numbers. Reply with ONLY a JSON object: '
          '{"explanation": "3 or 4 short, kind sentences of general healthy-eating '
          'guidance for a teenager (regular meals, variety, calcium, iron, water, '
          'talking to a doctor or school nurse for a personal plan)"}';
    } else {
      prompt += 'Calculate the daily needs to keep a healthy weight:\n'
          '1. BMR with the Mifflin-St Jeor equation.\n'
          '2. Multiply by the activity factor (Not active 1.2, Lightly active 1.375, '
          'Moderately active 1.55, Very active 1.725, Extremely active 1.9).\n'
          '3. Protein 1.0 g per kg (1.2 if Very or Extremely active), fat 30% of '
          'calories, carbs the rest. Fiber 14 g per 1000 kcal. Water 35 ml per kg.\n'
          '4. The main vitamins and minerals for this age and sex from standard '
          'recommended daily amounts.\n'
          'Never suggest eating below the calculated amount or losing weight.\n\n'
          'Reply with ONLY a JSON object with these keys: '
          '"calories" (number), "protein", "carbs", "fat", "fiber" (grams, numbers), '
          '"water" (litres, number), '
          '"vitamins" (array of 6 strings like "Vitamin C: 75 mg"), '
          '"minerals" (array of 6 strings like "Iron: 18 mg"), '
          '"method" (one short sentence with the numbers you used, e.g. '
          '"BMR 1,350 kcal x 1.55 = 2,090 kcal"), '
          '"explanation" (2 short, kind sentences in simple English).';
    }

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'responseMimeType': 'application/json',
              'temperature': 0,
            },
          }),
        )
        .timeout(const Duration(seconds: 40));
    if (response.statusCode != 200) {
      throw Exception('Gemini error ${response.statusCode}');
    }
    final data = jsonDecode(response.body);
    String text =
        data['candidates'][0]['content']['parts'][0]['text'].toString().trim();
    text = text.replaceAll(RegExp(r'^```(json)?|```$'), '').trim();
    final Map map = jsonDecode(text) as Map;
    if (under18) {
      return NutritionTargets(
        under18: true,
        explanation: (map['explanation'] ?? '').toString(),
      );
    }
    return NutritionTargets.fromMap(map);
  }

  static Future<RecipeIdeas> generateRecipes({
    required String meal,
    required String group, // nourish, balanced, light
    required bool highRisk,
    required List<String> avoidNames,
    WellbeingInfo? info,
  }) async {
    final Uri url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key=$myApiKey');

    final String need = group == 'nourish'
        ? 'The person is underweight for their height. Suggest filling, energy-rich, nourishing recipes. Never mark anything as low calorie.'
        : group == 'light'
            ? 'The person is above a healthy weight for their height. Suggest balanced, lighter recipes with plenty of vegetables and protein. Never suggest skipping meals, fasting or dieting.'
            : 'The person is at a healthy weight. Suggest balanced recipes.';

    String prompt =
        'You are a friendly nutrition helper in "nafsi", a university student wellbeing app in the UAE. '
        'It shows warning signs only and is not a medical diagnosis.\n\n';
    prompt += 'What we know about the person today:\n';
    prompt += '- Weight group: $group. $need\n';
    if (info != null) {
      prompt += '- Stress level from their Apple Watch: ${info.stressLevel}\n';
      if (info.sleepHours != null) {
        prompt += '- Sleep last night: ${info.sleepHours!.toStringAsFixed(1)} hours\n';
      }
      prompt += '- Meals logged today: ${info.mealsToday}\n';
      prompt += '- Eating warning signs level: ${info.eatingLevel}\n';
      if (info.signs.isNotEmpty) {
        prompt += '- Warning signs: ${info.signs.join('; ')}\n';
      }
      prompt += '- Latest eating disorder (EDE) survey: ${info.edeLevel ?? 'not taken'}\n';
    }
    if (highRisk) {
      prompt += '\nIMPORTANT: this person may be at risk of an eating disorder. '
          'Only suggest normal, satisfying meals. Never mention calories, numbers, '
          'weight, dieting, "light", "low-calorie", "guilt-free" or weight loss, '
          'and set "lowCalorie" to false for every recipe.\n';
    }
    prompt += '\nTasks:\n';
    prompt += '1. "summary": 2 or 3 short, kind sentences in simple English about how '
        'their eating and stress look today (for example that things look healthy, or '
        'that some warning signs showed up and what small step could help). '
        'Do not diagnose. If stress is High or Middle, gently say that calming, easy '
        'meals can help.\n';
    prompt += '2. "recipes": 10 different $meal recipes from around the world, '
        'including at least 3 Emirati or Middle Eastern dishes. '
        'If stress is High or Middle, make at least 4 of them stress-relieving '
        '(for example foods with magnesium, omega-3 or complex carbs such as nuts, '
        'spinach, bananas, oats, salmon, yogurt, warm soups) and quick to make.';
    if (meal == 'Snack') {
      prompt += ' Include at least 3 real sweets in healthier, small portions '
          '(for example date balls, luqaimat, kunafa cups, fruit tarts).';
      if (!highRisk && group != 'nourish') {
        prompt += ' Include at least 3 low-calorie stress-relief snacks so the '
            'person does not stress eat.';
      }
    }
    prompt += '\nUse halal ingredients that are easy to find in UAE supermarkets. '
        'Each recipe is for 1 serving with 3 to 7 ingredients (with amounts) and '
        '2 to 6 short steps in simple English.\n';
    if (avoidNames.isNotEmpty) {
      prompt += 'Do not suggest these again: ${avoidNames.join(', ')}.\n';
    }
    prompt += '\nReply with ONLY a JSON object: {"summary": string, "recipes": [ ... ]}. '
        'Each recipe has exactly these keys: "name", "cuisine", '
        '"wikiTitle" (the exact English Wikipedia article title for this dish or its '
        'main food, for a photo, e.g. "Shakshouka", "Hummus", "Knafeh"), '
        '"photoSearch" (one or two English words for the dish), '
        '"minutes", "calories", "protein", "carbs", "fat" (numbers, approximate), '
        '"stressRelief" (true/false), "lowCalorie" (true/false), "sweet" (true/false), '
        '"vitamins" (array of the 2 to 5 main vitamins, e.g. "Vitamin C", "Folate (B9)"), '
        '"minerals" (array of the 2 to 5 main minerals, e.g. "Iron", "Calcium"), '
        '"ingredients" (array of strings), "steps" (array of strings).';

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'responseMimeType': 'application/json',
              'temperature': 1.0,
            },
          }),
        )
        .timeout(const Duration(seconds: 50));

    if (response.statusCode != 200) {
      throw Exception('Gemini error ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    String text =
        data['candidates'][0]['content']['parts'][0]['text'].toString().trim();
    text = text.replaceAll(RegExp(r'^```(json)?|```$'), '').trim();

    final dynamic parsed = jsonDecode(text);
    final Map map = parsed is Map ? parsed : {'recipes': parsed};
    final List items = (map['recipes'] as List?) ?? [];
    int number(dynamic v) => v is num ? v.round() : int.tryParse('$v') ?? 0;
    bool flag(dynamic v) => v == true || v.toString() == 'true';
    final bool noLowCal = highRisk || group == 'nourish';

    final List<Recipe> list = [
      for (final item in items)
        if (item is Map && item['name'] != null)
          Recipe(
            name: item['name'].toString(),
            cuisine: (item['cuisine'] ?? 'Global').toString(),
            meal: meal,
            groups: [group],
            wikiTitle: item['wikiTitle']?.toString(),
            photoSearch: (item['photoSearch'] ?? item['name']).toString(),
            minutes: number(item['minutes']),
            calories: number(item['calories']),
            protein: number(item['protein']),
            carbs: number(item['carbs']),
            fat: number(item['fat']),
            stressRelief: flag(item['stressRelief']),
            lowCal: !noLowCal && flag(item['lowCalorie']),
            sweet: flag(item['sweet']),
            ingredients: [
              for (final i in (item['ingredients'] as List? ?? [])) i.toString(),
            ],
            steps: [
              for (final s in (item['steps'] as List? ?? [])) s.toString(),
            ],
            vitamins: [
              for (final v in (item['vitamins'] as List? ?? [])) v.toString(),
            ],
            minerals: [
              for (final m in (item['minerals'] as List? ?? [])) m.toString(),
            ],
            byAi: true,
          ),
    ];
    return RecipeIdeas(
      summary: (map['summary'] ?? '').toString(),
      recipes: list,
    );
  }
}

class CurrentProfile {
  static String? id;
  static String? firstName;
  static String? lastName;
  static String? relationship;

  static void clear() {
    id = null;
    firstName = null;
    lastName = null;
    relationship = null;
  }

  static String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  static bool get isOwner => relationship == 'Me';
}

CollectionReference<Map<String, dynamic>> profileRecords(
  String userId,
  String collection,
) {
  if (CurrentProfile.id == null) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(collection);
  }
  return profilesCollection(userId)
      .doc(CurrentProfile.id)
      .collection(collection);
}

const List<String> profileRecordCollections = [
  'gadSurveys',
  'edeSurveys',
  'llmResults',
  'appointments',
  'mealLogs',
  'bodyInfo',
];

String profileFullName(Map<String, dynamic> data) {
  return '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
}

String profileInitials(String fullName) {
  final List<String> words =
      fullName.split(' ').where((word) => word.isNotEmpty).toList();
  if (words.isEmpty) return '?';
  String result = words.first[0];
  if (words.length > 1) result += words.last[0];
  return result.toUpperCase();
}

const List<Color> profileColors = [
  Color(0xFFC9A882),
  Color(0xFF0F2A44),
  Color(0xFF7A9E7E),
  Color(0xFFB5727A),
  Color(0xFF6C7FA8),
  Color(0xFFD49A5A),
];

Color profileColor(int index) {
  if (index < 0 || index >= profileColors.length) return profileColors[0];
  return profileColors[index];
}

List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedProfiles(
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
) {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> sorted = [...docs];
  sorted.sort((a, b) {
    final bool aIsMain = a.data()['relationship'] == 'Me';
    final bool bIsMain = b.data()['relationship'] == 'Me';
    if (aIsMain != bIsMain) return aIsMain ? -1 : 1;
    return a.id.compareTo(b.id);
  });
  return sorted;
}

String newProfileId() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}

CollectionReference<Map<String, dynamic>> profilesCollection(String userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('profiles');
}

Widget profileAvatar(String fullName, int colorIndex, {double size = 100}) {
  return Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: profileColor(colorIndex),
      borderRadius: BorderRadius.circular(size * 0.22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Text(
      profileInitials(fullName),
      style: TextStyle(
        fontSize: size * 0.38,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

const BoxDecoration _creamBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF5EFE6),
      Color(0xFFEBE1D2),
    ],
  ),
);

const int maxProfiles = 6;

Future<bool> confirmAccountPassword(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final TextEditingController passwordController = TextEditingController();

  final bool? answer = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Account password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      );
    },
  );

  final String password = passwordController.text.trim();
  passwordController.dispose();

  if (answer != true) return false;

  final User user = FirebaseAuth.instance.currentUser!;

  try {
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      ),
    );
    return true;
  } catch (error) {
    print(error);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong account password'),
        ),
      );
    }
    return false;
  }
}

Future<bool> deleteFamilyMember(
  BuildContext context, {
  required String profileId,
  required String name,
}) async {
  final bool? answer = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Remove Family Member'),
        content: Text(
          'Are you sure you want to remove $name\'s profile?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );

  if (answer != true) return false;

  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final DocumentReference<Map<String, dynamic>> profile =
      profilesCollection(userId).doc(profileId);

  try {
    for (String collection in profileRecordCollections) {
      final records = await profile.collection(collection).get();
      for (var record in records.docs) {
        await record.reference.delete();
      }
    }

    await profile.delete();

    if (CurrentProfile.id == profileId) {
      CurrentProfile.clear();
    }
    return true;
  } catch (error) {
    print(error);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not remove the profile'),
        ),
      );
    }
    return false;
  }
}

Future<void> openFamilyMembers(BuildContext context) async {
  final bool confirmed = await confirmAccountPassword(
    context,
    title: 'Family Members',
    message: 'Enter the account password to manage family members.',
  );

  if (!confirmed || !context.mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const FamilyMembersScreen(),
    ),
  );
}

void openPasscodeScreen(
  BuildContext context,
  QueryDocumentSnapshot<Map<String, dynamic>> doc,
  int colorIndex,
) {
  final Map<String, dynamic> data = doc.data();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PasscodeScreen(
        profileId: doc.id,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        colorIndex: colorIndex,
        passcode: data['passcode'] ?? '',
        relationship: data['relationship'] ?? '',
      ),
    ),
  );
}

class ProfileSwitcherButton extends StatelessWidget {
  const ProfileSwitcherButton({super.key});

  static const Color navy = Color(0xFF0F2A44);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: profilesCollection(user.uid).snapshots(),
      builder: (context, snapshot) {
        final docs = sortedProfiles(snapshot.data?.docs ?? []);
        final int currentIndex =
            docs.indexWhere((doc) => doc.id == CurrentProfile.id);

        return PopupMenuButton<int>(
          tooltip: 'Switch profile',
          offset: const Offset(0, 52),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onSelected: (index) {
            if (docs[index].id == CurrentProfile.id) return;
            openPasscodeScreen(context, docs[index], index);
          },
          itemBuilder: (context) => [
            for (int i = 0; i < docs.length; i++)
              PopupMenuItem<int>(
                value: i,
                child: Row(
                  children: [
                    profileAvatar(profileFullName(docs[i].data()), i,
                        size: 34),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        profileFullName(docs[i].data()),
                        style: TextStyle(
                          color: navy,
                          fontWeight: docs[i].id == CurrentProfile.id
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (docs[i].id == CurrentProfile.id)
                      const Icon(Icons.check, color: navy, size: 20),
                  ],
                ),
              ),
          ],
          child: profileAvatar(
            CurrentProfile.fullName,
            currentIndex < 0 ? 0 : currentIndex,
            size: 42,
          ),
        );
      },
    );
  }
}

class ProfileSelectScreen extends StatelessWidget {
  const ProfileSelectScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    CurrentProfile.clear();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
      (route) => false,
    );
  }

  Widget profileTile(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    int colorIndex,
  ) {
    final String name = profileFullName(doc.data());

    return GestureDetector(
      onTap: () => openPasscodeScreen(context, doc, colorIndex),
      child: Column(
        children: [
          profileAvatar(name, colorIndex),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget addProfileTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileFormScreen(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: pinkAccent, width: 1.5),
            ),
            child: const Icon(Icons.add, color: navy, size: 44),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add Profile',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: _creamBackground,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => logOut(context),
                  icon: const Icon(Icons.logout, color: navy, size: 18),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(color: navy),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: navy, width: 1.5),
                ),
                child: const Icon(
                  Icons.spa_outlined,
                  color: navy,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'nafsi',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                  color: navy,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Who's using nafsi?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: user == null
                    ? const SizedBox()
                    : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: profilesCollection(user.uid).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Center(
                              child: Text('Could not load profiles'),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(color: navy),
                            );
                          }

                          final docs = sortedProfiles(snapshot.data!.docs);

                          return ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            children: [
                              if (docs.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 24),
                                  child: Text(
                                    'Create your profile to get started. You can '
                                    'add family members later from Settings → '
                                    'Family Members.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: navy,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 24,
                                crossAxisSpacing: 24,
                                childAspectRatio: 0.85,
                                children: [
                                  for (int i = 0; i < docs.length; i++)
                                    profileTile(context, docs[i], i),
                                  if (docs.isEmpty) addProfileTile(context),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasscodeScreen extends StatefulWidget {
  final String profileId;
  final String firstName;
  final String lastName;
  final int colorIndex;
  final String passcode;
  final String relationship;

  const PasscodeScreen({
    super.key,
    required this.profileId,
    required this.firstName,
    required this.lastName,
    required this.colorIndex,
    required this.passcode,
    required this.relationship,
  });

  String get fullName => '$firstName $lastName'.trim();

  @override
  State<PasscodeScreen> createState() => PasscodeScreenState();
}

class PasscodeScreenState extends State<PasscodeScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  static const int maxAttempts = 5;
  static const Duration lockDuration = Duration(seconds: 30);

  String entered = '';
  String? error;
  int wrongAttempts = 0;
  bool isLocked = false;
  Timer? lockTimer;

  @override
  void dispose() {
    lockTimer?.cancel();
    super.dispose();
  }

  void press(String digit) {
    if (isLocked || entered.length == 4) return;

    setState(() {
      entered += digit;
      error = null;
    });

    if (entered.length == 4) {
      Future.delayed(const Duration(milliseconds: 150), check);
    }
  }

  void backspace() {
    if (isLocked || entered.isEmpty) return;
    setState(() {
      entered = entered.substring(0, entered.length - 1);
    });
  }

  void check() {
    if (!mounted) return;

    if (entered == widget.passcode) {
      CurrentProfile.id = widget.profileId;
      CurrentProfile.firstName = widget.firstName;
      CurrentProfile.lastName = widget.lastName;
      CurrentProfile.relationship = widget.relationship;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
      return;
    }

    wrongAttempts++;

    if (wrongAttempts >= maxAttempts) {
      wrongAttempts = 0;
      lockTimer = Timer(lockDuration, () {
        if (!mounted) return;
        setState(() {
          isLocked = false;
          error = null;
        });
      });

      setState(() {
        isLocked = true;
        entered = '';
        error = 'Too many tries. Please wait 30 seconds.';
      });
    } else {
      setState(() {
        entered = '';
        error = 'Wrong passcode. Try again.';
      });
    }
  }

  Future<void> forgotPasscode() async {
    final bool confirmed = await confirmAccountPassword(
      context,
      title: 'Forgot passcode?',
      message: 'Enter the account password to reset the passcode for '
          '${widget.fullName}.',
    );

    if (!confirmed || !mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileFormScreen(
          profileId: widget.profileId,
          resetPasscode: true,
        ),
      ),
    );
  }

  Widget dot(int index) {
    final bool filled = index < entered.length;
    return Container(
      width: 18,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? navy : Colors.transparent,
        border: Border.all(color: navy, width: 1.5),
      ),
    );
  }

  Widget keypadButton({String? digit, IconData? icon, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 76,
        height: 76,
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 1,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: isLocked ? null : onTap,
            child: Center(
              child: digit != null
                  ? Text(
                      digit,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    )
                  : Icon(icon, color: navy),
            ),
          ),
        ),
      ),
    );
  }

  Widget keypadRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (String digit in digits)
          keypadButton(digit: digit, onTap: () => press(digit)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _creamBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                  ),
                ),
                const SizedBox(height: 10),
                profileAvatar(widget.fullName, widget.colorIndex, size: 90),
                const SizedBox(height: 14),
                Text(
                  widget.fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your 4-digit passcode',
                  style: TextStyle(fontSize: 15, color: navy),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [for (int i = 0; i < 4; i++) dot(i)],
                ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      error ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB3402C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                keypadRow(['1', '2', '3']),
                keypadRow(['4', '5', '6']),
                keypadRow(['7', '8', '9']),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 92, height: 92),
                    keypadButton(digit: '0', onTap: () => press('0')),
                    keypadButton(
                      icon: Icons.backspace_outlined,
                      onTap: backspace,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: forgotPasscode,
                  child: const Text(
                    'Forgot passcode?',
                    style: TextStyle(color: pinkAccent),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileFormScreen extends StatefulWidget {
  final String? profileId;

  final bool resetPasscode;

  const ProfileFormScreen({
    super.key,
    this.profileId,
    this.resetPasscode = false,
  });

  @override
  State<ProfileFormScreen> createState() => ProfileFormScreenState();
}

class ProfileFormScreenState extends State<ProfileFormScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  static const List<String> relationshipOptions = [
    'Mother',
    'Father',
    'Sister',
    'Brother',
    'Daughter',
    'Son',
    'Other',
  ];

  static const List<String> genderOptions = ['Female', 'Male'];

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passcodeController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  String? relationship;
  String? gender;
  bool hidePasscode = true;
  bool isSaving = false;
  bool isLoading = false;

  bool get isEditing => widget.profileId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      isLoading = true;
      loadProfile();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthdayController.dispose();
    phoneController.dispose();
    passcodeController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await profilesCollection(userId).doc(widget.profileId).get();
      final Map<String, dynamic> data = doc.data() ?? {};

      firstNameController.text = data['firstName'] ?? '';
      lastNameController.text = data['lastName'] ?? '';
      birthdayController.text = data['birthday'] ?? '';
      phoneController.text = data['phone'] ?? '';
      relationship = data['relationship'];
      gender = data['gender'];
    } catch (error) {
      print(error);
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> pickBirthday() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        birthdayController.text = '${date.day}/${date.month}/${date.year}';
      });
    }
  }

  Future<void> save() async {
    final String firstName = firstNameController.text.trim();
    final String passcode = passcodeController.text;

    if (firstName.isEmpty) {
      showMessage('Please enter a first name.');
      return;
    }
    if (relationship == null) {
      showMessage('Please choose who this profile is for.');
      return;
    }
    if (birthdayController.text.isEmpty) {
      showMessage('Please choose a birthday.');
      return;
    }
    if (gender == null) {
      showMessage('Please choose a gender.');
      return;
    }
    final bool keepPasscode =
        isEditing && !widget.resetPasscode && passcode.isEmpty;

    if (!keepPasscode && passcode.length != 4) {
      showMessage('The passcode must be 4 digits.');
      return;
    }
    if (!keepPasscode && passcode != confirmController.text) {
      showMessage('The passcodes do not match.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final DocumentReference<Map<String, dynamic>> doc = isEditing
        ? profilesCollection(userId).doc(widget.profileId)
        : profilesCollection(userId).doc(newProfileId());

    try {
      await doc.set({
        'firstName': firstName,
        'lastName': lastNameController.text.trim(),
        'birthday': birthdayController.text,
        'gender': gender,
        'phone': phoneController.text.trim(),
        'relationship': relationship,
        if (!keepPasscode) 'passcode': passcode,
      }, SetOptions(merge: true));

      if (CurrentProfile.id == doc.id) {
        CurrentProfile.firstName = firstName;
        CurrentProfile.lastName = lastNameController.text.trim();
        CurrentProfile.relationship = relationship;
      }

      if (!mounted) return;

      showMessage(isEditing ? 'Profile updated' : 'Profile created');
      Navigator.pop(context);
    } catch (error) {
      print(error);

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      showMessage('Could not save the profile');
    }
  }

  Future<void> deleteProfile() async {
    final bool deleted = await deleteFamilyMember(
      context,
      profileId: widget.profileId!,
      name: firstNameController.text.trim(),
    );

    if (deleted && mounted) Navigator.pop(context);
  }

  InputDecoration fieldDecoration(String label, IconData icon,
      {String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      counterText: '',
      prefixIcon: Icon(icon, color: navy),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 8, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
      ),
    );
  }

  Widget optionChips(
    List<String> options,
    String? selected,
    ValueChanged<String> onSelected,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (String option in options)
            GestureDetector(
              onTap: () => setState(() => onSelected(option)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected == option ? navy : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0D5C3)),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selected == option ? Colors.white : navy,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget passcodeField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: hidePasscode,
      keyboardType: TextInputType.number,
      maxLength: 4,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: fieldDecoration(
        label,
        Icons.lock_outline,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              hidePasscode = !hidePasscode;
            });
          },
          icon: Icon(
            hidePasscode ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _creamBackground,
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: navy))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: navy),
                        ),
                      ),
                      profileAvatar(
                          '${firstNameController.text} '
                          '${lastNameController.text}',
                          0),
                      const SizedBox(height: 16),
                      Text(
                        isEditing ? 'Edit Profile' : 'Add Profile',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                      const SizedBox(height: 20),

                      sectionLabel('Personal Details'),
                      TextField(
                        controller: firstNameController,
                        onChanged: (value) => setState(() {}),
                        decoration: fieldDecoration(
                            'First Name', Icons.person_outline,
                            hint: 'Enter first name'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: lastNameController,
                        onChanged: (value) => setState(() {}),
                        decoration: fieldDecoration(
                            'Last Name', Icons.person_outline,
                            hint: 'Enter last name'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: birthdayController,
                        readOnly: true,
                        onTap: pickBirthday,
                        decoration: fieldDecoration(
                            'Birthday', Icons.calendar_month_outlined,
                            hint: 'dd/mm/yyyy'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: fieldDecoration(
                            'Phone (optional)', Icons.phone_outlined,
                            hint: '0501234567'),
                      ),
                      const SizedBox(height: 16),

                      if (relationship != 'Me') ...[
                        sectionLabel('Who is this profile for?'),
                        optionChips(relationshipOptions, relationship,
                            (value) => relationship = value),
                        const SizedBox(height: 16),
                      ],

                      sectionLabel('Gender'),
                      optionChips(
                          genderOptions, gender, (value) => gender = value),
                      const SizedBox(height: 16),

                      sectionLabel('Passcode'),
                      passcodeField(
                        passcodeController,
                        widget.resetPasscode
                            ? 'New 4-digit passcode'
                            : isEditing
                                ? 'New passcode (leave empty to keep)'
                                : '4-digit passcode',
                      ),
                      const SizedBox(height: 16),
                      passcodeField(confirmController, 'Confirm passcode'),
                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'SAVE',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      if (isEditing) ...[
                        const SizedBox(height: 14),
                        TextButton.icon(
                          onPressed: isSaving ? null : deleteProfile,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color(0xFFB3402C),
                          ),
                          label: const Text(
                            'Delete Profile',
                            style: TextStyle(color: Color(0xFFB3402C)),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class FamilyMembersScreen extends StatelessWidget {
  const FamilyMembersScreen({super.key});

  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);
  static const Color grey = Color(0xFF6B6255);

  Future<void> removeMember(
    BuildContext context,
    String profileId,
    String name,
  ) async {
    final bool wasCurrent = CurrentProfile.id == profileId;

    final bool deleted = await deleteFamilyMember(
      context,
      profileId: profileId,
      name: name,
    );

    if (deleted && wasCurrent && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileSelectScreen(),
        ),
        (route) => false,
      );
    }
  }

  Widget memberCard(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    int colorIndex,
  ) {
    final Map<String, dynamic> data = doc.data();
    final String name =
        '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
    final String relationship = data['relationship'] ?? '';
    final String birthday = data['birthday'] ?? '';
    final bool isCurrent = CurrentProfile.id == doc.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          profileAvatar(name, colorIndex, size: 54),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrent ? '$name (you)' : name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [relationship, birthday]
                      .where((text) => text.isNotEmpty)
                      .join(' · '),
                  style: const TextStyle(fontSize: 13, color: grey),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileFormScreen(profileId: doc.id),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined, color: navy),
          ),
          IconButton(
            tooltip: 'Remove',
            onPressed: () => removeMember(context, doc.id, name),
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFFB3402C),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(
        selectedIndex: 2,
      ),
      body: Container(
        decoration: _creamBackground,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: navy,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Family Members',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: user == null
                    ? const SizedBox()
                    : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: profilesCollection(user.uid).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Center(
                              child: Text('Could not load family members'),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(color: navy),
                            );
                          }

                          final docs = sortedProfiles(snapshot.data!.docs);
                          final bool isFull = docs.length >= maxProfiles;

                          return ListView(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
                            children: [
                              Text(
                                '${docs.length} of $maxProfiles profiles',
                                textAlign: TextAlign.center,
                                style:
                                    const TextStyle(fontSize: 13, color: grey),
                              ),
                              const SizedBox(height: 16),
                              for (int i = 0; i < docs.length; i++)
                                memberCard(context, docs[i], i),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 54,
                                child: ElevatedButton.icon(
                                  onPressed: isFull
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileFormScreen(),
                                            ),
                                          );
                                        },
                                  icon: const Icon(Icons.person_add_alt_1),
                                  label: Text(
                                    isFull
                                        ? 'Maximum of $maxProfiles profiles'
                                        : 'ADD FAMILY MEMBER',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: pinkAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Top notification (slides down from the top of the screen)
/// -----------------------------------------------------------------------
void showTopNotification(BuildContext context, String title, String message) {
  final OverlayState overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => TopNotification(
      title: title,
      message: message,
      onClose: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class TopNotification extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onClose;

  const TopNotification({
    super.key,
    required this.title,
    required this.message,
    required this.onClose,
  });

  @override
  State<TopNotification> createState() => TopNotificationState();
}

class TopNotificationState extends State<TopNotification>
    with SingleTickerProviderStateMixin {
  static const Color navy = Color(0xFF0F2A44);
  static const Color pinkAccent = Color(0xFFC9A882);

  late AnimationController controller;
  late Animation<Offset> slide;
  bool closed = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    slide = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    controller.forward();

    // Hide it by itself after 4 seconds
    Future.delayed(const Duration(seconds: 4), close);
  }

  Future<void> close() async {
    if (closed || !mounted) return;
    closed = true;
    await controller.reverse();
    widget.onClose();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: slide,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: close,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: pinkAccent, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: navy,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              color: navy,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
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
}

/// -----------------------------------------------------------------------
/// Booking confirmation email (EmailJS)
/// -----------------------------------------------------------------------
const String emailJsServiceId = 'service_bh2tf0j';
const String emailJsTemplateId = 'template_70flfqs';
const String emailJsPublicKey = '0P9R2Jr-PbRbhL5Ng';

Future<void> sendBookingEmail({
  required String doctor,
  required String sessionType,
  required String date,
  required String time,
}) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) return;

  // Get the user's first name from Firestore (if it exists)
  String userName = 'there';
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final String? firstName = doc.data()?['firstName'];
    if (firstName != null && firstName.isNotEmpty) {
      userName = firstName;
    }
  } catch (e) {
    print('Could not read user name: $e');
  }

  try {
    final response = await http
        .post(
          Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'service_id': emailJsServiceId,
            'template_id': emailJsTemplateId,
            'user_id': emailJsPublicKey,
            'template_params': {
              'to_email': user.email,
              'user_name': userName,
              'doctor': doctor,
              'session_type': sessionType,
              'date': date,
              'time': time,
            },
          }),
        )
        .timeout(const Duration(seconds: 20));
    print('Email status: ${response.statusCode} ${response.body}');
  } catch (e) {
    print('Email error: $e');
  }
}

/// -----------------------------------------------------------------------
/// "Connect Apple Health": works with just an iPhone, no watch needed.
/// The iPhone's Health app counts steps, walking, flights climbed and
/// sleep (with Bedtime / Sleep Focus). A smart scale or other apps can
/// add weight and water. Heart rate and stress need an Apple Watch.
/// -----------------------------------------------------------------------
class AppleHealthConnectCard extends StatefulWidget {
  final VoidCallback onConnected;
  final bool onChartsPage;

  const AppleHealthConnectCard({
    super.key,
    required this.onConnected,
    this.onChartsPage = false,
  });

  /// Remembered while the app is open.
  static bool connected = false;

  @override
  State<AppleHealthConnectCard> createState() => AppleHealthConnectCardState();
}

class AppleHealthConnectCardState extends State<AppleHealthConnectCard> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);
  bool connecting = false;

  Future<void> connect() async {
    setState(() => connecting = true);
    bool ok = false;
    try {
      ok = await connectAppleHealth();
    } catch (e) {
      print('Connect Apple Health error: $e');
    }
    if (!mounted) return;
    setState(() {
      connecting = false;
      AppleHealthConnectCard.connected = ok;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Showing your health data. Pull down any time to refresh.'
              : 'Apple Health is not connected yet. You can turn it on later '
                  'in the Health app: Profile > Apps > nafsi.',
        ),
      ),
    );
    if (ok) {
      widget.onConnected();
      // Go straight to the stress and eating charts.
      if (mounted && !widget.onChartsPage) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthTrendsScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AppleHealthConnectCard.connected) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF3E8E5A), size: 18),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                'Apple Health connected',
                style: TextStyle(fontSize: 13, color: navy),
              ),
            ),
            TextButton(
              onPressed: connecting ? null : connect,
              child: const Text('Manage', style: TextStyle(color: navy)),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.phone_iphone, color: navy),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'No Apple Watch? Use your iPhone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Your iPhone\'s Health app already counts your steps, walking, '
            'flights climbed and sleep. Tap below to see your stress and '
            'eating charts. Heart rate and stress still need an Apple Watch.',
            style: TextStyle(fontSize: 13, color: navy, height: 1.4),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: connecting ? null : connect,
              icon: connecting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.favorite),
              label: const Text(
                'Check your health',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// DartPad can't reach Apple Health, so this only pretends to connect.
Future<bool> connectAppleHealth() async {
  await Future.delayed(const Duration(milliseconds: 800));
  return true;
}

/// -----------------------------------------------------------------------
/// Health page: shows Apple Watch data from Apple Health
/// (heart rate, stress level, blood pressure, steps, sleep, walking).
/// -----------------------------------------------------------------------
class HealthReading {
  final int? heartRate; // bpm, latest reading
  final double? hrv; // heart rate variability (SDNN, ms), latest reading
  final int? systolic;
  final int? diastolic;
  final int steps; // today
  final int stepsYesterday;
  final double? sleepHours; // last night
  final DateTime updatedAt;
  final bool isSample;

  const HealthReading({
    required this.heartRate,
    required this.hrv,
    required this.systolic,
    required this.diastolic,
    required this.steps,
    required this.stepsYesterday,
    required this.sleepHours,
    required this.updatedAt,
    this.isSample = false,
  });
}

/// Low / Middle / High stress from the watch data.
/// Uses HRV when the watch has it (higher HRV = calmer),
/// otherwise falls back to heart rate.
String? stressLevelFrom(HealthReading reading) {
  final double? hrv = reading.hrv;
  if (hrv != null) {
    if (hrv >= 50) return 'Low';
    if (hrv >= 30) return 'Middle';
    return 'High';
  }
  final int? hr = reading.heartRate;
  if (hr != null) {
    if (hr <= 85) return 'Low';
    if (hr <= 100) return 'Middle';
    return 'High';
  }
  return null;
}

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => HealthScreenState();
}

class HealthScreenState extends State<HealthScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);
  static const Color lightGold = Color(0xFFEFE4D3);

  static const int stepGoal = 10000;
  static const double sleepGoal = 8;

  HealthReading? reading;
  String? error;
  bool isLoading = true;
  String userName = '';

  // Same data and maths as the stress and eating charts.
  final TrendData trends = TrendData();
  bool trendsReady = false;
  String overallPeriod = 'Daily'; // Daily, Weekly, Monthly

  @override
  void initState() {
    super.initState();
    loadName();
    refresh();
  }

  Future<void> loadTrends() async {
    try {
      trends.history = await loadHealthHistory();
      await trends.loadMealsAndSurvey();
      if (!mounted) return;
      setState(() => trendsReady = true);
    } catch (e) {
      print('Overall result error: $e');
    }
  }

  /// Today's stress level from the chart data (null if no heart data).
  String? get chartStressToday {
    final HealthHistory? h = trends.history;
    if (!trendsReady || h == null) return null;
    final double? p = trends.stressDay(h.days.last).percent;
    return p == null ? null : levelFromPercent(p);
  }

  /// Overall percentage for a period: today, the last 7 days or 28 days.
  double? overallPercent({required bool stress}) {
    final HealthHistory? h = trends.history;
    if (h == null) return null;
    final double? wc = trends.weightChangePercent(h.days);
    double? one(DayHealth d) =>
        stress ? trends.stressDay(d).percent : trends.eatingDay(d, wc).percent;
    if (overallPeriod == 'Daily') return one(h.days.last);
    final int n = overallPeriod == 'Weekly' ? 7 : 28;
    return trends.avg(h.days.skip(h.days.length - n).map(one));
  }

  /// The same bars as the chart for that period.
  List<ChartPoint> overallPoints({required bool stress}) {
    final HealthHistory? h = trends.history;
    if (h == null) return [];
    if (stress) {
      trends.stressPeriod = overallPeriod;
      return trends.stressPoints(h);
    }
    trends.eatingPeriod = overallPeriod;
    return trends.eatingPoints(h);
  }

  Widget miniBars(List<ChartPoint> points) {
    return SizedBox(
      height: 56,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final pt in points)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: points.length > 12 ? 0.6 : 3),
                child: Container(
                  height: pt.percent == null ? 3 : 4 + pt.percent! / 100 * 50,
                  decoration: BoxDecoration(
                    color: pt.percent == null
                        ? const Color(0xFFE5DDD0)
                        : levelColorOf(levelFromPercent(pt.percent!)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget overallHalf(String title, IconData icon, bool stress) {
    final double? p = overallPercent(stress: stress);
    final String level = p == null ? 'No data' : levelFromPercent(p);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3EC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: navy),
                const SizedBox(width: 6),
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: navy)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              p == null ? '--' : '${p.round()}%',
              style: const TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: navy),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: p == null ? Colors.grey : levelColorOf(level),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(level,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            miniBars(overallPoints(stress: stress)),
            if (stress && p == null)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('Needs an Apple Watch',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6B6255))),
              ),
          ],
        ),
      ),
    );
  }

  Widget overallCard() {
    const Map<String, String> names = {
      'Daily': 'Today',
      'Weekly': 'Week',
      'Monthly': 'Month',
    };
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              sectionTitle('Overall Result'),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E9DD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    for (final e in names.entries)
                      GestureDetector(
                        onTap: () => setState(() => overallPeriod = e.key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: overallPeriod == e.key
                                ? navy
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            e.value,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: overallPeriod == e.key
                                  ? Colors.white
                                  : navy,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (!trendsReady)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator(color: navy)),
            )
          else ...[
            Row(
              children: [
                overallHalf('Stress', Icons.favorite_border, true),
                const SizedBox(width: 12),
                overallHalf('Eating habits', Icons.restaurant_outlined, false),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthTrendsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.insights, size: 18, color: navy),
                label: const Text(
                  'See full charts',
                  style: TextStyle(color: navy, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> loadName() async {
    String name = CurrentProfile.fullName;
    if (name.isEmpty) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          final Map<String, dynamic> data = doc.data() ?? {};
          name = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
        } catch (e) {
          print('Could not read user name: $e');
        }
      }
    }
    if (!mounted) return;
    setState(() {
      userName = name.isEmpty ? 'You' : name;
    });
  }

  Future<void> refresh() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final HealthReading result = await loadHealthReading();
      if (!mounted) return;
      setState(() {
        reading = result;
        isLoading = false;
      });
      loadTrends();
    } catch (e) {
      print('Health error: $e');
      if (!mounted) return;
      setState(() {
        error = 'Could not read your health data yet. Tap "Check your '
            'health" above. An Apple Watch is not needed for steps and sleep.';
        isLoading = false;
      });
    }
  }

  Color levelColor(String? level) {
    switch (level) {
      case 'Low':
        return const Color(0xFF3E8E5A);
      case 'Middle':
        return const Color(0xFFC98A2C);
      case 'High':
        return const Color(0xFFB3402C);
      default:
        return Colors.grey;
    }
  }

  String levelTip(String? level) {
    switch (level) {
      case 'Low':
        return 'You seem calm today. Keep it up with a short walk or your daily athkar.';
      case 'Middle':
        return 'Take a short break. Try slow breathing for 5 minutes: in for 4 seconds, out for 6.';
      case 'High':
        return 'Your stress looks high. Stop for a moment, breathe slowly, and talk to someone you trust.';
      default:
        return 'Stress needs heart rate, which only an Apple Watch can measure. '
            'Your steps and sleep from your iPhone are still shown below, and '
            'you can check your stress with the GAD survey any time.';
    }
  }

  String heartText(int? hr) {
    if (hr == null) return 'No reading yet.';
    if (hr < 60) return 'Your heartbeat is lower than usual.';
    if (hr <= 100) return 'Your heartbeat is normal.';
    return 'Your heartbeat is high.';
  }

  String updatedText(DateTime date) => '${formatDate(date)} | ${formatTime(date)}';

  Widget card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: navy,
      ),
    );
  }

  Widget ring({
    required String title,
    required String value,
    required String unit,
    required double progress,
    required String footer,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3EC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: lightGold),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: navy,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 74,
              height: 74,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 74,
                    height: 74,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 7,
                      color: navy,
                      backgroundColor: lightGold,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                      Text(
                        unit,
                        style: const TextStyle(fontSize: 10, color: navy),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              footer,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: navy),
            ),
          ],
        ),
      ),
    );
  }

  Widget walkingTile(HealthReading r) {
    final int diff = r.steps - r.stepsYesterday;
    final bool more = diff >= 0;
    final int percent = r.stepsYesterday == 0
        ? 0
        : ((diff.abs() / r.stepsYesterday) * 100).round();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3EC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: lightGold),
        ),
        child: Column(
          children: [
            const Text(
              'WALKING',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: navy,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: more ? const Color(0xFFE3F0E7) : const Color(0xFFF6E2DE),
              ),
              child: Icon(
                more ? Icons.trending_up : Icons.trending_down,
                size: 36,
                color: more ? const Color(0xFF3E8E5A) : const Color(0xFFB3402C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              r.stepsYesterday == 0
                  ? 'No data from yesterday'
                  : '${more ? 'More' : 'Less'} than yesterday ($percent%)',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: navy),
            ),
          ],
        ),
      ),
    );
  }

  Widget vitalsCard(HealthReading r) {
    final String? level = chartStressToday ?? stressLevelFrom(r);
    final bool hasPressure = r.systolic != null && r.diastolic != null;

    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Your Vitals'),
          const SizedBox(height: 14),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: navy,
                child: Text(
                  profileInitials(userName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    Text(
                      'Last checked: ${updatedText(r.updatedAt)}',
                      style: const TextStyle(fontSize: 12, color: navy),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heart Rate',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: gold, size: 26),
                        const SizedBox(width: 6),
                        Text(
                          r.heartRate == null ? '--' : '${r.heartRate} bpm',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: navy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      heartText(r.heartRate),
                      style: const TextStyle(fontSize: 12, color: navy),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stress Level',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: levelColor(level),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        level ?? 'No data',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      r.hrv == null
                          ? 'Based on your heart rate'
                          : 'Based on your HRV (${r.hrv!.round()} ms)',
                      style: const TextStyle(fontSize: 12, color: navy),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30, color: lightGold, thickness: 1.2),
          Row(
            children: [
              const Text(
                'Blood Pressure',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const Spacer(),
              Text(
                hasPressure ? '${r.systolic}/${r.diastolic}' : '--',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(width: 4),
              const Text('mmHg', style: TextStyle(fontSize: 12, color: navy)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            hasPressure
                ? 'From the latest reading saved in Apple Health.'
                : 'Apple Watch can\'t measure blood pressure. Readings from a '
                    'blood pressure monitor saved in Apple Health show here.',
            style: const TextStyle(fontSize: 12, color: navy),
          ),
        ],
      ),
    );
  }

  Widget supportCard(HealthReading r) {
    final String? level = chartStressToday ?? stressLevelFrom(r);
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: levelColor(level)),
              const SizedBox(width: 8),
              sectionTitle('What you can do'),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            levelTip(level),
            style: const TextStyle(fontSize: 14, color: navy, height: 1.4),
          ),
          if (level != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointmentScreen(
                        surveyName: 'Health Monitoring',
                        severity: level,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month_outlined),
                label: const Text('Book Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget insightsCard(HealthReading r) {
    final double sleep = r.sleepHours ?? 0;
    final int sleepH = sleep.floor();
    final int sleepM = ((sleep - sleepH) * 60).round();
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Daily Insights'),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ring(
                title: 'STEPS',
                value: r.steps.toString(),
                unit: 'steps',
                progress: r.steps / stepGoal,
                footer: 'Goal: 10,000',
              ),
              const SizedBox(width: 8),
              ring(
                title: 'SLEEP',
                value: r.sleepHours == null ? '--' : sleep.toStringAsFixed(1),
                unit: 'hours',
                progress: sleep / sleepGoal,
                footer: r.sleepHours == null
                    ? 'No sleep data'
                    : 'Last night: ${sleepH}h ${sleepM}m',
              ),
              const SizedBox(width: 8),
              walkingTile(r),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HealthReading? r = reading;

    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(selectedIndex: 1),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5EFE6), Color(0xFFEBE1D2)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: navy,
            onRefresh: refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      IconButton(
                        tooltip: 'Refresh',
                        onPressed: isLoading ? null : refresh,
                        icon: const Icon(Icons.refresh, color: navy),
                      ),
                    ],
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: navy, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.monitor_heart_outlined,
                      color: navy,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Check Health Status',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'From your Apple Watch or iPhone',
                    style: TextStyle(fontSize: 15, color: navy),
                  ),
                  const SizedBox(height: 22),
                  AppleHealthConnectCard(onConnected: refresh),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(color: navy),
                    )
                  else if (error != null)
                    card(
                      child: Column(
                        children: [
                          const Icon(Icons.watch_outlined,
                              color: gold, size: 40),
                          const SizedBox(height: 10),
                          Text(
                            error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: navy, height: 1.4),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: refresh,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: navy,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    )
                  else if (r != null) ...[
                    vitalsCard(r),
                    overallCard(),
                    supportCard(r),
                    insightsCard(r),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HealthTrendsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.insights),
                        label: const Text(
                          'Check my stress & eating habits',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Last updated: ${updatedText(r.updatedAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    if (r.isSample) ...[
                      const SizedBox(height: 6),
                      const Text(
                        'Sample data. Real Apple Health data only works on an iPhone.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// DartPad can't reach Apple Health, so this shows sample numbers.
/// The Flutter version of this file reads the real data instead.
Future<HealthReading> loadHealthReading() async {
  await Future.delayed(const Duration(milliseconds: 600));
  return HealthReading(
    heartRate: 72,
    hrv: 52,
    systolic: 120,
    diastolic: 80,
    steps: 8432,
    stepsYesterday: 7520,
    sleepHours: 7.5,
    updatedAt: DateTime.now(),
    isSample: true,
  );
}

/// -----------------------------------------------------------------------
/// Stress & eating habits: charts (daily / weekly / monthly) built from
/// Apple Health + Apple Watch data, the meal log and the EDE survey.
/// These are WARNING SIGNS, not a diagnosis.
/// -----------------------------------------------------------------------
class DayHealth {
  final DateTime day;
  final double? avgHr; // bpm
  final double? restingHr; // bpm
  final double? hrv; // ms (SDNN)
  final double? respRate; // breaths per minute
  final double? bloodOxygen; // %
  final double? sleepHours;
  final double mindfulMinutes;
  final double activeCalories; // kcal
  final double exerciseMinutes;
  final int workouts;
  final int steps;
  final double? weight; // kg
  final double? waterLitres;

  const DayHealth({
    required this.day,
    this.avgHr,
    this.restingHr,
    this.hrv,
    this.respRate,
    this.bloodOxygen,
    this.sleepHours,
    this.mindfulMinutes = 0,
    this.activeCalories = 0,
    this.exerciseMinutes = 0,
    this.workouts = 0,
    this.steps = 0,
    this.weight,
    this.waterLitres,
  });
}

/// "1 AM", "12 PM", ...
String hourLabel(int hour) =>
    '${hour % 12 == 0 ? 12 : hour % 12} ${hour < 12 ? 'AM' : 'PM'}';

/// One hour of today (12 AM to 11 PM).
class PartHealth {
  final String label;
  final int startHour; // 6, 12, 18, 0
  final double? avgHr;
  final double? hrv;
  final double activeCalories;

  const PartHealth({
    required this.label,
    required this.startHour,
    this.avgHr,
    this.hrv,
    this.activeCalories = 0,
  });
}

class HealthHistory {
  final List<DayHealth> days; // oldest -> newest, last one is today
  final List<PartHealth> todayParts;
  final bool isSample;
  final double? heightCm; // latest height saved in Apple Health
  final double? latestWeight; // newest weight, even if older than 30 days
  final DateTime? latestWeightDate;

  const HealthHistory({
    required this.days,
    required this.todayParts,
    this.isSample = false,
    this.heightCm,
    this.latestWeight,
    this.latestWeightDate,
  });
}

class MealEntry {
  final String dateKey; // yyyy-mm-dd
  final String meal; // Breakfast, Lunch, Dinner, Snack
  final int hour;
  final String? recipe; // set when logged from a recipe
  final int? calories;

  const MealEntry(this.dateKey, this.meal, this.hour,
      {this.recipe, this.calories});

  String get display => recipe == null ? meal : '$meal: $recipe';
}

String dateKeyOf(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String levelFromPercent(double p) {
  if (p >= 70) return 'High';
  if (p >= 40) return 'Middle';
  return 'Low';
}

Color levelColorOf(String level) {
  switch (level) {
    case 'High':
      return const Color(0xFFB3402C);
    case 'Middle':
      return const Color(0xFFC98A2C);
    default:
      return const Color(0xFF3E8E5A);
  }
}

double _part(double? value, double from, double to) {
  if (value == null) return 0;
  return ((value - from) / (to - from)).clamp(0.0, 1.0);
}

/// Stress 0-100 from HRV, heart rate, sleep, breathing and mindful minutes.
double? stressPercent({
  double? hrv,
  double? heartRate,
  double? sleepHours,
  double? respRate,
  double mindfulMinutes = 0,
}) {
  if (hrv == null && heartRate == null) return null;
  double score = 0;
  double weight = 0;
  if (hrv != null) {
    score += _part(-hrv, -65, -20) * 40; // low HRV = more stress
    weight += 40;
  }
  if (heartRate != null) {
    score += _part(heartRate, 62, 100) * 25;
    weight += 25;
  }
  if (sleepHours != null) {
    score += _part(-sleepHours, -8, -4.5) * 25;
    weight += 25;
  }
  if (respRate != null) {
    score += _part(respRate, 15, 21) * 10;
    weight += 10;
  }
  double result = score / weight * 100;
  result -= (mindfulMinutes / 10 * 5).clamp(0.0, 10.0);
  return result.clamp(0.0, 100.0);
}

class RiskResult {
  final double percent;
  final List<String> signs;
  const RiskResult(this.percent, this.signs);
}

/// Eating habits warning signs 0-100 for one day.
RiskResult eatingRisk({
  required DayHealth day,
  required int? meals, // null = nothing logged that week
  required String? edeLevel,
  double? weightChangePercent,
}) {
  double score = 0;
  final List<String> signs = [];

  if (meals != null) {
    if (meals == 0) {
      score += 35;
      signs.add('No meals logged');
    } else if (meals == 1) {
      score += 25;
      signs.add('Only 1 meal logged');
    } else if (meals == 2) {
      score += 10;
    }
  }
  if (day.activeCalories > 800 || day.exerciseMinutes > 90) {
    score += 20;
    signs.add('Very high exercise (possible compulsive exercise)');
  } else if (day.activeCalories > 600 || day.exerciseMinutes > 60) {
    score += 8;
  }
  if (day.workouts >= 3) {
    score += 5;
    signs.add('${day.workouts} workouts in one day');
  }
  if (day.restingHr != null && day.restingHr! < 50) {
    score += 15;
    signs.add('Very low resting heart rate');
  }
  if (day.sleepHours != null && day.sleepHours! < 6) {
    score += 8;
    signs.add('Less than 6 hours of sleep');
  }
  if (weightChangePercent != null && weightChangePercent.abs() >= 2) {
    score += 12;
    signs.add('Weight changed ${weightChangePercent.toStringAsFixed(1)}% this month');
  }
  if (day.waterLitres != null && day.waterLitres! < 1) {
    score += 3;
    signs.add('Low water intake');
  }
  if (edeLevel == 'High') {
    score += 20;
    signs.add('Latest EDE survey result was High');
  } else if (edeLevel == 'Middle') {
    score += 10;
    signs.add('Latest EDE survey result was Middle');
  }
  return RiskResult(score.clamp(0.0, 100.0), signs);
}

class ChartPoint {
  final String label; // under the bar
  final String title; // in the details box
  final double? percent;
  final List<String> details;
  final List<String> signs;

  const ChartPoint({
    required this.label,
    required this.title,
    required this.percent,
    this.details = const [],
    this.signs = const [],
  });
}

/// The maths behind the stress and eating charts. Shared by the
/// Stress & Eating Habits page and the Health page, so both always
/// show the same numbers.
mixin TrendMath {
  HealthHistory? history;
  List<MealEntry> meals = [];
  String? edeLevel;
  String stressPeriod = 'Weekly'; // Daily, Weekly, Monthly
  String eatingPeriod = 'Weekly';

  Future<void> loadMealsAndSurvey() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final mealDocs = await profileRecords(user.uid, 'mealLogs').get();
      meals = [
        for (final d in mealDocs.docs)
          MealEntry(
            (d.data()['date'] ?? '') as String,
            (d.data()['meal'] ?? 'Meal') as String,
            ((d.data()['hour'] ?? 12) as num).toInt(),
            recipe: d.data()['recipe'] as String?,
            calories: (d.data()['calories'] as num?)?.toInt(),
          ),
      ];
      final edeDocs = await profileRecords(user.uid, 'edeSurveys').get();
      if (edeDocs.docs.isNotEmpty) {
        // Newest record comes first (see newestFirstId).
        final int score = (edeDocs.docs.first.data()['score'] ?? 0) as int;
        final double average = score / 22; // 22 rating questions
        edeLevel = average <= 4
            ? 'Low'
            : average <= 7
                ? 'Middle'
                : 'High';
      }
    } catch (e) {
      print('Could not load meals: $e');
    }
  }

  // ---------- helpers ----------
  /// Calories (eaten or burned) are hidden for users with a high
  /// eating-disorder risk.
  bool get hideCalories {
    if (edeLevel == 'High') return true;
    final HealthHistory? h = history;
    if (h == null) return false;
    final RiskResult r = eatingRisk(
      day: h.days.last,
      meals: mealsKnown(h.days.last.day),
      edeLevel: edeLevel,
      weightChangePercent: weightChangePercent(h.days),
    );
    return r.percent >= 70;
  }

  double? latestWeight() {
    final HealthHistory? h = history;
    if (h == null) return null;
    for (final d in h.days.reversed) {
      if (d.weight != null) return d.weight;
    }
    return h.latestWeight;
  }

  DateTime? latestWeightDate() {
    final HealthHistory? h = history;
    if (h == null) return null;
    for (final d in h.days.reversed) {
      if (d.weight != null) return d.day;
    }
    return h.latestWeightDate;
  }

  /// Today's stress, sleep, meals and warning signs, for Gemini.
  WellbeingInfo? todayInfo() {
    final HealthHistory? h = history;
    if (h == null) return null;
    final DayHealth today = h.days.last;
    final double? stress = stressDay(today).percent;
    final ChartPoint eat = eatingDay(today, weightChangePercent(h.days));
    return WellbeingInfo(
      stressLevel: stress == null ? 'Low' : levelFromPercent(stress),
      sleepHours: today.sleepHours,
      mealsToday: mealsOn(today.day),
      eatingLevel: levelFromPercent(eat.percent ?? 0),
      signs: eat.signs,
      edeLevel: edeLevel,
    );
  }

  int caloriesOn(DateTime day) => meals
      .where((m) => m.dateKey == dateKeyOf(day))
      .fold(0, (sum, m) => sum + (m.calories ?? 0));

  int mealsOn(DateTime day) =>
      meals.where((m) => m.dateKey == dateKeyOf(day)).length;

  /// null when the user logged nothing in the 7 days around this day,
  /// so a missing log is not counted as a missed meal.
  int? mealsKnown(DateTime day) {
    final bool anyNearby = meals.any((m) {
      final DateTime? d = DateTime.tryParse(m.dateKey);
      return d != null && day.difference(d).inDays.abs() <= 7;
    });
    return anyNearby ? mealsOn(day) : null;
  }

  double? weightChangePercent(List<DayHealth> days) {
    final List<double> w = [
      for (final d in days)
        if (d.weight != null) d.weight!,
    ];
    if (w.length < 2) return null;
    return (w.last - w.first) / w.first * 100;
  }

  String fmt(double? v, String unit, {int digits = 0}) =>
      v == null ? '--' : '${v.toStringAsFixed(digits)} $unit';

  String dayTitle(DateTime d) =>
      '${shortWeekdays[d.weekday - 1]}, ${shortMonths[d.month - 1]} ${d.day}';

  double? avg(Iterable<double?> values) {
    final List<double> v = [
      for (final x in values)
        if (x != null) x,
    ];
    if (v.isEmpty) return null;
    return v.reduce((a, b) => a + b) / v.length;
  }

  // ---------- stress points ----------
  ChartPoint stressDay(DayHealth d) {
    final double? p = stressPercent(
      hrv: d.hrv,
      heartRate: d.restingHr ?? d.avgHr,
      sleepHours: d.sleepHours,
      respRate: d.respRate,
      mindfulMinutes: d.mindfulMinutes,
    );
    return ChartPoint(
      label: shortWeekdays[d.day.weekday - 1],
      title: dayTitle(d.day),
      percent: p,
      details: [
        'Average heart rate: ${fmt(d.avgHr, 'bpm')}',
        'Resting heart rate: ${fmt(d.restingHr, 'bpm')}',
        'Heart rate variability: ${fmt(d.hrv, 'ms')}',
        'Sleep: ${fmt(d.sleepHours, 'hours', digits: 1)}',
        'Breathing rate: ${fmt(d.respRate, 'per min', digits: 1)}',
        'Blood oxygen: ${fmt(d.bloodOxygen, '%')}',
        'Mindful minutes: ${d.mindfulMinutes.round()}',
      ],
    );
  }

  List<ChartPoint> stressPoints(HealthHistory h) {
    if (stressPeriod == 'Daily') {
      final int nowHour = DateTime.now().hour;
      return [
        for (final part in h.todayParts)
          ChartPoint(
            label: part.label,
            title: 'Today, ${part.label} - ${hourLabel((part.startHour + 1) % 24)}',
            percent: part.startHour > nowHour
                ? null
                : stressPercent(hrv: part.hrv, heartRate: part.avgHr),
            details: part.startHour > nowHour
                ? ['This hour has not happened yet.']
                : [
                    'Average heart rate: ${fmt(part.avgHr, 'bpm')}',
                    'Heart rate variability: ${fmt(part.hrv, 'ms')}',
                  ],
          ),
      ];
    }
    if (stressPeriod == 'Weekly') {
      return [for (final d in h.days.skip(h.days.length - 7)) stressDay(d)];
    }
    return [
      for (final week in weeks(h.days))
        () {
          final List<double?> ps = [
            for (final d in week) stressDay(d).percent,
          ];
          return ChartPoint(
            label: '${week.first.day.day}/${week.first.day.month}',
            title: '${dayTitle(week.first.day)} - ${dayTitle(week.last.day)}',
            percent: avg(ps),
            details: [
              'Average resting heart rate: ${fmt(avg(week.map((d) => d.restingHr)), 'bpm')}',
              'Average HRV: ${fmt(avg(week.map((d) => d.hrv)), 'ms')}',
              'Average sleep: ${fmt(avg(week.map((d) => d.sleepHours)), 'hours', digits: 1)}',
              'High-stress days: ${ps.where((p) => p != null && p >= 70).length} of ${week.length}',
            ],
          );
        }(),
    ];
  }

  /// Last 28 days split into 4 weeks.
  List<List<DayHealth>> weeks(List<DayHealth> days) {
    final List<DayHealth> last = days.skip(days.length - 28).toList();
    return [
      for (int i = 0; i < 4; i++) last.sublist(i * 7, i * 7 + 7),
    ];
  }

  // ---------- eating points ----------
  ChartPoint eatingDay(DayHealth d, double? weightChange) {
    final int? m = mealsKnown(d.day);
    final RiskResult r = eatingRisk(
      day: d,
      meals: m,
      edeLevel: edeLevel,
      weightChangePercent: weightChange,
    );
    final List<String> mealNames = [
      for (final e in meals)
        if (e.dateKey == dateKeyOf(d.day)) e.display,
    ];
    return ChartPoint(
      label: shortWeekdays[d.day.weekday - 1],
      title: dayTitle(d.day),
      percent: r.percent,
      signs: r.signs,
      details: [
        'Meals eaten: ${m == null ? 'not logged' : '$m${mealNames.isEmpty ? '' : ' (${mealNames.reversed.join(', ')})'}'}',
        if (!hideCalories) ...[
          'Calories eaten (from recipes): ${caloriesOn(d.day)} kcal',
          'Active calories burned: ${d.activeCalories.round()} kcal',
        ],
        'Exercise: ${d.exerciseMinutes.round()} min · Workouts: ${d.workouts}',
        'Steps: ${d.steps}',
        'Resting heart rate: ${fmt(d.restingHr, 'bpm')}',
        'Sleep: ${fmt(d.sleepHours, 'hours', digits: 1)}',
        'Water: ${fmt(d.waterLitres, 'L', digits: 1)}',
        'Weight: ${fmt(d.weight, 'kg', digits: 1)}',
        'Latest EDE survey: ${edeLevel ?? 'not taken yet'}',
      ],
    );
  }

  List<ChartPoint> eatingPoints(HealthHistory h) {
    final double? wc = weightChangePercent(h.days);
    if (eatingPeriod == 'Daily') {
      final DateTime now = DateTime.now();
      final List<MealEntry> today =
          meals.where((m) => m.dateKey == dateKeyOf(now)).toList();
      // Meal check-points: by this hour, this meal should be logged.
      const Map<int, List<Object>> checks = {
        10: ['breakfast', 5, 10],
        15: ['lunch', 11, 15],
        21: ['dinner', 17, 21],
      };
      return [
        for (final part in h.todayParts)
          () {
            final int hr = part.startHour;
            final List<MealEntry> inHour =
                today.where((m) => m.hour == hr).toList();
            if (hr > now.hour) {
              return ChartPoint(
                label: part.label,
                title: 'Today, ${part.label}',
                percent: null,
                details: const ['This hour has not happened yet.'],
              );
            }
            double p = inHour.isEmpty ? 5 : 2;
            final List<String> signs = [];
            final List<Object>? check = checks[hr];
            if (check != null && now.hour > hr) {
              final int from = check[1] as int;
              final int to = check[2] as int;
              final bool eaten =
                  today.any((m) => m.hour >= from && m.hour <= to);
              if (!eaten) {
                p += 50;
                signs.add('No ${check[0]} logged by ${hourLabel(hr + 1)}');
              }
            }
            if (part.activeCalories > 250) {
              p += 25;
              signs.add('A lot of exercise in this hour');
            }
            return ChartPoint(
              label: part.label,
              title: 'Today, ${part.label} - ${hourLabel((hr + 1) % 24)}',
              percent: p.clamp(0.0, 100.0),
              signs: signs,
              details: [
                'Meals logged: ${inHour.isEmpty ? 'none' : inHour.map((m) => m.display).join(', ')}',
                if (!hideCalories)
                  'Active calories burned: ${part.activeCalories.round()} kcal',
              ],
            );
          }(),
      ];
    }
    if (eatingPeriod == 'Weekly') {
      return [
        for (final d in h.days.skip(h.days.length - 7)) eatingDay(d, wc),
      ];
    }
    return [
      for (final week in weeks(h.days))
        () {
          final List<ChartPoint> ps = [
            for (final d in week) eatingDay(d, wc),
          ];
          final int totalMeals = week.fold(0, (s, d) => s + mealsOn(d.day));
          return ChartPoint(
            label: '${week.first.day.day}/${week.first.day.month}',
            title: '${dayTitle(week.first.day)} - ${dayTitle(week.last.day)}',
            percent: avg(ps.map((p) => p.percent)),
            signs: {for (final p in ps) ...p.signs}.toList(),
            details: [
              'Meals logged: $totalMeals (about ${(totalMeals / 7).toStringAsFixed(1)} a day)',
              if (!hideCalories)
                'Average active calories burned: ${avg(week.map((d) => d.activeCalories))?.round() ?? '--'} kcal',
              'Higher-risk days: ${ps.where((p) => (p.percent ?? 0) >= 70).length} of 7',
            ],
          );
        }(),
    ];
  }

}

/// A plain holder for the chart maths, used by the Health page.
class TrendData with TrendMath {}

class HealthTrendsScreen extends StatefulWidget {
  const HealthTrendsScreen({super.key});

  @override
  State<HealthTrendsScreen> createState() => HealthTrendsScreenState();
}

class HealthTrendsScreenState extends State<HealthTrendsScreen>
    with TrendMath {
  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);
  static const Color grey = Color(0xFF6B6255);
  static const List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  bool isLoading = true;
  String? error;

  int? stressSelected;
  int? eatingSelected;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final HealthHistory h = await loadHealthHistory();
      await loadMealsAndSurvey();
      if (!mounted) return;
      setState(() {
        history = h;
        isLoading = false;
        stressSelected = null;
        eatingSelected = null;
      });
    } catch (e) {
      print('Trends error: $e');
      if (!mounted) return;
      setState(() {
        error = 'Could not read your Apple Health data. Make sure nafsi is '
            'allowed to read Apple Health.';
        isLoading = false;
      });
    }
  }

  Future<void> logMeal(String type) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final DateTime now = DateTime.now();
    try {
      await profileRecords(user.uid, 'mealLogs').doc(newestFirstId()).set({
        'date': dateKeyOf(now),
        'time': formatTime(now),
        'hour': now.hour,
        'meal': type,
      });
      setState(() {
        meals.insert(0, MealEntry(dateKeyOf(now), type, now.hour));
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$type logged. Well done for eating!')),
      );
    } catch (e) {
      print(e);
    }
  }

  // ---------- UI ----------
  Widget card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gold.withValues(alpha: 0.5)),
      ),
      child: child,
    );
  }

  Widget periodButtons(String current, ValueChanged<String> onChanged) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E9DD),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final p in const ['Daily', 'Weekly', 'Monthly'])
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(p),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: current == p ? navy : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    p,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: current == p ? Colors.white : navy,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget barChart(
    List<ChartPoint> points,
    int? selected,
    ValueChanged<int> onSelect,
    String valueName,
  ) {
    const double maxHeight = 140;
    final bool hourly = points.length > 12;

    Widget column(int i) {
      final ChartPoint pt = points[i];
      final List<String> labelParts = pt.label.split(' ');
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onSelect(i),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onSelect(i),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (selected == i && pt.percent != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${pt.percent!.round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Container(
                width: hourly ? 14 : (points.length > 5 ? 22 : 34),
                height: pt.percent == null ? 4 : 6 + pt.percent! / 100 * maxHeight,
                decoration: BoxDecoration(
                  color: pt.percent == null
                      ? Colors.grey.shade300
                      : levelColorOf(levelFromPercent(pt.percent!))
                          .withValues(alpha: selected == i ? 1 : 0.75),
                  borderRadius: BorderRadius.circular(hourly ? 5 : 8),
                  border:
                      selected == i ? Border.all(color: navy, width: 2) : null,
                ),
              ),
              const SizedBox(height: 6),
              if (hourly)
                // "3" on top, "AM" under it
                Column(
                  children: [
                    Text(
                      labelParts.first,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selected == i ? FontWeight.bold : FontWeight.normal,
                        color: navy,
                      ),
                    ),
                    Text(
                      labelParts.length > 1 ? labelParts[1] : '',
                      style: const TextStyle(fontSize: 8, color: grey),
                    ),
                  ],
                )
              else
                Text(
                  pt.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        selected == i ? FontWeight.bold : FontWeight.normal,
                    color: navy,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (hourly) {
      return SizedBox(
        height: maxHeight + 72,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < points.length; i++)
                SizedBox(width: 32, child: column(i)),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: maxHeight + 62,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < points.length; i++) Expanded(child: column(i)),
        ],
      ),
    );
  }

  Widget detailsBox(ChartPoint? point, String valueName) {
    if (point == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Text(
          'Tap or hover over a bar to see the details.',
          style: TextStyle(fontSize: 12, color: grey),
        ),
      );
    }
    final double? p = point.percent;
    final String level = p == null ? 'No data' : levelFromPercent(p);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3EC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  point.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: navy,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: p == null ? Colors.grey : levelColorOf(level),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  p == null ? level : '$level · ${p.round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$valueName: ${p == null ? 'not enough data' : '${p.round()}%'}',
            style: const TextStyle(fontSize: 12, color: grey),
          ),
          const SizedBox(height: 8),
          for (final line in point.details)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text('• $line',
                  style: const TextStyle(fontSize: 13, color: navy)),
            ),
          if (point.signs.isNotEmpty) ...[
            const SizedBox(height: 6),
            const Text(
              'Warning signs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFB3402C),
                fontSize: 13,
              ),
            ),
            for (final s in point.signs)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 15, color: Color(0xFFB3402C)),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(s,
                          style: const TextStyle(fontSize: 13, color: navy)),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget chartCard({
    required String title,
    required IconData icon,
    required String period,
    required ValueChanged<String> onPeriod,
    required List<ChartPoint> points,
    required int? selected,
    required ValueChanged<int> onSelect,
    required String valueName,
  }) {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: navy),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          periodButtons(period, onPeriod),
          if (period == 'Daily')
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Today, hour by hour. Swipe sideways to see all 24 hours.',
                style: TextStyle(fontSize: 11, color: grey),
              ),
            ),
          const SizedBox(height: 14),
          barChart(points, selected, onSelect, valueName),
          detailsBox(
            selected != null && selected < points.length
                ? points[selected]
                : null,
            valueName,
          ),
        ],
      ),
    );
  }

  Widget mealLogCard() {
    final DateTime now = DateTime.now();
    final List<MealEntry> today =
        meals.where((m) => m.dateKey == dateKeyOf(now)).toList();
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant_menu, color: navy),
              SizedBox(width: 8),
              Text(
                'Log a meal',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Meals today: ${today.length}'
            '${today.isEmpty ? '' : ' (${today.reversed.map((m) => m.display).join(', ')})'}',
            style: const TextStyle(fontSize: 13, color: navy),
          ),
          if (!hideCalories) ...[
            const SizedBox(height: 4),
            Text(
              'Calories today: ${caloriesOn(now)} kcal '
              '(from recipes you marked as eaten)',
              style: const TextStyle(fontSize: 12, color: grey),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final type in mealTypes)
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16, color: navy),
                  label: Text(type),
                  backgroundColor: const Color(0xFFF0E9DD),
                  side: const BorderSide(color: gold),
                  labelStyle: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () => logMeal(type),
                ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipesScreen(
                      hideCalories: hideCalories,
                      weightFromWatch: latestWeight(),
                      weightFromWatchDate: latestWeightDate(),
                      heightFromWatch: history?.heightCm,
                      wellbeing: todayInfo(),
                    ),
                  ),
                );
                // Meals marked as eaten on the recipe pages show up here.
                await loadMealsAndSurvey();
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.menu_book_outlined, color: navy),
              label: const Text(
                'Food recommendations',
                style: TextStyle(fontWeight: FontWeight.bold, color: navy),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: navy, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget recommendationsCard(HealthHistory h) {
    final DayHealth today = h.days.last;
    final double? stress = stressDay(today).percent;
    final ChartPoint eat = eatingDay(today, weightChangePercent(h.days));
    final String stressLevel = stress == null ? 'Low' : levelFromPercent(stress);
    final String eatLevel = levelFromPercent(eat.percent ?? 0);
    final int todayMeals = mealsOn(today.day);

    final List<String> tips = [];
    if (stressLevel == 'High') {
      tips.add('Your stress signs are high. Stop for 5 minutes and breathe slowly: in for 4 seconds, out for 6.');
    } else if (stressLevel == 'Middle') {
      tips.add('Take a short break today. A 10-minute walk or your athkar can help you calm down.');
    } else {
      tips.add('Your stress looks low today. Keep up what you are doing.');
    }
    if ((today.hrv ?? 100) < 30) {
      tips.add('Your heart rate variability is low, which often comes with stress or tiredness. Try a mindful minute on your watch.');
    }
    if ((today.sleepHours ?? 8) < 6.5) {
      tips.add('You slept less than usual. Try to go to bed at the same time tonight and keep screens away for 30 minutes before.');
    }
    if (todayMeals < 3 && DateTime.now().hour >= 14) {
      tips.add('Try to eat regular meals. Three meals a day keeps your energy and mood steady.');
    }
    if (today.activeCalories > 800 || today.exerciseMinutes > 90) {
      tips.add('You exercised a lot today. Make sure you eat enough and give your body time to rest.');
    }
    if ((today.waterLitres ?? 2) < 1) {
      tips.add('Drink more water, around 2 litres a day.');
    }
    if (eatLevel != 'Low') {
      tips.add('Some eating warning signs showed up. Taking the EDE survey again can give a clearer picture.');
    }
    tips.add('Talk to someone you trust about how you feel. You don\'t have to handle it alone.');

    final String worst = stressLevel == 'High' || eatLevel == 'High'
        ? 'High'
        : stressLevel == 'Middle' || eatLevel == 'Middle'
            ? 'Middle'
            : 'Low';

    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: navy),
              SizedBox(width: 8),
              Text(
                'Recommendations',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: gold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                          fontSize: 14, color: navy, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookAppointmentScreen(
                      surveyName: 'Health Monitoring',
                      severity: worst,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'nafsi shows warning signs only. It is not a medical diagnosis.',
            style: TextStyle(fontSize: 11, color: grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HealthHistory? h = history;

    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(selectedIndex: 1),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5EFE6), Color(0xFFEBE1D2)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: navy,
            onRefresh: refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                  ),
                  const Center(
                    child: Text(
                      'Stress & Eating Habits',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'From your Apple Watch, meal log and surveys',
                      style: TextStyle(fontSize: 13, color: navy),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: navy),
                      ),
                    )
                  else if (error != null || h == null) ...[
                    AppleHealthConnectCard(onConnected: refresh, onChartsPage: true),
                    card(
                      child: Column(
                        children: [
                          Text(
                            error ?? 'No data yet.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: navy),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: refresh,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: navy,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  ]
                  else ...[
                    AppleHealthConnectCard(onConnected: refresh, onChartsPage: true),
                    if (h.days.every((d) =>
                        d.hrv == null && d.avgHr == null && d.restingHr == null))
                      card(
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.watch_outlined, color: gold),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'No heart rate found, so the stress chart is '
                                'empty. Stress needs an Apple Watch. The eating '
                                'chart still uses your iPhone\'s steps and sleep, '
                                'your meal log and your surveys.',
                                style: TextStyle(
                                    fontSize: 13, color: navy, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    chartCard(
                      title: 'Stress',
                      icon: Icons.favorite_border,
                      period: stressPeriod,
                      onPeriod: (p) => setState(() {
                        stressPeriod = p;
                        stressSelected = null;
                      }),
                      points: stressPoints(h),
                      selected: stressSelected,
                      onSelect: (i) => setState(() => stressSelected = i),
                      valueName: 'Stress level',
                    ),
                    mealLogCard(),
                    chartCard(
                      title: 'Eating Habits',
                      icon: Icons.restaurant_outlined,
                      period: eatingPeriod,
                      onPeriod: (p) => setState(() {
                        eatingPeriod = p;
                        eatingSelected = null;
                      }),
                      points: eatingPoints(h),
                      selected: eatingSelected,
                      onSelect: (i) => setState(() => eatingSelected = i),
                      valueName: 'Eating warning signs',
                    ),
                    recommendationsCard(h),
                    if (h.isSample)
                      const Center(
                        child: Text(
                          'Sample watch data. Real Apple Health data only works on an iPhone.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// DartPad can't reach Apple Health, so this makes 30 days of sample
/// watch data that changes a little from day to day.
Future<HealthHistory> loadHealthHistory() async {
  await Future.delayed(const Duration(milliseconds: 500));
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);

  double wave(int i, int salt, double min, double max) {
    final int x = ((i + 3) * 37 + salt * 101 + (i * i) % 17) % 100;
    return min + (max - min) * x / 100;
  }

  final List<DayHealth> days = [
    for (int i = 29; i >= 0; i--)
      () {
        final int n = 29 - i;
        final bool busyDay = n % 6 == 4; // some stressful days
        return DayHealth(
          day: today.subtract(Duration(days: i)),
          avgHr: wave(n, 1, 68, 84) + (busyDay ? 12 : 0),
          restingHr: wave(n, 2, 56, 68) + (busyDay ? 8 : 0),
          hrv: wave(n, 3, 35, 70) - (busyDay ? 18 : 0),
          respRate: wave(n, 4, 13, 17) + (busyDay ? 2 : 0),
          bloodOxygen: wave(n, 5, 95, 99),
          sleepHours: wave(n, 6, 5.5, 8.5) - (busyDay ? 1.5 : 0),
          mindfulMinutes: n % 3 == 0 ? 5 : 0,
          activeCalories: wave(n, 7, 250, 650) + (n % 9 == 5 ? 450 : 0),
          exerciseMinutes: wave(n, 8, 10, 50) + (n % 9 == 5 ? 60 : 0),
          workouts: n % 9 == 5 ? 3 : (n % 2),
          steps: wave(n, 9, 4000, 11000).round(),
          weight: 60 - n * 0.02,
          waterLitres: wave(n, 10, 0.8, 2.4),
        );
      }(),
  ];

  // Today, hour by hour: calm at night, busier in the day.
  final List<PartHealth> parts = [
    for (int hour = 0; hour < 24; hour++)
      PartHealth(
        label: hourLabel(hour),
        startHour: hour,
        avgHr: hour > now.hour
            ? null
            : hour < 6
                ? 56 + (hour % 3).toDouble()
                : 66 + ((hour * 7) % 20).toDouble() + (hour == 14 ? 18 : 0),
        hrv: hour > now.hour
            ? null
            : hour < 6
                ? 64 - (hour % 3).toDouble()
                : 52 - ((hour * 5) % 22).toDouble() - (hour == 14 ? 15 : 0),
        activeCalories: hour > now.hour
            ? 0
            : hour == 18
                ? 320
                : hour >= 7 && hour <= 21
                    ? 20 + ((hour * 13) % 60).toDouble()
                    : 2,
      ),
  ];

  return HealthHistory(days: days, todayParts: parts, isSample: true);
}

/// -----------------------------------------------------------------------
/// Food recommendations: recipes from around the world, matched to the
/// user's weight and height. Calories are hidden for users with a high
/// eating-disorder risk. Nutrition numbers are approximate.
/// -----------------------------------------------------------------------
class Recipe {
  final String name;
  final String cuisine;
  final String meal; // Breakfast, Lunch, Dinner, Snack
  final List<String> groups; // nourish, balanced, light
  final String? wikiTitle; // Wikipedia article with a photo of the dish
  final String photoSearch; // backup photo search on TheMealDB
  final int minutes;
  final int calories; // per serving, approximate
  final int protein; // grams
  final int carbs; // grams
  final int fat; // grams
  final List<String> ingredients;
  final List<String> steps;
  final List<String> vitamins; // main vitamins (approximate)
  final List<String> minerals; // main minerals (approximate)
  final bool byAi; // made by Gemini
  final bool stressRelief; // helps with stress
  final bool lowCal; // light, low-calorie snack
  final bool sweet;

  const Recipe({
    required this.name,
    required this.cuisine,
    required this.meal,
    required this.groups,
    this.wikiTitle,
    required this.photoSearch,
    required this.minutes,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.steps,
    this.vitamins = const [],
    this.minerals = const [],
    this.byAi = false,
    this.stressRelief = false,
    this.lowCal = false,
    this.sweet = false,
  });
}

const List<Recipe> recipes = [
  Recipe(
    name: 'Shakshuka',
    cuisine: 'Middle East',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Shakshouka',
    photoSearch: 'Shakshuka',
    minutes: 25,
    calories: 350, protein: 20, carbs: 25, fat: 20,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A', 'Vitamin C', 'Vitamin B1'],
    minerals: ['Selenium', 'Potassium', 'Magnesium', 'Iron', 'Zinc'],
    ingredients: ['2 eggs', '2 tomatoes, chopped', '½ red pepper, sliced', '½ onion, chopped', '1 tbsp olive oil', '½ tsp cumin and paprika', '1 slice wholegrain bread'],
    steps: [
      'Cook the onion and pepper in the oil for 5 minutes.',
      'Add the tomatoes and spices and cook until thick.',
      'Make two holes and crack an egg into each.',
      'Cover and cook 5 to 7 minutes. Serve with the bread.',
    ],
  ),
  Recipe(
    name: 'Ful Medames',
    cuisine: 'Egypt',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Ful_medames',
    photoSearch: 'Ful Medames',
    minutes: 15,
    calories: 450, protein: 20, carbs: 60, fat: 14,
    vitamins: ['Vitamin C', 'Vitamin A', 'Folate (B9)', 'Vitamin B1', 'Vitamin E'],
    minerals: ['Potassium', 'Iron', 'Magnesium', 'Zinc'],
    ingredients: ['1 cup cooked fava beans', '1 tbsp olive oil', '1 garlic clove, crushed', 'Juice of ½ lemon', '½ tsp cumin', '1 tomato, diced', '1 small pita'],
    steps: [
      'Warm the beans with a splash of water and mash lightly.',
      'Stir in the garlic, lemon and cumin.',
      'Top with tomato and olive oil and serve with the pita.',
    ],
  ),
  Recipe(
    name: 'Overnight Oats with Dates',
    cuisine: 'Global',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Porridge',
    photoSearch: 'Porridge',
    minutes: 5,
    calories: 380, protein: 15, carbs: 60, fat: 9,
    stressRelief: true,
    vitamins: ['Vitamin B1', 'Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin B6'],
    minerals: ['Magnesium', 'Iron', 'Zinc', 'Calcium', 'Phosphorus'],
    ingredients: ['½ cup rolled oats', '1 cup milk or laban', '1 tbsp chia seeds', '2 dates, chopped', 'A pinch of cinnamon'],
    steps: [
      'Mix the oats, milk, chia and cinnamon in a jar.',
      'Leave in the fridge overnight.',
      'Top with the dates in the morning.',
    ],
  ),
  Recipe(
    name: 'Banana Pancakes with Honey',
    cuisine: 'USA',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Pancake',
    photoSearch: 'Pancakes',
    minutes: 20,
    calories: 520, protein: 14, carbs: 80, fat: 15,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A', 'Vitamin B2', 'Vitamin B6'],
    minerals: ['Selenium', 'Calcium', 'Phosphorus', 'Potassium', 'Magnesium'],
    ingredients: ['¾ cup flour', '1 egg', '¾ cup milk', '1 tsp baking powder', '1 banana, sliced', '1 tbsp honey'],
    steps: [
      'Whisk the flour, baking powder, egg and milk.',
      'Cook small pancakes in a lightly buttered pan, flipping once.',
      'Serve with banana and honey.',
    ],
  ),
  Recipe(
    name: 'Greek Yogurt Berry Bowl',
    cuisine: 'Greece',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Strained_yogurt',
    photoSearch: 'Yogurt',
    minutes: 5,
    calories: 260, protein: 18, carbs: 32, fat: 6,
    stressRelief: true,
    vitamins: ['Vitamin B1', 'Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin C'],
    minerals: ['Magnesium', 'Iron', 'Zinc', 'Calcium', 'Phosphorus'],
    ingredients: ['1 cup Greek yogurt', '½ cup mixed berries', '2 tbsp granola', '1 tsp honey'],
    steps: [
      'Spoon the yogurt into a bowl.',
      'Top with berries, granola and honey.',
    ],
  ),
  Recipe(
    name: 'Avocado Egg Toast',
    cuisine: 'Global',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Avocado_toast',
    photoSearch: 'Avocado',
    minutes: 10,
    calories: 420, protein: 17, carbs: 35, fat: 24,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A', 'Vitamin C', 'Vitamin B1'],
    minerals: ['Selenium', 'Magnesium', 'Iron', 'Zinc', 'Potassium'],
    ingredients: ['2 slices wholegrain bread', '½ avocado', '1 egg', 'Salt, pepper and chilli flakes', 'A squeeze of lemon'],
    steps: [
      'Toast the bread.',
      'Mash the avocado with lemon, salt and pepper.',
      'Fry or boil the egg and put it on top.',
    ],
  ),
  Recipe(
    name: 'Balaleet',
    cuisine: 'UAE',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Balaleet',
    photoSearch: 'Balaleet',
    minutes: 20,
    calories: 480, protein: 14, carbs: 70, fat: 15,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A'],
    minerals: ['Selenium', 'Iron'],
    ingredients: ['1 cup thin vermicelli', '1 tbsp sugar', 'A pinch of saffron and cardamom', '1 tsp rose water', '1 egg', '1 tsp butter'],
    steps: [
      'Boil the vermicelli for 3 minutes and drain.',
      'Mix with sugar, saffron, cardamom and rose water.',
      'Make a thin omelette in the butter.',
      'Serve the omelette on top of the vermicelli.',
    ],
  ),
  Recipe(
    name: 'Manakish with Za\'atar',
    cuisine: 'Lebanon',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Manakish',
    photoSearch: 'Manakish',
    minutes: 15,
    calories: 380, protein: 10, carbs: 50, fat: 16,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin K', 'Vitamin E'],
    minerals: ['Potassium'],
    ingredients: ['1 small flatbread', '1 tbsp za\'atar', '1 tbsp olive oil', 'Tomato, cucumber and mint'],
    steps: [
      'Mix the za\'atar with the olive oil.',
      'Spread it on the bread.',
      'Bake at 200°C for 6 to 8 minutes.',
      'Serve with the fresh vegetables.',
    ],
  ),
  Recipe(
    name: 'Halloumi & Tomato Sandwich',
    cuisine: 'Cyprus',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Halloumi',
    photoSearch: 'Halloumi',
    minutes: 10,
    calories: 400, protein: 20, carbs: 35, fat: 19,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin B1', 'Vitamin B12', 'Vitamin B2'],
    minerals: ['Potassium', 'Magnesium', 'Iron', 'Zinc', 'Calcium'],
    ingredients: ['2 slices halloumi', '1 small brown bun', '1 tomato, sliced', 'A few rocket leaves', '1 tsp olive oil'],
    steps: [
      'Grill the halloumi for 2 minutes on each side.',
      'Put it in the bun with tomato and rocket.',
      'Drizzle with the olive oil.',
    ],
  ),
  Recipe(
    name: 'Vegetable Omelette',
    cuisine: 'Global',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Omelette',
    photoSearch: 'Omelette',
    minutes: 10,
    calories: 300, protein: 20, carbs: 8, fat: 20,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A', 'Vitamin C', 'Vitamin K'],
    minerals: ['Selenium', 'Iron', 'Magnesium', 'Calcium', 'Phosphorus'],
    ingredients: ['2 eggs', 'Spinach, pepper and onion, chopped', '1 tbsp milk', '1 tsp olive oil', '1 slice bread'],
    steps: [
      'Whisk the eggs with the milk.',
      'Cook the vegetables in the oil for 2 minutes.',
      'Pour in the eggs and cook until set, then fold.',
      'Serve with the bread.',
    ],
  ),
  Recipe(
    name: 'Granola with Milk & Fruit',
    cuisine: 'Global',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Granola',
    photoSearch: 'Granola',
    minutes: 3,
    calories: 350, protein: 12, carbs: 55, fat: 10,
    vitamins: ['Vitamin B1', 'Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin B6'],
    minerals: ['Magnesium', 'Iron', 'Zinc', 'Calcium', 'Phosphorus'],
    ingredients: ['½ cup granola', '1 cup milk', '1 small banana or apple, sliced'],
    steps: [
      'Pour the granola into a bowl.',
      'Add the milk and the fruit.',
    ],
  ),
  Recipe(
    name: 'Spinach & Feta Frittata',
    cuisine: 'Italy',
    meal: 'Breakfast',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Frittata',
    photoSearch: 'Frittata',
    minutes: 20,
    calories: 330, protein: 22, carbs: 10, fat: 22,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A', 'Vitamin K', 'Folate (B9)'],
    minerals: ['Selenium', 'Iron', 'Magnesium', 'Calcium', 'Phosphorus'],
    ingredients: ['2 eggs', '1 handful spinach', '2 tbsp crumbled feta', '½ onion', '1 tsp olive oil'],
    steps: [
      'Cook the onion and spinach in the oil.',
      'Pour over the beaten eggs and add the feta.',
      'Cook on low heat with a lid for 8 minutes.',
    ],
  ),
  Recipe(
    name: 'Chicken Shawarma Bowl',
    cuisine: 'Levant',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Shawarma',
    photoSearch: 'Shawarma',
    minutes: 30,
    calories: 550, protein: 38, carbs: 55, fat: 18,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin B12', 'Vitamin B2', 'Vitamin D'],
    minerals: ['Potassium', 'Calcium', 'Phosphorus', 'Iron', 'Zinc'],
    ingredients: ['150 g chicken thigh, sliced', '1 tsp shawarma spice', '¾ cup cooked rice', 'Cucumber, tomato and lettuce', '2 tbsp garlic yogurt sauce'],
    steps: [
      'Mix the chicken with the spices and a little oil.',
      'Cook in a hot pan for 8 to 10 minutes.',
      'Serve on the rice with the salad and sauce.',
    ],
  ),
  Recipe(
    name: 'Red Lentil Soup',
    cuisine: 'Turkey',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Lentil_soup',
    photoSearch: 'Corba',
    minutes: 35,
    calories: 320, protein: 18, carbs: 48, fat: 6,
    stressRelief: true,
    vitamins: ['Folate (B9)', 'Vitamin B1', 'Vitamin C', 'Vitamin A'],
    minerals: ['Iron', 'Magnesium', 'Potassium', 'Zinc'],
    ingredients: ['½ cup red lentils', '1 carrot', '½ onion', '2½ cups water or stock', '1 tsp cumin', 'Lemon wedge'],
    steps: [
      'Simmer everything except the lemon for 25 minutes.',
      'Blend until smooth.',
      'Serve with lemon.',
    ],
  ),
  Recipe(
    name: 'Chicken Biryani',
    cuisine: 'India',
    meal: 'Lunch',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Biryani',
    photoSearch: 'Biryani',
    minutes: 50,
    calories: 650, protein: 35, carbs: 80, fat: 20,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin B6', 'Vitamin B3'],
    minerals: ['Calcium', 'Phosphorus', 'Iron', 'Zinc'],
    ingredients: ['150 g chicken', '¾ cup basmati rice', '2 tbsp yogurt', '1 tsp biryani spice', '½ fried onion', 'Mint and coriander'],
    steps: [
      'Marinate the chicken in yogurt and spices for 15 minutes.',
      'Cook the chicken for 10 minutes.',
      'Layer half-cooked rice on top with onion and herbs.',
      'Cover and cook on low heat for 20 minutes.',
    ],
  ),
  Recipe(
    name: 'Tuna Niçoise Salad',
    cuisine: 'France',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Salade_niçoise',
    photoSearch: 'Nicoise',
    minutes: 20,
    calories: 400, protein: 30, carbs: 25, fat: 20,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A', 'Vitamin C', 'Folate (B9)'],
    minerals: ['Selenium', 'Potassium', 'Iron', 'Magnesium', 'Zinc'],
    ingredients: ['1 can tuna', '1 boiled egg', '4 small boiled potatoes', 'Green beans, tomatoes and olives', '1 tbsp olive oil and lemon'],
    steps: [
      'Boil the potatoes and beans and let them cool.',
      'Arrange with the tomatoes, olives, tuna and egg.',
      'Pour the dressing over.',
    ],
  ),
  Recipe(
    name: 'Falafel Wrap',
    cuisine: 'Middle East',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Falafel',
    photoSearch: 'Falafel',
    minutes: 15,
    calories: 520, protein: 18, carbs: 65, fat: 20,
    vitamins: ['Vitamin C', 'Vitamin A', 'Folate (B9)', 'Vitamin B1', 'Vitamin E'],
    minerals: ['Potassium', 'Iron', 'Magnesium', 'Zinc'],
    ingredients: ['4 baked falafel', '1 wrap or saj bread', '2 tbsp tahini sauce', 'Lettuce, tomato, pickles'],
    steps: [
      'Warm the falafel.',
      'Spread tahini on the wrap and add salad and falafel.',
      'Roll up tightly.',
    ],
  ),
  Recipe(
    name: 'Teriyaki Salmon Rice Bowl',
    cuisine: 'Japan',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Teriyaki',
    photoSearch: 'Teriyaki',
    minutes: 25,
    calories: 520, protein: 32, carbs: 60, fat: 15,
    stressRelief: true,
    vitamins: ['Folate (B9)', 'Vitamin B1', 'Vitamin E', 'Vitamin D', 'Vitamin B12'],
    minerals: ['Iron', 'Magnesium', 'Potassium', 'Zinc', 'Selenium'],
    ingredients: ['120 g salmon', '2 tbsp teriyaki sauce', '¾ cup cooked rice', 'Cucumber, edamame and carrot', 'Sesame seeds'],
    steps: [
      'Brush the salmon with sauce and bake at 200°C for 12 minutes.',
      'Put rice and vegetables in a bowl.',
      'Add the salmon and sesame seeds.',
    ],
  ),
  Recipe(
    name: 'Fattoush with Grilled Chicken',
    cuisine: 'Levant',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Fattoush',
    photoSearch: 'Fattoush',
    minutes: 20,
    calories: 430, protein: 33, carbs: 30, fat: 18,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin B12', 'Vitamin B6', 'Vitamin B3'],
    minerals: ['Potassium', 'Iron', 'Zinc'],
    ingredients: ['120 g chicken breast', 'Lettuce, tomato, cucumber, radish', 'A handful of toasted pita pieces', '1 tbsp olive oil', 'Lemon and sumac'],
    steps: [
      'Grill the chicken and slice it.',
      'Mix the vegetables and pita.',
      'Dress with oil, lemon and sumac and add the chicken.',
    ],
  ),
  Recipe(
    name: 'Mujaddara',
    cuisine: 'Levant',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Mujaddara',
    photoSearch: 'Mujaddara',
    minutes: 40,
    calories: 470, protein: 18, carbs: 75, fat: 11,
    vitamins: ['Folate (B9)', 'Vitamin B1', 'Vitamin B12', 'Vitamin B2', 'Vitamin D'],
    minerals: ['Iron', 'Magnesium', 'Potassium', 'Zinc', 'Calcium'],
    ingredients: ['½ cup brown lentils', '⅓ cup rice', '1 onion, sliced', '1 tbsp olive oil', '½ tsp cumin', 'Yogurt and salad to serve'],
    steps: [
      'Boil the lentils for 15 minutes.',
      'Add the rice, cumin and water and cook for 18 minutes.',
      'Fry the onion until golden and put on top.',
      'Serve with yogurt and salad.',
    ],
  ),
  Recipe(
    name: 'Chicken Caesar Wrap',
    cuisine: 'USA',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Caesar_salad',
    photoSearch: 'Caesar',
    minutes: 15,
    calories: 480, protein: 32, carbs: 40, fat: 20,
    vitamins: ['Vitamin B1', 'Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin B6'],
    minerals: ['Magnesium', 'Iron', 'Zinc', 'Calcium', 'Phosphorus'],
    ingredients: ['100 g grilled chicken', '1 wholewheat wrap', 'Romaine lettuce', '1 tbsp light Caesar dressing', '1 tbsp parmesan'],
    steps: [
      'Slice the chicken.',
      'Fill the wrap with lettuce, chicken, dressing and parmesan.',
      'Roll and cut in half.',
    ],
  ),
  Recipe(
    name: 'Quinoa Tabbouleh with Chickpeas',
    cuisine: 'Lebanon',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Tabbouleh',
    photoSearch: 'Tabbouleh',
    minutes: 20,
    calories: 410, protein: 15, carbs: 58, fat: 13,
    vitamins: ['Vitamin C', 'Vitamin A', 'Folate (B9)', 'Vitamin B1', 'Vitamin K'],
    minerals: ['Potassium', 'Iron', 'Magnesium', 'Zinc'],
    ingredients: ['½ cup cooked quinoa', '½ cup chickpeas', 'Lots of parsley and mint', '1 tomato and ½ cucumber', '1 tbsp olive oil and lemon'],
    steps: [
      'Chop the herbs and vegetables finely.',
      'Mix with the quinoa and chickpeas.',
      'Dress with oil and lemon.',
    ],
  ),
  Recipe(
    name: 'Harees',
    cuisine: 'UAE',
    meal: 'Lunch',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Harees',
    photoSearch: 'Harees',
    minutes: 90,
    calories: 520, protein: 35, carbs: 60, fat: 14,
    stressRelief: true,
    vitamins: ['Vitamin B1', 'Vitamin B12', 'Vitamin B6', 'Vitamin B3'],
    minerals: ['Magnesium', 'Iron', 'Zinc'],
    ingredients: ['½ cup soaked wheat', '150 g chicken or lamb', '3 cups water', 'Salt and cinnamon', '1 tsp ghee'],
    steps: [
      'Cook the wheat and meat in the water for 1 hour.',
      'Beat well with a wooden spoon until smooth.',
      'Serve warm with a little ghee and cinnamon.',
    ],
  ),
  Recipe(
    name: 'Minestrone Soup',
    cuisine: 'Italy',
    meal: 'Lunch',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Minestrone',
    photoSearch: 'Minestrone',
    minutes: 30,
    calories: 300, protein: 12, carbs: 45, fat: 8,
    stressRelief: true,
    vitamins: ['Vitamin C', 'Vitamin A', 'Folate (B9)', 'Vitamin B1'],
    minerals: ['Potassium', 'Iron', 'Magnesium', 'Zinc'],
    ingredients: ['Carrot, celery, zucchini and onion', '½ can tomatoes', '½ cup beans', '¼ cup small pasta', '2 cups stock'],
    steps: [
      'Cook the vegetables in a little oil for 5 minutes.',
      'Add tomatoes, stock and beans and simmer 15 minutes.',
      'Add the pasta and cook 8 more minutes.',
    ],
  ),
  Recipe(
    name: 'Grilled Hammour with Vegetables',
    cuisine: 'UAE',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Fish_as_food',
    photoSearch: 'Grilled Fish',
    minutes: 30,
    calories: 380, protein: 38, carbs: 25, fat: 12,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin D', 'Vitamin B12', 'Vitamin E'],
    minerals: ['Potassium', 'Selenium', 'Iodine', 'Iron'],
    ingredients: ['150 g hammour fillet', '1 tbsp olive oil', 'Lemon, garlic and cumin', 'Zucchini, peppers, onion', '½ cup cooked rice'],
    steps: [
      'Rub the fish with oil, lemon, garlic and cumin.',
      'Grill the vegetables until soft.',
      'Grill the fish 4 minutes on each side.',
      'Serve with vegetables and rice.',
    ],
  ),
  Recipe(
    name: 'Spaghetti Bolognese',
    cuisine: 'Italy',
    meal: 'Dinner',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Bolognese_sauce',
    photoSearch: 'Bolognese',
    minutes: 40,
    calories: 620, protein: 32, carbs: 75, fat: 20,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin B12', 'Vitamin B2', 'Vitamin D'],
    minerals: ['Potassium', 'Calcium', 'Phosphorus', 'Iron', 'Zinc'],
    ingredients: ['90 g spaghetti', '120 g minced beef', '½ can tomatoes', 'Onion and garlic', 'Grated cheese'],
    steps: [
      'Cook onion and garlic, then brown the beef.',
      'Add tomatoes and simmer 20 minutes.',
      'Serve on the spaghetti with cheese.',
    ],
  ),
  Recipe(
    name: 'Chicken Machboos',
    cuisine: 'UAE',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Kabsa',
    photoSearch: 'Kabsa',
    minutes: 60,
    calories: 600, protein: 38, carbs: 70, fat: 16,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin E', 'Vitamin B12', 'Vitamin B6'],
    minerals: ['Potassium', 'Magnesium', 'Zinc', 'Iron'],
    ingredients: ['150 g chicken', '¾ cup basmati rice', '1 tsp bzar spice', '1 dried lemon (loomi)', 'Onion and tomato', 'Raisins and nuts'],
    steps: [
      'Cook onion, chicken, tomato and spices.',
      'Add water and loomi and simmer 30 minutes.',
      'Cook the rice in the broth.',
      'Serve the chicken on the rice with raisins and nuts.',
    ],
  ),
  Recipe(
    name: 'Chicken & Vegetable Stir-Fry',
    cuisine: 'China',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Stir_frying',
    photoSearch: 'Stir Fry',
    minutes: 20,
    calories: 420, protein: 35, carbs: 40, fat: 12,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin B12', 'Vitamin B6', 'Vitamin B3'],
    minerals: ['Iron', 'Zinc', 'Potassium', 'Calcium'],
    ingredients: ['150 g chicken breast', 'Broccoli, carrot, peppers', '1 tbsp soy sauce', 'Ginger and garlic', '½ cup noodles or rice'],
    steps: [
      'Cook the chicken in a hot pan for 5 minutes.',
      'Add vegetables, ginger and garlic for 4 minutes.',
      'Add soy sauce and noodles and stir well.',
    ],
  ),
  Recipe(
    name: 'Chickpea & Spinach Curry',
    cuisine: 'India',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Chana_masala',
    photoSearch: 'Chickpea',
    minutes: 30,
    calories: 480, protein: 16, carbs: 70, fat: 14,
    stressRelief: true,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin K', 'Folate (B9)', 'Vitamin B1'],
    minerals: ['Potassium', 'Iron', 'Magnesium', 'Zinc', 'Calcium'],
    ingredients: ['1 cup chickpeas', '1 cup spinach', '½ can tomatoes', '1 tsp curry powder', '2 tbsp light coconut milk', '½ cup rice'],
    steps: [
      'Cook the curry powder in a little oil.',
      'Add tomatoes, chickpeas and spinach and simmer 15 minutes.',
      'Stir in coconut milk and serve with rice.',
    ],
  ),
  Recipe(
    name: 'Baked Salmon & Sweet Potato',
    cuisine: 'Norway',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Salmon_as_food',
    photoSearch: 'Salmon',
    minutes: 35,
    calories: 550, protein: 35, carbs: 45, fat: 24,
    stressRelief: true,
    vitamins: ['Folate (B9)', 'Vitamin B1', 'Vitamin C', 'Vitamin D', 'Vitamin B12'],
    minerals: ['Iron', 'Magnesium', 'Potassium', 'Zinc', 'Selenium'],
    ingredients: ['150 g salmon', '1 sweet potato, cubed', '1 tbsp olive oil', 'Lemon and dill', 'Green beans'],
    steps: [
      'Roast the sweet potato at 200°C for 15 minutes.',
      'Add the salmon and green beans.',
      'Roast 12 more minutes with lemon and dill.',
    ],
  ),
  Recipe(
    name: 'Saloona (Vegetable & Chicken Stew)',
    cuisine: 'UAE',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Stew',
    photoSearch: 'Stew',
    minutes: 45,
    calories: 420, protein: 30, carbs: 40, fat: 14,
    stressRelief: true,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin B12', 'Vitamin B6', 'Vitamin B3'],
    minerals: ['Potassium', 'Iron', 'Zinc'],
    ingredients: ['120 g chicken', 'Potato, zucchini, carrot', '1 tomato', '1 tsp bzar spice', 'Loomi (dried lemon)', '½ cup rice'],
    steps: [
      'Brown the chicken with the spices.',
      'Add vegetables, tomato, loomi and water.',
      'Simmer 30 minutes and serve with rice.',
    ],
  ),
  Recipe(
    name: 'Chicken Shish Kebab',
    cuisine: 'Turkey',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Shish_kebab',
    photoSearch: 'Kebab',
    minutes: 30,
    calories: 450, protein: 40, carbs: 30, fat: 16,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin B12', 'Vitamin B2', 'Vitamin D'],
    minerals: ['Calcium', 'Phosphorus', 'Potassium', 'Iron', 'Zinc'],
    ingredients: ['150 g chicken cubes', '2 tbsp yogurt', 'Paprika, garlic, lemon', 'Peppers and onion', '1 small pita'],
    steps: [
      'Marinate the chicken for 20 minutes.',
      'Thread onto skewers with the vegetables.',
      'Grill 10 to 12 minutes, turning.',
      'Serve with the pita.',
    ],
  ),
  Recipe(
    name: 'Stuffed Bell Peppers',
    cuisine: 'Mediterranean',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Stuffed_peppers',
    photoSearch: 'Stuffed Peppers',
    minutes: 45,
    calories: 430, protein: 25, carbs: 45, fat: 15,
    vitamins: ['Vitamin C', 'Vitamin A', 'Vitamin B12', 'Vitamin B6', 'Vitamin B3'],
    minerals: ['Potassium', 'Iron', 'Zinc'],
    ingredients: ['2 bell peppers', '100 g minced chicken or beef', '⅓ cup cooked rice', 'Tomato sauce', 'Parsley'],
    steps: [
      'Cut off the tops and remove the seeds.',
      'Mix meat, rice, sauce and parsley and fill the peppers.',
      'Bake at 190°C for 35 minutes.',
    ],
  ),
  Recipe(
    name: 'Beef & Vegetable Tagine',
    cuisine: 'Morocco',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Tajine',
    photoSearch: 'Tagine',
    minutes: 70,
    calories: 520, protein: 35, carbs: 45, fat: 20,
    vitamins: ['Folate (B9)', 'Vitamin B1', 'Vitamin B12', 'Vitamin B6', 'Vitamin B3'],
    minerals: ['Iron', 'Magnesium', 'Potassium', 'Zinc'],
    ingredients: ['150 g beef cubes', 'Carrot, zucchini, onion', '½ cup chickpeas', 'Cumin, cinnamon, ginger', '¼ cup couscous'],
    steps: [
      'Brown the beef with the spices.',
      'Add vegetables, chickpeas and water.',
      'Simmer 1 hour and serve with couscous.',
    ],
  ),
  Recipe(
    name: 'Shrimp Fried Rice',
    cuisine: 'China',
    meal: 'Dinner',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Fried_rice',
    photoSearch: 'Fried Rice',
    minutes: 20,
    calories: 560, protein: 28, carbs: 75, fat: 16,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A'],
    minerals: ['Selenium', 'Iodine', 'Potassium'],
    ingredients: ['100 g shrimp', '1 cup cooked rice', '1 egg', 'Peas, carrot, spring onion', '1 tbsp soy sauce'],
    steps: [
      'Cook the shrimp and set aside.',
      'Scramble the egg, then add vegetables and rice.',
      'Add soy sauce and shrimp and stir.',
    ],
  ),
  Recipe(
    name: 'Mushroom & Spinach Pasta',
    cuisine: 'Italy',
    meal: 'Dinner',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Pasta',
    photoSearch: 'Pasta',
    minutes: 20,
    calories: 500, protein: 18, carbs: 70, fat: 16,
    stressRelief: true,
    vitamins: ['Vitamin K', 'Vitamin A', 'Folate (B9)', 'Vitamin B1', 'Vitamin B12'],
    minerals: ['Iron', 'Magnesium', 'Zinc', 'Calcium', 'Phosphorus'],
    ingredients: ['80 g wholewheat pasta', 'Mushrooms and spinach', '2 tbsp light cream or yogurt', 'Garlic', 'Parmesan'],
    steps: [
      'Boil the pasta.',
      'Cook garlic and mushrooms, then add spinach.',
      'Stir in the cream and pasta and top with parmesan.',
    ],
  ),
  Recipe(
    name: 'Hummus & Veggie Sticks',
    cuisine: 'Levant',
    meal: 'Snack',
    groups: ['balanced', 'light'],
    wikiTitle: 'Hummus',
    photoSearch: 'Hummus',
    minutes: 5,
    calories: 200, protein: 7, carbs: 20, fat: 10,
    lowCal: true,
    vitamins: ['Vitamin B12', 'Vitamin D', 'Vitamin A', 'Vitamin C', 'Folate (B9)'],
    minerals: ['Selenium', 'Iron', 'Magnesium', 'Potassium', 'Zinc'],
    ingredients: ['3 tbsp hummus', 'Carrot, cucumber and pepper sticks'],
    steps: [
      'Cut the vegetables into sticks.',
      'Dip into the hummus.',
    ],
  ),
  Recipe(
    name: 'Dates & Mixed Nuts',
    cuisine: 'UAE',
    meal: 'Snack',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Date_palm',
    photoSearch: 'Dates',
    minutes: 1,
    calories: 280, protein: 6, carbs: 30, fat: 16,
    stressRelief: true,
    vitamins: ['Vitamin B6', 'Vitamin E'],
    minerals: ['Potassium', 'Magnesium', 'Zinc'],
    ingredients: ['3 dates', 'A small handful of almonds and walnuts'],
    steps: [
      'Enjoy slowly with a cup of water or tea.',
    ],
  ),
  Recipe(
    name: 'Fresh Fruit Salad with Mint',
    cuisine: 'Global',
    meal: 'Snack',
    groups: ['balanced', 'light'],
    wikiTitle: 'Fruit_salad',
    photoSearch: 'Fruit',
    minutes: 10,
    calories: 150, protein: 2, carbs: 36, fat: 1,
    lowCal: true,
    vitamins: ['Vitamin C', 'Vitamin K'],
    minerals: ['Potassium'],
    ingredients: ['1 cup mixed fruit', 'A few mint leaves', 'A squeeze of lime'],
    steps: [
      'Cut the fruit.',
      'Mix with lime and chopped mint.',
    ],
  ),
  Recipe(
    name: 'Labneh & Za\'atar Toast',
    cuisine: 'Levant',
    meal: 'Snack',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Labneh',
    photoSearch: 'Toast',
    minutes: 5,
    calories: 260, protein: 10, carbs: 25, fat: 13,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin K', 'Vitamin E'],
    minerals: ['Calcium', 'Phosphorus'],
    ingredients: ['1 slice bread', '2 tbsp labneh', '1 tsp za\'atar', '1 tsp olive oil', 'Cucumber slices'],
    steps: [
      'Toast the bread.',
      'Spread labneh, add za\'atar, oil and cucumber.',
    ],
  ),
  Recipe(
    name: 'Peanut Butter Banana Smoothie',
    cuisine: 'Global',
    meal: 'Snack',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Smoothie',
    photoSearch: 'Smoothie',
    minutes: 5,
    calories: 400, protein: 15, carbs: 50, fat: 15,
    stressRelief: true,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin B6', 'Vitamin C'],
    minerals: ['Calcium', 'Phosphorus', 'Potassium', 'Magnesium', 'Zinc'],
    ingredients: ['1 banana', '1 cup milk', '1 tbsp peanut butter', '1 tsp honey', 'Ice'],
    steps: [
      'Blend everything until smooth.',
    ],
  ),
  Recipe(
    name: 'Yogurt with Honey & Walnuts',
    cuisine: 'Greece',
    meal: 'Snack',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Yogurt',
    photoSearch: 'Yogurt',
    minutes: 2,
    calories: 230, protein: 12, carbs: 20, fat: 11,
    stressRelief: true,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin E'],
    minerals: ['Calcium', 'Phosphorus', 'Magnesium', 'Zinc'],
    ingredients: ['¾ cup plain yogurt', '1 tsp honey', '4 walnut halves'],
    steps: [
      'Top the yogurt with walnuts and honey.',
    ],
  ),
  Recipe(
    name: 'Dark Chocolate & Almonds',
    cuisine: 'Global',
    meal: 'Snack',
    groups: ['balanced', 'light'],
    wikiTitle: 'Dark_chocolate',
    photoSearch: 'Chocolate',
    minutes: 1,
    calories: 160, protein: 4, carbs: 10, fat: 12,
    stressRelief: true,
    lowCal: true,
    sweet: true,
    vitamins: ['Vitamin E'],
    minerals: ['Magnesium', 'Zinc', 'Iron'],
    ingredients: ['2 small squares of dark chocolate (70% or more)', '8 almonds'],
    steps: [
      'Eat slowly and enjoy each piece. Dark chocolate and almonds have magnesium, which helps your body relax.',
    ],
  ),
  Recipe(
    name: 'Berries & Greek Yogurt Cup',
    cuisine: 'Global',
    meal: 'Snack',
    groups: ['balanced', 'light'],
    wikiTitle: 'Strawberry',
    photoSearch: 'Berries',
    minutes: 3,
    calories: 140, protein: 12, carbs: 16, fat: 3,
    stressRelief: true,
    lowCal: true,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin C'],
    minerals: ['Calcium', 'Phosphorus', 'Potassium'],
    ingredients: ['½ cup Greek yogurt', '½ cup berries', 'A drizzle of honey'],
    steps: [
      'Put the yogurt in a cup and top with berries and honey.',
    ],
  ),
  Recipe(
    name: 'Chamomile Tea & Oat Biscuit',
    cuisine: 'Global',
    meal: 'Snack',
    groups: ['balanced', 'light'],
    wikiTitle: 'Herbal_tea',
    photoSearch: 'Tea',
    minutes: 5,
    calories: 90, protein: 2, carbs: 15, fat: 3,
    stressRelief: true,
    lowCal: true,
    vitamins: ['Vitamin B1', 'Vitamin C'],
    minerals: ['Magnesium', 'Iron', 'Zinc', 'Potassium'],
    ingredients: ['1 chamomile tea bag', '1 small oat biscuit', 'A slice of lemon (optional)'],
    steps: [
      'Steep the tea in hot water for 5 minutes.',
      'Sip slowly with the biscuit. Chamomile helps you calm down.',
    ],
  ),
  Recipe(
    name: 'Air-Popped Popcorn',
    cuisine: 'USA',
    meal: 'Snack',
    groups: ['balanced', 'light'],
    wikiTitle: 'Popcorn',
    photoSearch: 'Popcorn',
    minutes: 5,
    calories: 110, protein: 3, carbs: 22, fat: 1,
    lowCal: true,
    vitamins: ['Vitamin B1'],
    minerals: ['Magnesium', 'Iron', 'Zinc'],
    ingredients: ['3 cups air-popped popcorn', 'A pinch of salt or cinnamon'],
    steps: [
      'Pop the corn without oil in a covered pot or popper.',
      'Sprinkle with salt or cinnamon.',
    ],
  ),
  Recipe(
    name: 'Edamame with Sea Salt',
    cuisine: 'Japan',
    meal: 'Snack',
    groups: ['balanced', 'light'],
    wikiTitle: 'Edamame',
    photoSearch: 'Edamame',
    minutes: 5,
    calories: 150, protein: 13, carbs: 10, fat: 6,
    stressRelief: true,
    lowCal: true,
    vitamins: ['Folate (B9)', 'Vitamin B1'],
    minerals: ['Iron', 'Magnesium', 'Potassium', 'Zinc'],
    ingredients: ['1 cup edamame in pods', 'A pinch of sea salt'],
    steps: [
      'Boil or steam for 4 minutes.',
      'Sprinkle with salt and pop the beans out.',
    ],
  ),
  Recipe(
    name: 'Banana with Cinnamon',
    cuisine: 'Global',
    meal: 'Snack',
    groups: ['balanced', 'light'],
    wikiTitle: 'Banana',
    photoSearch: 'Banana',
    minutes: 1,
    calories: 110, protein: 1, carbs: 27, fat: 0,
    stressRelief: true,
    lowCal: true,
    vitamins: ['Vitamin B6', 'Vitamin C'],
    minerals: ['Potassium', 'Magnesium', 'Iron'],
    ingredients: ['1 banana', 'A pinch of cinnamon'],
    steps: [
      'Slice the banana and sprinkle with cinnamon. Bananas have potassium and B6, which help with stress.',
    ],
  ),
  Recipe(
    name: 'Date & Oat Energy Balls',
    cuisine: 'UAE',
    meal: 'Snack',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Date_palm',
    photoSearch: 'Dates',
    minutes: 15,
    calories: 200, protein: 5, carbs: 28, fat: 8,
    sweet: true,
    vitamins: ['Vitamin B1', 'Vitamin B6', 'Vitamin E'],
    minerals: ['Magnesium', 'Iron', 'Zinc', 'Potassium'],
    ingredients: ['5 dates, pitted', '¼ cup oats', '1 tbsp peanut butter', 'Desiccated coconut'],
    steps: [
      'Blend the dates, oats and peanut butter.',
      'Roll into small balls and coat in coconut.',
      'Chill for 10 minutes.',
    ],
  ),
  Recipe(
    name: 'Mini Luqaimat (Baked)',
    cuisine: 'UAE',
    meal: 'Snack',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Luqaimat',
    photoSearch: 'Luqaimat',
    minutes: 30,
    calories: 250, protein: 5, carbs: 40, fat: 8,
    sweet: true,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin B6'],
    minerals: ['Calcium', 'Phosphorus', 'Potassium', 'Magnesium', 'Iron'],
    ingredients: ['½ cup flour', '¼ cup milk', '½ tsp yeast', 'Saffron and cardamom', '1 tbsp date syrup'],
    steps: [
      'Mix the flour, milk, yeast and spices and leave 20 minutes.',
      'Make small balls and bake at 200°C for 12 minutes.',
      'Drizzle with date syrup.',
    ],
  ),
  Recipe(
    name: 'Kunafa Cups',
    cuisine: 'Levant',
    meal: 'Snack',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Knafeh',
    photoSearch: 'Kunafa',
    minutes: 30,
    calories: 300, protein: 9, carbs: 35, fat: 14,
    sweet: true,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin E'],
    minerals: ['Calcium', 'Phosphorus', 'Magnesium', 'Zinc'],
    ingredients: ['½ cup kataifi dough', '2 tbsp soft cheese or cream', '1 tsp butter', '1 tbsp light sugar syrup', 'Crushed pistachio'],
    steps: [
      'Press the buttered kataifi into a muffin tin.',
      'Add cheese in the middle and cover with more kataifi.',
      'Bake at 190°C for 15 minutes.',
      'Add syrup and pistachio.',
    ],
  ),
  Recipe(
    name: 'Basbousa (Small Piece)',
    cuisine: 'Egypt',
    meal: 'Snack',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Basbousa',
    photoSearch: 'Basbousa',
    minutes: 40,
    calories: 260, protein: 4, carbs: 40, fat: 9,
    sweet: true,
    vitamins: ['Vitamin E'],
    minerals: ['Magnesium', 'Zinc'],
    ingredients: ['1 small square of basbousa (semolina cake)', '1 almond on top', 'A drizzle of syrup'],
    steps: [
      'Bake a tray of basbousa and cut small squares.',
      'Enjoy one piece with tea.',
    ],
  ),
  Recipe(
    name: 'Umm Ali',
    cuisine: 'Egypt',
    meal: 'Snack',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Umm_Ali',
    photoSearch: 'Umm Ali',
    minutes: 25,
    calories: 350, protein: 10, carbs: 45, fat: 14,
    sweet: true,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin E'],
    minerals: ['Calcium', 'Phosphorus', 'Magnesium', 'Zinc', 'Iron'],
    ingredients: ['1 croissant or puff pastry piece', '¾ cup milk', '1 tbsp nuts and raisins', '1 tsp sugar', 'A pinch of cinnamon'],
    steps: [
      'Break the pastry into an oven dish with the nuts and raisins.',
      'Heat the milk with sugar and pour over.',
      'Bake at 200°C for 15 minutes.',
    ],
  ),
  Recipe(
    name: 'Baked Apple with Cinnamon',
    cuisine: 'Global',
    meal: 'Snack',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Baked_apple',
    photoSearch: 'Apple',
    minutes: 30,
    calories: 150, protein: 1, carbs: 32, fat: 3,
    stressRelief: true,
    sweet: true,
    vitamins: ['Vitamin B1', 'Vitamin C'],
    minerals: ['Magnesium', 'Iron', 'Zinc', 'Potassium'],
    ingredients: ['1 apple', '1 tsp honey', 'Cinnamon', '1 tbsp oats'],
    steps: [
      'Core the apple and fill with oats, honey and cinnamon.',
      'Bake at 180°C for 25 minutes.',
    ],
  ),
  Recipe(
    name: 'Mini Fruit Tart',
    cuisine: 'France',
    meal: 'Snack',
    groups: ['nourish', 'balanced'],
    wikiTitle: 'Fruit_tart',
    photoSearch: 'Tart',
    minutes: 20,
    calories: 280, protein: 5, carbs: 35, fat: 13,
    sweet: true,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin C'],
    minerals: ['Calcium', 'Phosphorus', 'Potassium'],
    ingredients: ['1 small tart shell', '2 tbsp custard or yogurt', 'Strawberries, kiwi or grapes'],
    steps: [
      'Fill the shell with custard.',
      'Arrange the fruit on top.',
    ],
  ),
  Recipe(
    name: 'Mahalabia (Milk Pudding)',
    cuisine: 'Levant',
    meal: 'Snack',
    groups: ['nourish', 'balanced', 'light'],
    wikiTitle: 'Muhallebi',
    photoSearch: 'Pudding',
    minutes: 15,
    calories: 220, protein: 7, carbs: 35, fat: 6,
    stressRelief: true,
    sweet: true,
    vitamins: ['Vitamin B12', 'Vitamin B2', 'Vitamin D', 'Vitamin E'],
    minerals: ['Calcium', 'Phosphorus', 'Magnesium', 'Zinc'],
    ingredients: ['1 cup milk', '1½ tbsp cornflour', '1 tbsp sugar', '1 tsp rose water', 'Pistachio to top'],
    steps: [
      'Whisk the milk, cornflour and sugar and heat until thick.',
      'Add rose water and pour into a cup.',
      'Chill and top with pistachio.',
    ],
  ),
];

/// What we know about the user today, sent to Gemini with the recipes.
class WellbeingInfo {
  final String stressLevel; // Low, Middle, High
  final double? sleepHours;
  final int mealsToday;
  final String eatingLevel; // Low, Middle, High
  final List<String> signs;
  final String? edeLevel;

  const WellbeingInfo({
    required this.stressLevel,
    this.sleepHours,
    required this.mealsToday,
    required this.eatingLevel,
    this.signs = const [],
    this.edeLevel,
  });
}

/// Gemini's answer: a short summary plus recipes.
class RecipeIdeas {
  final String summary;
  final List<Recipe> recipes;
  const RecipeIdeas({required this.summary, required this.recipes});
}

/// Small labels under a recipe. Low calorie is never mentioned to users
/// who are underweight or at high eating-disorder risk.
List<String> recipeLabels(Recipe r, {required bool hideCalories, required String group}) {
  final bool showLowCal = r.lowCal && !hideCalories && group != 'nourish';
  return [
    if (r.stressRelief) showLowCal ? 'Stress relief · low calorie' : 'Stress relief',
    if (!r.stressRelief && showLowCal) 'Low calorie',
    if (r.sweet) 'Sweet',
  ];
}

Widget labelChip(String text) {
  final bool stress = text.startsWith('Stress');
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: stress ? const Color(0xFFE3F0E7) : const Color(0xFFF6E9D7),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: stress ? const Color(0xFF3E8E5A) : const Color(0xFF8A6A3E),
      ),
    ),
  );
}

/// -----------------------------------------------------------------------
/// Height & Weight (Settings). Saved per profile and used for the food
/// recommendations. Can be filled from Apple Health.
/// -----------------------------------------------------------------------
class BodyInfoScreen extends StatefulWidget {
  const BodyInfoScreen({super.key});

  @override
  State<BodyInfoScreen> createState() => BodyInfoScreenState();
}

class BodyInfoScreenState extends State<BodyInfoScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);
  static const Color grey = Color(0xFF6B6255);

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  bool isLoading = true;
  bool isSaving = false;
  bool isReadingHealth = false;
  String? lastUpdated;
  String? activity;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc =
            await profileRecords(user.uid, 'bodyInfo').doc('current').get();
        final Map<String, dynamic> data = doc.data() ?? {};
        if (data['weight'] != null) {
          weightController.text = (data['weight'] as num).toStringAsFixed(0);
        }
        if (data['height'] != null) {
          heightController.text = (data['height'] as num).toStringAsFixed(0);
        }
        lastUpdated = data['updated'] as String?;
        activity = data['activity'] as String?;
      } catch (e) {
        print(e);
      }
    }
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> fillFromHealth() async {
    setState(() => isReadingHealth = true);
    try {
      final HealthHistory h = await loadHealthHistory();
      double? weight;
      for (final d in h.days.reversed) {
        if (d.weight != null) {
          weight = d.weight;
          break;
        }
      }
      weight ??= h.latestWeight;
      if (!mounted) return;
      setState(() {
        if (weight != null) weightController.text = weight.toStringAsFixed(0);
        if (h.heightCm != null) {
          heightController.text = h.heightCm!.toStringAsFixed(0);
        }
        isReadingHealth = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            weight == null && h.heightCm == null
                ? 'No weight or height is saved in Apple Health yet.'
                : 'Filled from Apple Health. Press Save to keep it.',
          ),
        ),
      );
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() => isReadingHealth = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read Apple Health.')),
      );
    }
  }

  Future<void> save() async {
    final double? weight = double.tryParse(weightController.text.trim());
    final double? height = double.tryParse(heightController.text.trim());
    if (weight == null || weight < 20 || weight > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a weight in kg.')),
      );
      return;
    }
    if (height == null || height < 80 || height > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a height in cm.')),
      );
      return;
    }
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => isSaving = true);
    final DateTime now = DateTime.now();
    try {
      await profileRecords(user.uid, 'bodyInfo').doc('current').set({
        'weight': weight,
        'height': height,
        'updated': formatDate(now),
        'savedAt': now.millisecondsSinceEpoch,
        if (activity != null) 'activity': activity,
      }, SetOptions(merge: true));
      if (!mounted) return;
      setState(() {
        isSaving = false;
        lastUpdated = formatDate(now);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Height and weight saved.')),
      );
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() => isSaving = false);
    }
  }

  Widget numberField(
      TextEditingController controller, String label, String unit, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        prefixIcon: Icon(icon, color: navy),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(selectedIndex: 2),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5EFE6), Color(0xFFEBE1D2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                ),
                const Center(
                  child: Icon(Icons.monitor_weight_outlined,
                      color: navy, size: 44),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Height & Weight',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Used to choose food recommendations and work out your daily needs.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: navy),
                  ),
                ),
                const SizedBox(height: 26),
                if (isLoading)
                  const Center(child: CircularProgressIndicator(color: navy))
                else ...[
                  numberField(weightController, 'Weight', 'kg',
                      Icons.monitor_weight_outlined),
                  const SizedBox(height: 16),
                  numberField(heightController, 'Height', 'cm', Icons.height),
                  const SizedBox(height: 20),
                  const Text(
                    'How active are you?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (int i = 0; i < activityLevels.length; i++)
                    GestureDetector(
                      onTap: () => setState(() => activity = activityLevels[i]),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: activity == activityLevels[i]
                              ? navy
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: activity == activityLevels[i] ? navy : gold,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activityLevels[i],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: activity == activityLevels[i]
                                    ? Colors.white
                                    : navy,
                              ),
                            ),
                            Text(
                              activityHints[i],
                              style: TextStyle(
                                fontSize: 12,
                                color: activity == activityLevels[i]
                                    ? Colors.white70
                                    : grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (lastUpdated != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: $lastUpdated',
                      style: const TextStyle(fontSize: 12, color: grey),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: isReadingHealth ? null : fillFromHealth,
                      icon: isReadingHealth
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: navy),
                            )
                          : const Icon(Icons.favorite_border, color: navy),
                      label: const Text(
                        'Fill from Apple Health',
                        style: TextStyle(
                            color: navy, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: gold, width: 1.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Weight comes from Apple Health automatically when a smart '
                    'scale or the Health app has saved one. The Apple Watch '
                    'itself can\'t measure weight.',
                    style: TextStyle(fontSize: 12, color: grey, height: 1.4),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Daily needs: Gemini calculates calories, macros, vitamins and minerals
/// from age, sex, height, weight and activity level.
/// Never shown to users at high eating-disorder risk.
/// -----------------------------------------------------------------------
const List<String> activityLevels = [
  'Not active',
  'Lightly active',
  'Moderately active',
  'Very active',
  'Extremely active',
];

const List<String> activityHints = [
  'Mostly sitting, little exercise',
  'Light exercise 1 to 3 days a week',
  'Exercise 3 to 5 days a week',
  'Hard exercise 6 to 7 days a week',
  'Very hard exercise or a physical job',
];

class NutritionTargets {
  final bool under18;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final double water; // litres
  final List<String> vitamins; // "Vitamin C: 75 mg"
  final List<String> minerals; // "Iron: 18 mg"
  final String method;
  final String explanation;

  const NutritionTargets({
    this.under18 = false,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.fiber = 0,
    this.water = 0,
    this.vitamins = const [],
    this.minerals = const [],
    this.method = '',
    this.explanation = '',
  });

  Map<String, dynamic> toMap() => {
        'under18': under18,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'fiber': fiber,
        'water': water,
        'vitamins': vitamins,
        'minerals': minerals,
        'method': method,
        'explanation': explanation,
      };

  static NutritionTargets fromMap(Map data) {
    int n(dynamic v) => v is num ? v.round() : int.tryParse('$v') ?? 0;
    return NutritionTargets(
      under18: data['under18'] == true,
      calories: n(data['calories']),
      protein: n(data['protein']),
      carbs: n(data['carbs']),
      fat: n(data['fat']),
      fiber: n(data['fiber']),
      water: (data['water'] is num) ? (data['water'] as num).toDouble() : 0,
      vitamins: [for (final v in (data['vitamins'] as List? ?? [])) v.toString()],
      minerals: [for (final m in (data['minerals'] as List? ?? [])) m.toString()],
      method: (data['method'] ?? '').toString(),
      explanation: (data['explanation'] ?? '').toString(),
    );
  }
}

/// What the user ate today (from the meal log).
class DayTotals {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int meals;
  const DayTotals(this.calories, this.protein, this.carbs, this.fat, this.meals);
}

Future<DayTotals> loadTodayTotals() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return const DayTotals(0, 0, 0, 0, 0);
  final String today = dateKeyOf(DateTime.now());
  int cal = 0, p = 0, c = 0, f = 0, meals = 0;
  try {
    final docs = await profileRecords(user.uid, 'mealLogs').get();
    for (final d in docs.docs) {
      final Map<String, dynamic> data = d.data();
      if (data['date'] != today) continue;
      meals++;
      cal += ((data['calories'] ?? 0) as num).toInt();
      p += ((data['protein'] ?? 0) as num).toInt();
      c += ((data['carbs'] ?? 0) as num).toInt();
      f += ((data['fat'] ?? 0) as num).toInt();
    }
  } catch (e) {
    print(e);
  }
  return DayTotals(cal, p, c, f, meals);
}

/// Age in years from "d/m/yyyy", or null.
int? ageFromBirthday(String? birthday) {
  if (birthday == null) return null;
  final List<String> parts = birthday.split('/');
  if (parts.length != 3) return null;
  final int? d = int.tryParse(parts[0]);
  final int? m = int.tryParse(parts[1]);
  final int? y = int.tryParse(parts[2]);
  if (d == null || m == null || y == null) return null;
  final DateTime now = DateTime.now();
  int age = now.year - y;
  if (now.month < m || (now.month == m && now.day < d)) age--;
  return age;
}

/// Birthday and gender of the profile that is open now.
Future<Map<String, dynamic>> currentProfileDetails() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return {};
  try {
    if (CurrentProfile.id != null) {
      final doc =
          await profilesCollection(user.uid).doc(CurrentProfile.id).get();
      final Map<String, dynamic> data = doc.data() ?? {};
      if (data.isNotEmpty) return data;
    }
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data() ?? {};
  } catch (e) {
    print(e);
    return {};
  }
}

/// Loads saved targets, or asks Gemini when something changed.
/// Returns null if age, sex, height, weight or activity is missing.
Future<NutritionTargets?> loadDailyNeeds({
  required double? weight,
  required double? height,
  bool forceNew = false,
}) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null || weight == null || height == null) return null;
  final Map<String, dynamic> profile = await currentProfileDetails();
  final int? age = ageFromBirthday(profile['birthday'] as String?);
  final String? sex = profile['gender'] as String?;
  final doc = await profileRecords(user.uid, 'bodyInfo').doc('current').get();
  final Map<String, dynamic> body = doc.data() ?? {};
  final String? activity = body['activity'] as String?;
  if (age == null || sex == null || activity == null) return null;

  final String inputs =
      '$age|$sex|${height.round()}|${weight.round()}|$activity';
  if (!forceNew && body['targetsFor'] == inputs && body['targets'] is Map) {
    return NutritionTargets.fromMap(body['targets'] as Map);
  }
  final NutritionTargets t = await GeminiService.calculateDailyNeeds(
    age: age,
    sex: sex,
    heightCm: height,
    weightKg: weight,
    activity: activity,
  );
  await profileRecords(user.uid, 'bodyInfo').doc('current').set({
    'targets': t.toMap(),
    'targetsFor': inputs,
  }, SetOptions(merge: true));
  return t;
}

const Map<String, IconData> mealIcons = {
  'Breakfast': Icons.free_breakfast_outlined,
  'Lunch': Icons.lunch_dining_outlined,
  'Dinner': Icons.dinner_dining_outlined,
  'Snack': Icons.cookie_outlined,
};

/// nourish = more energy, balanced, light = lighter balanced meals.
String foodGroupFor(double? weight, double? heightCm, bool highRisk) {
  if (weight == null || heightCm == null || heightCm <= 0) return 'balanced';
  final double bmi = weight / ((heightCm / 100) * (heightCm / 100));
  if (bmi < 18.5) return 'nourish';
  // Never suggest lighter meals to someone with a high eating-disorder risk.
  if (bmi >= 25 && !highRisk) return 'light';
  return 'balanced';
}

/// Picture of a recipe, looked up on TheMealDB (free recipe database).
/// Shows a styled placeholder if no picture is found or it can't load.
class RecipePhoto extends StatefulWidget {
  final Recipe recipe;
  final double height;
  final double radius;

  const RecipePhoto({
    super.key,
    required this.recipe,
    this.height = 120,
    this.radius = 16,
  });

  static final Map<String, String?> cache = {};

  @override
  State<RecipePhoto> createState() => RecipePhotoState();
}

class RecipePhotoState extends State<RecipePhoto> {
  String? url;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final String key = '${widget.recipe.wikiTitle}|${widget.recipe.photoSearch}';
    if (RecipePhoto.cache.containsKey(key)) {
      setState(() => url = RecipePhoto.cache[key]);
      return;
    }
    String? found;
    // 1. A real photo of the dish from its Wikipedia article.
    final String? wiki = widget.recipe.wikiTitle;
    if (wiki != null && wiki.isNotEmpty) {
      try {
        final response = await http
            .get(Uri.parse(
                'https://en.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(wiki)}'))
            .timeout(const Duration(seconds: 8));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          found = (data['thumbnail'] as Map?)?['source'] as String?;
        }
      } catch (e) {
        print('Wikipedia photo error: $e');
      }
    }
    // 2. Backup: TheMealDB recipe photos.
    if (found == null) {
      try {
        final response = await http
            .get(Uri.parse(
                'https://www.themealdb.com/api/json/v1/1/search.php?s=${Uri.encodeComponent(widget.recipe.photoSearch)}'))
            .timeout(const Duration(seconds: 8));
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List? meals = data['meals'] as List?;
        if (meals != null && meals.isNotEmpty) {
          found = meals.first['strMealThumb'] as String?;
        }
      } catch (e) {
        print('TheMealDB photo error: $e');
      }
    }
    RecipePhoto.cache[key] = found;
    if (!mounted) return;
    setState(() => url = found);
  }

  Widget placeholder() {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE9DCC6), Color(0xFFC9A882)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        mealIcons[widget.recipe.meal] ?? Icons.restaurant,
        size: widget.height / 2.6,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? u = url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: u == null
          ? placeholder()
          : Image.network(
              u,
              height: widget.height,
              width: double.infinity,
              fit: BoxFit.cover,
              webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
              errorBuilder: (context, error, stack) => placeholder(),
            ),
    );
  }
}

class RecipesScreen extends StatefulWidget {
  final bool hideCalories;
  final double? weightFromWatch;
  final DateTime? weightFromWatchDate;
  final double? heightFromWatch;
  final WellbeingInfo? wellbeing;

  const RecipesScreen({
    super.key,
    required this.hideCalories,
    this.weightFromWatch,
    this.weightFromWatchDate,
    this.heightFromWatch,
    this.wellbeing,
  });

  @override
  State<RecipesScreen> createState() => RecipesScreenState();
}

class RecipesScreenState extends State<RecipesScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);
  static const Color grey = Color(0xFF6B6255);

  String meal = 'Breakfast';
  double? weight;
  double? height;
  bool loaded = false;

  // New recipes from Gemini, per meal and weight group.
  final Map<String, List<Recipe>> aiRecipes = {};
  bool generating = false;
  String? aiSummary;

  // Daily needs (from Gemini) and what was eaten today.
  NutritionTargets? targets;
  DayTotals today = const DayTotals(0, 0, 0, 0, 0);
  bool needsLoading = false;
  bool needsMissingInfo = false;
  String? needsError;

  Future<void> loadNeeds({bool forceNew = false}) async {
    if (widget.hideCalories) return; // never shown to high-risk users
    setState(() {
      needsLoading = true;
      needsError = null;
    });
    try {
      final DayTotals totals = await loadTodayTotals();
      final NutritionTargets? t = await loadDailyNeeds(
        weight: weight,
        height: height,
        forceNew: forceNew,
      );
      if (!mounted) return;
      setState(() {
        today = totals;
        targets = t;
        needsMissingInfo = t == null;
        needsLoading = false;
      });
    } catch (e) {
      print('Daily needs error: $e');
      if (!mounted) return;
      setState(() {
        needsLoading = false;
        needsError = 'Gemini could not work out your daily needs right now.';
      });
    }
  }

  Future<void> refreshTodayTotals() async {
    final DayTotals totals = await loadTodayTotals();
    if (mounted) setState(() => today = totals);
  }

  Widget progressRow(String name, int eaten, int target, String unit) {
    final double v = target <= 0 ? 0 : (eaten / target).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: navy)),
              const Spacer(),
              Text('$eaten / $target $unit',
                  style: const TextStyle(fontSize: 12, color: grey)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: v,
              minHeight: 8,
              color: navy,
              backgroundColor: const Color(0xFFEFE4D3),
            ),
          ),
        ],
      ),
    );
  }

  Widget dailyNeedsCard() {
    final NutritionTargets? t = targets;
    Widget box(Widget child) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: gold.withValues(alpha: 0.5)),
          ),
          child: child,
        );
    const Widget title = Row(
      children: [
        Icon(Icons.local_fire_department_outlined, color: navy),
        SizedBox(width: 8),
        Text(
          'Your daily needs',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: navy,
          ),
        ),
      ],
    );
    if (needsLoading) {
      return box(const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: navy),
          ),
          SizedBox(width: 10),
          Text('Gemini is working out your daily needs...',
              style: TextStyle(color: navy)),
        ],
      ));
    }
    if (needsMissingInfo || needsError != null) {
      return box(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 8),
          Text(
            needsError ??
                'Add your height, weight and activity level (and a birthday and '
                    'gender in your profile) so Gemini can work out your daily needs.',
            style: const TextStyle(fontSize: 13, color: navy, height: 1.4),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              if (needsError != null) {
                loadNeeds();
                return;
              }
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BodyInfoScreen()),
              );
              loadBody();
            },
            icon: Icon(needsError != null ? Icons.refresh : Icons.edit,
                color: navy),
            label: Text(
              needsError != null ? 'Try again' : 'Add height, weight & activity',
              style: const TextStyle(color: navy, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ));
    }
    if (t == null) return const SizedBox.shrink();
    if (t.under18) {
      return box(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 8),
          Text(t.explanation,
              style: const TextStyle(fontSize: 13, color: navy, height: 1.4)),
        ],
      ));
    }
    final int left = t.calories - today.calories;
    return box(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 10),
        Text(
          left >= 0
              ? 'Today: ${today.calories} of ${t.calories} kcal · $left kcal left'
              : 'Today: ${today.calories} of ${t.calories} kcal',
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: navy),
        ),
        const SizedBox(height: 8),
        progressRow('Calories', today.calories, t.calories, 'kcal'),
        progressRow('Protein', today.protein, t.protein, 'g'),
        progressRow('Carbs', today.carbs, t.carbs, 'g'),
        progressRow('Fat', today.fat, t.fat, 'g'),
        Text('Fiber: ${t.fiber} g  ·  Water: ${t.water.toStringAsFixed(1)} L',
            style: const TextStyle(fontSize: 12, color: grey)),
        if (t.vitamins.isNotEmpty) ...[
          const SizedBox(height: 10),
          const Text('Vitamins per day',
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: navy)),
          const SizedBox(height: 4),
          Text(t.vitamins.join('  ·  '),
              style: const TextStyle(fontSize: 12, color: grey, height: 1.5)),
        ],
        if (t.minerals.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text('Minerals per day',
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: navy)),
          const SizedBox(height: 4),
          Text(t.minerals.join('  ·  '),
              style: const TextStyle(fontSize: 12, color: grey, height: 1.5)),
        ],
        if (t.explanation.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(t.explanation,
              style: const TextStyle(fontSize: 13, color: navy, height: 1.4)),
        ],
        if (t.method.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text('How Gemini worked it out: ${t.method}',
              style: const TextStyle(fontSize: 11, color: grey)),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => loadNeeds(forceNew: true),
            icon: const Icon(Icons.refresh, size: 16, color: navy),
            label: const Text('Recalculate',
                style: TextStyle(color: navy, fontSize: 12)),
          ),
        ),
      ],
    ));
  }

  /// Calming foods go first when stress is Middle or High.
  bool get stressFirst {
    final String level = widget.wellbeing?.stressLevel ?? 'Low';
    return level == 'High' || level == 'Middle';
  }

  String get listKey => '${meal}_$group';

  /// Asks Gemini for new recipes. Keeps the current ones if it fails.
  Future<void> newRecipes() async {
    if (generating) return;
    setState(() => generating = true);
    final List<String> shown = [
      for (final r in recipes)
        if (r.meal == meal) r.name,
      for (final r in aiRecipes[listKey] ?? <Recipe>[]) r.name,
    ];
    try {
      final RecipeIdeas ideas = await GeminiService.generateRecipes(
        meal: meal,
        group: group,
        highRisk: widget.hideCalories,
        avoidNames: shown,
        info: widget.wellbeing,
      );
      if (ideas.recipes.isEmpty) throw Exception('No recipes');
      if (!mounted) return;
      setState(() {
        aiRecipes[listKey] = ideas.recipes;
        if (ideas.summary.isNotEmpty) aiSummary = ideas.summary;
        generating = false;
      });
    } catch (e) {
      print('Recipe AI error: $e');
      if (!mounted) return;
      setState(() => generating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Could not get new recipes right now. Please try again in a minute.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final int hour = DateTime.now().hour;
    meal = hour < 11
        ? 'Breakfast'
        : hour < 16
            ? 'Lunch'
            : hour < 21
                ? 'Dinner'
                : 'Snack';
    weight = widget.weightFromWatch;
    height = widget.heightFromWatch;
    loadBody();
  }

  Future<void> loadBody() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc =
            await profileRecords(user.uid, 'bodyInfo').doc('current').get();
        final Map<String, dynamic> data = doc.data() ?? {};
        if (data['height'] != null) height = (data['height'] as num).toDouble();
        height ??= widget.heightFromWatch;
        // Use the number the user typed if it is newer than Apple Health.
        final int savedAt = ((data['savedAt'] ?? 0) as num).toInt();
        final int watchAt =
            widget.weightFromWatchDate?.millisecondsSinceEpoch ?? 0;
        if (data['weight'] != null &&
            (widget.weightFromWatch == null || savedAt > watchAt)) {
          weight = (data['weight'] as num).toDouble();
        }
      } catch (e) {
        print(e);
      }
    }
    if (!mounted) return;
    setState(() => loaded = true);
    if (height == null || weight == null) {
      editBody();
    } else {
      loadNeeds();
    }
  }

  Future<void> editBody() async {
    final TextEditingController w =
        TextEditingController(text: weight?.toStringAsFixed(0) ?? '');
    final TextEditingController h =
        TextEditingController(text: height?.toStringAsFixed(0) ?? '');
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Your weight and height'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'We use these only to choose recipes that fit you.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: w,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                helperText: widget.weightFromWatch != null
                    ? 'From Apple Health (you can change it)'
                    : null,
              ),
            ),
            TextField(
              controller: h,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved != true) return;
    final double? newW = double.tryParse(w.text.trim());
    final double? newH = double.tryParse(h.text.trim());
    setState(() {
      if (newW != null) weight = newW;
      if (newH != null) height = newH;
    });
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await profileRecords(user.uid, 'bodyInfo').doc('current').set({
        'weight': weight,
        'height': height,
        'updated': formatDate(DateTime.now()),
        'savedAt': DateTime.now().millisecondsSinceEpoch,
      }, SetOptions(merge: true));
      loadNeeds();
    } catch (e) {
      print(e);
    }
  }

  String get group => foodGroupFor(weight, height, widget.hideCalories);

  String get groupText {
    if (widget.hideCalories) {
      return 'These recipes are chosen to help you eat regular, nourishing '
          'meals. Try not to skip any meal today.';
    }
    switch (group) {
      case 'nourish':
        return 'Your weight looks a little low for your height, so these '
            'recipes give you more energy. Enjoy a full portion and add a '
            'snack between meals.';
      case 'light':
        return 'These are balanced, lighter recipes. Fill half your plate '
            'with vegetables and keep eating three regular meals. Please '
            'don\'t skip meals.';
      default:
        return 'Your weight looks healthy for your height. These balanced '
            'recipes help you keep it that way.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool noLowCal = group == 'nourish' || widget.hideCalories;
    final List<Recipe> list = aiRecipes[listKey] ??
        recipes
            .where((r) =>
                r.meal == meal &&
                r.groups.contains(group) &&
                !(r.lowCal && noLowCal))
            .toList();
    if (stressFirst) {
      // Calming foods first when stress is high.
      list.sort((a, b) =>
          (b.stressRelief ? 1 : 0).compareTo(a.stressRelief ? 1 : 0));
    }
    final bool showingAi = aiRecipes.containsKey(listKey);

    return Scaffold(
      bottomNavigationBar: const NafsiBottomNavigationBar(selectedIndex: 1),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5EFE6), Color(0xFFEBE1D2)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: navy,
            onRefresh: newRecipes,
            child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.arrow_back_ios_new, color: navy),
                ),
                const Center(
                  child: Text(
                    'Food Recommendations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Recipes from around the world, chosen for you',
                    style: TextStyle(fontSize: 13, color: navy),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: gold.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, color: navy),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.hideCalories
                                  ? 'Your meal plan'
                                  : 'Weight: ${weight == null ? '--' : '${weight!.toStringAsFixed(0)} kg'}'
                                      '  ·  Height: ${height == null ? '--' : '${height!.toStringAsFixed(0)} cm'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: navy,
                              ),
                            ),
                          ),
                          if (!widget.hideCalories)
                            TextButton(
                              onPressed: editBody,
                              child: const Text('Edit'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        groupText,
                        style: const TextStyle(
                            fontSize: 13, color: navy, height: 1.4),
                      ),
                    ],
                  ),
                ),
                if (!widget.hideCalories) dailyNeedsCard(),
                if (aiSummary != null || stressFirst) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2A44),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          aiSummary != null
                              ? Icons.auto_awesome
                              : Icons.self_improvement,
                          color: gold,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            aiSummary ??
                                'Your stress looks ${widget.wellbeing?.stressLevel.toLowerCase()} '
                                    'today, so calming, easy recipes are shown first. '
                                    'Tap "New recipes" for a personal summary from Gemini.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    for (final m in mealIcons.keys) ...[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => meal = m),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: meal == m ? navy : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: meal == m ? navy : gold),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  mealIcons[m],
                                  color: meal == m ? Colors.white : navy,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  m,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: meal == m ? Colors.white : navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (m != 'Snack') const SizedBox(width: 8),
                    ],
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        showingAi
                            ? 'New ideas from Gemini AI'
                            : 'Our picks for you · pull down for new ideas',
                        style: const TextStyle(fontSize: 12, color: grey),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: generating ? null : newRecipes,
                      icon: generating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: navy),
                            )
                          : const Icon(Icons.auto_awesome, color: navy, size: 18),
                      label: Text(
                        generating ? 'Finding...' : 'New recipes',
                        style: const TextStyle(
                            color: navy, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (!loaded)
                  const Center(child: CircularProgressIndicator(color: navy))
                else
                  // Each card is only as tall as its picture and text.
                  LayoutBuilder(builder: (context, constraints) {
                    final double cardWidth = (constraints.maxWidth - 12) / 2;
                    return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final r in list)
                        SizedBox(
                        width: cardWidth,
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  recipe: r,
                                  hideCalories: widget.hideCalories,
                                  group: group,
                                  targets: targets,
                                ),
                              ),
                            );
                            refreshTodayTotals();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: gold.withValues(alpha: 0.5)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RecipePhoto(recipe: r, height: 95),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 8, 10, 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: navy,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.hideCalories
                                            ? '${r.cuisine} · ${r.minutes} min'
                                            : '${r.cuisine} · ${r.calories} kcal',
                                        style: const TextStyle(
                                            fontSize: 11, color: grey),
                                      ),
                                      if (recipeLabels(r,
                                              hideCalories: widget.hideCalories,
                                              group: group)
                                          .isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          children: [
                                            for (final l in recipeLabels(r,
                                                hideCalories:
                                                    widget.hideCalories,
                                                group: group))
                                              labelChip(l),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ),
                    ],
                  );
                  }),
                const SizedBox(height: 12),
                const Text(
                  'Photos from TheMealDB (themealdb.com). Nutrition values are '
                  'approximate. For a personal plan, talk to a dietitian.',
                  style: TextStyle(fontSize: 11, color: grey),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final bool hideCalories;
  final String group;
  final NutritionTargets? targets;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.hideCalories,
    required this.group,
    this.targets,
  });

  @override
  State<RecipeDetailScreen> createState() => RecipeDetailScreenState();
}

class RecipeDetailScreenState extends State<RecipeDetailScreen> {
  static const Color navy = Color(0xFF0F2A44);
  static const Color gold = Color(0xFFC9A882);
  static const Color grey = Color(0xFF6B6255);

  bool isSaving = false;
  bool eaten = false;

  Recipe get r => widget.recipe;

  Future<void> markEaten() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => isSaving = true);
    final DateTime now = DateTime.now();
    try {
      await profileRecords(user.uid, 'mealLogs').doc(newestFirstId()).set({
        'date': dateKeyOf(now),
        'time': formatTime(now),
        'hour': now.hour,
        'meal': r.meal,
        'recipe': r.name,
        'calories': r.calories,
        'protein': r.protein,
        'carbs': r.carbs,
        'fat': r.fat,
      });
      final DayTotals totals = await loadTodayTotals();
      if (!mounted) return;
      setState(() {
        isSaving = false;
        eaten = true;
      });
      showEatenSummary(totals);
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() => isSaving = false);
    }
  }

  Widget macroBar() {
    final int p = r.protein * 4;
    final int c = r.carbs * 4;
    final int f = r.fat * 9;
    final int total = p + c + f;
    if (total == 0) {
      return const Text('Nutrition details are not available for this recipe.');
    }
    Widget segment(int value, Color color) => value <= 0
        ? const SizedBox.shrink()
        : Expanded(
            flex: value,
            child: Container(height: 12, color: color),
          );
    Widget legend(String name, int grams, int value, Color color) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              '$name ${grams}g (${(value / total * 100).round()}%)',
              style: const TextStyle(fontSize: 12, color: navy),
            ),
          ],
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Row(
            children: [
              segment(p, navy),
              segment(c, gold),
              segment(f, const Color(0xFF7A9E7E)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            legend('Protein', r.protein, p, navy),
            legend('Carbs', r.carbs, c, gold),
            legend('Fat', r.fat, f, const Color(0xFF7A9E7E)),
          ],
        ),
      ],
    );
  }

  Widget section(String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5EFE6),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  RecipePhoto(recipe: r, height: 260, radius: 0),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context, eaten),
                          icon: const Icon(Icons.arrow_back, color: navy),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 14,
                      runSpacing: 6,
                      children: [
                        _info(Icons.public, r.cuisine),
                        _info(Icons.timer_outlined, '${r.minutes} min'),
                        _info(mealIcons[r.meal] ?? Icons.restaurant, r.meal),
                        if (!widget.hideCalories)
                          _info(Icons.local_fire_department_outlined,
                              '${r.calories} kcal'),
                      ],
                    ),
                    if (recipeLabels(r,
                            hideCalories: widget.hideCalories,
                            group: widget.group)
                        .isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final l in recipeLabels(r,
                              hideCalories: widget.hideCalories,
                              group: widget.group))
                            labelChip(l),
                        ],
                      ),
                    ],
                    if (r.byAi)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Made by Gemini AI. Check the ingredients for allergies.',
                          style: TextStyle(fontSize: 12, color: grey),
                        ),
                      ),
                    const SizedBox(height: 18),
                    if (!widget.hideCalories && r.calories > 0)
                      section('Nutrition (per serving, approx.)', macroBar()),
                    section(
                      'Ingredients (1 serving)',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final i in r.ingredients)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.circle, size: 7, color: gold),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(i,
                                        style: const TextStyle(
                                            fontSize: 14, color: navy)),
                                  ),
                                ],
                              ),
                            ),
                          if (widget.group == 'nourish')
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Tip: add a glass of milk or laban on the side for extra energy.',
                                style: TextStyle(fontSize: 12, color: grey),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (r.vitamins.isNotEmpty || r.minerals.isNotEmpty)
                      section(
                        'Vitamins & minerals (approx.)',
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (r.vitamins.isNotEmpty) ...[
                              const Text(
                                'Vitamins',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: grey),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  for (final v in r.vitamins)
                                    nutrientChip(v, const Color(0xFFFFF3D6),
                                        const Color(0xFF8A6A1E)),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (r.minerals.isNotEmpty) ...[
                              const Text(
                                'Minerals',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: grey),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  for (final m in r.minerals)
                                    nutrientChip(m, const Color(0xFFE6EEF6),
                                        const Color(0xFF0F2A44)),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    section(
                      'Steps',
                      Column(
                        children: [
                          for (int i = 0; i < r.steps.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: navy,
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      r.steps[i],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: navy,
                                          height: 1.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: isSaving || eaten ? null : markEaten,
                        icon: Icon(eaten ? Icons.check_circle : Icons.check),
                        label: Text(
                          eaten ? 'Added to your meal log' : 'Done, I ate this',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF3E8E5A),
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// After "Done, I ate this": calories for the meal and for today.
  /// High-risk users only see a kind message, never numbers.
  void showEatenSummary(DayTotals totals) {
    final NutritionTargets? t = widget.targets;
    final bool showNumbers = !widget.hideCalories;
    final bool hasTarget = t != null && !t.under18 && t.calories > 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF3E8E5A)),
            SizedBox(width: 8),
            Text('Added to your meal log'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              showNumbers
                  ? '${r.name}: ${r.calories} kcal'
                  : 'Well done for eating ${r.name}! Regular meals help your '
                      'body and mood.',
              style: const TextStyle(fontSize: 15, color: navy),
            ),
            if (showNumbers) ...[
              const SizedBox(height: 12),
              Text(
                hasTarget
                    ? 'Today: ${totals.calories} of ${t!.calories} kcal'
                    : 'Today so far: ${totals.calories} kcal',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              if (hasTarget) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (totals.calories / t!.calories).clamp(0.0, 1.0),
                    minHeight: 10,
                    color: navy,
                    backgroundColor: const Color(0xFFEFE4D3),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  totals.calories <= t!.calories
                      ? '${t!.calories - totals.calories} kcal left for today'
                      : 'You have reached your daily calories',
                  style: const TextStyle(fontSize: 13, color: grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Protein ${totals.protein}/${t!.protein} g  ·  '
                  'Carbs ${totals.carbs}/${t!.carbs} g  ·  '
                  'Fat ${totals.fat}/${t!.fat} g',
                  style: const TextStyle(fontSize: 12, color: grey),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                '${totals.meals} meal${totals.meals == 1 ? '' : 's'} logged today',
                style: const TextStyle(fontSize: 12, color: grey),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget nutrientChip(String text, Color background, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: gold),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13, color: navy)),
      ],
    );
  }
}

/// =======================================================================
/// DARTPAD DEMO: fake Firebase
/// DartPad can't run Firebase, so these classes copy the parts of the
/// Firebase API this app uses and keep everything in memory instead.
///
/// Demo login:  demo@nafsi.com / 123456   (profile passcode: 1234)
///
/// Accounts, data and the logged-in user are saved in the browser's
/// local storage, so they are still there after you reload DartPad.
///
/// To go back to real Firebase: delete everything from here to the end
/// of the file and restore the Firebase imports at the top.
/// =======================================================================

class DefaultFirebaseOptions {
  static const Object? currentPlatform = null;
}

class Firebase {
  static Future<void> initializeApp({Object? options}) async {
    _FakeDb.load();
    _FakeDb.seedDemoAccount();
  }
}

class FirebaseAuthException implements Exception {
  final String code;
  final String? message;
  FirebaseAuthException({required this.code, this.message});
  @override
  String toString() => 'FirebaseAuthException($code): $message';
}

class User {
  final String uid;
  final String? email;
  User(this.uid, this.email);

  Future<void> reauthenticateWithCredential(AuthCredential credential) async {
    if (FirebaseAuth._passwords[email?.toLowerCase()] != credential.password) {
      throw FirebaseAuthException(
          code: 'wrong-password', message: 'Wrong password');
    }
  }
}

class UserCredential {
  final User? user;
  UserCredential(this.user);
}

class AuthCredential {
  final String email;
  final String password;
  AuthCredential(this.email, this.password);
}

class EmailAuthProvider {
  static AuthCredential credential(
      {required String email, required String password}) {
    return AuthCredential(email, password);
  }
}

class FirebaseAuth {
  static final FirebaseAuth instance = FirebaseAuth._();
  FirebaseAuth._();

  static final Map<String, String> _passwords = {};
  static final Map<String, String> _uids = {};

  User? currentUser;

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    email = email.trim().toLowerCase();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_passwords.containsKey(email) || _passwords[email] != password) {
      throw FirebaseAuthException(
          code: 'invalid-credential', message: 'Wrong email or password');
    }
    currentUser = User(_uids[email]!, email);
    _FakeDb.save();
    return UserCredential(currentUser);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    email = email.trim().toLowerCase();
    await Future.delayed(const Duration(milliseconds: 300));
    if (email.isEmpty || !email.contains('@')) {
      throw FirebaseAuthException(
          code: 'invalid-email', message: 'The email address is not valid.');
    }
    if (password.length < 6) {
      throw FirebaseAuthException(
          code: 'weak-password',
          message: 'Password should be at least 6 characters.');
    }
    if (_passwords.containsKey(email)) {
      throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'This email is already registered.');
    }
    final String uid = 'user_${DateTime.now().microsecondsSinceEpoch}';
    _passwords[email] = password;
    _uids[email] = uid;
    currentUser = User(uid, email);
    _FakeDb.save();
    return UserCredential(currentUser);
  }

  Future<void> signOut() async {
    currentUser = null;
    _FakeDb.save();
  }
}

class SetOptions {
  final bool merge;
  SetOptions({this.merge = false});
}

class _FakeDb {
  static final Map<String, Map<String, dynamic>> docs = {};
  static final StreamController<void> changes =
      StreamController<void>.broadcast();

  static void notify() {
    save();
    changes.add(null);
  }

  // ---- Browser local storage ----
  static const String _storageKey = 'nafsi_demo_data';

  static JSObject? get _storage {
    try {
      return globalContext['localStorage'] as JSObject?;
    } catch (_) {
      return null;
    }
  }

  static void save() {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String data = jsonEncode({
        'passwords': FirebaseAuth._passwords,
        'uids': FirebaseAuth._uids,
        'docs': docs,
        'currentEmail': user?.email,
      });
      _storage?.callMethod('setItem'.toJS, _storageKey.toJS, data.toJS);
    } catch (error) {
      print('Could not save to local storage: $error');
    }
  }

  static void load() {
    try {
      final JSAny? raw =
          _storage?.callMethod('getItem'.toJS, _storageKey.toJS);
      if (raw == null) return;
      final Map<String, dynamic> data =
          jsonDecode((raw as JSString).toDart) as Map<String, dynamic>;
      FirebaseAuth._passwords
          .addAll(Map<String, String>.from(data['passwords'] ?? {}));
      FirebaseAuth._uids.addAll(Map<String, String>.from(data['uids'] ?? {}));
      final Map<String, dynamic> savedDocs =
          Map<String, dynamic>.from(data['docs'] ?? {});
      savedDocs.forEach((path, value) {
        docs[path] = Map<String, dynamic>.from(value as Map);
      });
      final String? email = data['currentEmail'] as String?;
      if (email != null && FirebaseAuth._uids.containsKey(email)) {
        FirebaseAuth.instance.currentUser =
            User(FirebaseAuth._uids[email]!, email);
      }
    } catch (error) {
      print('Could not load from local storage: $error');
    }
  }

  static void seedDemoAccount() {
    const String email = 'demo@nafsi.com';
    if (FirebaseAuth._passwords.containsKey(email)) return;
    const String uid = 'demo_user';
    FirebaseAuth._passwords[email] = '123456';
    FirebaseAuth._uids[email] = uid;
    docs['users/$uid'] = {
      'firstName': 'Demo',
      'lastName': 'User',
      'email': email,
      'phone': '0500000000',
      'birthday': '1/1/2000',
      'gender': 'Female',
    };
    docs['users/$uid/profiles/1000000000000'] = {
      'firstName': 'Demo',
      'lastName': 'User',
      'birthday': '1/1/2000',
      'gender': 'Female',
      'phone': '0500000000',
      'relationship': 'Me',
      'passcode': '1234',
    };
  }
}

class FirebaseFirestore {
  static final FirebaseFirestore instance = FirebaseFirestore._();
  FirebaseFirestore._();

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return CollectionReference<Map<String, dynamic>>._(path);
  }
}

class CollectionReference<T> {
  final String path;
  CollectionReference._(this.path);

  DocumentReference<T> doc([String? id]) {
    return DocumentReference<T>._(
        '$path/${id ?? DateTime.now().microsecondsSinceEpoch.toString()}');
  }

  Future<DocumentReference<T>> add(Map<String, dynamic> data) async {
    final DocumentReference<T> ref = doc();
    await ref.set(data);
    return ref;
  }

  QuerySnapshot<T> _current() {
    final String prefix = '$path/';
    final List<String> ids = _FakeDb.docs.keys
        .where((key) =>
            key.startsWith(prefix) && !key.substring(prefix.length).contains('/'))
        .map((key) => key.substring(prefix.length))
        .toList()
      ..sort();
    return QuerySnapshot<T>._(ids
        .map((id) => QueryDocumentSnapshot<T>._(DocumentReference<T>._('$path/$id')))
        .toList());
  }

  Future<QuerySnapshot<T>> get() async => _current();

  Stream<QuerySnapshot<T>> snapshots() async* {
    yield _current();
    await for (final _ in _FakeDb.changes.stream) {
      yield _current();
    }
  }
}

class DocumentReference<T> {
  final String path;
  DocumentReference._(this.path);

  String get id => path.split('/').last;

  CollectionReference<Map<String, dynamic>> collection(String name) {
    return CollectionReference<Map<String, dynamic>>._('$path/$name');
  }

  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) async {
    final Map<String, dynamic>? old = _FakeDb.docs[path];
    if (options != null && options.merge && old != null) {
      _FakeDb.docs[path] = {...old, ...data};
    } else {
      _FakeDb.docs[path] = Map<String, dynamic>.from(data);
    }
    _FakeDb.notify();
  }

  Future<void> update(Map<String, dynamic> data) =>
      set(data, SetOptions(merge: true));

  Future<void> delete() async {
    _FakeDb.docs.remove(path);
    _FakeDb.notify();
  }

  Future<DocumentSnapshot<T>> get() async => DocumentSnapshot<T>._(this);

  Stream<DocumentSnapshot<T>> snapshots() async* {
    yield DocumentSnapshot<T>._(this);
    await for (final _ in _FakeDb.changes.stream) {
      yield DocumentSnapshot<T>._(this);
    }
  }
}

class DocumentSnapshot<T> {
  final DocumentReference<T> reference;
  final Map<String, dynamic>? _data;
  DocumentSnapshot._(this.reference)
      : _data = _FakeDb.docs[reference.path] == null
            ? null
            : Map<String, dynamic>.from(_FakeDb.docs[reference.path]!);

  String get id => reference.id;
  bool get exists => _data != null;
  T? data() => _data as T?;
}

class QueryDocumentSnapshot<T> extends DocumentSnapshot<T> {
  QueryDocumentSnapshot._(DocumentReference<T> reference) : super._(reference);

  @override
  T data() => (_data ?? <String, dynamic>{}) as T;
}

class QuerySnapshot<T> {
  final List<QueryDocumentSnapshot<T>> docs;
  QuerySnapshot._(this.docs);
  int get size => docs.length;
}

// ---------------------------------------------------------------------
// Small replacement for package:http (DartPad doesn't have it anymore).
// Uses the browser's fetch(), so http.get / http.post keep working.
// ---------------------------------------------------------------------
class NafsiHttpResponse {
  final int statusCode;
  final String body;
  const NafsiHttpResponse(this.statusCode, this.body);
}

class NafsiHttp {
  const NafsiHttp();

  Future<NafsiHttpResponse> get(Uri url, {Map<String, String>? headers}) =>
      _send('GET', url, headers, null);

  Future<NafsiHttpResponse> post(Uri url,
          {Map<String, String>? headers, Object? body}) =>
      _send('POST', url, headers, body);

  Future<NafsiHttpResponse> _send(String method, Uri url,
      Map<String, String>? headers, Object? body) async {
    final Map<String, Object?> init = {'method': method};
    if (headers != null) init['headers'] = headers;
    if (body != null) init['body'] = body is String ? body : jsonEncode(body);

    final JSObject res = await globalContext
        .callMethod<JSPromise<JSObject>>(
            'fetch'.toJS, url.toString().toJS, init.jsify())
        .toDart;
    final int status = (res['status'] as JSNumber).toDartInt;
    final String text =
        (await res.callMethod<JSPromise<JSString>>('text'.toJS).toDart).toDart;
    return NafsiHttpResponse(status, text);
  }
}

const http = NafsiHttp();
