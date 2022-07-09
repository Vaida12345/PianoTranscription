//
//  ListItemView.swift
//  PianoTranscription
//
//  Created by Vaida on 7/9/22.
//

import SwiftUI
import SwiftTagger

struct ListItemView: View {
    
    @State var selection: Set<ItemContainer.ID>
    @State var item: ItemContainer
    @Binding var items: [ItemContainer]
    
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
                    
                    if item.isAudio {
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
                guard item.isAudio else { return }
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
