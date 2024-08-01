import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> ringtones = [];
  FlutterSoundPlayer? player;

  @override
  void initState() {
    super.initState();
    player = FlutterSoundPlayer();
  }

  @override
  void dispose() {
    player?.closeAudioSession();
    player = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Method Channel'),
      ),
      body: Column(
        children: [
          if (ringtones.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: ringtones.length,
                  itemBuilder: (context, index) {
                    final ringtone = ringtones[index];
                    return Card(
                      child: ListTile(
                        title: Text(ringtone),
                        onTap: () async {
                          try {
                            await player?.openAudioSession();
                            await player?.startPlayer(
                              fromURI: '/system/media/audio/ringtones/$ringtone.ogg',
                              codec: Codec.opusOGG
                            );
                          } catch (e) {
                            // Handle errors here
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () async {
              var channel = const MethodChannel("ringtone_channel");
              try {
                List<dynamic> result = await channel.invokeMethod('getRingtones');
                ringtones = result.cast<String>();
                setState(() {});
              } catch (e) {
                // Handle errors here
              }
            },
            child: const Text('Get Ringtones'),
          ),
        ],
      ),
    );
  }
}
