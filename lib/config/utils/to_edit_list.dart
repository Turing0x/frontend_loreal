import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sticker_maker/config/riverpod/declarations.dart';

void managerOfElementsOnList(WidgetRef ref, dynamic element) {
  final theBottom = ref.read(showButtomtoEditAList.notifier);
  final theList = ref.read(toEditAList.notifier);
  final theList1 = ref.watch(toEditAList.notifier);

  final theMoney = ref.read(toManageTheMoney.notifier);
  final theMoney1 = ref.watch(toManageTheMoney.notifier);

  if (theList1.state.contains(element.uuid)) {
    theList.state.remove(element.uuid);

    if (theList.state.isEmpty) {
      theBottom.state = false;
    }

    return;
  }

  final isInList = theMoney1.state.any((each) => each.uuid == element.uuid);

  if (isInList) {
    theMoney.state.removeWhere((each) => each.uuid == element.uuid);
  } else {
    theMoney.state.add(element);
  }

  theList.state.add(element.uuid);
  theBottom.state = true;
}
