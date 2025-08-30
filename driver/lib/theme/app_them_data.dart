import 'package:flutter/material.dart';

class AppThemData {
  // === CORES PRINCIPAIS - TÔ AKI MOBILIDADE ===
  // Cor Primária (Pulsar Urbano)
  static Color primary500 = Color(0xFFC54398);
  static const Color primary50 = Color(0xFFFDF2F8);
  static const Color primary100 = Color(0xFFFCE7F3);
  static const Color primary200 = Color(0xFFFBCFE8);
  static const Color primary300 = Color(0xFFF9A8D4);
  static const Color primary400 = Color(0xFFF472B6);
  static const Color primary600 = Color(0xFFB83B87);
  static const Color primary700 = Color(0xFFA03276);
  static const Color primary800 = Color(0xFF882A65);
  static const Color primary900 = Color(0xFF701F54);
  static const Color primary950 = Color(0xFF4A0E35);

  // Cor Secundária (Inovação Vibrante)
  static const Color secondary500 = Color(0xFF8F268A);
  static const Color secondary50 = Color(0xFFFDF2FD);
  static const Color secondary100 = Color(0xFFFCE7FB);
  static const Color secondary200 = Color(0xFFFACFF7);
  static const Color secondary300 = Color(0xFFF7A8F0);
  static const Color secondary400 = Color(0xFFF472E6);
  static const Color secondary600 = Color(0xFF7C2279);
  static const Color secondary700 = Color(0xFF6B1D68);
  static const Color secondary800 = Color(0xFF591957);
  static const Color secondary900 = Color(0xFF481546);
  static const Color secondary950 = Color(0xFF2F0D2F);

  // Cor de Fundo (Nuvem de Sol)
  static const Color bgScreen = Color(0xFFF6F6F6);

  // Cor de Texto/Elementos Escuros (Eclipse)
  static const Color labelColorLightPrimary = Color(0xFF000516);
  static const Color black = Color(0xFF000516);

  // === CORES DE SISTEMA (mantidas) ===
  static const Color white = Color(0xFFFFFFFF);

  // Cores de Aviso
  static const Color warning03 = Color(0xFFFEF0C7);
  static const Color warning06 = Color(0xFFFDB022);
  static const Color warning08 = Color(0xFFDC6803);
  static const Color warning500 = Color(0xFFFFD600);

  // Cores de Erro
  static const Color error02 = Color(0xFFFEF3F2);
  static const Color error08 = Color(0xFFD92C20);
  static const Color error07 = Color(0xFFF04437);
  static const Color danger500 = Color(0xFFFF3B30);
  static const Color danger950 = Color(0xFF4B0804);
  static const Color danger50 = Color(0xFFFFF2F1);

  // Cores de Sucesso
  static const Color success = Color(0xFF27C041);
  static const Color success02 = Color(0xFFECFDF3);
  static const Color success07 = Color(0xFF12B669);
  static const Color success08 = Color(0xFF039754);
  static const Color success50 = Color(0xFFf0fdf1);
  static const Color success100 = Color(0xFFddfbe1);
  static const Color success200 = Color(0xFFbdf5c6);
  static const Color success300 = Color(0xFF89ec9a);
  static const Color success400 = Color(0xFF4cd964);
  static const Color success500 = Color(0xFF27c041);
  static const Color success600 = Color(0xFF1a9f31);
  static const Color success700 = Color(0xFF187d2a);
  static const Color success800 = Color(0xFF186326);
  static const Color success900 = Color(0xFF165122);
  static const Color success950 = Color(0xFF062d0e);

  // Cores Azuis (para informações)
  static const Color blueLight = Color(0xFF0BA4EB);
  static const Color blueLight07 = Color(0xFF0BA4EB);
  static const Color blueLight01 = Color(0xFF36BFF9);
  static const Color blue = Color(0xFF016AA2);
  static const Color info500 = Color(0xFF1EADFF);
  static const Color info950 = Color(0xFF0E315D);
  static const Color info50 = Color(0xFFEDFAFF);

  // Escala de Cinzas
  static const Color grey08 = Color(0xFF4B5565);
  static const Color grey25 = Color(0xFFffffff);
  static const Color grey50 = Color(0xFFf5f6f6);
  static const Color grey100 = Color(0xFFe4e7e9);
  static const Color grey200 = Color(0xFFccd0d5);
  static const Color grey300 = Color(0xFFa8b0b8);
  static const Color grey400 = Color(0xFF7d8793);
  static const Color grey500 = Color(0xFF626c78);
  static const Color grey600 = Color(0xFF545b66);
  static const Color grey700 = Color(0xFF454a52);
  static const Color grey800 = Color(0xFF40444a);
  static const Color grey900 = Color(0xFF383a41);
  static const Color grey950 = Color(0xFF232529);

  // Gradiente (atualizado com cores primárias)
  static const List<Color> gradient03 = [Color(0xFFC54398), Color(0xFF8F268A)];

  // Cores para Introdução/Onboarding
  static const Color intro1 = Color(0xFFFDF2F8);
  static const Color intro2 = Color(0xFFEDFAFF);
  static const Color intro3 = Color(0xFFFDF2FD);

  // Status de Reservas/Agendamentos
  static const Color bookingNew = Color(0xFF1EADFF);
  static const Color bookingOngoing = Color(0xFFD19D00);
  static const Color bookingCompleted = Color(0xFF27C041);
  static const Color bookingRejected = Color(0xFFC54398); // Usando cor primária
  static const Color bookingCancelled = Color(0xFFFF3B30);
}
