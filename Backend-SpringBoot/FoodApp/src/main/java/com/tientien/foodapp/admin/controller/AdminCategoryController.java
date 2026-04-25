package com.tientien.foodapp.admin.controller;

import com.tientien.foodapp.category.entity.Category;
import com.tientien.foodapp.category.repository.CategoryRepository;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/categories")
@RequiredArgsConstructor
public class AdminCategoryController {

    private final CategoryRepository categoryRepository;
    private final RestaurantRepository restaurantRepository;

    // Get all categories
    @GetMapping
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    // Get categories by restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public List<Category> getCategoriesByRestaurant(@PathVariable Long restaurantId) {
        return categoryRepository.findByRestaurantId(restaurantId);
    }

    // Get category by ID
    @GetMapping("/{id}")
    public Category getCategoryById(@PathVariable Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));
    }

    // Create category
    @PostMapping
    public Category createCategory(@RequestBody CreateCategoryRequest request) {
        Category category = new Category();
        category.setName(request.getName());
        if (request.getRestaurantId() != null) {
            Restaurant restaurant = restaurantRepository.findById(request.getRestaurantId())
                    .orElseThrow(() -> new RuntimeException("Restaurant not found"));
            category.setRestaurant(restaurant);
        }
        return categoryRepository.save(category);
    }

    // Update category
    @PutMapping("/{id}")
    public Category updateCategory(
            @PathVariable Long id,
            @RequestBody UpdateCategoryRequest request) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));
        category.setName(request.getName());
        if (request.getRestaurantId() != null) {
            Restaurant restaurant = restaurantRepository.findById(request.getRestaurantId())
                    .orElseThrow(() -> new RuntimeException("Restaurant not found"));
            category.setRestaurant(restaurant);
        }
        return categoryRepository.save(category);
    }

    // Delete category
    @DeleteMapping("/{id}")
    public void deleteCategory(@PathVariable Long id) {
        categoryRepository.deleteById(id);
    }

    // Request DTOs
    @lombok.Data
    public static class CreateCategoryRequest {
        private String name;
        private Long restaurantId;
    }

    @lombok.Data
    public static class UpdateCategoryRequest {
        private String name;
        private Long restaurantId;
    }
}
