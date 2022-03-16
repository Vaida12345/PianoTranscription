# PianoTranscription
Macos execuatble and app of [Piano transcription](https://github.com/bytedance/piano_transcription), which generates midi files with music using Machine Learning.

**UNDER DEVELOPMENT**

## Portable Executable File
All the files are complied from [Piano transcription](https://github.com/bytedance/piano_transcription).

This is a portable executable file, hence you do not need to install anything.

Download [here](https://github.com/Vaida12345/PianoTranscription/releases/tag/executable).

### Arguments:
```
--audio_path
--output_midi_path
--checkpoint_path
--cuda
```
`checkpoint_path` the path for the checkpoint file (from [Piano transcription](https://github.com/bytedance/piano_transcription), download [here](https://github.com/Vaida12345/PianoTranscription/releases/tag/executable)).

### Example:
`PianoTranscription --audio_path='music.m4a' --output_midi_path='file.midi' --checkpoint_path='checkpoint.pth'`

You might want to allow apps downloaded from Anywhere, by entering this into Terminal: `sudo spctl --master-disable`. Otherwise, mac would keep telling you that it cannot varify the developer.

### If you want to build it yourself:

install `pyinstaller` > In your terminal, 

`pyinstaller example.py --collect-all piano_transcription_interface --collect-all torch --collect-all ffmpeg --collect-all librose --collect-all tensorflow --collect-all sklearn --collect-all scipy --collect-all audioread --collect-all numpy --collect-all mido`

Note: example.py from [Piano transcription](https://github.com/bytedance/piano_transcription).

## Credits
- [Piano transcription](https://github.com/bytedance/piano_transcription)
