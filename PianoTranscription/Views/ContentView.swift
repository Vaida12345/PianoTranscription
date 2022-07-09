//
//  ContentView.swift
//  PianoTranscription
//
//  Created by Vaida on 3/16/22.
//

import SwiftUI
import Support

struct ContentView: View {
    
    @State private var selection: Set<ItemContainer.ID> = []
    @State private var items: [ItemContainer] = []
    
    @State private var isProcessing = false
    @State private var isShowingConfigView = false
    
    @AppStorage("onsetThreshold")       private var onsetThreshold: Double = 0.3
    @AppStorage("offsetThreshold")      private var offsetThreshold: Double = 0.3
    @AppStorage("frameThreshold")       private var frameThreshold: Double = 0.1
    @AppStorage("padelOffsetThreshold") private var padelOffsetThreshold: Double = 0.2
    @AppStorage("batchSize")            private var batchSize: Double = 10
    
    var body: some View {
        ZStack {
            VStack {
                if items.isEmpty {
                    ContainerView {
                        VStack {
                            Image(systemName: "square.and.arrow.down.fill")
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100, alignment: .center)
                            Text("Drop file or folder here")
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                } else {
                    List(selection: $selection) {
                        ForEach(items) { item in
                            ListItemView(selection: selection, item: item, items: $items)
                        }
                        .onMove { fromIndex, toIndex in
                            items.move(fromOffsets: fromIndex, toOffset: toIndex)
                        }
                        .contextMenu {
                            Button("Remove") {
                                withAnimation {
                                    items.removeAll(where: { selection.contains($0.id) })
                                }
                            }
                            Divider()
                            if selection.count == 1 {
                                Button("Open") {
                                    items.filter({ selection.contains($0.id) }).first!.item.open()
                                }
                            }
                            Button("Show in Finder") {
                                items.filter({ selection.contains($0.id) }).map(\.item).revealInFinder()
                            }
                        }
                    }
                }
            }
            
            if isShowingConfigView{
                HStack {
                    Spacer()
                    Divider()
                    
                    ConfigView()
                        .frame(width: 400, alignment: .trailing)
                }
                .padding()
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            }
        }
        .onDrop(of: [.fileURL], isTargeted: nil) { providers in
            Task {
                let possibleExtensions = [".wav", ".m4a", ".mov", ".mp3", ".mp4", ".aiff", ".tak", ".aac", ".3gp", ".asf", ".avi", ".flac", ".flv", ".mkv", ".ogg", ".webm"]
                let audioExtensions = [".wav", ".m4a", ".mp3", ".aiff", ".aac", ".3gp", ".avi", ".flac", ".ogg"]
                let items = await [FinderItem](from: providers)
                
                for item in items {
                    guard possibleExtensions.contains(item.extensionName.lowercased()) else { continue }
                    self.items.append(.init(item: item, isAudio: audioExtensions.contains(item.extensionName.lowercased())))
                }
            }
            return true
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    withAnimation {
                        items.removeAll()
                    }
                } label: {
                    Text("Remove all")
                }
                .disabled(items.isEmpty)
            }
            
            ToolbarItemGroup {
                Toggle(isOn: $isShowingConfigView.animation()) {
                    Image(systemName: "gear")
                }
                
                Button {
                    isProcessing = true
                } label: {
                    Text("Done")
                        .padding()
                }
                .disabled(items.isEmpty)
            }
        }
        .sheet(isPresented: $isProcessing) {
            ProcessingView(items: $items, isShown: $isProcessing, settings: .init(batchSize: Int(self.batchSize), onsetThreshold: self.onsetThreshold, offsetThreshold: self.offsetThreshold, frameThreshold: self.frameThreshold, padelOffsetThreshold: self.padelOffsetThreshold))
        }
        
    }
}


