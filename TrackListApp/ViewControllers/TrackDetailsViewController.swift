//
//  TrackDetailsViewController.swift
//  TrackListApp
//
//  Created by Анастасия Конончук on 20.04.2024.
//

import UIKit
import AVFoundation

final class TrackDetailsViewController: UIViewController {
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    var track: Track!
    
    private var trackDetailsViewModel = TrackDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        setupUI()
    }
    
    @IBAction private func playButtonAction(_ sender: Any) {
        if trackDetailsViewModel.isPlaying {
            trackDetailsViewModel.player?.play()
        } else {
            trackDetailsViewModel.fetchMusic(from: track.previewUrl ?? "") { [weak self] result in
                switch result {
                case .success:
                    self?.trackDetailsViewModel.player?.play()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction private func pauseButtonAction(_ sender: Any) {
        trackDetailsViewModel.player?.pause()
        trackDetailsViewModel.isPlaying = true
    }
    
    private func setupUI() {
        activityIndicator.startAnimating()
        
        let modifyURL = track.artworkUrl100?.replacingOccurrences(of: "100", with: "1000")
        
        NetworkManager.shared.fetchImage(url: modifyURL ?? "") { [weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.coverImageView.image = image
        }
        
        titleLabel.text = track.title
    }
}
