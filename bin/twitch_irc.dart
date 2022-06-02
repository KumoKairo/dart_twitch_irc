import '../lib/client.dart';

void main() async {
  Client();
  // var envVars = Platform.environment;

  // var channel =
  //     IOWebSocketChannel.connect(Uri.parse('wss://irc-ws.chat.twitch.tv:443'));

  // channel.sink
  //     .add('CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands');
  // channel.sink.add('PASS ${envVars['TWITCH_OAUTH_TOKEN']}');
  // channel.sink.add('NICK $channelName');
  // channel.sink.add('JOIN #$userName');

  // // channel.sink.add('PRIVMSG #$userName :running from flutter');

  // channel.stream.listen((message) {
  //   print('------');
  //   print(message);
  //   print('------');
  // });
}
