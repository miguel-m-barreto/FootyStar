# Footy Star v1.0.1
## Contracts
1) Contratos (definem o salário — ponto)

Cada oferta tem: clubTier (1–4), role (Bench/Rotation/Starter/Key), position (ST/MF/DF), weekly_wage, bonuses, duration=20 semanas.

1.1 Bandas salariais por tier (faixas-alvo do clube)

Tier1: £600–£1 200

Tier2: £1 200–£2 400

Tier3: £2 400–£4 800

Tier4: £4 800–£9 000
Wage ceiling (hard cap por jogador): T1 £1.2k, T2 £2.8k, T3 £5.5k, T4 £10k.

1.2 Como o clube calcula o alvo (antes da tua pedinchice)
r = Reputation / 100
base = lerp(banda_min, banda_max, r)
roleFactor: Bench 0.8 • Rotation 1.0 • Starter 1.2 • Key 1.5
posFactor: ST 1.10 • MF 1.00 • DF 0.90
target_wage = clamp(base * roleFactor * posFactor, banda_min, wage_ceiling)


Negociação: 3 tentativas. Até +10% ao alvo é plausível; +20% começa a falhar muito; >20% esquece.

1.3 Role impacta minutos (depois de assinar)

Bónus ao Selection Score: Bench +0, Rot +5, Starter +10, Key +20.

Pisos típicos: Bench 0–30’, Rot 45–75’, Starter 75–90’, Key 90’ (se saudável).

1.4 Extras do contrato (MVP)

Bónus: Golo £200, Assist £100, MOM £400 (fixos por agora).

Signing bonus: 2× weekly_wage (pago uma vez quando assinas).

Sem cláusulas de rescisão/loans/appearance fee na 1.0.1.

2) Mercado & Agente (dinâmico, não “3 ofertas no fim”)

InterestScore semanal por clube (Monitoring ≥40, Enquiry ≥60, Offer ≥80).

Janelas: semanas 9–11 e 19–20. Podes pré-acordar para fim de época.

Agente: estado Satisfied / Explore / Actively Seeking (+0 / +0.2 / +0.4 no interesse), favoritos/no-go, wage expectation (×0.9…×1.3).

No máximo 2 novas Enquiries/semana, interesse decai 8%/semana se ignorado.

3) Fluxo de dinheiro semanal (realista e jogável)

Start da semana: entra weekly_wage + endorsement(s); sai lifestyle.

Jogas & treinas: ganhas XP (moments) e SP (base 5 +2/golo +1/assist +1/MOM), multiplicado por minutes/rating/league/MMR.

Fim da semana: entram bónus (golo/assist/MOM).

Promoções de skill: pagas Cost(L) (exponencial contínua; C0=£300, C1=£13 000) e aplicas os níveis em fila (Banked Progress).

4) Endorsements (dinheiro limpo, escalonado por reputação)

Mantemos simples e previsível:

Bronze (Rep ≥50): £500/semana, 10 semanas.

Silver (Rep ≥65): £900/semana, 10 semanas.

Gold (Rep ≥80): £1 500/semana, 10 semanas.
Regra: 1 ativo de cada vez. Se assinas um superior, o inferior termina. (Nada de rescindir por má forma na 1.0.1.)

5) Lifestyle (buffs pay-as-you-go — não quebram o jogo)

Gym Pass — £250/semana → +5% de XP quando convertes SP→XP (Skills tab).

Nutrition — £150/semana → +10% XP de jogo (após multiplicadores).

Sports Psych — £200/semana → +6 Confidence/semana (ajuda nos moments).
On/off à vontade; cobrado no início da semana.

6) Investimentos (MVP-lite, com travões)

Sem SimCity. Poucos, claros, limitados, começam a render na semana seguinte. Máx 1 ativo em 1.0.1.

Index Fund — custo £5 000 → +£100/semana (ROI ~20 semanas). Requisito: Rep ≥40.

Local Franchise — custo £10 000 → +£300/semana (ROI ~33 semanas; útil se assinado cedo e/ou em v1.1). Requisito: Rep ≥60.

Bloqueado se faltarem <6 semanas para acabar a época (para não burlar ROI).

Zero revenda. Isto é um sink decente se estiveres a nadar em cash.

7) Balance targets (senão, trocamos knobs)

Starter em Tier2, rating ~7.2: salário ~£2.2k/semana; com 1–2 golos/assist → £500–900 extras + SP 6–9.
Custo médio de promoção a L60–70: £2.5k–£4k por nível. ⇒ ~1–2 promoções/semana se focares.

Key em Tier3, rating ~7.5 + Silver endorsement: £3.5k + £900/semana; promoções L80 começam a doer (£6k–£8k).

Se fica fácil demais → aumenta C1 para £16–18k ou baixa bandas salariais 10–15%.

8) Anti-exploit (para não matar o pacing)

SP nunca promove — só enche barras.

Banked Progress infinito, mas OVR só sobe quando pagas.

Wage ceiling por tier trava salários ridículos.

MMR anti-farm reduz XP/SP se jogas muito abaixo do teu nível.

Investimentos 1 ativo e ROI longo → não viras banqueiro a meio da época.

TL;DR

Salário = contrato calculado por tier + role + posição + tua reputação.

Mercado vivo por interesse semanal + agente, não “3 ofertas no fim”.

Dinheiro entra por salário/endorsement/bónus; sai por promoções de skill (gate real), lifestyle e (se quiseres) investimentos.