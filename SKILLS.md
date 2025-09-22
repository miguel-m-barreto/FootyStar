# Footy Star v1.0.1 — Skill Set (18 Core)

## Skills

### Físicas (6)

1) Acceleration — How fast you explode from a standstill.
2) Sprint Speed — Top speed sustained over distance.
3) Agility — Quick body turns and direction changes.
4) Strength — Shielding the ball and winning shoulder duels.
5) Jumping — Vertical leap and timing in aerials.
6) Stamina — Hold performance to 90’ (late-game decay reducer).

### Técnicas (7)

7) First Touch — Clean first control (foot/chest), fewer bad receptions.
8) Dribbling — Close control at pace; 1v1 take-ons.
9) Short Passing — Accuracy and tempo up to ~20m.
10) Long Passing — Driven/lofted accuracy beyond ~20m.
11) Finishing — Quick box finishing and 1v1 outcomes.
12) Long Shots — Shooting from range; scales with Shot Power.
13) Heading — Direction and power on aerial contact.

### Mentais/Defensivas (5)

14) Anticipation — Reading play to arrive first and intercept.
15) Positioning — Being in the right spot (attack/defense context).
16) Marking — Staying tight and body-orienting without fouling.
17) Tackling — Winning the ball cleanly (includes slides).
18) Composure — Decisions under pressure; fewer chokes in key moments.

------

## Moments

Como cada role usa isto nos “Moments”

### avançado

- Box Finish: Finishing 60, Composure 20, First Touch 10, Positioning 10.
- 1v1 vs GK: Finishing 45, Composure 35, Acceleration 10, Dribbling 10.
- Offensive Header: Heading 55, Jumping 25, Positioning 10, Strength 10.
- Long Shot: Long Shots 55, (+Shot Power bonus), Composure 20, Dribbling 10, 
- Positioning 15 → rebalance para 100: use 45/—/20/10/25 (LongShots 45, 
- ShotPower bonus, Composure 20, Dribbling 10, Positioning 25).

### médio

- Through Ball (short): Short Passing 55, Anticipation 20, Composure 15, Dribbling 10.
- Switch of Play: Long Passing 60, Anticipation 20, Composure 20.
- Edge-of-Box Shot: Long Shots 50, Composure 25, First Touch 15, Dribbling 10.

### defesa

- Stand Tackle: Tackling 55, Marking 25, Anticipation 15, Strength 5.
- Interception: Anticipation 50, Positioning 30, Agility 20.
- Aerial Clear: Heading 50, Jumping 30, Strength 20.

(Os pesos são percentagens relativas que somam 100; ligam direto ao teu motor de moments.)

---

## Custos, xp e progressão

### Opção 1 Progresso com limites

### Progressão e recompensas (ligam direto ao sistema XP/SP/$)

- XP cap por nível (5→100): exponencial contínua com âncoras: XPcap(L) = round( X0 * (X1/X0)^((L-5)/95) )

Recomendado: X0=30, X1=350 (crescimento ~+2.6%/nível).

- Custo $ por promoção: Cost(L) = round( C0 * (C1/C0)^((L-5)/95) )

Recomendado: C0=£300, C1=£13,000 (~+4.0%/nível).

- SP ganho por jogo (antes de multiplicadores): base 5 +2/golo +1/assist +1/MOM.

Conversão: 1 SP = 10 XP (sem limite; SP não promove).

#### Multiplicadores:

- Minutes: minFactor = clamp(min/90, 0.3..1.0)

- Rating: rateFactor = 0.6 + 0.1*rating (5.0→1.1, 8.0→1.4)

- League: leagueFactor ∈ {0.85, 1.00, 1.15, 1.30}

- MMR anti-farm: 1/(1 + 0.015*ΔOVR^2) (se jogas abaixo do teu nível)

- Overflow com cap cheio: 25% do XP extra → SP (anti-frustração).

#### Seleção de minutos (sem energia, coerente)

Selection Score:
0.6*RoleOVR + 0.2*Reputation + 0.2*CoachRelation (+injury gates)
Rep ≥40 → tende a 90’. Stamina apenas reduz debuff tardio, não “gasta”.

### Opção 2 Banked Progress (Fila de Promoções)

- Quando uma skill enche a barra de XP: Não trava. Todo XP extra continua a acumular para os próximos níveis dessa skill, sem limites, até ao nível 100.

- O resultado é uma fila de promoções: +N níveis prontos + XP parcial do nível seguinte.

- Nada sobe de nível nem afeta OVR até pagares. Quando tiveres $, podes promover 1, várias ou todas de uma vez.

