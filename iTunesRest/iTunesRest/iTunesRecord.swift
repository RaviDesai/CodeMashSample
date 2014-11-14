//
//  iTunesResults.swift
//  iTunesRest
//
//  Created by Ravi Desai on 11/13/14.
//  Copyright (c) 2014 RSD. All rights reserved.
//

import Foundation

public enum iTunesWrapperType : String {
    case Track = "track"
    case Collection = "collection"
    case Artist = "artist"
}

public func toiTunesWrapperType(wrapperJson: JSON) -> iTunesWrapperType? {
    if let wrapper = wrapperJson as? String {
        return iTunesWrapperType(rawValue: wrapper)
    }
    return .None
}

public enum iTunesKindType : String {
    case Book = "book"
    case Album = "album"
    case CoachedAudio = "coached-audio"
    case FeatureMovie = "feature-movie"
    case InteractiveBooklet = "interactive-booklet"
    case MusicVideo = "music-video"
    case PDF = "pdf"
    case Podcast = "podcast"
    case PodcastEpisode = "podcast-episode"
    case SoftwarePackage = "software-package"
    case Song = "song"
    case TVEpisode = "tv-episode"
    case Artist = "artist"
}

public func toiTunesKindType(kindJson: JSON) -> iTunesKindType? {
    if let kind = kindJson as? String {
        return iTunesKindType(rawValue: kind)
    }
    return .None
}

public enum iTunesExplicitness : String {
    case Explicit = "explicit"
    case Cleaned = "cleaned"
    case NotExplicit = "notExplicit"
}

public func toiTunesExplicitness(explicitJson: JSON) -> iTunesExplicitness? {
    if let explicit = explicitJson as? String {
        return iTunesExplicitness(rawValue: explicit)
    }
    return .None
}

public struct iTunesRecord {
    public var Wrapper : iTunesWrapperType
    public var Kind : iTunesKindType
    public var ArtistId : Int
    public var CollectionId : Int
    public var TrackId : Int
    public var ArtistName : String
    public var CollectionName : String
    public var TrackName : String
    public var CollectionCensoredName : String
    public var TrackCensoredName : String
    public var ArtistViewURL : NSURL
    public var CollectionViewURL : NSURL
    public var TrackViewURL : NSURL
    public var PreviewURL : NSURL?
    public var ArtworkURL60 : NSURL?
    public var ArtworkURL100 : NSURL?
    public var CollectionPrice : Double
    public var TrackPrice : Double
    public var CollectionExplicitness : iTunesExplicitness
    public var TrackExplicitness : iTunesExplicitness
    public var DiscCount : Int
    public var TrackCount : Int
    public var TrackNumber : Int
    public var TrackTimeMillis : Int?
    public var Country : String
    public var Currency : String
    public var PrimaryGenreName : String
    
    public init(wrapper: iTunesWrapperType, kind: iTunesKindType, artistId: Int, collectionId: Int, trackId: Int, artistName: String, collectionName: String, trackName: String, collectionCensoredName: String, trackCensoredName: String, artistViewURL: NSURL, collectionViewURL: NSURL, trackViewURL: NSURL, previewURL: NSURL?, artworkURL60: NSURL?, artworkURL100: NSURL?, collectionPrice: Double, trackPrice: Double, collectionExplicitness: iTunesExplicitness, trackExplicitness: iTunesExplicitness, discCount: Int, trackCount: Int, trackNumber: Int, trackTimeMillis: Int?, country: String, currency: String, primaryGenreName: String) {
        self.Wrapper = wrapper
        self.Kind = kind
        self.ArtistId = artistId
        self.CollectionId = collectionId
        self.TrackId = trackId
        self.ArtistName = artistName
        self.CollectionName = collectionName
        self.TrackName = trackName
        self.CollectionCensoredName = collectionCensoredName
        self.TrackCensoredName = trackCensoredName
        self.ArtistViewURL = artistViewURL
        self.CollectionViewURL = collectionViewURL
        self.TrackViewURL = trackViewURL
        self.PreviewURL = previewURL
        self.ArtworkURL60 = artworkURL60
        self.ArtworkURL100 = artworkURL100
        self.CollectionPrice = collectionPrice
        self.TrackPrice = trackPrice
        self.CollectionExplicitness = collectionExplicitness
        self.TrackExplicitness = trackExplicitness
        self.DiscCount = discCount
        self.TrackCount = trackCount
        self.TrackNumber = trackNumber
        self.TrackTimeMillis = trackTimeMillis
        self.Country = country
        self.Currency = currency
        self.PrimaryGenreName = primaryGenreName
    }
    
