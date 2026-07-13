## Alertas Dinâmicos

### País com Maior Queda

Identifica dinamicamente o país com a maior queda de faturamento, comparando o ano mais recente no contexto (MAX de dCalendario[Ano]) contra o ano anterior. Robusto: funciona mesmo com 'Todos' selecionado no filtro de ano.

```dax
País com Maior Queda =
VAR AnoAtual = MAX(dCalendario[Ano]) VAR TabelaVariacoes = ADDCOLUMNS( VALUES(DimStore[RegionCountryName]), "@VarRS", CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual) - CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual - 1) ) VAR TabelaValida = FILTER(TabelaVariacoes, NOT ISBLANK([@VarRS])) VAR PaisMaiorQueda = MINX(TOPN(1, TabelaValida, [@VarRS], ASC), DimStore[RegionCountryName]) RETURN IF(ISBLANK(PaisMaiorQueda), "Sem dados no período", PaisMaiorQueda)
```

### Valor da Queda - País Crítico

Valor em R$ da queda do país crítico, comparando o ano mais recente no contexto contra o ano anterior. Robusto a filtro 'Todos'.

```dax
Valor da Queda - País Crítico =
VAR AnoAtual = MAX(dCalendario[Ano]) VAR TabelaVariacoes = ADDCOLUMNS( VALUES(DimStore[RegionCountryName]), "@VarRS", CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual) - CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual - 1) ) VAR TabelaValida = FILTER(TabelaVariacoes, NOT ISBLANK([@VarRS])) RETURN MINX(TabelaValida, [@VarRS])
```

### Alerta País Crítico

Texto pronto para cartão: país com maior queda + valor R$ + percentual, comparando ano mais recente no contexto vs ano anterior.

```dax
Alerta País Crítico =
VAR Pais = [País com Maior Queda] VAR Valor = [Valor da Queda - País Crítico] VAR Perc = [% Queda - País Crítico] RETURN IF(ISBLANK(Valor), "Sem dados suficientes para comparação", Pais & " (" & FORMAT(Valor, "R$ #,0") & " | " & FORMAT(Perc, "0.00%") & ")")
```

### % Queda - País Crítico

Percentual de queda do país crítico, comparando ano mais recente no contexto vs ano anterior. Robusto a filtro 'Todos'.

```dax
% Queda - País Crítico =
VAR AnoAtual = MAX(dCalendario[Ano]) VAR TabelaVariacoes = ADDCOLUMNS( VALUES(DimStore[RegionCountryName]), "@VarRS", CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual) - CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual - 1), "@FatAnterior", CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual - 1) ) VAR TabelaValida = FILTER(TabelaVariacoes, NOT ISBLANK([@VarRS])) VAR LinhaCritica = TOPN(1, TabelaValida, [@VarRS], ASC) RETURN DIVIDE(MINX(LinhaCritica, [@VarRS]), MAXX(LinhaCritica, [@FatAnterior]))
```

### Perda Acumulada por País ($)

Calcula quanto cada país (RegionCountryName) deixou de faturar no total, comparando o primeiro ano com o último ano disponível na base (ignora filtro de ano selecionado, sempre olha o histórico completo). Valor negativo = perda; positivo = crescimento.

```dax
Perda Acumulada por País ($) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR AnoMax = CALCULATE(MAX(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR FatInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, ALL(dCalendario[Ano]))
VAR FatFinal = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMax, ALL(dCalendario[Ano]))

RETURN 
FatFinal - FatInicial
```

### Perda Acumulada por País (%)

Percentual de queda (ou crescimento) acumulado de cada país (RegionCountryName), comparando o primeiro ano com o último ano disponível na base. Ignora filtro de ano selecionado, sempre olha o histórico completo.

```dax
Perda Acumulada por País (%) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR AnoMax = CALCULATE(MAX(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR FatInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, ALL(dCalendario[Ano])) 
VAR FatFinal = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMax, ALL(dCalendario[Ano])) 

RETURN DIVIDE(FatFinal - FatInicial, FatInicial)
```

### País Crítico - Período Total

Identifica o país com a maior perda acumulada de faturamento no período completo (primeiro ano vs último ano da base). Correto para uso em Card sem filtro de país.

