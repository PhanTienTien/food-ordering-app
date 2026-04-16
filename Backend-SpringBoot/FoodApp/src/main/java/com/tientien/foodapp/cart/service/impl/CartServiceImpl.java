package com.tientien.foodapp.cart.service.impl;

import com.tientien.foodapp.cart.entity.Cart;
import com.tientien.foodapp.cart.entity.CartItem;
import com.tientien.foodapp.cart.repository.CartRepository;
import com.tientien.foodapp.cart.service.CartService;
import com.tientien.foodapp.common.exception.NotFoundException;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.menuitems.repository.MenuItemRepository;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;
    private final MenuItemRepository menuItemRepository;
    private final UserRepository userRepository;

    @Override
    public Cart addToCart(Long userId, Long menuItemId, Integer quantity) {

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        MenuItem item = menuItemRepository.findById(menuItemId)
                .orElseThrow(() -> new NotFoundException("Item not found"));

        // 🔥 Lấy hoặc tạo cart
        Cart cart = cartRepository.findByUserId(userId)
                .orElseGet(() -> {
                    Cart newCart = new Cart();
                    newCart.setUser(user);
                    return newCart;
                });

        // 💣 RULE: chỉ 1 restaurant
        if (cart.getRestaurant() == null) {
            cart.setRestaurant(item.getRestaurant());
        } else if (!cart.getRestaurant().getId()
                .equals(item.getRestaurant().getId())) {

            throw new RuntimeException("Cart belongs to another restaurant");
        }

        // 🔥 Check item tồn tại chưa
        Optional<CartItem> existingItem = cart.getItems()
                .stream()
                .filter(ci -> ci.getMenuItem().getId().equals(menuItemId))
                .findFirst();

        if (existingItem.isPresent()) {
            CartItem ci = existingItem.get();
            ci.setQuantity(ci.getQuantity() + quantity);
        } else {
            CartItem ci = new CartItem();
            ci.setCart(cart);
            ci.setMenuItem(item);
            ci.setQuantity(quantity);

            cart.getItems().add(ci);
        }

        return cartRepository.save(cart);
    }

    @Override
    public Cart updateQuantity(Long userId, Long menuItemId, Integer quantity) {

        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new NotFoundException("Cart not found"));

        CartItem item = cart.getItems().stream()
                .filter(ci -> ci.getMenuItem().getId().equals(menuItemId))
                .findFirst()
                .orElseThrow(() -> new NotFoundException("Item not in cart"));

        if (quantity <= 0) {
            cart.getItems().remove(item);
        } else {
            item.setQuantity(quantity);
        }

        return cartRepository.save(cart);
    }

    @Override
    public void clearCart(Long userId) {
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new NotFoundException("Cart not found"));

        cart.getItems().clear();
        cart.setRestaurant(null);

        cartRepository.save(cart);
    }

    @Override
    public Cart getCart(Long userId) {
        return cartRepository.findByUserId(userId)
                .orElseThrow(() -> new NotFoundException("Cart not found"));
    }
}
