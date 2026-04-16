package com.tientien.foodapp.staff.controller;

import com.tientien.foodapp.common.enums.MenuItemStatus;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.menuitems.service.MenuItemService;
import com.tientien.foodapp.menuitems.service.MenuItemService.MenuItemCreateRequest;
import com.tientien.foodapp.menuitems.service.MenuItemService.MenuItemUpdateRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/staff/menu-items")
@RequiredArgsConstructor
public class StaffMenuController {

    private final MenuItemService menuItemService;

    // Get all menu items for staff's restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public List<MenuItem> getRestaurantMenuItems(@PathVariable Long restaurantId) {
        return menuItemService.getMenuItemsByRestaurant(restaurantId);
    }

    // Toggle item availability (available/out_of_stock)
    @PutMapping("/{itemId}/toggle-status")
    public MenuItem toggleItemStatus(
            @PathVariable Long itemId,
            @RequestParam MenuItemStatus status) {
        return menuItemService.updateStatus(itemId, status);
    }

    // Update item price
    @PutMapping("/{itemId}/price")
    public MenuItem updatePrice(
            @PathVariable Long itemId,
            @RequestParam Double price,
            @RequestParam(required = false) Double discountPrice) {
        return menuItemService.updatePrice(itemId, price, discountPrice);
    }

    // Update item details
    @PutMapping("/{itemId}")
    public MenuItem updateItem(
            @PathVariable Long itemId,
            @RequestBody MenuItemUpdateRequest request) {
        return menuItemService.updateItem(itemId, request);
    }

    // Create new menu item
    @PostMapping
    public MenuItem createItem(@RequestBody MenuItemCreateRequest request) {
        return menuItemService.createItem(request);
    }

    // Delete menu item
    @DeleteMapping("/{itemId}")
    public void deleteItem(@PathVariable Long itemId) {
        menuItemService.deleteItem(itemId);
    }
}

