package com.tientien.foodapp.menuitems.controller;

import com.tientien.foodapp.menuitems.dto.MenuItemResponse;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.menuitems.service.MenuItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/menu-items")
@RequiredArgsConstructor
public class MenuItemController {

    private final MenuItemService menuItemService;

    // Get all menu items
    @GetMapping
    public List<MenuItemResponse> getAllMenuItems() {
        return menuItemService.getAllMenuItems().stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    private MenuItemResponse toDto(MenuItem menuItem) {
        if (menuItem == null) return null;
        MenuItemResponse dto = new MenuItemResponse();
        dto.setId(menuItem.getId());
        dto.setName(menuItem.getName());
        dto.setPrice(menuItem.getPrice());
        dto.setDiscountPrice(menuItem.getDiscountPrice());
        dto.setStatus(menuItem.getStatus() != null ? menuItem.getStatus().name() : null);
        dto.setImage(menuItem.getImage());
        dto.setDescription(menuItem.getDescription());

        // Flatten nested objects
        if (menuItem.getRestaurant() != null) {
            dto.setRestaurantId(menuItem.getRestaurant().getId());
            dto.setRestaurantName(menuItem.getRestaurant().getName());
        }
        if (menuItem.getCategory() != null) {
            dto.setCategoryId(menuItem.getCategory().getId());
            dto.setCategoryName(menuItem.getCategory().getName());
        }
        return dto;
    }

    // Get menu item by ID
    @GetMapping("/{id}")
    public MenuItemResponse getMenuItemById(@PathVariable Long id) {
        return toDto(menuItemService.getMenuItemById(id));
    }

    // Get menu items by restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public List<MenuItemResponse> getMenuItemsByRestaurant(@PathVariable Long restaurantId) {
        return menuItemService.getMenuItemsByRestaurant(restaurantId).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    // Get menu items by category
    @GetMapping("/category/{categoryId}")
    public List<MenuItemResponse> getMenuItemsByCategory(@PathVariable Long categoryId) {
        return menuItemService.getMenuItemsByCategory(categoryId).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    // Get menu items by category and restaurant
    @GetMapping("/category/{categoryId}/restaurant/{restaurantId}")
    public List<MenuItemResponse> getMenuItemsByCategoryAndRestaurant(
            @PathVariable Long categoryId,
            @PathVariable Long restaurantId) {
        return menuItemService.getMenuItemsByCategoryAndRestaurant(categoryId, restaurantId).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    // Search menu items by keyword
    @GetMapping("/search")
    public List<MenuItemResponse> searchMenuItems(@RequestParam(required = false) String keyword) {
        return menuItemService.searchMenuItems(keyword).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    // Advanced search with filters
    @GetMapping("/filter")
    public List<MenuItemResponse> filterMenuItems(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long restaurantId,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice) {
        return menuItemService.searchWithFilters(keyword, restaurantId, categoryId, minPrice, maxPrice).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    // Get available menu items only
    @GetMapping("/available")
    public List<MenuItemResponse> getAvailableMenuItems() {
        return menuItemService.getAvailableMenuItems().stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }
}