```dax
País Crítico - Período Total =
VAR TabelaPerdas = ADDCOLUMNS( VALUES(DimStore[RegionCountryName]), "@Perda", CALCULATE([Perda Acumulada por País ($)]) ) VAR TabelaValida = FILTER(TabelaPerdas, NOT ISBLANK([@Perda])) VAR PaisCritico = MINX(TOPN(1, TabelaValida, [@Perda], ASC), DimStore[RegionCountryName]) RETURN IF(ISBLANK(PaisCritico), "Sem dados", PaisCritico)
```

### Valor Perda - País Crítico (Período Total)

Valor em R$ da perda acumulada do país crítico no período completo (primeiro ano vs último ano da base). Correto para uso em Card sem filtro de país.

```dax
Valor Perda - País Crítico (Período Total) =
VAR TabelaPerdas = ADDCOLUMNS( VALUES(DimStore[RegionCountryName]), "@Perda", CALCULATE([Perda Acumulada por País ($)]) ) VAR TabelaValida = FILTER(TabelaPerdas, NOT ISBLANK([@Perda])) RETURN MINX(TabelaValida, [@Perda])
```

### Alerta País Crítico (Período Total)

Texto pronto para card: país com maior perda acumulada no período total + valor R$ + %.

```dax
Alerta País Crítico (Período Total) =
VAR Pais = [País Crítico - Período Total] 
VAR Valor = [Valor Perda - País Crítico (Período Total)] 
VAR TabelaPerc = ADDCOLUMNS( VALUES(DimStore[RegionCountryName]), "@Perda", CALCULATE([Perda Acumulada por País ($)]), "@PercPerda", CALCULATE([Perda Acumulada por País (%)]) )
VAR Perc = MINX(TOPN(1, FILTER(TabelaPerc, NOT ISBLANK([@Perda])), [@Perda], ASC), [@PercPerda])
 
RETURN IF(ISBLANK(Valor), "Sem dados suficientes", Pais & " (" & FORMAT(Valor, "$ #,0") & " | " & FORMAT(Perc, "0.00%") & ")")
```

### Perda Acumulada por Categoria ($)

Calcula quanto cada categoria de produto (ProductCategoryName) deixou de faturar no total, comparando o primeiro ano com o último ano disponível na base. Ignora filtro de ano selecionado.

```dax
Perda Acumulada por Categoria ($) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR AnoMax = CALCULATE(MAX(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR FatInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, ALL(dCalendario[Ano])) 
VAR FatFinal = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMax, ALL(dCalendario[Ano])) 

RETURN FatFinal - FatInicial
```

### Perda Acumulada por Categoria (%)

Percentual de queda (ou crescimento) acumulado de cada categoria de produto, comparando o primeiro ano com o último ano disponível na base.

```dax
Perda Acumulada por Categoria (%) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR AnoMax = CALCULATE(MAX(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR FatInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, ALL(dCalendario[Ano])) 
VAR FatFinal = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMax, ALL(dCalendario[Ano])) 

RETURN DIVIDE(FatFinal - FatInicial, FatInicial)
```

### Categoria Crítica - Período Total

Identifica a categoria de produto com a maior perda acumulada de faturamento no período completo (primeiro ano vs último ano). Correto para uso em Card sem filtro de categoria.

```dax
Categoria Crítica - Período Total =
VAR TabelaPerdas = ADDCOLUMNS( VALUES(DimProduct[ProductCategoryName]), "@Perda", CALCULATE([Perda Acumulada por Categoria ($)]) ) VAR TabelaValida = FILTER(TabelaPerdas, NOT ISBLANK([@Perda])) VAR CategoriaCritica = MINX(TOPN(1, TabelaValida, [@Perda], ASC), DimProduct[ProductCategoryName]) RETURN IF(ISBLANK(CategoriaCritica), "Sem dados", CategoriaCritica)
```

### Valor Perda - Categoria Crítica (Período Total)

Valor em R$ da perda acumulada da categoria crítica no período completo. Correto para uso em Card sem filtro de categoria.

```dax
Valor Perda - Categoria Crítica (Período Total) =
VAR TabelaPerdas = ADDCOLUMNS( VALUES(DimProduct[ProductCategoryName]), "@Perda", CALCULATE([Perda Acumulada por Categoria ($)]) ) VAR TabelaValida = FILTER(TabelaPerdas, NOT ISBLANK([@Perda])) RETURN MINX(TabelaValida, [@Perda])
```

