package com.tientien.foodapp.cart.mapper;

import com.tientien.foodapp.cart.dto.CartItemResponse;
import com.tientien.foodapp.cart.dto.CartResponse;
import com.tientien.foodapp.cart.entity.Cart;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class CartMapper {

    public CartResponse toDto(Cart cart) {

        CartResponse dto = new CartResponse();

        dto.setId(cart.getId());

        if (cart.getRestaurant() != null) {
            dto.setRestaurantId(cart.getRestaurant().getId());
            dto.setRestaurantName(cart.getRestaurant().getName());
        }

        List<CartItemResponse> items = cart.getItems().stream().map(ci -> {
            CartItemResponse item = new CartItemResponse();

            item.setId(ci.getId());
            item.setQuantity(ci.getQuantity());

            // Build nested menuItem object to match FE expected schema
            CartItemResponse.MenuItemSummary menuItemSummary = new CartItemResponse.MenuItemSummary();
            menuItemSummary.setId(ci.getMenuItem().getId());
            menuItemSummary.setName(ci.getMenuItem().getName());
            menuItemSummary.setImage(ci.getMenuItem().getImage());
            menuItemSummary.setPrice(ci.getMenuItem().getPrice());
            menuItemSummary.setDiscountPrice(ci.getMenuItem().getDiscountPrice());

            item.setMenuItem(menuItemSummary);

            double unitPrice = ci.getMenuItem().getDiscountPrice() != null
                    ? ci.getMenuItem().getDiscountPrice()
                    : ci.getMenuItem().getPrice();

            item.setUnitPrice(unitPrice);
            item.setTotalPrice(unitPrice * ci.getQuantity());

            return item;
        }).toList();

        dto.setItems(items);

        double total = items.stream()
                .mapToDouble(CartItemResponse::getTotalPrice)
                .sum();

        dto.setTotalPrice(total);

        return dto;
    }
}
