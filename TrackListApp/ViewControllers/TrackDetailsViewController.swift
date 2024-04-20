//
//  TrackDetailsViewController.swift
//  TrackListApp
//
//  Created by Анастасия Конончук on 20.04.2024.
//

import UIKit

final class TrackDetailsViewController: UIViewController {
   
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    var track: Track!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        setupUI()
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
