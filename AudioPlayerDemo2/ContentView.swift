//
//  ContentView.swift
//  AudioPlayerDemo2
//
//  Created by kwon eunji on 12/13/23.
//

import SwiftUI
import AVKit


struct ContentView: View {
    var audioFileName = "bird"
    
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Bird Sound")
                    .font(.title)
                
                VStack(spacing: 20) {
                    Image(systemName: isPlaying ? "pause.circle.fill" :
                        "play.circle.fill"
                    )
                        .font(.largeTitle)
                        .onTapGesture {
                            isPlaying ? stopAudio() : playAudio()
                        }
                    Slider(value: Binding(get: {
                        currentTime
                    }, set: { newValue in
                        seekAudio(to: newValue)
                    }), in: 0...totalTime)
                    .accentColor(.white)
                    HStack {
                        Text(timeString(time: currentTime))
                            .foregroundStyle(.white)
                        Spacer()
                        Text(timeString(time: totalTime))
                            .foregroundStyle(.white)
                    }
                    
                    
                }
                .padding(.horizontal)
            }
            .foregroundStyle(.white)
        }
        .onAppear(perform: {
            setupAudio()
        })
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(), perform: { _ in
            updateProgress()
        })
    }
    
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: "bird", withExtension: "mp3") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
            
        } catch {
            print("Error loading audio file: \(error)")
        }
    }
    
    private func playAudio() {
        player?.play()
        isPlaying = true
    }
    
    private func stopAudio() {
        player?.pause()
        isPlaying = false
    }
    
    private func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime
    }
    
    private func seekAudio(to time: TimeInterval) {
        player?.currentTime = time
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
