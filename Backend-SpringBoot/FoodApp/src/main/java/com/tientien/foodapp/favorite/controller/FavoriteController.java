package com.tientien.foodapp.favorite.controller;

import com.tientien.foodapp.favorite.entity.Favorite;
import com.tientien.foodapp.favorite.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @GetMapping
    public List<Favorite> getAllFavorites() {
        return favoriteService.getAllFavorites();
    }

    @GetMapping("/{id}")
    public Favorite getFavoriteById(@PathVariable Long id) {
        return favoriteService.getFavoriteById(id);
    }

    @GetMapping("/user/{userId}")
    public List<Favorite> getFavoritesByUser(@PathVariable Long userId) {
        return favoriteService.getFavoritesByUser(userId);
    }

    @GetMapping("/check")
    public boolean isFavorite(
            @RequestParam Long userId,
            @RequestParam Long menuItemId) {
        return favoriteService.isFavorite(userId, menuItemId);
    }

    @PostMapping
    public Favorite addFavorite(
            @RequestParam Long userId,
            @RequestParam Long menuItemId) {
        return favoriteService.addFavorite(userId, menuItemId);
    }

    @DeleteMapping
    public void removeFavorite(
            @RequestParam Long userId,
            @RequestParam Long menuItemId) {
        favoriteService.removeFavorite(userId, menuItemId);
    }
}
