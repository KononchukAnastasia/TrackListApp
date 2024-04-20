//
//  NetworkManager.swift
//  TrackListApp
//
//  Created by Анастасия Конончук on 20.04.2024.
//

import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchTrack(url: String, term: String, completion: @escaping (_ track: TrackRequest) -> ()) {
        guard let url = URL(string: url + term) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let track = try JSONDecoder().decode(TrackRequest.self, from: data)
                
                DispatchQueue.main.async {
                    completion(track)
                }
            } catch {
                print("JSON Decoding Error: \(error.localizedDescription)")
                
            }
        }.resume()
    }
    
    func fetchImage(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: url) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, let response = response else {
                    print(error?.localizedDescription ?? "No error description")
                    return
                }
                print(response)
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
}
