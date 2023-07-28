import 'package:frontend_loreal/riverpod/declarations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void managerOfElementsOnList(WidgetRef ref, dynamic element) {
  final theBottom = ref.read(showButtomtoEditAList.notifier);
  final theList = ref.read(toEditAList.notifier);
  final theList1 = ref.watch(toEditAList.notifier);

  if (theList1.state.contains(element)) {
    theList.state.remove(element);

    if (theList.state.isEmpty) {
      theBottom.state = false;
    }

    return;
  }

  theList.state.add(element);
  theBottom.state = true;
}