### Alerta Categoria Crítica (Período Total)

Texto pronto para card: categoria de produto com maior perda acumulada no período total + valor R$ + %.

```dax
Alerta Categoria Crítica (Período Total) =
VAR Categoria = [Categoria Crítica - Período Total] 
VAR Valor = [Valor Perda - Categoria Crítica (Período Total)] 
VAR TabelaPerc = ADDCOLUMNS( VALUES(DimProduct[ProductCategoryName]), "@Perda", CALCULATE([Perda Acumulada por Categoria ($)]), "@PercPerda", CALCULATE([Perda Acumulada por Categoria (%)]) ) 
VAR Perc = MINX(TOPN(1, FILTER(TabelaPerc, NOT ISBLANK([@Perda])), [@Perda], ASC), [@PercPerda]) 

RETURN IF(ISBLANK(Valor), "Sem dados suficientes", Categoria & " (" & FORMAT(Valor, "$ #,0") & " | " & FORMAT(Perc, "0.00%") & ")")
```

### % da Queda Total por País

Calcula o percentual que cada país (RegionCountryName) representa na perda total de faturamento da empresa (período completo, primeiro ano vs último ano). Use numa tabela/matriz com RegionCountryName nas linhas.

```dax
% da Queda Total por País =
IF( HASONEVALUE(DimStore[RegionCountryName]), VAR PerdaPais = [Perda Acumulada por País ($)] VAR PerdaTotalEmpresa = CALCULATE([Perda Acumulada por País ($)], ALL(DimStore)) RETURN DIVIDE(PerdaPais, PerdaTotalEmpresa), "" )
```

### Mês Crítico (Maior Queda MoM)

Identifica o mês específico (Ano-Mês) com a maior queda de faturamento em relação ao mês anterior (comparação cronológica mês a mês, não ano a ano).

```dax
Mês Crítico (Maior Queda MoM) =
VAR TabelaMeses = ADDCOLUMNS( VALUES(dCalendario[Ano-Mês Chave]), "@Periodo", CALCULATE(SELECTEDVALUE(dCalendario[Período Mês-Ano])), "@Variacao", CALCULATE([Faturamento Total]) - CALCULATE([Faturamento Total], DATEADD(dCalendario[Date], -1, MONTH)), "@FatAnterior", CALCULATE([Faturamento Total], DATEADD(dCalendario[Date], -1, MONTH)) ) VAR TabelaValida = FILTER(TabelaMeses, NOT ISBLANK([@FatAnterior])) VAR MesCritico = MAXX(TOPN(1, TabelaValida, [@Variacao], ASC), [@Periodo]) RETURN IF(ISBLANK(MesCritico), "Sem dados", MesCritico)
```

### Valor Perda - Mês Crítico

Valor em R$ da queda do mês crítico (comparação com o mês anterior cronológico).

```dax
Valor Perda - Mês Crítico =
VAR TabelaMeses = ADDCOLUMNS( VALUES(dCalendario[Ano-Mês Chave]), "@Variacao",
 CALCULATE([Faturamento Total]) - CALCULATE([Faturamento Total], 
 DATEADD(dCalendario[Date], -1, MONTH)), "@FatAnterior", 
 CALCULATE([Faturamento Total], 
 DATEADD(dCalendario[Date], -1, MONTH)) ) 

VAR TabelaValida = FILTER(TabelaMeses, NOT ISBLANK([@FatAnterior])) 

RETURN MINX(TabelaValida, [@Variacao])
```

### % Queda - Mês Crítico

Percentual de queda do mês crítico em relação ao mês anterior cronológico.

```dax
% Queda - Mês Crítico =
VAR TabelaMeses = ADDCOLUMNS( VALUES(dCalendario[Ano-Mês Chave]), "@Variacao", CALCULATE([Faturamento Total]) - CALCULATE([Faturamento Total], DATEADD(dCalendario[Date], -1, MONTH)), "@FatAnterior", CALCULATE([Faturamento Total], DATEADD(dCalendario[Date], -1, MONTH)) ) VAR TabelaValida = FILTER(TabelaMeses, NOT ISBLANK([@FatAnterior])) VAR LinhaCritica = TOPN(1, TabelaValida, [@Variacao], ASC) RETURN DIVIDE(MINX(LinhaCritica, [@Variacao]), MAXX(LinhaCritica, [@FatAnterior]))
```

