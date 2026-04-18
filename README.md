# lib-port-llm-chat-call-tool

Biblioteca Rust que define o **contrato** para chamada de ferramenta em um chat com LLM. A implementação concreta fica em outra biblioteca.

## Contrato

### `LibPortLlmChatCallTool`

Trait assíncrona responsável por invocar o modelo e devolver as ferramentas que devem ser executadas.

- **`invoke`** — recebe `temperature`, `max_tokens`, `system_prompt`, a mensagem atual do usuário (`user_input`), o histórico (`message_history`), as ferramentas disponíveis (`tools`), e retorna `Result<ChatResponse, Box<dyn std::error::Error + Send + Sync>>`.

### Tipos

- **`SystemPrompt`** — prompt de sistema (`content: String`).
- **`MessageUser`** / **`MessageAssistant`** — mensagem do usuário ou do assistente (`content: String`).
- **`ChatMessage`** — enum com variantes `User(MessageUser)` e `Assistant(MessageAssistant)`.
- **`ToolDefinition`** — definição de ferramenta para o modelo (`name`, `description`, `parameters`).
- **`ToolCall`** — chamada emitida pelo modelo (`id`, `name`, `args`).
- **`LlmOutput`** — enum com variantes `ToolCalls(Vec<ToolCall>)` e `NoToolCall`.
- **`ChatResponse`** — métricas e saída (`latency_ms`, `input_tokens`, `output_tokens`, `cost_usd`, `output`).

## Comandos

| Nome | O que faz |
|-------------|-----------|
| `make all` | Equivale a `make fmt && make lint && make check && make build && make test` |
| `make fmt` | Aplica formatação padrão do Rust |
| `make lint` | Verifica se todos os avisos foram tratados |
| `make check` | Análise estática sem gerar binários |
| `make build` | Compila |
| `make test` | Executa a suíte de testes |
| `make clean` | Remove diretório de artefatos (`target/`) |

## Licença

Veja [LICENSE](LICENSE).
