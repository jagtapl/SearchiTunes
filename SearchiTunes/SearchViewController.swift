//
//  ViewController.swift
//  SearchiTunes
//
//  Created by LALIT JAGTAP on 5/7/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup inset to remove space between search bar and top row
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        // register "Cell" nib file for use in the code
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        tableView.rowHeight = 80
        
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()        // hide keyboard or u could have set attribute to do so
        
            hasSearched = true
            searchResults = []
        
            let url = iTunesURL(searchText: searchBar.text!)
            print("URL: '\(url)'")
            
            if let data = performStoreRequest(with: url) {
                searchResults = parse(data: data)
            }
            
//            searchResults.sort(by: {result1, result2 in
//                return result1.name.localizedStandardCompare(result2.name) == .orderedAscending})

//            searchResults.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
            
//            searchResults.sort { $0 < $1 }
  
            searchResults.sort { $0 > $1 }
            
            tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "SearchResultCell"
//        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
//        if cell == nil {
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
//        }
        
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
        
            let searchResult = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            //cell.artistNameLabel.text = searchResult.artistName
            if searchResult.artistName.isEmpty {
                cell.artistNameLabel.text = "Unknown"
            } else {
                cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, searchResult.type)
            }
            return cell
        }
    }
    
    // MARK:- Private Methods
    func iTunesURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    func performStoreRequest(with url: URL) -> Data? {
        do {
            //return try String(contentsOf: url, encoding: .utf8)
            return try Data(contentsOf: url)
        } catch {
            print("Download Error \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error \(error)")
            return []
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store." + " Please try again.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
