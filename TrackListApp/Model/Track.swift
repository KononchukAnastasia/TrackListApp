//
//  Track.swift
//  TrackListApp
//
//  Created by Анастасия Конончук on 20.04.2024.
//
import Foundation

// MARK: - TrackRequest
struct TrackRequest: Codable {
    let resultCount: Int
    let results: [Track]
}

// MARK: - Track
struct Track: Codable {
    let artistName: String?
    let trackName: String?
    let artworkUrl100: String?
    
    var title: String {
        "\(artistName ?? "") - \(trackName ?? "")"
    }
}
