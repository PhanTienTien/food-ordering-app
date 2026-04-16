package com.tientien.foodapp.menuitems.service;

import com.tientien.foodapp.common.enums.MenuItemStatus;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import java.util.List;

public interface MenuItemService {
    List<MenuItem> getAllMenuItems();
    MenuItem getMenuItemById(Long id);
    List<MenuItem> getMenuItemsByRestaurant(Long restaurantId);
    List<MenuItem> getMenuItemsByCategory(Long categoryId);
    List<MenuItem> searchMenuItems(String keyword);
    List<MenuItem> searchWithFilters(String keyword, Long restaurantId, Long categoryId, Double minPrice, Double maxPrice);
    List<MenuItem> getAvailableMenuItems();

    // Staff methods
    MenuItem updateStatus(Long itemId, MenuItemStatus status);
    MenuItem updatePrice(Long itemId, Double price, Double discountPrice);
    MenuItem updateItem(Long itemId, MenuItemUpdateRequest request);
    MenuItem createItem(MenuItemCreateRequest request);
    void deleteItem(Long itemId);

    // Request DTOs
    class MenuItemUpdateRequest {
        public String name;
        public String description;
        public Double price;
        public Double discountPrice;
        public MenuItemStatus status;
        public String image;
    }

    class MenuItemCreateRequest {
        public String name;
        public String description;
        public Double price;
        public Double discountPrice;
        public Long restaurantId;
        public Long categoryId;
        public String image;
    }
}
