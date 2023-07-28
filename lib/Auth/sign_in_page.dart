import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:frontend_loreal/widgets/simple_txt.dart';
import 'package:frontend_loreal/server/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils_exports.dart';

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

  @override
  void initState() {
    Future<String?> offlinePass = AuthServices.getpassListerOffline();
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
              Container(
                height: 250,
                margin: EdgeInsets.only(
                    left: size.width * .09,
                    right: size.width * .09,
                    top: size.width * .15),
                child: SvgPicture.asset('lib/assets/undraw_unlock_re_a558.svg'),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 45, right: 45, top: size.height * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    textoDosis('Loreal', 55, fontWeight: FontWeight.w600),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: textoDosis('v1', 20),
                    )
                  ],
                )
              ),
              textoDosis('Ingrese sus datos de acceso al sistema', 20),
              const SizedBox(height: 30),
              SimpleTxt(
                  color: Colors.grey[300],
                  icon: Icons.person_outline,
                  texto: 'Nombre de usuario',
                  keyboardType: TextInputType.text,
                  controlador: nameController,
                  onChange: (valor) => setState(() {})),
              SimpleTxt(
                  color: Colors.grey[300],
                  icon: Icons.password_outlined,
                  texto: 'Clave de acceso',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  controlador: passController,
                  onChange: (valor) => setState(() {})),
              const SizedBox(height: 20),
              _contBotones(routesByRole),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Visibility(
                  visible: !btnOffline,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: ElevatedButton.icon(
                          icon: const Icon(Icons.link_off_outlined),
                          label: textoDosis('Offline', 20, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (btnOffline)
                                ? Colors.grey[300]
                                : Colors.red[300],
                            elevation: 2,
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, 'offline_pass')),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Row _contBotones(Map<String, void Function()> routesByRole) {
    final authService = AuthServices();
    final btnManager = ref.watch(btnManagerR);
    final btnManagerM = ref.read(btnManagerR.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textoDosis('Vamos allá!!!', 18, color: Colors.black),
        const SizedBox(width: 10),
        AbsorbPointer(
          absorbing: btnManager,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  (!btnManager) ? Colors.blue[300] : Colors.grey[400],
              elevation: 2,
            ),
            onPressed: () {
              btnManagerM.state = true;
              FocusScope.of(context).unfocus();
              final chUsername = ref.read(chUser.notifier);
              final setGlobalRole = ref.read(globalRole.notifier);

              if (nameController.text.isEmpty || passController.text.isEmpty) {
                btnManagerM.state = false;
                return showToast('Debe completar la información de registro');
              }

              final typeRole = authService.login(
                  nameController.text.trim(), passController.text.trim());

              typeRole.then((value) {
                if (value != '') {
                  routesByRole[value]!.call();
                }
                chUsername.state = nameController.text.trim();
                setGlobalRole.state = value;
                btnManagerM.state = false;
              }).catchError((error) {
                showToast(
                    'Ha ocurrido un error al conectar con el servidor. Por favor, revise su conexión a internet');
                btnManagerM.state = false;
                return error;
              });
            },
            child: textoDosis((!btnManager) ? 'Acceder' : 'Autenticando...', 20,
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}
