use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SystemPrompt {
    pub content: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MessageUser {
    pub content: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MessageAssistant {
    pub content: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ChatMessage {
    User(MessageUser),
    Assistant(MessageAssistant),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ToolDefinition {
    pub name: String,
    pub description: String,
    pub input_schema: Value,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ToolCall {
    pub id: String,
    pub name: String,
    pub args: Value,
    pub missing_fields: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum LlmOutput {
    ToolCalls(Vec<ToolCall>),
    NoToolCall,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ChatResponse {
    pub latency_ms: u128,
    pub input_tokens: u64,
    pub output_tokens: u64,
    pub cost_usd: f64,
    pub output: LlmOutput,
}

#[async_trait]
pub trait LibPortLlmChatCallTool: Send + Sync {
    async fn invoke(
        &self,
        temperature: f64,
        max_tokens: u32,
        system_prompt: SystemPrompt,
        user_input: MessageUser,
        message_history: Vec<ChatMessage>,
        tools: Vec<ToolDefinition>,
    ) -> Result<ChatResponse, Box<dyn std::error::Error + Send + Sync>>;
}
