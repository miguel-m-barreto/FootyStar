# Footy Star v1.0.1
## 1 Match & Moments Engine

### 1.1 Nº de moments por jogo

- Base por role (90’): ST 4.0, MF 3.0, DF 2.5.

- Escala por minutos: exp = base * minFactor, onde minFactor = clamp(min/90, 0.3..1.0).

- Jitter: ±0.8 aleatório (normal), arredondado para inteiro ≥1.

- Distribuição por tipo (ST): Box Finish 0.45, Header 0.25, 1v1 0.15, Long Shot 0.15.

- (MF): Through Ball 0.45, Switch 0.25, Edge Shot 0.30.

- (DF): Stand Tackle 0.5, Interception 0.3, Aerial Clear 0.2.

### 1.2 Cálculo de sucesso

#### Define-se um score do jogador para o momento:

- S = Σ(weight_i * skill_i) + m_confidence

- m_confidence = −5…+5 (média das últimas 3 ratings, mapeada).

#### Dificuldade (D) é contínua:

- D = baseD(tipo) + Lfac + OppFac + TimeFatigue

- baseD (defaults): Box 50, 1v1 56, Header 54, LongShot 62, ThroughBall 55, Switch 52, EdgeShot 58, StandTackle 56, Interception 54, AerialClear 52.

- Lfac = (leagueTier-2)*3 ⇒ Tier1:-3, Tier2:0, Tier3:+3, Tier4:+6.

- OppFac = clamp((OppTeamRating-60)/2, -10, +15). (Usa overall defensivo/medio do oponente; MVP: rating de equipa.)

- TimeFatigue = max(0, (minute-70)/20) * clamp(15 - 0.1*Stamina, 0, 15).

#### Probabilidade (logística):

p = clamp( sigmoid((S - D)/6), 0.05, 0.95 )


#### Efeitos:

- Sucesso ofensivo gera golo no Box/1v1/LongShot (100% do “sucesso” = finalização).

- Header ofensivo: 85% golo, 15% ao lado (mas conta “big chance”, rating +0.3).

- Through Ball: 60% assist, 40% “key pass” (sem golo).

- Switch: “successful switch” (rating +0.2).

- Edge Shot: 55% golo se sucesso; caso contrário “on target” (rating +0.2).

- Stand Tackle/Interception/Clear sucessos valem rating +0.5/+0.4/+0.3 respetivamente.

#### 1.3 XP/SP por momento (antes dos multiplicadores globais)

- Sucesso (ofensivo): +8 XP na principal, +4 XP na secundária.

- Falha (ofensivo): +3 XP na principal.

- Sucesso (defensivo): +6 XP (Tackling/Interception/Heading conforme).

- Depois aplica: minFactor * rateFactor * leagueFactor * mmrFactor.

- SP por jogo (no fim): base 5 +2/golo +1/assist +1/MOM, também multiplicado por minFactor * rateFactor * leagueFactor * mmrFactor.

#### 1.4 Rating de jogo (1–10)

- Base 6.0.

- Golo +1.2, Assist +0.8, Key Pass +0.3, Switch bom +0.2.

- Desarme +0.5, Interceção +0.4, Corte aéreo +0.3.

- 1v1 falhado claro −0.4, mau First Touch que mata jogada −0.3.

- Clamp 4.5–10.0. MOM = maior rating; empate resolve pelo contributo ofensivo.

- Isto liga 1:1 às weights por momento que já fechámos.

## 2 Minutos / Seleção (sem energia)

#### Selection Score semanal:

- Sel = 0.6*RoleOVR + 0.2*Reputation + 0.2*CoachRelation + ε

ε ruído normal ±2. Lesão/ban zeram.

#### Minutos jogados:

- Se Sel >= 70 ⇒ 90’.

- 60–69 ⇒ 75–85’ (random).

- 50–59 ⇒ 45–70’.
 
- <50 ⇒ 0–30’ (banco).

#### RoleOVR 
para ST/MF/DF = média ponderada das 18 skills (pesos distintos por role; fechamos depois).

#### Reputation
sobe se rating >6.8; desce se <6.0 (multiplicado por leagueFactor).

#### CoachRelation 
+1 por treino consistente e jogos ≥7.0, −2 se faltas treino/evento negativo.