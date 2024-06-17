//
//  TrackDetailsViewModel.swift
//  TrackListApp
//
//  Created by Анастасия Конончук on 02.05.2024.
//

import Foundation
import AVFAudio

final class TrackDetailsViewModel {
    var player: AVAudioPlayer?
    var isPlaying = false
    
    func fetchMusic(from url: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.fetchMusic(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    self.player = try AVAudioPlayer(data: data)
                    self.player?.play()
                    self.isPlaying = true
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func pauseTrack() {
        player?.pause()
        isPlaying = false
    }
}
