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
        NavigationView{
            VStack{
                Text("Listen with headphones for best effect!").padding()
                Button(action: {
                    self.playHapticSong(name: "In My Blood")
                }, label: {
                    SongCardView(songName: "In My Blood", albumPhotoURL: URL(string: "https://i.scdn.co/image/ab67616d00001e02269423eb6467e308c0fbce24")!, artistName: "Shawn Mendes")
                }).buttonStyle(PlainButtonStyle())
                Button(action: {
                    self.playHapticSong(name: "Heat Waves")
                }, label: {
                    SongCardView(songName: "Heat Waves", albumPhotoURL: URL(string: "https://i.scdn.co/image/ab67616d00001e02712701c5e263efc8726b1464")!, artistName: "Glass Animals")
                }).buttonStyle(PlainButtonStyle())
                Spacer()
            }.onAppear {
                let audioSession = AVAudioSession.sharedInstance()
                
                engine = try? CHHapticEngine(audioSession: audioSession)
            }
            .navigationBarTitle(Text("Music With Haptics"))
        }
    }
    func playHapticSong(name: String){
        do {
            
            let path = Bundle.main.path(forResource: name, ofType:"mp3")!
            let url = URL(fileURLWithPath: path)
            player = try AVAudioPlayer(contentsOf: url)
            
            
            guard let path = Bundle.main.path(forResource: name, ofType: "ahap") else { return }
            try engine?.start()
            
            try engine?.playPattern(from: URL(fileURLWithPath: path))
            player!.play()
            
        } catch {
            print("SOMETHING WENT WRONG: \(error)")
        }
    }
}
