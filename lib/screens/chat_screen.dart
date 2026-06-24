import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../models/sector.dart';
import '../models/user_profile.dart';
import '../services/sunbird_service.dart';
import '../services/storage_service.dart';
import '../theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/language_selector.dart';
import '../widgets/voice_button.dart';

class ChatScreen extends StatefulWidget {
  final Sector sector;
  final UserProfile profile;
  final String? initialMessage;
  final bool generalMode;

  const ChatScreen({
    super.key,
    required this.sector,
    required this.profile,
    this.initialMessage,
    this.generalMode = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _sunbird = SunbirdService();
  final _storage = StorageService();
  final _uuid = const Uuid();
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  late String _language;
  bool _isLoading = false;
  bool _isRecording = false;
  bool _showQuestions = true;

  final List<Message> _messages = [];
  final List<Map<String, String>> _history = [];

  @override
  void initState() {
    super.initState();
    _language = widget.profile.language;
    _loadHistory();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialMessage!);
      });
    }
  }

  Future<void> _loadHistory() async {
    final sectorId = widget.generalMode ? 'general' : widget.sector.id;
    final saved = await _storage.loadHistory(sectorId);
    if (saved.isNotEmpty) {
      setState(() {
        _messages.addAll(saved);
        _showQuestions = false;
      });
      for (final m in saved) {
        _history.add({'role': m.isUser ? 'user' : 'assistant', 'content': m.text});
      }
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMsg = Message(
      id: _uuid.v4(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      sector: widget.sector.id,
    );
    final loadingMsg = Message(
      id: 'loading',
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    setState(() {
      _messages.add(userMsg);
      _messages.add(loadingMsg);
      _isLoading = true;
      _showQuestions = false;
      _controller.clear();
    });
    _scrollToBottom();

    _history.add({'role': 'user', 'content': text.trim()});

    final reply = await _sunbird.chat(
      userMessage: text.trim(),
      languageCode: _language,
      profile: widget.profile,
      history: List.from(_history)..removeLast(),
    );

    _history.add({'role': 'assistant', 'content': reply});
    if (_history.length > 40) _history.removeRange(0, 2);

    final replyMsg = Message(
      id: _uuid.v4(),
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
      sector: widget.sector.id,
    );

    setState(() {
      _messages.removeWhere((m) => m.id == 'loading');
      _messages.add(replyMsg);
      _isLoading = false;
    });

    final sectorId = widget.generalMode ? 'general' : widget.sector.id;
    await _storage.saveHistory(sectorId, _messages);
    _scrollToBottom();
  }

  Future<void> _toggleVoice() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        _sendMessage(_language == 'lug'
            ? '[Okutegeereza amaloboozi gyo...]'
            : '[Transcribing your voice...]');
        final transcript = await _sunbird.speechToText(
          audioFilePath: path,
          languageCode: _language,
        );
        if (transcript != null && transcript.isNotEmpty) {
          setState(() => _messages.removeLast());
          _history.removeLast();
          await _sendMessage(transcript);
        }
      }
    } else {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/teddy_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(const RecordConfig(), path: path);
        setState(() => _isRecording = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission needed for voice input')),
        );
      }
    }
  }

  Future<void> _speakMessage(String text) async {
    final audioBase64 = await _sunbird.textToSpeech(text: text, languageCode: _language);
    if (audioBase64 != null) {
      final bytes = base64Decode(audioBase64);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/teddy_tts.mp3');
      await file.writeAsBytes(bytes);
      await _player.play(DeviceFileSource(file.path));
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearHistory() async {
    final sectorId = widget.generalMode ? 'general' : widget.sector.id;
    await _storage.clearHistory(sectorId);
    setState(() {
      _messages.clear();
      _history.clear();
      _showQuestions = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sector = widget.sector;
    final color = TeddyTheme.sectorColor(sector.color);
    final isLg = _language == 'lug';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(sector.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.generalMode ? 'Teddy AI' : (isLg ? sector.titleLg : sector.titleEn),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Powered by Sunbird AI',
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (val) {
              if (val == 'clear') _clearHistory();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(isLg ? 'Sazaamu ebikwatibwa' : 'Clear chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Language bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: LanguageSelector(
              selectedCode: _language,
              onChanged: (code) => setState(() => _language = code),
            ),
          ),
          const Divider(height: 1),

          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState(color, isLg)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (ctx, i) {
                      final msg = _messages[i];
                      return Column(
                        children: [
                          ChatBubble(message: msg),
                          // Speak button for Teddy responses
                          if (!msg.isUser && !msg.isLoading)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 46, bottom: 4),
                                child: GestureDetector(
                                  onTap: () => _speakMessage(msg.text),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.volume_up_rounded, size: 14, color: Colors.grey.shade400),
                                      const SizedBox(width: 4),
                                      Text(isLg ? 'Wulira' : 'Listen', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),

          // Quick questions (shown when chat is empty)
          if (_showQuestions && !widget.generalMode)
            _buildQuickQuestions(isLg),

          // Input bar
          _buildInputBar(isLg),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color color, bool isLg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.sector.emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text(
            isLg ? widget.sector.titleLg : widget.sector.titleEn,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            isLg ? 'Buuza kibuuzo kyona...' : 'Ask anything about this topic...',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuestions(bool isLg) {
    final questions = widget.sector.questions;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLg ? 'Ebibuuzo eby\'okutandika:' : 'Quick questions:',
            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: questions.map((q) {
              return GestureDetector(
                onTap: () => _sendMessage(isLg ? q.lg : q.en),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                    color: TeddyTheme.primarySurface,
                  ),
                  child: Text(
                    isLg ? q.lg : q.en,
                    style: const TextStyle(fontSize: 12, color: TeddyTheme.primary),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(bool isLg) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            VoiceButton(isRecording: _isRecording, onTap: _toggleVoice),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: isLg ? 'Wandiika...' : 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _sendMessage(_controller.text),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.grey.shade300 : TeddyTheme.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isLoading ? Icons.hourglass_top_rounded : Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
