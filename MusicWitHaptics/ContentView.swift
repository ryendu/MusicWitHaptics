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
import MediaPlayer

struct ContentView: View {
    @State var showPicker = false
    @State var url: URL? = nil
    @State var engine: CHHapticEngine!
    @State var player: AVAudioPlayer?
    @State var hapticPlayer: CHHapticAdvancedPatternPlayer?
    @State var songs = ["In My Blood", "Heat Waves"]
    @State var isPlaying = false
    var body: some View {
        NavigationView{
            VStack{
                Text("Listen with headphones for best effect! Note: Haptics require app to be open and in focus.").padding()
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
                VStack{
                    if !self.isPlaying{
                        Button(action: {
                            if self.player == nil{
                                self.playHapticSong(name: songs[0])
                            } else {
                                self.player?.play()
                                try? self.hapticPlayer?.resume(atTime: CHHapticTimeImmediate)
                                self.isPlaying = true
                            }
                        }, label: {
                            Image(systemName: "play.circle.fill").resizable().frame(width: 50, height: 50)
                        })
                    } else {
                        Button(action: {
                            if self.player != nil{
                                self.player?.pause()
                                try? self.hapticPlayer?.pause(atTime: CHHapticTimeImmediate)
                                self.isPlaying = false
                            }
                        }, label: {
                            Image(systemName: "pause.circle.fill").resizable().frame(width: 50, height: 50)
                        })
                    }
                }.padding()
                
            }.onAppear {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    engine = try CHHapticEngine(audioSession: AVAudioSession.sharedInstance())
                    try engine.start()
                } catch {
                    print("ERRORRRRRRRRRRRRRRR")
                    print(error)
                }
                
            }
            .navigationBarTitle(Text("Music With Haptics"))
        }
    }
    func createPatternFromAHAP(_ filename: String) -> CHHapticPattern? {
        // Get the URL for the pattern in the app bundle.
        let patternURL = Bundle.main.url(forResource: filename, withExtension: "ahap")!
        
        do {
            // Read JSON data from the URL.
            let patternJSONData = try Data(contentsOf: patternURL, options: [])
            
            // Create a dictionary from the JSON data.
            let dict = try JSONSerialization.jsonObject(with: patternJSONData, options: [])
            
            if let patternDict = dict as? [CHHapticPattern.Key: Any] {
                // Create a pattern from the dictionary.
                return try CHHapticPattern(dictionary: patternDict)
            }
        } catch let error {
            print("Error creating haptic pattern: \(error)")
        }
        return nil
    }
    
    func playHapticSong(name: String){
        do {
            
            let path = Bundle.main.path(forResource: name, ofType:"mp3")!
            let url = URL(fileURLWithPath: path)
            
            self.player = try AVAudioPlayer(contentsOf: url)
            
            guard let ahapPattern = createPatternFromAHAP(name) else { return }
            self.hapticPlayer = try self.engine.makeAdvancedPlayer(with:ahapPattern)
            
            try self.hapticPlayer?.start(atTime: 0)
            player?.play()
            self.isPlaying = true
            
        } catch {
            print("SOMETHING WENT WRONG: \(error.localizedDescription)")
        }
    }
}
