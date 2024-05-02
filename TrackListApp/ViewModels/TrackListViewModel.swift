//
//  TrackListViewModel.swift
//  TrackListApp
//
//  Created by Анастасия Конончук on 02.05.2024.
//

import Foundation

final class TrackListViewModel {
    var trackList: [Track] = []
    
    func fetchTracks(searchText: String, completion: @escaping (Result<TrackRequest, Error>) -> Void) {
        NetworkManager.shared.fetchTrack(url: API.track.rawValue, term: searchText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let trackRequest):
                    completion(.success(trackRequest))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
