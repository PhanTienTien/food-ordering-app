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

            item.setMenuItemId(ci.getMenuItem().getId());
            item.setName(ci.getMenuItem().getName());
            item.setImage(ci.getMenuItem().getImage());

            double price = ci.getMenuItem().getDiscountPrice() != null
                    ? ci.getMenuItem().getDiscountPrice()
                    : ci.getMenuItem().getPrice();

            item.setPrice(price);
            item.setQuantity(ci.getQuantity());
            item.setTotalPrice(price * ci.getQuantity());

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
