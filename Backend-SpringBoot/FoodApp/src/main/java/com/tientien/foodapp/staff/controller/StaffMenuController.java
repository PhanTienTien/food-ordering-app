package com.tientien.foodapp.staff.controller;

import com.tientien.foodapp.common.enums.MenuItemStatus;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.menuitems.service.MenuItemService;
import com.tientien.foodapp.menuitems.service.MenuItemService.MenuItemCreateRequest;
import com.tientien.foodapp.menuitems.service.MenuItemService.MenuItemUpdateRequest;
import com.tientien.foodapp.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/staff/menu-items")
@RequiredArgsConstructor
public class StaffMenuController {

    private final MenuItemService menuItemService;

    // Get all menu items for staff's restaurant
    @GetMapping("/restaurant/{restaurantId}")
    public List<MenuItem> getRestaurantMenuItems(
            @PathVariable Long restaurantId,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        verifyRestaurantAccess(staff, restaurantId);
        return menuItemService.getMenuItemsByRestaurant(restaurantId);
    }

    // Toggle item availability (available/out_of_stock)
    @PutMapping("/{itemId}/toggle-status")
    public MenuItem toggleItemStatus(
            @PathVariable Long itemId,
            @RequestParam MenuItemStatus status,
            Authentication authentication) {
        verifyMenuItemAccess(requireStaff(authentication), itemId);
        return menuItemService.updateStatus(itemId, status);
    }

    // Update item price
    @PutMapping("/{itemId}/price")
    public MenuItem updatePrice(
            @PathVariable Long itemId,
            @RequestParam Double price,
            @RequestParam(required = false) Double discountPrice,
            Authentication authentication) {
        verifyMenuItemAccess(requireStaff(authentication), itemId);
        return menuItemService.updatePrice(itemId, price, discountPrice);
    }

    // Update item details
    @PutMapping("/{itemId}")
    public MenuItem updateItem(
            @PathVariable Long itemId,
            @RequestBody MenuItemUpdateRequest request,
            Authentication authentication) {
        verifyMenuItemAccess(requireStaff(authentication), itemId);
        return menuItemService.updateItem(itemId, request);
    }

    // Create new menu item
    @PostMapping
    public MenuItem createItem(
            @RequestBody MenuItemCreateRequest request,
            Authentication authentication) {
        User staff = requireStaff(authentication);
        request.restaurantId = requireRestaurantId(staff);
        return menuItemService.createItem(request);
    }

    // Delete menu item
    @DeleteMapping("/{itemId}")
    public void deleteItem(
            @PathVariable Long itemId,
            Authentication authentication) {
        verifyMenuItemAccess(requireStaff(authentication), itemId);
        menuItemService.deleteItem(itemId);
    }

    private User requireStaff(Authentication authentication) {
        Object principal = authentication.getPrincipal();
        if (principal instanceof User user) {
            return user;
        }
        throw new RuntimeException("Unauthorized");
    }

    private Long requireRestaurantId(User staff) {
        if (staff.getRestaurant() == null || staff.getRestaurant().getId() == null) {
            throw new RuntimeException("Staff is not assigned to a restaurant");
        }
        return staff.getRestaurant().getId();
    }

    private void verifyRestaurantAccess(User staff, Long restaurantId) {
        if (!restaurantId.equals(requireRestaurantId(staff))) {
            throw new RuntimeException("Not your restaurant");
        }
    }

    private void verifyMenuItemAccess(User staff, Long itemId) {
        MenuItem item = menuItemService.getMenuItemById(itemId);
        if (item.getRestaurant() == null ||
                !item.getRestaurant().getId().equals(requireRestaurantId(staff))) {
            throw new RuntimeException("Not your restaurant menu item");
        }
    }
}
