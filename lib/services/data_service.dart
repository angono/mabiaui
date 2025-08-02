import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mabiaui/screens/screens.dart';

class DataService {
  Future<List<Song>> getSongs() async {
    final jsonString = await rootBundle.loadString('assets/db/songs.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Song.fromJson(json)).toList();
  }

  Future<List<Artist>> getArtists() async {
    final jsonString = await rootBundle.loadString('assets/db/artists.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Artist.fromJson(json)).toList();
  }

  Future<List<Album>> getAlbums() async {
    final jsonString = await rootBundle.loadString('assets/db/albums.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Album.fromJson(json)).toList();
  }

  Future<List<Genre>> getGenres() async {
    final jsonString = await rootBundle.loadString('assets/db/genres.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Genre.fromJson(json)).toList();
  }

  Future<List<Song>> getSongsByGenre(String genreName) async {
    final songs = await getSongs();
    return songs.where((song) => song.genre == genreName).toList();
  }

  Future<List<Song>> getSongsByArtist(String artistId) async {
    final songs = await getSongs();
    return songs.where((song) => song.artistId == artistId).toList();
  }

  Future<List<Song>> getSongsByAlbum(String albumId) async {
    final songs = await getSongs();
    return songs.where((song) => song.albumId == albumId).toList();
  }

  // Add these methods to filter songs
  // Future<List<Song>> getSongsByArtist(String artistName) async {
  //   final songs = await getSongs();
  //   return songs.where((song) => song.artist == artistName).toList();
  // }

  // Future<List<Song>> getSongsByAlbum(String albumTitle) async {
  //   final songs = await getSongs();
  //   return songs.where((song) => song.album == albumTitle).toList();
  // }
}
