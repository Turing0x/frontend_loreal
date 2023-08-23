import 'package:flutter/material.dart';
import 'package:frontend_loreal/config/utils_exports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class SorteoPick3 extends ConsumerStatefulWidget {
  const SorteoPick3({
    super.key,
    required this.pick3,
    required this.onChange,
  });
  final String pick3;
  final void Function(String) onChange;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SorteoPick3State();
}

class _SorteoPick3State extends ConsumerState<SorteoPick3> {
  @override
  Widget build(BuildContext context) {
    final btnManagerQ = StateProvider<bool>((ref) => false);
    String pick3 = widget.pick3;
    return ProviderScope(
      child: Consumer(builder: (_, ref, __) {
        final btnManager = ref.watch(btnManagerQ);
        return dinamicGroupBox(
            'Sorteo Pick3',
            [
              boldLabel('Resultado de la búsqueda: ', pick3, 20),
              const SizedBox(height: 10),
              AbsorbPointer(
                absorbing: btnManager,
                key: UniqueKey(),
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
                      String join = '';
                      ref.read(btnManagerQ.notifier).state = true;

                      final url = Uri.parse('https://www.flalottery.com/pick3');
                      final res = await http.get(url);

                      dom.Document html = dom.Document.html(res.body);
                      final titles = html
                          .getElementsByClassName('gamePageNumbers')
                          .map((e) => e.getElementsByClassName('balls'))
                          .toList();

                      (DateTime.now().hour < 14)
                          ? join =
                              '${titles[0][0].innerHtml}${titles[0][1].innerHtml}${titles[0][2].innerHtml}'
                          : join =
                              '${titles[1][0].innerHtml}${titles[1][1].innerHtml}${titles[1][2].innerHtml}';

                      pick3 = join;
                      widget.onChange.call(pick3);
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
