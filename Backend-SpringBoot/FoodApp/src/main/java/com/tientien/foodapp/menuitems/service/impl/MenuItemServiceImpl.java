package com.tientien.foodapp.menuitems.service.impl;

import com.tientien.foodapp.category.entity.Category;
import com.tientien.foodapp.category.repository.CategoryRepository;
import com.tientien.foodapp.common.enums.MenuItemStatus;
import com.tientien.foodapp.common.exception.NotFoundException;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.menuitems.repository.MenuItemRepository;
import com.tientien.foodapp.menuitems.service.MenuItemService;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MenuItemServiceImpl implements MenuItemService {

    private final MenuItemRepository menuItemRepository;
    private final RestaurantRepository restaurantRepository;
    private final CategoryRepository categoryRepository;

    @Override
    public List<MenuItem> getAllMenuItems() {
        return menuItemRepository.findAll();
    }

    @Override
    public MenuItem getMenuItemById(Long id) {
        return menuItemRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Menu item not found with id: " + id));
    }

    @Override
    public List<MenuItem> getMenuItemsByRestaurant(Long restaurantId) {
        return menuItemRepository.findByRestaurantId(restaurantId);
    }

    @Override
    public List<MenuItem> getMenuItemsByCategory(Long categoryId) {
        return menuItemRepository.findByCategoryId(categoryId);
    }

    @Override
    public List<MenuItem> getMenuItemsByCategoryAndRestaurant(Long categoryId, Long restaurantId) {
        return menuItemRepository.findByCategoryIdAndRestaurantId(categoryId, restaurantId);
    }

    @Override
    public List<MenuItem> searchMenuItems(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return menuItemRepository.findByStatus(MenuItemStatus.AVAILABLE.name());
        }
        return menuItemRepository.searchByName(keyword);
    }

    @Override
    public List<MenuItem> searchWithFilters(String keyword, Long restaurantId, Long categoryId, 
                                           Double minPrice, Double maxPrice) {
        return menuItemRepository.searchWithFilters(keyword, restaurantId, categoryId, minPrice, maxPrice);
    }

    @Override
    public List<MenuItem> getAvailableMenuItems() {
        return menuItemRepository.findByStatus(MenuItemStatus.AVAILABLE.name());
    }

    @Override
    public MenuItem updateStatus(Long itemId, MenuItemStatus status) {
        MenuItem item = menuItemRepository.findById(itemId)
                .orElseThrow(() -> new NotFoundException("Menu item not found"));
        item.setStatus(status);
        return menuItemRepository.save(item);
    }

    @Override
    public MenuItem updatePrice(Long itemId, Double price, Double discountPrice) {
        MenuItem item = menuItemRepository.findById(itemId)
                .orElseThrow(() -> new NotFoundException("Menu item not found"));
        item.setPrice(price);
        item.setDiscountPrice(discountPrice);
        return menuItemRepository.save(item);
    }

    @Override
    public MenuItem updateItem(Long itemId, MenuItemUpdateRequest request) {
        MenuItem item = menuItemRepository.findById(itemId)
                .orElseThrow(() -> new NotFoundException("Menu item not found"));
        
        if (request.name != null) item.setName(request.name);
        if (request.description != null) item.setDescription(request.description);
        if (request.price != null) item.setPrice(request.price);
        if (request.discountPrice != null) item.setDiscountPrice(request.discountPrice);
        if (request.status != null) item.setStatus(request.status);
        if (request.image != null) item.setImage(request.image);
        
        return menuItemRepository.save(item);
    }

    @Override
    public MenuItem createItem(MenuItemCreateRequest request) {
        MenuItem item = new MenuItem();
        item.setName(request.name);
        item.setDescription(request.description);
        item.setPrice(request.price);
        item.setDiscountPrice(request.discountPrice);
        item.setStatus(MenuItemStatus.AVAILABLE);
        item.setImage(request.image);

        if (request.restaurantId != null) {
            Restaurant restaurant = restaurantRepository.findById(request.restaurantId)
                    .orElseThrow(() -> new NotFoundException("Restaurant not found with id: " + request.restaurantId));
            item.setRestaurant(restaurant);
        }

        if (request.categoryId != null) {
            Category category = categoryRepository.findById(request.categoryId)
                    .orElseThrow(() -> new NotFoundException("Category not found with id: " + request.categoryId));
            item.setCategory(category);
        }

        return menuItemRepository.save(item);
    }

    @Override
    public void deleteItem(Long itemId) {
        MenuItem item = menuItemRepository.findById(itemId)
                .orElseThrow(() -> new NotFoundException("Menu item not found"));
        menuItemRepository.delete(item);
    }
}
