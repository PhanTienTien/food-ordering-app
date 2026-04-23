package com.tientien.foodapp.favorite.service.impl;

import com.tientien.foodapp.favorite.entity.Favorite;
import com.tientien.foodapp.favorite.repository.FavoriteRepository;
import com.tientien.foodapp.favorite.service.FavoriteService;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.menuitems.repository.MenuItemRepository;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final UserRepository userRepository;
    private final MenuItemRepository menuItemRepository;

    @Override
    public List<Favorite> getAllFavorites() {
        return favoriteRepository.findAll();
    }

    @Override
    public Favorite getFavoriteById(Long id) {
        return favoriteRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
    }

    @Override
    public List<Favorite> getFavoritesByUser(Long userId) {
        return favoriteRepository.findByUserId(userId);
    }

    @Override
    public Favorite addFavorite(Long userId, Long menuItemId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        MenuItem menuItem = menuItemRepository.findById(menuItemId)
                .orElseThrow(() -> new RuntimeException("MenuItem not found"));

        // Check if already favorite
        if (favoriteRepository.findByUserIdAndMenuItemId(userId, menuItemId).isPresent()) {
            throw new RuntimeException("Item already in favorites");
        }

        Favorite favorite = new Favorite();
        favorite.setUser(user);
        favorite.setMenuItem(menuItem);

        return favoriteRepository.save(favorite);
    }

    @Override
    public void removeFavorite(Long userId, Long menuItemId) {
        Favorite favorite = favoriteRepository.findByUserIdAndMenuItemId(userId, menuItemId)
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
        favoriteRepository.delete(favorite);
    }

    @Override
    public boolean isFavorite(Long userId, Long menuItemId) {
        return favoriteRepository.findByUserIdAndMenuItemId(userId, menuItemId).isPresent();
    }
}
