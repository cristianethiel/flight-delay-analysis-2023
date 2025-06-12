# Análise de Atrasos e Cancelamentos de Voos – EUA (Jan/2023)

Exploração de dados operacionais da aviação comercial norte-americana com o objetivo de entender os fatores que contribuem para atrasos, cancelamentos e desvios. O projeto foi desenvolvido para fornecer insights estratégicos à companhia aérea, apoiando a melhoria da eficiência operacional e a redução de custos.

## Visão Geral

Janeiro de 2023 foi marcado por disrupções históricas na aviação dos Estados Unidos, incluindo falhas técnicas e eventos climáticos extremos. A análise foca na identificação de padrões operacionais, gargalos críticos e causas dos atrasos, orientando recomendações acionáveis com foco em redução de prejuízos e otimização de processos.

## Problema Central

Atrasos e cancelamentos afetam diretamente:
- A satisfação dos passageiros
- Os custos operacionais
- A competitividade no setor

A companhia aérea precisava:
- Mapear rotas críticas
- Entender as causas operacionais dos atrasos
- Identificar padrões por período, companhia e aeroporto
- Avaliar o impacto financeiro e estrutural dos problemas

## Ferramentas e Tecnologias
- **Linguagens:** SQL (BigQuery), Python
- **Bibliotecas Python:** Pandas, NumPy, Matplotlib, Seaborn
- **Banco de Dados:** Google BigQuery
- **Visualização:** Power BI
- **Ambiente:** VS Code

## Estrutura do Repositório
- [`/dataset`](https://drive.google.com/file/d/1aJnB3STqw-KXs-_LP-0cXvBVOTQFSGXx/view?usp=sharing): Dados tratados (CSV).
- [`/dados_brutos`](https://drive.google.com/file/d/1ZrgwcRV7t39irbuf6WKEltobzpoJmzPn/view?usp=sharing): Dados originais (CSV).
- `/documentacao`: Documentação técnica.
  - `ficha_tecnica_voos.pdf`: Objetivos, metodologia, EDA e insights estratégicos.
  - `apresentacao_voos.pdf`: Principais achados e recomendações executivas.
- `flight_delay_notebook.ipynb`: Análise exploratória e estatística descritiva.
- `requirements.txt`: Dependências Python.

## Metodologia

- **Coleta e Tratamento:**
  - Dados carregados no BigQuery com análise de valores nulos e duplicados.
  - Interpretação correta dos nulos como parte do processo operacional (ex: voos cancelados).
  
- **Análise Exploratória (EDA):**
  - Estatísticas descritivas (com e sem outliers).
  - Análises por rota, companhia, período do dia e dia da semana.
  - Correlações entre variáveis operacionais.
  - Segmentação por coortes de eventos extremos (tempestades e falhas técnicas).

- **Análise de Coorte:**
  - Segmentação temporal dos voos com base em eventos críticos (ex: tempestades de gelo, falha da FAA).
  - Cálculo de taxa de atrasos, cancelamentos e análise de causas.

## Data Visualization

O projeto conta com um **dashboard interativo desenvolvido no Power BI**, dividido em três páginas principais com foco em diferentes stakeholders da companhia aérea:

### 1. Executive Summary
Foco em visão geral rápida e tomada de decisão estratégica:
- Total de voos e percentuais de pontualidade, cancelamentos e desvios.
- Causas de atrasos agrupadas por origem (operacional vs externa).
- Tendência diária de atrasos médios.
- Top cidades com mais atrasos, cancelamentos e desvios.

### 2. Delay Insights and Trends
Foco em análises operacionais detalhadas:
- Análise por horário do dia e dia da semana.
- Causas específicas dos atrasos (ex: clima, aeronave anterior, problemas com a companhia).
- Top 10 rotas e companhias por volume de atrasos.
- Distribuição por duração dos atrasos.

### 3. Diversions & Cancellations
Foco em eventos críticos e rotas impactadas:
- Análise de desvios e cancelamentos por horário e dia da semana.
- Top 5 rotas e companhias com maior número de eventos.
- Comparativo entre causas e padrões sazonais.

👉 [Acesse o Dashboard no Power BI](https://app.powerbi.com/view?r=eyJrIjoiY2NmNzg5NjctNTJhYy00NDA3LThhYzEtYjFmMTJkNGY3MDFjIiwidCI6IjVhOGViYWRmLTdlNDQtNDYzZi04OTdiLThkYzhiODcwZDAyZiJ9)


## Principais Insights

👉 [Link para a Apresentação](https://www.loom.com/share/a91105ff440b4c1093cbf05121906103)

- **35% dos atrasos** foram causados por **efeito cascata (Late Aircraft)**.
- **Clima** foi responsável por **64% dos cancelamentos**, com foco em rotas montanhosas.
- **Quarta-feira** foi o pior dia, com maior atraso médio (84,66 min) e frequência de atrasos.
- **Período da tarde** e **início da semana** são os mais críticos para o planejamento.
- Aeroportos como **FSD, JAX e AUS** apresentaram gargalos estruturais de solo (tempo de taxiamento).
- Estimativas mostram que **apenas atrasos por efeito cascata custaram >330 milhões de dólares** no mês.

## Analista de Dados

Cristiane Thiel  
🌐 [https://cristianethiel.com.br/](https://cristianethiel.com.br/)  
🔗 [https://www.linkedin.com/in/cristianethiel/](https://www.linkedin.com/in/cristianethiel/)
