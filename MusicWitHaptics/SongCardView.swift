//
//  SongCardView.swift
//  MusicWitHaptics
//
//  Created by Ryan D on 7/17/21.
//

import SwiftUI
import URLImage

struct SongCardView: View {
    var songName: String
    var albumPhotoURL: URL
    var artistName: String
    var body: some View {
        HStack{
            URLImage(self.albumPhotoURL,content: {img in
                img
                    .resizable()
                    .frame(width:100,height:100)
                    .padding(.trailing)
            })
            VStack(alignment: .leading){
                Text(songName)
                    .font(.headline)
                Text(artistName)
                    .font(.caption)
            }
            Spacer()
        }//.padding(.vertical)
        
        .padding(.trailing)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 8))
        .padding(.horizontal)
    }
}

struct SongCardView_Previews: PreviewProvider {
    static var previews: some View {
        SongCardView(songName: "In My Blood", albumPhotoURL: URL(string: "https://i.scdn.co/image/ab67616d00001e02269423eb6467e308c0fbce24")!, artistName: "Shawn Mendes")
    }
}
