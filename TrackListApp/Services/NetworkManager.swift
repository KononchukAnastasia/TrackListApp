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
    
    func fetchTrack(url: String, term: String, completion: @escaping (Result<TrackRequest, Error>) -> ()) {
        guard let url = URL(string: url + term) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let track = try JSONDecoder().decode(TrackRequest.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(track))
                }
            } catch {
                print("JSON Decoding Error: \(error.localizedDescription)")
                completion(.failure(error))
                
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
    
    func fetchMusic(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}
