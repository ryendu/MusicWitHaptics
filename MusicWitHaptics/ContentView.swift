//
//  ContentView.swift
//  MusicWitHaptics
//
//  Created by Ryan D on 7/16/21.
//

import SwiftUI
import MobileCoreServices
import AVFoundation
import CoreHaptics

struct ContentView: View {
    @State var showPicker = false
    @State var url: URL? = nil
    @State var engine: CHHapticEngine!
    @State var player: AVAudioPlayer?
    var body: some View {
        VStack{
            Button(action: {
                self.playTestHaptic()
            }, label: {
                Text("Play test haptic")
            })
        }.onAppear {
            let audioSession = AVAudioSession.sharedInstance()
            
            engine = try? CHHapticEngine(audioSession: audioSession)
        }
    }
    func playTestHaptic(){
        do {
            
            let path = Bundle.main.path(forResource: "In My Blood", ofType:"mp3")!
            let url = URL(fileURLWithPath: path)
            player = try AVAudioPlayer(contentsOf: url)
            
            
            guard let path = Bundle.main.path(forResource: "imb", ofType: "ahap") else { return }
            try engine?.start()
            
            try engine?.playPattern(from: URL(fileURLWithPath: path))
            player!.play()
            
        } catch {
            print("SOMETHING WENT WRONG: \(error)")
        }
    }
}
