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
    
    private let trackListViewModel = TrackListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        trackTableView.dataSource = self
        trackTableView.delegate = self
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackListViewModel.trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "trackName",
            for: indexPath
        ) as? TrackCell else {
            fatalError()
        }
        
        let track = trackListViewModel.trackList[indexPath.row]
        
        cell.configureCell(imageURL: track.artworkUrl100, text: track.title)
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let track = trackListViewModel.trackList[indexPath.row]
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
            trackListViewModel.trackList = []
            trackTableView.reloadData()
            return
        }
        activityIndicator.startAnimating()
        
        trackListViewModel.fetchTracks(searchText: searchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let trackRequest):
                    self?.trackListViewModel.trackList = trackRequest.results
                case .failure(let error):
                    print("Error fetching tracks: \(error.localizedDescription)")
                    self?.trackListViewModel.trackList = []
                }
                self?.trackTableView.reloadData()
            }
        }
    }
}
