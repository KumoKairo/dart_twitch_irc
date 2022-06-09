import 'dart:async';
import 'dart:ffi';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:twitch_irc/client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'client_test.mocks.dart';

@GenerateMocks([WebSocketChannel, WebSocketSink, Stream, StreamSubscription])
void main() {
  late WebSocketChannel mockSocket;
  late WebSocketSink mockSink;
  late Stream mockStream;
  late StreamSubscription mockStreamSubscription;

  WebSocketChannel mockSocketFactory() {
    return mockSocket;
  }

  setUp() {
    mockSocket = MockWebSocketChannel();
    mockSink = MockWebSocketSink();
    mockStream = MockStream();
    mockStreamSubscription = MockStreamSubscription();

    when(mockStream.listen(any)).thenAnswer((_) => mockStreamSubscription);
    when(mockSink.add(any)).thenAnswer((invocation) => {});
    when(mockSocket.sink).thenAnswer((_) => mockSink);
    when(mockSocket.stream).thenAnswer((_) => mockStream);
  }

  test('Creating a client should send 4 messages to the sink', () {
    setUp();
    Client(webSocketFactory: mockSocketFactory);
    verify(mockSink.add(any)).called(4);
  });
}
