package com.tientien.foodapp.cart.controller;

import com.tientien.foodapp.cart.dto.CartResponse;
import com.tientien.foodapp.cart.entity.Cart;
import com.tientien.foodapp.cart.mapper.CartMapper;
import com.tientien.foodapp.cart.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;
    private final CartMapper cartMapper;

    @PostMapping("/add")
    public CartResponse addToCart(
            @RequestParam Long userId,
            @RequestParam Long menuItemId,
            @RequestParam Integer quantity
    ) {
        Cart cart = cartService.addToCart(userId, menuItemId, quantity);
        return cartMapper.toDto(cart);
    }

    @PutMapping("/update")
    public CartResponse update(
            @RequestParam Long userId,
            @RequestParam Long menuItemId,
            @RequestParam Integer quantity
    ) {
        return cartMapper.toDto(
                cartService.updateQuantity(userId, menuItemId, quantity)
        );
    }

    @GetMapping
    public CartResponse getCart(@RequestParam Long userId) {
        return cartMapper.toDto(cartService.getCart(userId));
    }

    @DeleteMapping("/clear")
    public void clear(@RequestParam Long userId) {
        cartService.clearCart(userId);
    }
}
