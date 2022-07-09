//
//  ConfigView.swift
//  PianoTranscription
//
//  Created by Vaida on 7/9/22.
//

import SwiftUI

struct ConfigView: View {
    
    @AppStorage("onsetThreshold")       private var onsetThreshold: Double = 0.3
    @AppStorage("offsetThreshold")      private var offsetThreshold: Double = 0.3
    @AppStorage("frameThreshold")       private var frameThreshold: Double = 0.1
    @AppStorage("padelOffsetThreshold") private var padelOffsetThreshold: Double = 0.2
    @AppStorage("batchSize")            private var batchSize: Double = 16
    
    var body: some View {
        VStack {
            List {
                Slider(value: $batchSize, in: 1...16, step: 1) {
                    Text("Batch Size")
                }
                .padding(.bottom)
                .help("an integer between 0 and 16")
                
                Slider(value: $onsetThreshold, in: 0...1) {
                    Text("onset threshold")
                }
                
                Slider(value: $offsetThreshold, in: 0...1) {
                    Text("offset threshold")
                }
                
                Slider(value: $frameThreshold, in: 0...1) {
                    Text("frame threshold")
                }
                
                Slider(value: $padelOffsetThreshold, in: 0...1) {
                    Text("pedal offset threshold")
                }
            }
            
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        let model = InferenceSettings()
                        self.onsetThreshold = model.onsetThreshold
                        self.offsetThreshold = model.offsetThreshold
                        self.frameThreshold = model.frameThreshold
                        self.padelOffsetThreshold = model.padelOffsetThreshold
                        self.batchSize = Double(model.batchSize)
                    }
                } label: {
                    Text("Reset")
                        .padding()
                }
            }
        }
    }
}
