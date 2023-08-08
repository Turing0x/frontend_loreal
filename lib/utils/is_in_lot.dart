Map<String, Object> isInLot( String lot, String numero ){

  String fijo = lot.split(' ')[0].substring(1, 3);
  String centena = lot.split(' ')[0];

  String dFijo = fijo[0];
  String tFijo = fijo[1];

  String corrido1 = lot.split(' ')[1];
  String corrido2 = lot.split(' ')[2];

  String dCorrido1 = corrido1[0];
  String tCorrido1 = corrido1[1];

  String dCorrido2 = corrido2[0];
  String tCorrido2 = corrido2[1];

  Map<String, String> map = {
    'fijo': fijo,
    'centena': centena,
    'dFijo': dFijo,
    'tFijo': tFijo,
    'corrido1': corrido1,
    'corrido2': corrido2,
    'dCorrido1': dCorrido1,
    'tCorrido1': tCorrido1,
    'dCorrido2': dCorrido2,
    'tCorrido2': tCorrido2
  };

  return {
    'isInside': map.containsValue(numero),
    'type': map.keys.firstWhere(
      (key) => map[key] == numero, orElse: () => '',
  )
  };

}