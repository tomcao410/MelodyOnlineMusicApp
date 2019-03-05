//
//  Song.swift
//  MelodyProject
//
//  Created by Tom on 12/12/18.
//  Copyright © 2018 Tom. All rights reserved.
//

import Foundation

class Song
{
    var artist: String = String()
    var name: String = String()
    
    static var songs: [String] = ["Alec Benjamin - Worst Day of my Life",
                                  "Justin Bieber-LoveYourself",
                                  "AlecBenjamin-If We Have Each Other"]
    static var songArtist: [String] = ["Alec Benjamin", "Justin Bieber", "Alec Benjamin"]
    
    static var songName: [String] = ["Worst Day of My Life",
                                     "Love Yourself",
                                     "If We Have Each Other"]
    
    static var recommendedSongs: [String] = ["Alec Benjamin-The Wolf And The Sheep",
                                             "Bebe Rexha-I'm A Mess",
                                             "BRay-Con Trai Cung",
                                             "Khalid-Love Lies",
                                             "Mino-Fiance"]
    
    static var UsUkSongs: [String] = ["Alec Benjamin-Let Me Down Slowly",
                                      "Bebe Rexha-Knees",
                                      "Billie Eilish-Lovely",
                                      "Camila Cabello-Consequences",
                                      "Dua Lipa-Kiss And Make Up"]
    
    static var VPopSongs: [String] = ["LyLy-24H",
                                      "Den Vau-Do Em Biet Anh Dang Nghi Gi",
                                      "Huynh Tu-Duong Mot Chieu",
                                      "Son Tung MTP-Lac Troi",
                                      "Tien Tien-Em Khong The"]
    
    static var KPopSongs: [String] = ["Black Pink-Ddudu Ddudu",
                                      "EXID-I Love You",
                                      "iKON-Killing Me",
                                      "JENNIE-SOLO",
                                      "Sunmi-Siren"]
    
    static var globalSongs: [String] = ["Huong Giang-Anh Dang O Dau Day Anh",
                                        "Camila Cabello-Beautiful",
                                        "BIGBANG-If You",
                                        "Black Pink-ForeverYoung",
                                        "David Guetta-Don't Leave Me Alone"]
    
    
    // MARK: Split Song and Artist name (return string array)
    static func splitSongArtistName(Songs:[String])->([String],[String]){
        var resultSongs = [String]()
        var resultArtists = [String]()
        for index in 0..<Songs.count {
            if let indexSubstring = Songs[index].lastIndex(of: "-") {
                let range = Songs[index].index(after:indexSubstring)..<Songs[index].endIndex
                let songName = String(Songs[index][range])
                resultSongs.append(songName)
            }
            if let indexSubstring = Songs[index].lastIndex(of: "-") {
                let range = Songs[index].startIndex...Songs[index].index(before: indexSubstring)
                let artist = String(Songs[index][range])
                resultArtists.append(artist)
            }
        }
        return (resultSongs,resultArtists)
    }
    
    //MARK: Split Song's name (return string array)
    static func splitSongName(Songs:[String])->[String]{
        var resultSongs = [String]()
        for index in 0..<Songs.count {
            if let indexSubstring = Songs[index].lastIndex(of: "-") {
                let range = Songs[index].index(after:indexSubstring)..<Songs[index].endIndex
                let songName = String(Songs[index][range])
                resultSongs.append(songName)
            }
        }
        return resultSongs
    }
    
    // MARK: Song's name in Play Screen (return string)
    static func setSongName(with fileName: String)->String
    {
        var result: String = "Song name"
        if let indexSubstring = fileName.lastIndex(of: "-") {
            let range = fileName.index(after:indexSubstring)..<fileName.endIndex
            result = String(fileName[range])
        }
        return result
    }
    
    // MARK: Artist name in Play Screen (return string)
    static func setArtist(with fileName: String)->String
    {
        var result: String = "Unknown artist"
        if let indexSubstring = fileName.lastIndex(of: "-")
        {
            let range = fileName.startIndex...fileName.index(before: indexSubstring)
            result = String(fileName[range])
        }
        return result
    }
    
    // 
    static func findArtistInCertainSongList(Songs:[String], songName: String)->[String]{
        var resultArtist = [String]()
        var resultSongs = [String]()
        var result = [String]()
        for index in 0..<Songs.count {
            if let indexSubstring = Songs[index].lastIndex(of: "-") {
                let range = Songs[index].index(after:indexSubstring)..<Songs[index].endIndex
                let songName = String(Songs[index][range])
                resultSongs.append(songName)
            }
            if let indexSubstring = Songs[index].lastIndex(of: "-") {
                let range = Songs[index].startIndex...Songs[index].index(before: indexSubstring)
                let artist = String(Songs[index][range])
                resultArtist.append(artist)
            }
        }
            
        for index in 0..<resultSongs.count{
            if songName == resultSongs[index]{
                result.append(resultArtist[index])
            }
        }
        return result
    }
    
    //MARK: Find Artist from SongName
    static func findArtistFromSongName(Songs:[String])->[String]{
        var result = [String]()
        for index in 0..<Songs.count {
            var temp = [String]()
            temp = Song.findArtistInCertainSongList(Songs: Song.recommendedSongs, songName: Songs[index])
            for i in 0..<temp.count {
                result.append(temp[i])
            }
            temp = Song.findArtistInCertainSongList(Songs: Song.UsUkSongs, songName: Songs[index])
            for i in 0..<temp.count {
                result.append(temp[i])
            }
            temp = Song.findArtistInCertainSongList(Songs: Song.KPopSongs, songName: Songs[index])
            for i in 0..<temp.count {
                result.append(temp[i])
            }
            temp = Song.findArtistInCertainSongList(Songs: Song.globalSongs, songName: Songs[index])
            for i in 0..<temp.count {
                result.append(temp[i])
            }
            temp = Song.findArtistInCertainSongList(Songs: Song.VPopSongs, songName: Songs[index])
            for i in 0..<temp.count {
                result.append(temp[i])
            }
        }
        return result
    }
}
