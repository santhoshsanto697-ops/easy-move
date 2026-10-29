
import 'package:flutter/material.dart';

void main() {
  runApp(const DartChatApp());
}

const Color green = Color(0xFF075E54);
const Color lightGreen = Color(0xFFDCF8C6);
const Color chatBg = Color(0xFFECE5DD);

class DartChatApp extends StatelessWidget {
  const DartChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DartChat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Contact {
  final String name;
  final String message;
  final String time;
  final Color color;
  final int unread;

  const Contact(
    this.name,
    this.message,
    this.time,
    this.color, {
    this.unread = 0,
  });
}

const List<Contact> contacts = [
  Contact('Arun', 'Hello! How are you?', '9:15 AM', Colors.blue,
      unread: 2),
  Contact('Kumar', 'See you tomorrow!', '9:10 AM', Colors.orange),
  Contact('Priya', 'Thank you!', '8:55 AM', Colors.purple,
      unread: 1),
  Contact('Rahul', 'Good morning', '8:30 AM', Colors.teal),
  Contact('Vijay', 'Send me the notes', 'Yesterday', Colors.red),
  Contact('Santhosh', 'Okay bro', 'Yesterday', Colors.indigo),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = contacts
        .where((c) =>
            c.name.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: const Text(
          'DartChat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() => selectedTab = 0);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () =>
                showMessage(context, 'DartChat menu'),
          ),
        ],
      ),

      // Main screen changes according to the selected tab.
      body: selectedTab == 0
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (value) =>
                        setState(() => search = value),
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: green,
                          child: Icon(Icons.group_add,
                              color: Colors.white),
                        ),
                        title: const Text('New group'),
                        onTap: () => showMessage(
                            context, 'New group selected'),
                      ),
                      for (final contact in filtered)
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                          leading: CircleAvatar(
                            radius: 27,
                            backgroundColor: contact.color,
                            child: Text(
                              contact.name[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(contact.message),
                          trailing: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(
                                contact.time,
                                style:
                                    const TextStyle(fontSize: 11),
                              ),
                              if (contact.unread > 0) ...[
                                const SizedBox(height: 5),
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: green,
                                  child: Text(
                                    '${contact.unread}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ChatPage(contact: contact),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            )
          : selectedTab == 1
              ? const Center(
                  child: Text(
                    'No new status updates',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : selectedTab == 2
                  ? ListView(
                      children: [
                        for (final c in contacts)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: c.color,
                              child: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(c.name),
                            subtitle: const Text('Tap to call'),
                            onTap: () => showMessage(
                              context,
                              'Calling is not connected yet',
                            ),
                          ),
                      ],
                    )
                  : const ProfilePage(),

      floatingActionButton: selectedTab == 0
          ? FloatingActionButton(
              backgroundColor: green,
              foregroundColor: Colors.white,
              onPressed: () => showMessage(
                context,
                'Select a contact to start chatting',
              ),
              child: const Icon(Icons.chat),
            )
          : null,

      // Four navigation tabs, including Profile.
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.circle_outlined),
            label: 'Status',
          ),
          NavigationDestination(
            icon: Icon(Icons.call_outlined),
            label: 'Calls',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
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
  final Contact contact;

  const ChatPage({super.key, required this.contact});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();

  final List<ChatMessage> messages = [
    ChatMessage('Hi!', false, '9:00 AM'),
    ChatMessage('yenna pandra machii', true, '9:01 AM'),
    ChatMessage('saptiyaa', true, '9:02 AM'), // Fixed: comma added
    ChatMessage('summadha iruka. Thank you!', false, '9:03 AM'),
  ];

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          text,
          true,
          TimeOfDay.now().format(context),
        ),
      );
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
        backgroundColor: green,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.contact.color,
              child: Text(
                widget.contact.name[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contact.name,
                    style: const TextStyle(fontSize: 17),
                  ),
                  const Text(
                    'Tap here for contact info',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => showMessage(
                context, 'Calling is not connected yet'),
          ),
        ],
      ),
      body: Container(
        color: chatBg,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  return Align(
                    alignment: msg.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(context).size.width * 0.78,
                      ),
                      margin:
                          const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            msg.isMe ? lightGreen : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg.time,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              if (msg.isMe) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.done_all,
                                  size: 14,
                                  color: Colors.blue,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 4,
                        onSubmitted: (_) => sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          prefixIcon:
                              const Icon(Icons.emoji_emotions),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(28),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    CircleAvatar(
                      backgroundColor: green,
                      child: IconButton(
                        onPressed: sendMessage,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  String username = '';
  String bio = 'Hey there! I am using DartChat.';
  bool isPrivate = true;

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void saveProfile() {
    final enteredName = usernameController.text.trim();

    if (enteredName.isEmpty) {
      showMessage(context, 'Please enter a username');
      return;
    }

    setState(() {
      username = enteredName;
      bio = bioController.text.trim();
    });

    showMessage(context, 'Profile updated successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: green,
            child: Icon(
              Icons.person,
              size: 55,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            username.isEmpty ? 'Your Profile' : username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            bio,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Edit your profile',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: usernameController,
          maxLength: 30,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: bioController,
          maxLength: 150,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Bio',
            hintText: 'Tell people something about yourself',
            prefixIcon: Icon(Icons.info_outline),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Private profile'),
          subtitle: const Text(
            'Privacy setting (demo only)',
          ),
          value: isPrivate,
          activeTrackColor: green,
          onChanged: (value) {
            setState(() => isPrivate = value);
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: saveProfile,
          icon: const Icon(Icons.save),
          label: const Text('Save Profile'),
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(15),
          ),
        ),
      ],
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
