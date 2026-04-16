package com.tientien.foodapp.cart.service;

import com.tientien.foodapp.cart.entity.Cart;

public interface CartService {

    Cart addToCart(Long userId, Long menuItemId, Integer quantity);

    Cart updateQuantity(Long userId, Long menuItemId, Integer quantity);

    void clearCart(Long userId);

    Cart getCart(Long userId);
}
