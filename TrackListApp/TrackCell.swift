//
//  TrackCell.swift
//  TrackListApp
//
//  Created by Анастасия Конончук on 20.04.2024.
//

import UIKit

final class TrackCell: UITableViewCell {

    @IBOutlet private var coverImageVew: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configureCell(imageURL: String?, text: String) {
        NetworkManager.shared.fetchImage(url: imageURL ?? "") { [weak self] image in
            self?.coverImageVew.image = image
        }
        
        titleLabel.text = text
    }
}
