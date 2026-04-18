.PHONY: all build test check fmt lint clean

all: fmt lint check build test

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