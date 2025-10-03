// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get activeContract => 'Contrato Ativo';

  @override
  String get addDemoMessage => 'Adicionar mensagem de demo';

  @override
  String get advanceWeek => 'Avançar Semana';

  @override
  String ageAge(int age) {
    return 'Idade $age';
  }

  @override
  String get annual => 'Anual';

  @override
  String get cancel => 'Cancelar';

  @override
  String get careerStatistics => 'Estatísticas de carreira';

  @override
  String get careerStats => 'Estatísticas de Carreira';

  @override
  String get casino => 'Casino';

  @override
  String get casinoAllIn => 'Casino — All In';

  @override
  String casinoLoss(double loss, double cash) {
    return 'Casino: perdeste $loss. Novo saldo: $cash';
  }

  @override
  String get casinoPlaceBet => 'Casino — Fazer Aposta';

  @override
  String casinoWin(double delta, double cash) {
    return 'Casino: ganhaste $delta. Novo saldo: $cash';
  }

  @override
  String get cash => 'Saldo';

  @override
  String get clauses => 'Cláusulas';

  @override
  String get clearAll => 'Limpar tudo';

  @override
  String get contractDetails => 'Detalhes do Contrato';

  @override
  String get costs => 'Custos';

  @override
  String get delta => 'Delta';

  @override
  String get duration => 'Duração';

  @override
  String get economy => 'Economia';

  @override
  String get enterAnyAmount => 'Introduz um valor (até ao saldo)';

  @override
  String get finance => 'Finanças';

  @override
  String get general => 'Geral';

  @override
  String get goToMatches => 'Ir para Jogos';

  @override
  String get home => 'Início';

  @override
  String get income => 'Receitas';

  @override
  String get language => 'Idioma';

  @override
  String get languageChanged => 'Idioma alterado';

  @override
  String get leagueTable => 'Tabela da Liga';

  @override
  String get loyaltyBonus => 'Bónus de Lealdade';

  @override
  String lvLevel(int level) {
    return 'Nv $level';
  }

  @override
  String matchPlayedFriendly(Object home, Object away) {
    return 'Jogo realizado\n$home vs $away (amigável/fora de calendário)';
  }

  @override
  String matchResult(int week, Object home, int hg, int ag, Object away) {
    return 'Resultado — Semana $week\n$home $hg - $ag $away';
  }

  @override
  String get matchScheduled => 'Jogo agendado';

  @override
  String get myTeam => 'A Minha Equipa';

  @override
  String get nationalStandings => 'Classificação Nacional';

  @override
  String get negotiate => 'Negociar';

  @override
  String get nextMatch => 'Próximo jogo';

  @override
  String nextOpponent(Object opponent) {
    return 'Próximo adversário: $opponent';
  }

  @override
  String get noFixturesScheduled => 'Sem jogos agendados';

  @override
  String get noNotifications => 'Sem notificações';

  @override
  String get noStandingsYet =>
      'Ainda não há classificação. Joga um jogo para preencher a tabela.';

  @override
  String get notifications => 'Notificações';

  @override
  String get ok => 'OK';

  @override
  String get perAssist => 'Por Assistência';

  @override
  String get perGoal => 'Por Golo';

  @override
  String get performanceBonuses => 'Bónus de Desempenho';

  @override
  String get play => 'Jogar';

  @override
  String get playAdvance => 'Jogar e Avançar';

  @override
  String get playersStandings => 'Classificação de Jogadores';

  @override
  String get preview => 'Pré-visualização';

  @override
  String get previewSubtitle => 'Pré-visualização de etiquetas comuns';

  @override
  String raiseApproved(double inc, double next) {
    return 'Aumento aprovado (+$inc/semana). Novo salário: $next/semana.';
  }

  @override
  String get raiseDenied =>
      'Aumento recusado por agora. Melhora forma e reputação para aumentar as hipóteses.';

  @override
  String get reject => 'Rejeitar';

  @override
  String get releaseClause => 'Cláusula de Rescisão';

  @override
  String get requestSalaryRaise => 'Pedir Aumento';

  @override
  String get requestTransfer => 'Pedir Transferência';

  @override
  String resultScore(int hg, int ag) {
    return 'Resultado: $hg - $ag';
  }

  @override
  String get restAllSquad => 'Descansar Plantel';

  @override
  String get salary => 'Salário';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get settings => 'Definições';

  @override
  String get skills => 'Skills';

  @override
  String statusPercent(Object status, int value) {
    return 'Estado: $status ($value%)';
  }

  @override
  String get store => 'Loja';

  @override
  String get topAssists => 'Melhores Assistentes';

  @override
  String get topScorers => 'Melhores Marcadores';

  @override
  String get train => 'Treinar';

  @override
  String get trophiesMilestones => 'Troféus e marcos';

  @override
  String get tryYourLuck => 'Tenta a tua sorte';

  @override
  String get viewContract => 'Ver Contrato';

  @override
  String wWeek(int week) {
    return 'S$week';
  }

  @override
  String get wagerAmount => 'Valor da aposta';

  @override
  String get week => 'Semana';

  @override
  String get weekly => 'Semanal';

  @override
  String get weeklyCosts => 'Custos Semanais';

  @override
  String get weeklyIncome => 'Receita Semanal';
}
