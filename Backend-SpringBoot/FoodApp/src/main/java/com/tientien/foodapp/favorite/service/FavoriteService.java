package com.tientien.foodapp.favorite.service;

import com.tientien.foodapp.favorite.entity.Favorite;

import java.util.List;

public interface FavoriteService {
    List<Favorite> getAllFavorites();
    Favorite getFavoriteById(Long id);
    List<Favorite> getFavoritesByUser(Long userId);
    Favorite addFavorite(Long userId, Long menuItemId);
    void removeFavorite(Long userId, Long menuItemId);
    boolean isFavorite(Long userId, Long menuItemId);
}
