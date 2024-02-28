# projects_monthly_bot

A Dart command-line application that provides the logic for
Discord Bots used in the projects-monthly server.

## API Key & Bot tokens

The app retrieves an API Key & Bot tokens from relevant environment
variables. One way to add the env vars is with a VS Code launch config
such as:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "projects_monthly_bot",
      "request": "launch",
      "type": "dart",
      "env": {
        "THE_BOT_TOKEN" : "...",
        "GEMINI_BOT_TOKEN" : "...",
        "GEMINI_API_KEY" : "...",
      }
    }
  ]
}
```