### Alerta Mês Crítico

Texto pronto para card: mês com maior queda MoM + valor R$ + %.

```dax
Alerta Mês Crítico =
VAR Mes = [Mês Crítico (Maior Queda MoM)] 
VAR Valor = [Valor Perda - Mês Crítico] 
VAR Perc = [% Queda - Mês Crítico] 

RETURN 
IF(ISBLANK(Valor), "Sem dados suficientes", Mes & " (" & FORMAT(Valor, "$ #,0") & " | " & FORMAT(Perc, "0.00%") & ")")
```

### Perda do Pico Sazonal ($)

Compara o faturamento do pico sazonal (Novembro + Dezembro) do ano mais recente no contexto contra o mesmo período do ano anterior. Robusto a filtro 'Todos'.

```dax
Perda do Pico Sazonal ($) =
VAR AnoAtual = MAX(dCalendario[Ano]) 
VAR FatPicoAtual = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual, dCalendario[Mês Número] IN {11, 12}) 
VAR FatPicoAnterior = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual - 1, dCalendario[Mês Número] IN {11, 12}) 

RETURN FatPicoAtual - FatPicoAnterior
```

### Perda do Pico Sazonal (%)

Percentual de queda (ou crescimento) do pico sazonal (Novembro + Dezembro) do ano mais recente no contexto vs o mesmo período do ano anterior.

```dax
Perda do Pico Sazonal (%) =
VAR AnoAtual = MAX(dCalendario[Ano]) VAR FatPicoAtual = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual, dCalendario[Mês Número] IN {11, 12}) VAR FatPicoAnterior = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoAtual - 1, dCalendario[Mês Número] IN {11, 12}) RETURN DIVIDE(FatPicoAtual - FatPicoAnterior, FatPicoAnterior)
```

### Alerta Pico Sazonal

Texto pronto para card: perda do pico sazonal de fim de ano (Nov+Dez) comparado ao ano anterior, com valor R$ e %.

```dax
Alerta Pico Sazonal =
VAR Valor = [Perda do Pico Sazonal ($)] VAR Perc = [Perda do Pico Sazonal (%)] RETURN IF(ISBLANK(Valor), "Sem dados suficientes", "Pico Nov+Dez: " & FORMAT(Valor, "R$ #,0") & " (" & FORMAT(Perc, "0.00%") & ")")
```

### Perda Pico Sazonal (Período Total) ($)

Compara o faturamento do pico sazonal (Novembro + Dezembro) do primeiro ano da base contra o último ano da base (ex: 2007 vs 2009). Ignora filtro de ano selecionado, sempre olha o período completo.

```dax
Perda Pico Sazonal (Período Total) ($) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano])) VAR AnoMax = CALCULATE(MAX(dCalendario[Ano]), ALL(dCalendario[Ano])) VAR FatPicoInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, dCalendario[Mês Número] IN {11, 12}, ALL(dCalendario[Ano])) VAR FatPicoFinal = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMax, dCalendario[Mês Número] IN {11, 12}, ALL(dCalendario[Ano])) RETURN FatPicoFinal - FatPicoInicial
```

### Perda Pico Sazonal (Período Total) (%)

Percentual de queda do pico sazonal (Nov+Dez), comparando o primeiro ano da base contra o último ano da base. Ignora filtro de ano selecionado.

```dax
Perda Pico Sazonal (Período Total) (%) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano])) VAR AnoMax = CALCULATE(MAX(dCalendario[Ano]), ALL(dCalendario[Ano])) VAR FatPicoInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, dCalendario[Mês Número] IN {11, 12}, ALL(dCalendario[Ano])) VAR FatPicoFinal = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMax, dCalendario[Mês Número] IN {11, 12}, ALL(dCalendario[Ano])) RETURN DIVIDE(FatPicoFinal - FatPicoInicial, FatPicoInicial)
```

### Alerta Pico Sazonal (Período Total)

Texto pronto para card: perda do pico sazonal comparando o primeiro e o último ano da base (período completo).

```dax
Alerta Pico Sazonal (Período Total) =
VAR Valor = [Perda Pico Sazonal (Período Total) ($)] 
VAR Perc = [Perda Pico Sazonal (Período Total) (%)] 

RETURN IF(ISBLANK(Valor), "Sem dados suficientes", "Pico Nov+Dez 2007→2009: " & FORMAT(Valor, "$ #,0") & " (" & FORMAT(Perc, "0.00%") & ")")
```

