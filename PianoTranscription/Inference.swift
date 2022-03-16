//
//  Inference.swift
//  PianoTranscription
//
//  Created by Vaida on 3/16/22.
//

import Foundation

fileprivate func inference(input: FinderItem, output: FinderItem, update: @escaping (_ file: String) -> Void) {
    let pianoTransItem = FinderItem(at: Bundle.main.bundlePath + "/Contents/Resources/PianoTranscription/PianoTranscription")
    let checkpointItem = FinderItem(at: Bundle.main.bundlePath + "/Contents/Resources/checkpoint.pth")
    
    update(input.path + "\n")
    update("\(pianoTransItem.shellPath) --audio_path=\'\(input.path)\' --output_midi_path=\'\(output.path)\' --checkpoint_path=\'\(checkpointItem.path)\'" + "\n")
    let value = shell(["\(pianoTransItem.shellPath) --audio_path=\'\(input.path)\' --output_midi_path=\'\(output.path)\' --checkpoint_path=\'\(checkpointItem.path)\'"])
    update(value ?? "")
}

extension Array where Element == FinderItem {
    
    func inference(update: @escaping (_ file: String) -> Void, next: @escaping (_ file: String) -> Void, completion: @escaping () -> Void) {
        let outputFolder = FinderItem(at: FinderItem.downloadsItem.path + "/Piano Transcription")
        do {
            try outputFolder.generateDirectory(isFolder: true)
        } catch { print(error) }
        
        
        DispatchQueue.concurrentPerform(iterations: self.count) { index in
            let outputName = self[index].relativePath ?? self[index].name
            var output = FinderItem(at: outputFolder.path + "/\(outputName).midi")
            output.generateOutputPath()
            PianoTranscription.inference(input: self[index], output: output, update: update)
            
            next(self[index].name)
        }
        
        completion()
    }
    
}
