# CLAUDE.md

As regras deste ecossistema são centralizadas no repositório **lib-spec**, sincronizado automaticamente em `.spec/` pelo `make all` (alvo `make spec`).

- Se `.spec/` não existir, rode `make spec` antes de qualquer tarefa.
- Ponto de entrada das regras: @.spec/AGENTS.md
- Carregue apenas os arquivos de `.spec/.ai/` relevantes à tarefa (tabela "quando ler" no AGENTS.md) — ver `.spec/.ai/rules/llm-context.md`.
- Nunca duplique conteúdo normativo neste arquivo — ele é só um ponteiro; a norma mora no lib-spec.