- Estados por skill (sem código, só lógica)

#### Lógica

- Level (L): 5…100.

- XP_atual: 0…XPcap(L) (se a fila estiver vazia).

- QueuedLevels (QL): inteiros de níveis completamente “pagáveis”.

- QueuedXP: progresso parcial do nível virtual (L + QL) (0…XPcap(L+QL)).

- Virtual Level (VL): VL = L + QL. (Só para cálculo/UX; não conta para OVR até pagares.)

- No 100: se VL == 100 e recebes mais XP/SP, converte 50% em SP (não perdes progresso; incentiva gastar SP noutras skills).

Como entra XP/SP

XP de jogo (moments com multiplicadores) e SP→XP sempre avançam a barra pela sequência:
L → L+1 → L+2 → …
Podem “encher” 3, 4, 7 níveis — o que for. Sem desperdício.

SP continua: 1 SP = 10 XP, sem teto. Podes encher 100% via SP e bancar quantos níveis quiseres.

Promoção (paga e aplica)

Cost(L) mantém a curva exponencial:
Cost(L) = round(C0 * (C1/C0)^((L-5)/95)) (ex.: C0=£300, C1=£13 000).

Promote 1: paga Cost(L), aplica L := L+1.

Promote All: paga Σ_i Cost(L + i) para i = 0…QL-1, aplica de uma vez.

Partial mantém-se: QueuedXP fica como progresso do próximo nível.

UI/UX (sem confusão)

Cada skill mostra: Level 62 (+3 queued) e uma barra “Next (partial)”.

Botões:

Promote (1 nível) — mostra custo corrente.

Promote xN — dropdown com N e custo total.

Promote All — custo total das QL.

Tooltip: “Stats só contam quando promoves.” (sem choros depois 🤷)

Exemplo (números redondos)

Estás em L=5, XPcap(5)=30. Jogas bem + gastas SP, total 380 XP na mesma skill.

Avança:

L5→L6 (30), sobra 350

L6→L7 (31), sobra 319

L7→L8 (32), sobra 287

L8→L9 (33), sobra 254

L9→L10 (34), sobra 220

L10→L11 (35), sobra 185

L11→L12 (37), sobra 148

L12→L13 (38), sobra 110

L13→L14 (39), sobra 71
→ Ficas com QL=9 e QueuedXP=71 rumo a L14.
Tens £0? Fine. Quando entrarem salários/prémios, podes pagar 9 promoções de seguida; o QueuedXP=71 continua lá.

Impacto no resto do design

Overflow→SP (25%): removido (não é preciso, já não há perda).

MMR anti-farm, league/minutes/rating multipliers: mantêm-se iguais — só afetam a velocidade de encher a fila, não a promoção em si.

Treino: continua a ser só SP→XP com bónus de eficiência; entra na mesma fila.

OVR/Seleção: não usa VL; só conta depois de promover. Queres subir no onze? Paga. É o travão económico do jogo.

Riscos & salvaguardas

Explosão late-game (“20 níveis de uma vez”): é propositado e controlado pelo custo exponencial. Se ficar rápido demais, sobe C1 (ex.: £16–18k).

Sentir “estou melhor mas não rendo mais”: resolvido com UI clara + “Promote All” a um toque.

Cap 100: todo XP extra vira SP a 50% nessa skill; incentiva distribuir.



---

## Tradução
para depois traduzir:

PT - EN (para UI futura em EN)

Aceleração - Acceleration

Agilidade - Agility

Antecipação - Anticipation

Aproximação - (coberto por Acceleration/Positioning/Marking)

Bravura - (trait futuro; leve bónus em Tackling/Heading)

Cabeceio - Heading

Carrinho - Tackling

Chuto curto - Finishing

Chuto longo - Long Shots

Compostura - Composure

Concentração - (trait futuro “Consistency”)

Confiança - Confidence (estado derivado, não skill)

Controlo - First Touch

Criatividade - (1.1: Vision)

Determinação - (trait futuro “Work Rate/Drive”)

Domínio de peito - First Touch

Drible - Dribbling

Força – corpo - Strength

Força – perna - (Shot Power interno, bónus)

Liderança - (trait futuro)

Marcação - Marking

Passe curto - Short Passing

Passe longo - Long Passing

Posicionamento - Positioning

Salto - Jumping Reach

Velocidade - Sprint Speed

Técnica - (cortada no MVP)

Vigor - Stamina

Pontaria - (dividida em Finishing/Passing)