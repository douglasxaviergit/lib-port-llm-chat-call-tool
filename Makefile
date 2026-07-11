.PHONY: all build test check fmt lint clean spec debt

SPEC_REPO ?= https://github.com/douglasxaviergit/lib-spec.git
SPEC_DIR  ?= .spec

# CLI de LLM usada pelo `make debt` (troque por cursor-agent se preferir)
LLM ?= claude

all: spec fmt lint check build test

## Sincroniza as regras compartilhadas (lib-spec) em .spec/ — fail-soft, throttle de 4h
spec:
	@if [ ! -d "$(SPEC_DIR)/.git" ]; then \
		git clone --depth 1 --quiet "$(SPEC_REPO)" "$(SPEC_DIR)" 2>/dev/null \
			&& echo "regras compartilhadas baixadas em $(SPEC_DIR)/" \
			|| echo "aviso: nao foi possivel baixar lib-spec (offline?); regras podem estar desatualizadas"; \
	elif [ -z "$$(find "$(SPEC_DIR)/.git" -name FETCH_HEAD -mmin -240 2>/dev/null)" ]; then \
		git -C "$(SPEC_DIR)" pull --ff-only --quiet 2>/dev/null || true; \
	fi

## Audita o repositório contra as regras do lib-spec (LLM) e atualiza TECH_DEBT.md
debt: spec
	@command -v $(LLM) >/dev/null 2>&1 || { echo "erro: CLI '$(LLM)' nao encontrada (instale o Claude Code ou rode make debt LLM=<cli>)"; exit 1; }
	@test -f "$(SPEC_DIR)/.ai/prompts/auditor.md" || { echo "erro: $(SPEC_DIR)/.ai/prompts/auditor.md nao encontrado (lib-spec desatualizado? rode: rm -rf $(SPEC_DIR) && make spec)"; exit 1; }
	@echo "auditando com $(LLM) (pode levar alguns minutos)..."
	@{ echo "<!-- auditoria: $$(date +%F) | lib-spec @ $$(git -C $(SPEC_DIR) rev-parse --short HEAD 2>/dev/null || echo '?') | engine: $(LLM) -->"; \
	   $(LLM) -p "$$(cat $(SPEC_DIR)/.ai/prompts/auditor.md)"; } > TECH_DEBT.md \
	   && echo "TECH_DEBT.md atualizado"

## Compila
build:
	cargo build

## Roda todos os testes
test:
	cargo test

## Verifica erros sem compilar
check:
	cargo check

## Formata o código
fmt:
	cargo fmt

## Roda o linter
lint:
	cargo clippy -- -D warnings

## Remove artefatos de compilação
clean:
	cargo clean
