//
//  ContentView.swift
//  PianoTranscription
//
//  Created by Vaida on 3/16/22.
//

import SwiftUI
import SwiftTagger

struct ContentView: View {
    
    @State var selection: Set<FinderItem.ID> = []
    @State var items: [FinderItem] = []
    
    @State var isProcessing = false
    
    var body: some View {
        VStack {
            if items.isEmpty {
                WelcomeView(items: $items)
            } else {
                List(selection: $selection) {
                    ForEach(items) {  item in
                        ListItemView(selection: selection, item: item, items: $items)
                    }
                    .onMove(perform: { fromIndex, toIndex in
                        items.move(fromOffsets: fromIndex, toOffset: toIndex)
                    })
                    .contextMenu {
                        Button("Remove") {
                            withAnimation {
                                items.removeAll(where: { selection.contains($0.id) })
                            }
                        }
                        Divider()
                        if selection.count == 1 {
                            Button("Open") {
                                items.filter({ selection.contains($0.id) }).first!.open()
                            }
                        }
                        Button("Show in Finder") {
                            withAnimation {
                                items.filter({ selection.contains($0.id) }).revealInFinder()
                            }
                        }
                    }
                }
            }
        }
        .onDrop(of: [.fileURL], isTargeted: nil) { providers in
            Task {
                await items.append(from: providers) { item in
                    let possibleExtensions = [".wav", ".m4a", ".mov", ".mp3", ".mp4", ".aiff", ".tak", ".aac", ".3gp", ".asf", ".avi", ".flac", ".flv", ".mkv", ".ogg", ".webm"]
                    return item.type == .audio || possibleExtensions.contains(item.extensionName.lowercased())
                }
            }
            return true
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Remove all") {
                    withAnimation {
                        items.removeAll()
                    }
                }
                .disabled(items.isEmpty)
            }
            
            ToolbarItem {
                Button("Add Items") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = true
                    panel.canChooseDirectories = true
                    if panel.runModal() == .OK {
                        items.append(from: panel.urls) { item in
                            let possibleExtensions = [".wav", ".m4a", ".mov", ".mp3", ".mp4", ".aiff", ".tak", ".aac", ".3gp", ".asf", ".avi", ".flac", ".flv", ".mkv", ".ogg", ".webm"]
                            return item.type == .audio || possibleExtensions.contains(item.extensionName.lowercased())
                        }
                    }
                }
            }
            
            ToolbarItem {
                Button("Done") {
                    isProcessing = true
                }
                .disabled(items.isEmpty)
            }
        }
        .sheet(isPresented: $isProcessing) {
            ProcessingView(items: $items, isShown: $isProcessing)
        }
        
    }
}

struct WelcomeView: View {
    
    @Binding var items: [FinderItem]
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "square.and.arrow.down.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(.all)
                    .frame(width: 100, height: 100, alignment: .center)
                Text("Drag files or folder.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.all)
        .onTapGesture(count: 2) {
            let panel = NSOpenPanel()
            panel.allowsMultipleSelection = true
            panel.canChooseDirectories = true
            if panel.runModal() == .OK {
                items.append(from: panel.urls) { item in
                    let possibleExtensions = [".wav", ".m4a", ".mov", ".mp3", ".mp4", ".aiff", ".tak", ".aac", ".3gp", ".asf", ".avi", ".flac", ".flv", ".mkv", ".ogg", ".webm"]
                    return item.type == .audio || possibleExtensions.contains(item.extensionName.lowercased())
                }
            }
        }
    }
}

struct ListItemView: View {
    
    @State var selection: Set<FinderItem.ID>
    @State var item: FinderItem
    @Binding var items: [FinderItem]
    
    @State var cover = NSImage(named: "Music")!
    @State var title: String? = nil
    @State var artist: String? = nil
    
    var audioFile: SwiftTagger.AudioFile? {
        return try? .init(location: item.url)
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(nsImage: cover)
                    .resizable()
                    .cornerRadius(5)
                    .scaledToFit()
                    .padding(2.5)
                    .frame(height: 70)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        if let title = title {
                            Text(title)
                                .padding([.horizontal, .top])
                        }
                        
                        if let artist = artist {
                            Text(artist)
                                .foregroundColor(.secondary)
                                .padding([.horizontal, .top])
                        }
                    }
                    
                    Text(item.path)
                        .foregroundColor(.secondary)
                        .padding([.horizontal, .bottom])
                    
                    Spacer()
                }
                Spacer()
            }
            
            Divider()
        }
        .onAppear {
            DispatchQueue(label: "background").async {
                guard let audioFile = audioFile else { return }
                self.title = audioFile.title
                self.artist = audioFile.artist
                
                if let image = audioFile.coverArt {
                    self.cover = image
                }
            }
        }
        .frame(height: 75)
    }
}

struct ProcessingView: View {
    
    @Binding var items: [FinderItem]
    @Binding var isShown: Bool
    
    
    @State var progress = 0.0
    @State var currentItem = ""
    @State var output = ""
    @State var isFinished = false
    
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
                    Button("Cancel") {
                        exit(0)
                    }
                    .padding()
                    
                    Spacer()
                } else {
                    Spacer()
                    
                    Button("Show in Finder") {
                        FinderItem(at: FinderItem.downloadsItem.path + "/Piano Transcription").revealInFinder()
                    }
                    .padding()
                    
                    Button("Done") {
                        isShown = false
                        withAnimation {
                            items.removeAll()
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            DispatchQueue(label: "background").async {
                items.inference { file in
                    output += file
                } next: { file in
                    currentItem = file
                    progress += 1 / Double(items.count)
                } completion: {
                    isFinished = true
                    FinderItem(at: FinderItem.downloadsItem.path + "/Piano Transcription").setIcon(image: NSImage(named: "PianoTranscription")!)
                }
            }
        }
        .frame(width: 800, height: 400)
    }
}
