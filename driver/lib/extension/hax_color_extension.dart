// ignore_for_file: deprecated_member_use

import 'dart:ui';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  /// Retorna Colors.black se a string for inválida ou nula.
  static Color fromHex(String? hexString) {
    // Verificar se o valor é nulo ou vazio
    if (hexString == null || hexString.isEmpty) {
      print('Warning: HexColor.fromHex recebeu valor nulo ou vazio. Usando cor padrão.');
      return const Color(0xFFFDB022); // Preto como padrão
    }

    try {
      final buffer = StringBuffer();

      // Remover espaços em branco
      hexString = hexString.trim();

      // Verificar se a string não está vazia após trim
      if (hexString.isEmpty) {
        print('Warning: HexColor.fromHex recebeu string vazia após trim. Usando cor padrão.');
        return const Color(0xFFFDB022);
      }

      // Adicionar alpha se necessário
      if (hexString.length == 6 || hexString.length == 7) {
        buffer.write('ff');
      }

      // Remover # se presente
      buffer.write(hexString.replaceFirst('#', ''));

      // Verificar se o resultado tem um comprimento válido
      final finalHex = buffer.toString();
      if (finalHex.length != 8) {
        print('Warning: HexColor.fromHex - formato inválido: "$hexString". Usando cor padrão.');
        return const Color(0xFFFDB022);
      }

      // Verificar se contém apenas caracteres hexadecimais válidos
      if (!RegExp(r'^[0-9A-Fa-f]+$').hasMatch(finalHex)) {
        print('Warning: HexColor.fromHex - caracteres inválidos em: "$hexString". Usando cor padrão.');
        return const Color(0xFFFDB022);
      }

      return Color(int.parse(finalHex, radix: 16));
    } catch (e) {
      print('Error: HexColor.fromHex falhou ao processar "$hexString": $e');
      return const Color(0xFFFDB022); // Retorna preto em caso de erro
    }
  }

  /// Versão alternativa que permite especificar uma cor padrão
  static Color fromHexWithDefault(String? hexString, Color defaultColor) {
    if (hexString == null || hexString.isEmpty) {
      return defaultColor;
    }

    try {
      final buffer = StringBuffer();
      hexString = hexString.trim();

      if (hexString.isEmpty) {
        return defaultColor;
      }

      if (hexString.length == 6 || hexString.length == 7) {
        buffer.write('ff');
      }

      buffer.write(hexString.replaceFirst('#', ''));

      final finalHex = buffer.toString();
      if (finalHex.length != 8 || !RegExp(r'^[0-9A-Fa-f]+$').hasMatch(finalHex)) {
        return defaultColor;
      }

      return Color(int.parse(finalHex, radix: 16));
    } catch (e) {
      print('Error: HexColor.fromHexWithDefault falhou: $e');
      return defaultColor;
    }
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
