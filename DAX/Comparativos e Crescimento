## Comparativos e Crescimento

### Vendas Período Mês Anterior

Vendas do período anterior para comparação

```dax
Vendas Período Mês Anterior =
CALCULATE([Faturamento Total], DATEADD(dCalendario[Date], -1, MONTH))
```

### Vendas Ano Anterior

Vendas do mesmo período no ano anterior

```dax
Vendas Ano Anterior =
VAR AnoAtual = MAX(dCalendario[Ano]) RETURN CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual - 1)
```

### Variação % vs Período MêS Anterior

Variação percentual em relação ao período anterior

```dax
Variação % vs Período MêS Anterior =
DIVIDE([Faturamento Total] - [Vendas Período Mês Anterior], [Vendas Período Mês Anterior], 0) * 100
```

### Crescimento % YoY

Crescimento percentual vs mesmo período do ano passado

```dax
Crescimento % YoY =
DIVIDE([Faturamento Total] - [Vendas Ano Anterior], [Vendas Ano Anterior], 0) * 100
```

### Variação R$ vs Período Mês Anterior

Valor absoluto da variação vs período anterior

```dax
Variação R$ vs Período Mês Anterior =
[Faturamento Total] - [Vendas Período Mês Anterior]
```

### Crescimento R$ YoY

Valor absoluto do crescimento YoY

```dax
Crescimento R$ YoY =
[Faturamento Total] - [Vendas Ano Anterior]
```

### Lucro Ano Anterior

Lucro líquido do mesmo período no ano anterior

```dax
Lucro Ano Anterior =
CALCULATE([Lucro Líquido], SAMEPERIODLASTYEAR(dCalendario[Date]))
```

### Crescimento Lucro % YoY

Crescimento do lucro líquido vs ano anterior (%)

```dax
Crescimento Lucro % YoY =
DIVIDE([Lucro Líquido] - [Lucro Ano Anterior], ABS([Lucro Ano Anterior]), BLANK()) * 100
```

### Margem Ano Anterior %

Margem de lucro do mesmo período no ano anterior

```dax
Margem Ano Anterior % =
CALCULATE([Margem de Lucro %], SAMEPERIODLASTYEAR(dCalendario[Date]))
```

### Variação Margem pp YoY

Diferença em pontos percentuais da margem vs ano anterior

```dax
Variação Margem pp YoY =
[Margem de Lucro %] - [Margem Ano Anterior %]
```

### Ticket Médio Ano Anterior

Ticket médio do mesmo período no ano anterior

```dax
Ticket Médio Ano Anterior =
CALCULATE([Ticket Médio], SAMEPERIODLASTYEAR(dCalendario[Date]))
```

### Crescimento Ticket % YoY

Crescimento do ticket médio vs ano anterior (%)

```dax
Crescimento Ticket % YoY =
DIVIDE([Ticket Médio] - [Ticket Médio Ano Anterior], ABS([Ticket Médio Ano Anterior]), BLANK()) * 100
```

### Vendas Período Ano Anterior

```dax
Vendas Período Ano Anterior =
CALCULATE([Faturamento Total], DATEADD(dCalendario[Date], -1, YEAR))
```

### Variação R$ vs Período Ano Anterior

```dax
Variação R$ vs Período Ano Anterior =
VAR variacao = [Faturamento Total] - [Vendas Período Ano Anterior]
VAR Variacao2 = DIVIDE([Faturamento Total] - [Vendas Período Ano Anterior], [Vendas Ano Anterior], 0)
RETURN
IF(variacao <= 0, BLANK())
```

### Variação % vs Período Ano Anterior

```dax
Variação % vs Período Ano Anterior =
DIVIDE([Faturamento Total] - [Vendas Período Ano Anterior], [Vendas Ano Anterior], BLANK())
```

### Margem Ano Anterior % COM SETA novo

```dax
Margem Ano Anterior % COM SETA novo =
VAR MargemAtual = [Margem de Lucro %] / 100

VAR MargemAnterior = CALCULATE( [Margem de Lucro %] / 100, SAMEPERIODLASTYEAR(dCalendario[Date]))

RETURN
IF(MargemAtual > MargemAnterior, FORMAT(MargemAtual, "0.00%") & "▲", FORMAT(MargemAnterior, "0.00%") & "▼" )
```
