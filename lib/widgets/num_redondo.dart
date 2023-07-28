import 'package:frontend_loreal/utils_exports.dart';

class NumeroRedondoWidget extends StatelessWidget {
  const NumeroRedondoWidget({
    super.key,
    required this.numero,
    this.mostrarBorde = true,
    this.isParles = false,
    this.lenght = 2,
    this.margin = 1,
    this.width = 35,
    this.height = 35,
    this.color,
    this.fontWeight,
    this.fontSize = 0,
  });
  final String numero;
  final bool mostrarBorde;
  final bool isParles;
  final int lenght;
  final double margin;
  final double width;
  final double height;
  final Color? color;
  final FontWeight? fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tieneBorde(mostrarBorde: mostrarBorde, numero: int.parse(numero))
            ? Colors.black
            : Colors.transparent,
      ),
      width: !isParles ? width : null,
      height: !isParles ? height : null,
      child: Container(
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              tieneBorde(mostrarBorde: mostrarBorde, numero: int.parse(numero))
                  ? color ?? Colors.white
                  : Colors.transparent,
        ),
        child: Center(
            child: textoDosis(numero,
                (fontSize != 0) ? fontSize : _tamLetra(int.parse(numero)),
                fontWeight: fontWeight)),
      ),
    );
  }

  bool tieneBorde({num? numero, required bool mostrarBorde}) {
    if (numero != null && mostrarBorde) return true;
    return false;
  }

  double _tamLetra(num? numero) {
    if (numero != null && numero.toStringAsFixed(0).length >= 4) return 10;
    return 15;
  }
}
