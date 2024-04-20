//
//  TrackListViewController.swift
//  TrackListApp
//
//  Created by Анастасия Конончук on 20.04.2024.
//

import UIKit

final class TrackListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet private var searchTrackSearchBar: UISearchBar!
    @IBOutlet private var trackTableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var trackList: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        trackTableView.dataSource = self
        trackTableView.delegate = self
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "trackName",
            for: indexPath
        ) as? TrackCell else {
            fatalError()
        }
        
        let track = trackList[indexPath.row]
        
        cell.configureCell(imageURL: track.artworkUrl100, text: track.title)
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let track = trackList[indexPath.row]
        performSegue(withIdentifier: "showDetails", sender: track)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let trackDetailsVC = segue.destination as? TrackDetailsViewController else { return }
        trackDetailsVC.track = sender as? Track
    }
    
    // MARK: - UISearch bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count >= 3 else {
            trackList = []
            trackTableView.reloadData()
            return
        }
        activityIndicator.startAnimating()
        
        NetworkManager.shared.fetchTrack(url: API.track.rawValue, term: searchText) { [weak self] result in
            self?.activityIndicator.stopAnimating()
            self?.trackList = result.results
            self?.trackTableView.reloadData()
        }
    }
}
