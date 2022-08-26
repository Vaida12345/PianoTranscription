# PianoTranscription
MacOS executable and app of [Piano transcription](https://github.com/bytedance/piano_transcription), which generates midi tracks on Piano from music using Machine Learning.

## Install
Files and source code could be found in [releases](https://github.com/Vaida12345/PianoTranscription/releases).

Note: If mac says the app was damaged / unknown developer, please go to `System Preferences > Security & Privacy > General`, and click `Open Anyway`. [Show Details.](https://github.com/Vaida12345/Annotation/wiki#why-i-cant-open-the-app)

## Interface
Written with SwiftUI.

<img width="1227" alt="Screen Shot 2022-03-16 at 7 03 43 PM" src="https://user-images.githubusercontent.com/91354917/158576353-f44ab0ce-1f20-4f99-8882-dbf5466f0796.png">

## Example
- [Variations on the Kanon](https://github.com/Vaida12345/PianoTranscription/files/9120096/Variations.on.the.Kanon.midi.zip) (George Winston, December, by Pachelbel)
- [Ballade No. 1 in G minor, Op. 23](https://github.com/Vaida12345/PianoTranscription/files/9120105/Ballade.No.1.in.G.minor.Op.23.midi.zip) (四月は君の嘘, 四月は君の嘘 僕と君との音楽帳, by Chopin)

## Portable Executable File
All the files are complied from [Piano transcription](https://github.com/bytedance/piano_transcription).

This is a portable executable file, hence you do not need to install anything.

### Arguments:
```
--audio_path: The path for the source.
--output_midi_path: The path for the destination.
--checkpoint_path: The path for checkpoint file
```
the checkpoint file can be obtained from [Piano transcription](https://github.com/bytedance/piano_transcription)

#### Additional Arguments:
These arguments are optional
```
--cuda: A boolean value determining whether gpu should be used.
--onsetThreshold
--offsetThreshold
--frameThreshold
--padelOffsetThreshold
--batchSize
```

### Example:
`PianoTranscription --audio_path='music.m4a' --output_midi_path='file.midi' --checkpoint_path='checkpoint.pth'`

### If you want to build it yourself:

install `pyinstaller` > In your terminal, 

`pyinstaller example.py --collect-all piano_transcription_inference --collect-all torch --collect-all librosa --collect-all sklearn --collect-all scipy --collect-all audioread --collect-all numpy --collect-all mido`

Note: You would find the files in `Build Files` helpful

## Credits
- [Piano transcription](https://github.com/bytedance/piano_transcription)
- [Swift Tagger](https://github.com/NCrusher74/SwiftTagger)
