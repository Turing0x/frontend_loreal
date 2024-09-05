import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_chat/config/riverpod/declarations.dart';
import 'package:safe_chat/config/server/http/auth.dart';
import 'package:safe_chat/config/server/http/local_storage.dart';
import 'package:safe_chat/config/utils_exports.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  int vecesMal = 0;
  bool btnOffline = true;
  bool showPass = true;

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
    final size = MediaQuery.of(context).size;
    final btnManager = ref.watch(btnManagerR);

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
      backgroundColor: const Color(0xFF6D60F8),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: size.width * .5,
              child: Image.asset('lib/assets/image_login.webp'),
            ),
            Container(
              padding: const EdgeInsets.all(40),
              height: size.height * .7,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(children: [
                CustomTextField(
                    obscureText: false,
                    size: size,
                    nameController: nameController,
                    title: 'Nombre de usuario',
                    hintText: 'John Doe'),
                const SizedBox(height: 20),
                CustomTextField(
                  size: size,
                  obscureText: true,
                  nameController: passController,
                  title: 'Contraseña de su cuenta',
                  hintText: '123ABC',
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: textoDosis('Olvidaste la contraseña?', 14,
                      color: const Color(0xFF7F7F7F)),
                ),
                AbsorbPointer(
                  absorbing: btnManager,
                  child: GestureDetector(
                    onTap: () => _onPressed(routesByRole),
                    child: Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (!btnManager)
                                ? const Color(0xFFFFCA3C)
                                : Colors.grey[400],
                            boxShadow: const [
                              BoxShadow(color: Colors.black54, blurRadius: 1)
                            ]),
                        height: 50,
                        width: size.width,
                        child: textoDosis(
                            (!btnManager)
                                ? 'Iniciar Sesión'
                                : 'Intentando entrar...',
                            20)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BtnImage(name: 'google'),
                      BtnImage(name: 'apple'),
                      BtnImage(name: 'facebook'),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                textoDosis('Aún no tienes una cuenta?', 16,
                    color: const Color(0xFF7F7F7F)),
              ]),
            )
          ],
        )),
      ),
    );
  }

  void _onPressed(Map<String, void Function()> routesByRole) {
    final authService = AuthServices();
    final btnManagerM = ref.read(btnManagerR.notifier);

    btnManagerM.state = true;
    FocusScope.of(context).unfocus();
    final chUsername = ref.read(chUser.notifier);
    final setGlobalRole = ref.read(globalRole.notifier);

    if (nameController.text.isEmpty || passController.text.isEmpty) {
      btnManagerM.state = false;
      return showToast(context, 'Rellene los campos vacíos para poder acceder');
    }

    final typeRole = authService.login(
        nameController.text.trim(), passController.text.trim(), context);

    typeRole.then((value) {
      if (value != '') {
        routesByRole[value]!.call();
      }
      chUsername.state = nameController.text.trim();
      setGlobalRole.state = value;
      btnManagerM.state = false;
    }).catchError((error) {
      showToast(context, 'Revise su conexión a Internet por favor');
      btnManagerM.state = false;
      return error;
    });
  }
}

class BtnImage extends StatelessWidget {
  const BtnImage({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      padding: const EdgeInsets.all(8),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0EF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Image.asset(
        'lib/assets/$name.png',
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.size,
    required this.nameController,
    required this.title,
    required this.hintText,
    required this.obscureText,
  });

  final Size size;
  final TextEditingController nameController;
  final String title;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: textoDosis(title, 18, color: const Color(0xFF7F7F7F)),
        ),
        Container(
          width: size.width,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFF7F7F7),
          ),
          child: TextField(
            controller: nameController,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF7F7F7F),
                fontSize: 15,
              ),
            ),
          ),
        )
      ],
    );
  }
}
