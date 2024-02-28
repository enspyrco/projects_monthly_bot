import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nyxx/nyxx.dart';

late final GenerativeModel model;

void main(List<String> arguments) async {
  final theBotToken = Platform.environment['THE_BOT_TOKEN'];
  final geminiBotToken = Platform.environment['GEMINI_BOT_TOKEN'];
  final geminiApiKey = Platform.environment['GEMINI_API_KEY'];
  verifyEnvVars(theBotToken, geminiBotToken, geminiApiKey);

  model = GenerativeModel(model: 'gemini-1.0-pro', apiKey: geminiApiKey!);

  final theBotClient = await Nyxx.connectGateway(
    theBotToken!,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );

  final geminiClient = await Nyxx.connectGateway(
    geminiBotToken!,
    GatewayIntents.allUnprivileged,
    options: GatewayClientOptions(plugins: [logging, cliIntegration]),
  );

  final theBotUser = await theBotClient.users.fetchCurrentUser();

  theBotClient.onMessageCreate.listen((event) async {
    if (event.mentions.contains(theBotUser)) {
      await event.message.channel.sendMessage(MessageBuilder(
        content: 'Hi from the_bot!',
        replyId: event.message.id,
      ));
    }
  });

  final geminiBotUser = await geminiClient.users.fetchCurrentUser();

  geminiClient.onMessageCreate.listen((event) async {
    if (event.mentions.contains(geminiBotUser)) {
      // TODO: Don't assume gemini mention is at the start
      final contentString = event.message.content.replaceRange(0, 23, '');
      final content = [Content.text(contentString)];
      final response = await model.generateContent(content);

      String responseString = response.text!;
      if (responseString.length > 2000) {
        responseString = responseString.substring(0, 2000);
      }

      await event.message.channel.sendMessage(MessageBuilder(
        content: responseString,
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