    public static func create(wrapper: iTunesWrapperType)(kind: iTunesKindType)(artistId: Int)(collectionId: Int)
        (trackId: Int)(artistName: String)(collectionName: String)(trackName: String)(collectionCensoredName: String)
        (trackCensoredName: String)(artistViewURL: NSURL)(collectionViewURL: NSURL)(trackViewURL: NSURL)
        (previewURL: NSURL?)(artworkURL60: NSURL?)(artworkURL100: NSURL?)(collectionPrice: Double)(trackPrice: Double)
        (collectionExplicitness: iTunesExplicitness)(trackExplicitness: iTunesExplicitness)(discCount: Int)
        (trackCount: Int)(trackNumber: Int)(trackTimeMillis: Int?)(country: String)(currency: String)
        (primaryGenreName: String) -> iTunesRecord {
            return iTunesRecord(wrapper: wrapper, kind: kind, artistId: artistId, collectionId: collectionId, trackId: trackId, artistName: artistName, collectionName: collectionName, trackName: trackName, collectionCensoredName: collectionCensoredName, trackCensoredName: trackCensoredName, artistViewURL: artistViewURL, collectionViewURL: collectionViewURL, trackViewURL: trackViewURL, previewURL: previewURL, artworkURL60: artworkURL60, artworkURL100: artworkURL100, collectionPrice: collectionPrice, trackPrice: trackPrice, collectionExplicitness: collectionExplicitness, trackExplicitness: trackExplicitness, discCount: discCount, trackCount: trackCount, trackNumber: trackNumber, trackTimeMillis: trackTimeMillis, country: country, currency: currency, primaryGenreName: primaryGenreName)
    }
    
    /*
    public static func createFromJson(json: JSONDictionary) -> iTunesRecord {
        if let record = json >>- toDictionary {
            return iTunesRecord.create <^>
                record["wrapper"] >>- toiTunesWrapperType <*>
                record["kind"] >>- toiTunesWrapperType <*>
                record["artistId"] >>- toInt <*>
                record["collectionId"] >>- toInt <*>
                record["trackId"] >>- toInt <*>
                record["artistName"] >>- toString <*>
                record["collectionName"] >>- toString <*>
                record["trackName"] >>- toString <*>
                record["collectionCensoredName"] >>- toString <*>
                record["trackCensoredName"] >>- toString <*>
                record["artistViewUrl"] >>- toUrl <*>
                record["collectionViewUrl"] >>- toUrl <*>
                record["trackViewUrl"] >>- toUrl <*>
                record["previewUrl"] >>- toUrl <**>
                record["artworkUrl60"] >>- toUrl <**>
                record["artworkUrl100"] >>- toUrl <**>
                record["collectionPrice"] >>- toDouble <*>
                record["trackPrice"] >>- toDouble <*>
                record["collectionExplicitness"] >>- toiTunesExplicitness <*>
                record["trackExplicitness"] >>- toiTunesExplicitness <*>
                record["discCount"] >>- toInt <*>
                record["trackCount"] >>- toInt <*>
                record["trackNumber"] >>- toInt <*>
                record["trackTimeMills"] >>- toInt <**>
                record["country"] >>- toString <*>
                record["currency"] >>- toString <*>
                record["primaryGenreName"] >>- toString
        }
    }
    */
}