package com.tientien.foodapp.favorite.repository;

import com.tientien.foodapp.favorite.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {

    List<Favorite> findByUserId(Long userId);
    Optional<Favorite> findByUserIdAndMenuItemId(Long userId, Long menuItemId);
}
