pyinstaller /Users/vaida/Desktop/PianoTranscription.py --collect-all audioread --collect-all librosa --collect-all llvmlite --collect-all mido --collect-all numba --collect-all numpy --collect-all scipy --collect-all sklearn --collect-all soundfile --collect-all torchlibrosa



/Users/vaida/dist/PianoTranscription/PianoTranscription --audio_path="/Users/vaida/Desktop/4u.m4a" --output_midi_path="/Users/vaida/Desktop/file.midi" --checkpoint_path="/Users/vaida/Desktop/checkpoint.pth" --onsetThreshold=0.3 --offsetThreshold=0.3 --frameThreshold=0.1 --padelOffsetThreshold=0.2 --batchSize=1

xattr -r -d com.apple.quarantine
