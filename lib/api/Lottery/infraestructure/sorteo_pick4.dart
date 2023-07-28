import 'package:frontend_loreal/utils_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class SorteoPick4 extends ConsumerStatefulWidget {
  const SorteoPick4({
    super.key,
    required this.pick4,
    required this.onChange,
  });
  final String pick4;
  final void Function(String) onChange;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SorteoPick4State();
}

class _SorteoPick4State extends ConsumerState<SorteoPick4> {
  @override
  Widget build(BuildContext context) {
    final btnManagerQ = StateProvider<bool>((ref) => false);
    String pick4 = widget.pick4;
    return ProviderScope(
      child: Consumer(builder: (_, ref, __) {
        final btnManager = ref.watch(btnManagerQ);
        return dinamicGroupBox(
            'Sorteo Pick4',
            [
              boldLabel('Resultado de la búsqueda: ', pick4, 20),
              const SizedBox(height: 10),
              AbsorbPointer(
                absorbing: btnManager,
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (!btnManager)
                            ? Colors.green[400]
                            : Colors.grey[400],
                        elevation: 2),
                    icon: const Icon(Icons.search),
                    label: (!btnManager)
                        ? const Text('Buscar')
                        : const Text('Buscando...'),
                    onPressed: () async {
                      ref.read(btnManagerQ.notifier).state = true;

                      String join = '';

                      final url = Uri.parse('https://www.flalottery.com/pick4');
                      final res = await http.get(url);

                      dom.Document html = dom.Document.html(res.body);
                      final titles = html
                          .getElementsByClassName('gamePageNumbers')
                          .map((e) => e.getElementsByClassName('balls'))
                          .toList();

                      (DateTime.now().hour < 14)
                          ? join =
                              ' ${titles[0][0].innerHtml}${titles[0][1].innerHtml} '
                                  '${titles[0][2].innerHtml}${titles[0][3].innerHtml}'
                          : join =
                              ' ${titles[1][0].innerHtml}${titles[1][1].innerHtml} '
                                  '${titles[1][2].innerHtml}${titles[1][3].innerHtml}';

                      pick4 = join;

                      widget.onChange.call(pick4);
                      ref.read(btnManagerQ.notifier).state = false;
                    },
                  ),
                ),
              ),
            ],
            padding: 0);
      }),
    );
  }
}
