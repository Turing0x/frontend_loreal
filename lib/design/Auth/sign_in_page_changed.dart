import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sticker_maker/config/globals/variables.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';
import 'package:sticker_maker/config/server/http/auth.dart';
import 'package:sticker_maker/config/server/http/local_storage.dart';
import 'package:sticker_maker/config/utils/biometrics.dart';
import 'package:sticker_maker/config/utils_exports.dart';

class OtherSignInPage extends ConsumerStatefulWidget {
  const OtherSignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtherSignInPageState();
}

class _OtherSignInPageState extends ConsumerState<OtherSignInPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  int vecesMal = 0;
  bool btnOffline = true;
  bool showPass = true;

  bool successAuth = false;

  @override
  void initState() {
    Future<String?> offlinePass = LocalStorage.getpassListerOffline();
    offlinePass.then((value) {
      if (value != null) {
        setState(() {
          btnOffline = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, void Function()> routesByRole = {
      'banco': () =>
          Navigator.pushReplacementNamed(context, 'main_banquero_page'),
      'colector general': () =>
          Navigator.pushReplacementNamed(context, 'main_colector_page'),
      'colector simple': () =>
          Navigator.pushReplacementNamed(context, 'main_colector_page'),
      'listero': () =>
          Navigator.pushReplacementNamed(context, 'main_listero_page')
    };

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 150),
              Container(
                alignment: Alignment.center,
                child: textoDosis('Welcome Back!', 25,
                    fontWeight: FontWeight.bold),
              ),
              textoDosis('Enter your account here', 20, color: Colors.grey),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email or phone number',
                      hintText: 'Enter your email or phone number'),
                  controller: nameController,
                  onChanged: (value) => setState(() {}),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your username'),
                  obscureText: showPass,
                  controller: passController,
                  onChanged: (value) => setState(() {}),
                ),
              ),
              _contBotones(routesByRole),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textoDosis('or continue ', 20, color: Colors.grey),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                      child: textoDosis('with', 20, color: Colors.grey)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF35541),
                    elevation: 2,
                  ),
                  onPressed: () {},
                  child: textoDosis('Google', 20,
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textoDosis("Don't have any account?", 20, color: Colors.grey),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {},
                    child: textoDosis('Sign Up', 20,
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AbsorbPointer _contBotones(Map<String, void Function()> routesByRole) {
    final authService = AuthServices();
    final btnManager = ref.watch(btnManagerR);
    final btnManagerM = ref.read(btnManagerR.notifier);

    return AbsorbPointer(
      absorbing: btnManager,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                (!btnManager) ? Colors.green[300] : Colors.grey[400],
            elevation: 2,
          ),
          onPressed: () async {
            final LocalAuthentication auth = LocalAuthentication();

            bool has = await hasBiometrics();
            if (has) {
              bool didAuthenticate = await auth.authenticate(
                  options: const AuthenticationOptions(
                      biometricOnly: true, stickyAuth: true),
                  localizedReason: 'Touch your finger on the sensor to login');

              if (didAuthenticate) {
                setState(() {
                  successAuth = true;
                });
              }
            } else {
              showToast(context, 'Your device does not support biometrics');
            }

            if (!successAuth) {
              showToast(context, "We couldn't authenticate you");
              return;
            }

            btnManagerM.state = true;
            FocusScope.of(context).unfocus();
            final chUsername = ref.read(chUser.notifier);
            final setGlobalRole = ref.read(globalRole.notifier);

            if (nameController.text.isEmpty || passController.text.isEmpty) {
              btnManagerM.state = false;
              return showToast(context, 'Please fill in the form');
            }

            final typeRole = authService.login(nameController.text.trim(),
                passController.text.trim(), context);

            typeRole.then((value) {
              if (value != '') {
                routesByRole[value]!.call();
              }
              chUsername.state = nameController.text.trim();
              setGlobalRole.state = value;
              isAuthenticatedBiometrics = true;
              btnManagerM.state = false;
            }).catchError((error) {
              showToast(
                  context, 'Something went wrong. Please, try again later');
              btnManagerM.state = false;
              return error;
            });
          },
          child: textoDosis(
              (!btnManager) ? 'Make Login' : 'Authenticating...', 20,
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
