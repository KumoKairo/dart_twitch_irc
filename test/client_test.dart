import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:twitch_irc/client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'client_test.mocks.dart';

@GenerateMocks([WebSocketChannel])
void main() {
  test('PING message should return true', () {});
}
