package com.tientien.foodapp.category.controller;

import com.tientien.foodapp.category.entity.Category;
import com.tientien.foodapp.category.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryRepository categoryRepository;

    @GetMapping
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    @GetMapping("/restaurant/{restaurantId}")
    public List<Category> getCategoriesByRestaurant(@PathVariable Long restaurantId) {
        return categoryRepository.findByRestaurantId(restaurantId);
    }

    @GetMapping("/{id}")
    public Category getCategoryById(@PathVariable Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));
    }
}
