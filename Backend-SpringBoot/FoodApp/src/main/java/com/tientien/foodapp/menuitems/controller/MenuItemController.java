package com.tientien.foodapp.menuitems.controller;

import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.menuitems.service.MenuItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/menu-items")
@RequiredArgsConstructor
public class MenuItemController {

    private final MenuItemService menuItemService;

    // Get all menu items
    @GetMapping
    public List<MenuItem> getAllMenuItems() {
        return menuItemService.getAllMenuItems();
    }

    // Get menu item by ID
    @GetMapping("/{id}")
    public MenuItem getMenuItemById(@PathVariable Long id) {
        return menuItemService.getMenuItemById(id);
    }

    // Get menu items by restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public List<MenuItem> getMenuItemsByRestaurant(@PathVariable Long restaurantId) {
        return menuItemService.getMenuItemsByRestaurant(restaurantId);
    }

    // Get menu items by category
    @GetMapping("/category/{categoryId}")
    public List<MenuItem> getMenuItemsByCategory(@PathVariable Long categoryId) {
        return menuItemService.getMenuItemsByCategory(categoryId);
    }

    // Get menu items by category and restaurant
    @GetMapping("/category/{categoryId}/restaurant/{restaurantId}")
    public List<MenuItem> getMenuItemsByCategoryAndRestaurant(
            @PathVariable Long categoryId,
            @PathVariable Long restaurantId) {
        return menuItemService.getMenuItemsByCategoryAndRestaurant(categoryId, restaurantId);
    }

    // Search menu items by keyword
    @GetMapping("/search")
    public List<MenuItem> searchMenuItems(@RequestParam(required = false) String keyword) {
        return menuItemService.searchMenuItems(keyword);
    }

    // Advanced search with filters
    @GetMapping("/filter")
    public List<MenuItem> filterMenuItems(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long restaurantId,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice) {
        return menuItemService.searchWithFilters(keyword, restaurantId, categoryId, minPrice, maxPrice);
    }

    // Get available menu items only
    @GetMapping("/available")
    public List<MenuItem> getAvailableMenuItems() {
        return menuItemService.getAvailableMenuItems();
    }
}
