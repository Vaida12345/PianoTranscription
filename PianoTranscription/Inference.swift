//
//  Inference.swift
//  PianoTranscription
//
//  Created by Vaida on 3/16/22.
//

import Foundation
import Support
import AppKit

struct InferenceSettings {
    var batchSize: Int = 10
    var onsetThreshold: Double = 0.3
    var offsetThreshold: Double = 0.3
    var frameThreshold: Double = 0.1
    var padelOffsetThreshold: Double = 0.2
}

private func inferenceNewProgress(_ line: String) -> Double? {
    let components = line.components(separatedBy: "/")
    guard components.count == 2 else { return nil }
    guard let lhs = Int(components.first!), let rhs = Int(components.last!) else { return nil }
    return Double(lhs) / Double(rhs)
}


fileprivate func inference(settings: InferenceSettings, input: FinderItem, output: FinderItem, manager: ShellManager, update: @escaping (_ file: String) -> Void, updateP: @escaping (_ progress: Double) -> Void) {
    let pianoTransItem = FinderItem.bundleDirectory.with(subPath: "Contents/Resources/PianoTranscription/PianoTranscription")
    let checkpointItem = FinderItem.bundleDirectory.with(subPath: "Contents/Resources/checkpoint.pth")
    
    manager.onOutputChanged { newLine in
        update(newLine + "\n")
        guard let progress = inferenceNewProgress(newLine) else { return }
        updateP(progress)
    }
    manager.run(arguments: "\(pianoTransItem.shellPath) --audio_path=\'\(input.path)\' --output_midi_path=\'\(output.path)\' --checkpoint_path=\'\(checkpointItem.path)\' --onsetThreshold=\(settings.onsetThreshold) --offsetThreshold=\(settings.offsetThreshold) --frameThreshold=\(settings.frameThreshold) --padelOffsetThreshold=\(settings.padelOffsetThreshold) --batchSize=\(settings.batchSize)")
    update("Started shell command:\n")
    update("\(pianoTransItem.shellPath) --audio_path=\'\(input.path)\' --output_midi_path=\'\(output.path)\' --checkpoint_path=\'\(checkpointItem.path)\' --onsetThreshold=\(settings.onsetThreshold) --offsetThreshold=\(settings.offsetThreshold) --frameThreshold=\(settings.frameThreshold) --padelOffsetThreshold=\(settings.padelOffsetThreshold) --batchSize=\(settings.batchSize)")
}


extension Array where Element == ItemContainer {
    
    func inference(managers: ShellManagers, settings: InferenceSettings, update: @escaping (_ file: String) -> Void, next: @escaping (_ file: String) -> Void, completion: @escaping () -> Void, updateP: @escaping (_ progress: Double) -> Void) {
        let outputFolder = FinderItem.downloadsDirectory.with(subPath: "Piano Transcription")
        outputFolder.generateDirectory(isFolder: true)
        
        for index in 0..<self.count {
            let outputName = self[index].relativePath ?? self[index].fileName
            let output = outputFolder.with(subPath: "\(outputName).midi")
            output.generateOutputPath()
            
            let manager = managers.addManager()
            PianoTranscription.inference(settings: settings, input: self[index].item, output: output, manager: manager, update: update) { newProgress in
                updateP((newProgress + Double(index + 1)) / Double(self.count))
            }
            
            manager.wait()
            next(self[index].name)
        }
        
        completion()
    }
    
}
