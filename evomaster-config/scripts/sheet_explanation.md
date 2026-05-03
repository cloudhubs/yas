# Explicacao das colunas do CSV final

Este arquivo documenta as colunas geradas pelo script `evomaster-analysis.py`.
O CSV final tem uma linha por metodo analisado e, em alguns casos, pode haver mais de uma linha para o mesmo metodo quando ele representa multiplas chamadas HTTP.

## Identificacao do teste

| Coluna | Significado |
|---|---|
| `service` | Nome do servico analisado. Normalmente corresponde ao diretorio do servico dentro de `generated-tests/blackbox`. |
| `profile` | Perfil/role usado na geracao do teste, como `admin`, `customer` ou `none`. |
| `file` | Nome do arquivo Java de teste analisado. |
| `class` | Nome da classe Java encontrada no arquivo de teste. |
| `test_method` | Nome do metodo de teste (`public void ...`) analisado. |
| `file_type` | Classificacao derivada do nome do arquivo: `faults`, `successes`, `others` ou `unknown`. |
| `file_path` | Caminho absoluto do arquivo Java original analisado. |

## Informacoes da chamada HTTP

| Coluna | Significado |
|---|---|
| `is_complex_method` | Indica se o metodo contem multiplas chamadas HTTP ou multiplas entradas no comentario de rastreio. |
| `call_index` | Indice da chamada dentro do metodo. Em metodo simples, geralmente vale `1`. |
| `call_expected_status_code` | Status code esperado para a chamada, extraido do comentario gerado pelo EvoMaster quando essa informacao existe. |
| `endpoint` | Endpoint associado a chamada HTTP. |
| `http` | Metodo HTTP da chamada, como `GET`, `POST`, `PUT`, `PATCH` ou `DELETE`. |
| `asserted_code` | Lista dos status codes realmente verificados no corpo do teste via `.statusCode(...)`. Se houver varios, eles aparecem separados por `;`. |
| `asserts_the_expected_HTTP_status_codes?` | Trechos detectados no formato `.statusCode(...).assertThat()`, usados para indicar que houve assertiva explicita do codigo HTTP esperado. Se houver varios, aparecem separados por ` | `. |
| `assert_count` | Quantidade de asserts identificados na parte de verificacao da resposta (`then()`), incluindo status, body, headers, cookies etc. |
| `missing_url_parameter_values` | Trecho da chamada HTTP usado para inspecionar parametros de URL. O nome da coluna sugere "faltantes", mas na pratica o script grava o snippet da chamada para analise. |
| `missing_request_body` | Trechos `.body(...)` encontrados antes da chamada HTTP. Se houver varios, aparecem separados por ` | `. |
| `credentials_header` | Headers relacionados a autenticacao detectados no teste, como `Authorization` ou `Bearer`. Se houver varios, aparecem separados por ` | `. |

## Metricas de imports e compilacao

| Coluna | Significado |
|---|---|
| `imports_count` | Quantidade total de imports presentes no arquivo Java. |
| `wildcard_imports` | Quantidade de imports com curinga, por exemplo `import x.y.*;`. |
| `compiled` | Indica se a classe compilou com sucesso no projeto Maven temporario. |
| `compile_error_count` | Quantidade de diagnosticos de compilacao encontrados. Se a compilacao falhar sem diagnostico estruturado, o script registra `1`. |
| `compile_error_types` | Tipos de erro de compilacao classificados pelo script, separados por `;`. Exemplos: `missing_import`, `incorrect_import`, `syntax_error`, `type_error`, `undefined_variable`, `annotation_error`, `generic_type_misuse`, `dependency_resolution`, `compile_timeout`, `compilation_error`. |
| `missing_imports` | Quantidade de imports cujo pacote nao existe, considerando apenas linhas de import. |
| `incorrect_imports` | Quantidade de imports marcados como incorretos/inacessiveis, considerando apenas linhas de import. |
| `unused_imports` | Campo reservado no CSV. No estado atual do script, ele e gravado vazio. |
| `dependency_availability_pct` | Percentual estimado de imports resolvidos com sucesso. Se houver erro de resolucao de dependencias, o valor pode ser `0.0`. |
| `syntax_errors` | Quantidade de erros de sintaxe classificados. |
| `type_errors` | Quantidade de erros de tipo classificados. |
| `undefined_variables` | Quantidade de referencias a variaveis/simbolos nao definidos detectadas na compilacao. |
| `type_annotation_errors` | Quantidade de erros relacionados a annotations. |
| `generic_type_misuses` | Quantidade de erros relacionados a uso incorreto de generics. |
| `compile_exit_code` | Codigo de saida do processo Maven de compilacao. |
| `compile_timeout` | Indica se a compilacao excedeu o tempo limite configurado. |
| `compile_error_summary` | Resumo curto do primeiro erro relevante de compilacao, timeout ou falha de dependencia. |

## Logs de compilacao

| Coluna | Significado |
|---|---|
| `class_log_dir` | Diretorio onde os logs de compilacao da classe foram gravados. |
| `compile_log_path` | Caminho do log combinado de compilacao (`stdout` + `stderr`). |
| `compile_stdout_log_path` | Caminho do log de saida padrao da compilacao. |
| `compile_stderr_log_path` | Caminho do log de erro da compilacao. |

## Execucao do metodo de teste

| Coluna | Significado |
|---|---|
| `runs` | Indica que o metodo executou com sucesso: processo sem erro, sem timeout, teste detectado e sem failures/errors. |
| `run_detected` | Indica que houve evidencias de execucao do teste. O script considera resumo textual do Surefire (`Tests run: ...`), diretorio de relatorios e tambem os arquivos XML do Surefire quando os logs textuais vierem vazios. |
| `runtime_error_count` | Quantidade de falhas/erros em tempo de execucao. Pode ficar vazio quando o metodo nao foi executado, por exemplo se a classe nao compilou. |
| `runtime_error_types` | Tipos de erro em tempo de execucao, separados por `;`. Pode incluir `test_failure`, `test_error`, `timeout`, `maven_failure` e nomes de excecoes detectadas no log. |
| `run_exit_code` | Codigo de saida do processo Maven que executou o metodo. Fica vazio quando a execucao nao ocorre. |
| `run_timeout` | Indica se a execucao do metodo excedeu o tempo limite. Fica vazio quando a execucao nao ocorre. |
| `execution_seconds` | Tempo total de execucao do processo do metodo, em segundos. |
| `cpu_seconds` | Tempo estimado de CPU consumido pelo processo, em segundos, quando disponivel. |
| `peak_working_set_mb` | Pico de memoria utilizado pelo processo, em MB, quando disponivel. |
| `run_error_summary` | Resumo curto da falha de execucao, timeout ou primeira linha relevante encontrada no log. |

## Logs de execucao

| Coluna | Significado |
|---|---|
| `method_log_dir` | Diretorio onde os logs de execucao do metodo foram gravados. |
| `run_log_path` | Caminho do log combinado de execucao (`stdout` + `stderr`). |
| `run_stdout_log_path` | Caminho do log de saida padrao da execucao. |
| `run_stderr_log_path` | Caminho do log de erro da execucao. |

## Observacoes importantes

- O CSV e escrito com base no metodo `write_row`, entao esta documentacao reflete o comportamento real atual do script.
- Quando a classe nao compila, as colunas de execucao do metodo podem ficar vazias.
- Um metodo "complexo" pode aparecer repetido no CSV com `call_index` diferente, representando chamadas HTTP distintas associadas ao mesmo metodo de teste.
- Campos com multiplos valores costumam usar `;` ou ` | ` como separadores, dependendo da logica interna do script.
