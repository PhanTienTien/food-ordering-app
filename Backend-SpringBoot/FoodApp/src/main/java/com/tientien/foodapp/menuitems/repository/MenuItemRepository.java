package com.tientien.foodapp.menuitems.repository;

import com.tientien.foodapp.menuitems.entity.MenuItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MenuItemRepository extends JpaRepository<MenuItem, Long> {

    List<MenuItem> findByRestaurantId(Long restaurantId);

    List<MenuItem> findByCategoryId(Long categoryId);

    // Search by name (case insensitive)
    @Query("SELECT m FROM MenuItem m WHERE LOWER(m.name) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<MenuItem> searchByName(@Param("keyword") String keyword);

    // Search with filters
    @Query("SELECT m FROM MenuItem m WHERE " +
           "(:keyword IS NULL OR LOWER(m.name) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
           "(:restaurantId IS NULL OR m.restaurant.id = :restaurantId) AND " +
           "(:categoryId IS NULL OR m.category.id = :categoryId) AND " +
           "(:minPrice IS NULL OR m.price >= :minPrice) AND " +
           "(:maxPrice IS NULL OR m.price <= :maxPrice) AND " +
           "m.status = 'AVAILABLE'")
    List<MenuItem> searchWithFilters(
            @Param("keyword") String keyword,
            @Param("restaurantId") Long restaurantId,
            @Param("categoryId") Long categoryId,
            @Param("minPrice") Double minPrice,
            @Param("maxPrice") Double maxPrice);

    // Find by status
    List<MenuItem> findByStatus(String status);
}
