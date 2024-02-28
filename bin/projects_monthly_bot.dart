import 'dart:io';

import 'package:nyxx/nyxx.dart';

void main(List<String> arguments) async {
  final theBotToken = Platform.environment['THE_BOT_TOKEN'];
  final geminiToken = Platform.environment['GEMINI_TOKEN'];
  final apiKey = Platform.environment['API_KEY'];
  verifyEnvVars(theBotToken, geminiToken, apiKey);

  final theBotClient = await Nyxx.connectGateway(
    theBotToken!,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );

  final geminiClient = await Nyxx.connectGateway(
    geminiToken!,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );

  final theBotUser = await theBotClient.users.fetchCurrentUser();

  theBotClient.onMessageCreate.listen((event) async {
    if (event.mentions.contains(theBotUser)) {
      await event.message.channel.sendMessage(MessageBuilder(
        content: 'Hi There!',
        replyId: event.message.id,
      ));
    }
  });

  final geminiBotUser = await geminiClient.users.fetchCurrentUser();

  geminiClient.onMessageCreate.listen((event) async {
    if (event.mentions.contains(geminiBotUser)) {
      await event.message.channel.sendMessage(MessageBuilder(
        content: 'Hi There!',
        replyId: event.message.id,
      ));
    }
  });
}

void verifyEnvVars(String? theBotToken, String? geminiToken, String? apiKey) {
  if (theBotToken == null) {
    throw Exception(
      'A Discord bot token must be provided using the \$THE_BOT_TOKEN environment'
      ' variable',
    );
  }

  if (geminiToken == null) {
    throw Exception(
      'A Discord bot token must be provided using the \$GEMINI_TOKEN environment'
      ' variable',
    );
  }

  if (apiKey == null) {
    throw Exception(
      'No \$API_KEY environment variable',
    );
  }
}