### Perda Acumulada por Trimestre (%)

Percentual de queda (ou crescimento) acumulado por Trimestre, comparando o primeiro ano com o último ano disponível na base (ex: T4 2007 vs T4 2009). Use com Trimestre nas linhas/eixo do visual.

```dax
Perda Acumulada por Trimestre (%) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano]))
VAR AnoMax = CALCULATE(MAX(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR FatInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, ALL(dCalendario[Ano]))
VAR FatFinal = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMax, ALL(dCalendario[Ano])) 

RETURN DIVIDE(FatFinal - FatInicial, FatInicial)
```

### Perda Acumulada por Trimestre ($)

Valor em R$ da perda acumulada por Trimestre, comparando o primeiro ano com o último ano disponível na base. Use com Trimestre nas linhas/eixo do visual.

```dax
Perda Acumulada por Trimestre ($) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR AnoMax = CALCULATE(MAX(dCalendario[Ano]), ALL(dCalendario[Ano])) 
VAR FatInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, ALL(dCalendario[Ano])) 
VAR FatFinal = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMax, ALL(dCalendario[Ano])) 

RETURN FatFinal - FatInicial
```

### Perda Acumulada por Categoria (Ano Selecionado) ($)

Calcula a perda (ou ganho) acumulada de cada categoria, comparando o primeiro ano da base contra o ano selecionado no filtro (slicer 'Selecione o Ano' ou contexto de linha/coluna com Ano). Diferente da versao original, esta medida RESPEITA o filtro de ano: com 'Todos' selecionado, AnoSelecionado = ultimo ano da base (mesmo resultado da medida original); com um ano especifico selecionado, mostra a perda acumulada ate aquele ano.

```dax
Perda Acumulada por Categoria (Ano Selecionado) ($) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano]))
VAR AnoSelecionado = MAX(dCalendario[Ano])
VAR FatInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, ALL(dCalendario[Ano]))
VAR FatSelecionado = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoSelecionado, ALL(dCalendario[Ano]))
RETURN FatSelecionado - FatInicial
```

### Perda Acumulada por Categoria (Ano Selecionado, Oculta Ano Base) ($)

Igual a 'Perda Acumulada por Categoria (Ano Selecionado) ($)', mas retorna BLANK() no ano-base (primeiro ano da base, ex: 2007), em vez de 0. Isso faz com que o ano-base nao apareca em tabelas/matrizes (Power BI oculta automaticamente linhas onde todas as medidas sao BLANK, desde que 'Mostrar itens sem dados' esteja desativado). Assim, so aparecem os anos que de fato tiveram perda/ganho acumulado calculavel (ex: 2008, 2009).

```dax
Perda Acumulada por Categoria (Ano Selecionado, Oculta Ano Base) ($) =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano]))
VAR AnoSelecionado = MAX(dCalendario[Ano])
VAR FatInicial = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoMin, ALL(dCalendario[Ano]))
VAR FatSelecionado = CALCULATE([Faturamento Total], dCalendario[Ano] = AnoSelecionado, ALL(dCalendario[Ano]))
RETURN
    IF(
        AnoSelecionado = AnoMin,
        BLANK(),
        FatSelecionado - FatInicial
    )
```

### Filtro - E Ano Base

Medida auxiliar para uso como FILTRO DE VISUAL (nao para exibir em cartao/coluna). Retorna 1 quando o Ano em contexto e o ano-base (primeiro ano da base, ex: 2007) e 0 caso contrario. Arraste esta medida para o painel de Filtros do visual (tabela/matriz) e configure o filtro como 'e igual a' -> desmarque 1 (ou configure 'nao e igual a 1'). Isso remove a linha/coluna do ano-base completamente do visual, mesmo que outras medidas (ex: Faturamento Total) tenham valor nesse ano.

```dax
Filtro - E Ano Base =
VAR AnoMin = CALCULATE(MIN(dCalendario[Ano]), ALL(dCalendario[Ano]))
VAR AnoSelecionado = MAX(dCalendario[Ano])
RETURN
    IF(AnoSelecionado = AnoMin, 1, 0)
```
