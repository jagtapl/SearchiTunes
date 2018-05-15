//
//  SearchResult.swift
//  SearchiTunes
//
//  Created by LALIT JAGTAP on 5/7/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import Foundation

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}

func > (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.artistName.localizedStandardCompare(rhs.artistName) == .orderedDescending
}

class SearchResult: Codable, CustomStringConvertible {
    var kind: String?
    var artistName = ""
    var trackName: String?
    var trackPrice: Double?
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }
    
//    var type: String {
//        return kind ?? "audiobook"
//    }
    
    var type: String {
        let kind = self.kind ?? "audiobook"
        switch kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "E-Book"
        case "feature-movie": return "Movie"
        case "music-video": return "Music Video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: break
        }
        return "Unknown"
    }
    
    var name: String {
        return trackName ?? collectionName ?? ""
    }
    
    var description: String {
        return "Kind: \(kind ?? "") Name: \(name), Artist Name: \(artistName) \n"
    }
    
    var storeUrl: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    
    var price: Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    
    var genre: String {
        if let genre = itemGenre {
            return genre
        }
        else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
}

