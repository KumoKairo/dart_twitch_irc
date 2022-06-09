import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef Messages = List<String>;
typedef MessageHandler = bool Function(Messages);
typedef WebSocketFactory = WebSocketChannel Function();

const channelName = 'kumokairo';
const userName = 'kumokairo';
Uri twitchUri = Uri(scheme: 'wss', host: 'irc-ws.chat.twitch.tv', port: 443);

class Client {
  late WebSocketFactory _webSocketFactory;
  late WebSocketChannel _channel;
  final List<MessageHandler> _handlersQueue = List.empty(growable: true);

  Client({WebSocketFactory? webSocketFactory}) {
    _webSocketFactory = webSocketFactory ?? defaultWebsocketFactory;

    _handlersQueue.addAll([checkAuth, checkPing, checkReconnect]);
    connect();
  }

  void connect() async {
    var envVars = Platform.environment;

    _channel = _webSocketFactory();
    _channel.stream.listen(receivedMessage);
    sendMessage(
        'CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands');
    sendMessage('PASS ${envVars['TWITCH_OAUTH_TOKEN']}');
    sendMessage('NICK $userName');
    sendMessage('JOIN #$channelName');
  }

  void disconnect() {
    _channel.sink.close();
  }

  void reconnect() {
    _channel.sink.close();
    connect();
  }

  void sendMessage(String message) async {
    message = message.replaceAll(RegExp('PASS .+'), 'PASS :xxx-xxx-xxx');
    print('> $message');
    _channel.sink.add(message);
  }

  void receivedMessage(dynamic rawMessage) async {
    var messages = (rawMessage as String).trim().split('\r\n');
    for (var message in messages) {
      print(message);
    }
    print('---------');
    // Running all handlers, returning early if we found a perfect match
    // That is, if a certain message is to be handled by only one handler
    for (var handler in _handlersQueue) {
      if (handler(messages)) {
        break;
      }
    }
  }

  bool checkAuth(Messages messages) {
    // Successful authentication
    if (messages.length == 8 &&
        messages[0].contains('001') &&
        messages[1].contains('002') &&
        messages[2].contains('003') &&
        messages[3].contains('004') &&
        messages[4].contains('375') &&
        messages[5].contains('372') &&
        messages[6].contains('376')) {
      return true;

      // Unsuccessful authentication
    } else if (messages.length == 1 &&
        (messages[0].contains('Login authentication failed') ||
            messages[0].contains('Improperly formatted auth'))) {
      disconnect();
      return false;
    }

    return false;
  }

  bool checkPing(Messages messages) {
    if (messages.length == 1 && messages[0].contains('PING')) {
      var originalMessage = messages[0].split(':')[1];
      sendMessage('PONG :$originalMessage');
      return true;
    }

    return false;
  }

  bool checkReconnect(Messages messages) {
    if (messages.length == 1 && messages[0].contains('RECONNECT')) {
      reconnect();
      return true;
    }
    return false;
  }

  WebSocketChannel defaultWebsocketFactory() {
    return WebSocketChannel.connect(twitchUri);
  }
}

class ChatUser {
  String displayName;

  bool isBroadcaster;
  bool isSubscriber;
  bool isMod;
  bool isVip;

  ChatUser(this.displayName, this.isBroadcaster, this.isSubscriber, this.isMod,
      this.isVip);

  static ChatUser createFromTags(String tags) {
    return ChatUser("test", false, false, false, false);
  }
}
