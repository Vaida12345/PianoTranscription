//
//  ProcessingView.swift
//  PianoTranscription
//
//  Created by Vaida on 7/9/22.
//

import SwiftUI
import Support

struct ProcessingView: View {
    
    @Binding var items: [ItemContainer]
    @Binding var isShown: Bool
    let settings: InferenceSettings
    
    
    @State private var progress = 0.0
    @State private var currentItem = ""
    @State private var output = ""
    @State private var isFinished = false
    
    private let managers = ShellManagers()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Inferring: \(currentItem)")
                .padding()
            ProgressView(value: isFinished ? 1 : progress)
                .progressViewStyle(.linear)
                .padding()
            
            TextEditor(text: .constant(output))
                .padding()
            
            HStack {
                if !isFinished {
                    Button {
                        self.managers.terminate()
                        exit(0)
                    } label: {
                        Text("Cancel")
                            .padding()
                    }
                    .padding()
                    
                    Spacer()
                } else {
                    Spacer()
                    
                    Button {
                        FinderItem.downloadsDirectory.with(subPath: "Piano Transcription").revealInFinder()
                    } label: {
                        Text("Show in Finder")
                    }
                    .padding()
                    
                    Button {
                        isShown = false
                        withAnimation {
                            items.removeAll()
                        }
                    } label: {
                        Text("Done")
                            .padding()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            DispatchQueue(label: "background").async {
                items.inference(managers: self.managers, settings: settings) { file in
                    output += file
                } next: { file in
                    currentItem = file
                    progress += 1 / Double(items.count)
                } completion: {
                    isFinished = true
                    FinderItem.downloadsDirectory.with(subPath: "Piano Transcription").setIcon(image: NSImage(named: "PianoTranscription")!)
                } updateP: { progress in
                    self.progress = progress
                }
            }
        }
        .frame(width: 800, height: 400)
    }
}
