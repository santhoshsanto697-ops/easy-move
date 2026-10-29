
import 'package:flutter/material.dart';

void main() {
  runApp(const DartChatApp());
}

class DartChatApp extends StatelessWidget {
  const DartChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DartChat',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF075E54),
        useMaterial3: true,
      ),
      home: const ChatHomePage(),
    );
  }
}

class ChatUser {
  final String name;
  final String message;
  final String time;
  final Color color;

  const ChatUser(
    this.name,
    this.message,
    this.time,
    this.color,
  );
}

class ChatHomePage extends StatelessWidget {
  const ChatHomePage({super.key});

  static const users = [
    ChatUser('Arun', 'Hello! How are you?', '9:15 AM',
        Colors.blue),
    ChatUser('Kumar', 'See you tomorrow', '9:10 AM',
        Colors.orange),
    ChatUser('Priya', 'Thank you!', '8:55 AM',
        Colors.purple),
    ChatUser('Rahul', 'Good morning', '8:30 AM',
        Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        title: const Text(
          'DartChat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 20),
          Icon(Icons.more_vert),
          SizedBox(width: 12),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.teal.shade50,
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Welcome! Start chatting with your friends.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          for (final user in users)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: user.color,
                child: Text(
                  user.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(user.message),
              trailing: Text(user.time),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(user: user),
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Select a contact to start chatting.'),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage(this.text, this.isMe, this.time);
}

class ChatPage extends StatefulWidget {
  final ChatUser user;

  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();

  final List<ChatMessage> messages = [
    ChatMessage('Hi!', false, '9:00 AM'),
    ChatMessage('Hello! How are you?', true, '9:01 AM'),
    ChatMessage('I am fine. Thank you!', false, '9:02 AM'),
  ];

  void sendMessage() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    final now = TimeOfDay.now().format(context);

    setState(() {
      messages.add(ChatMessage(text, true, now));
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.user.color,
              child: Text(
                widget.user.name[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.user.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width * 0.78,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? const Color(0xFFDCF8C6)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.text,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.time,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textCapitalization:
                          TextCapitalization.sentences,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF075E54),
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
