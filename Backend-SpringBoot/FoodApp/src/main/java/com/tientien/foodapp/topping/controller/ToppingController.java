package com.tientien.foodapp.topping.controller;

import com.tientien.foodapp.topping.entity.Topping;
import com.tientien.foodapp.topping.enums.ToppingStatus;
import com.tientien.foodapp.topping.service.ToppingService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/toppings")
@RequiredArgsConstructor
public class ToppingController {

    private final ToppingService toppingService;

    @GetMapping
    public List<Topping> getAllToppings() {
        return toppingService.getAllToppings();
    }

    @GetMapping("/{id}")
    public Topping getToppingById(@PathVariable Long id) {
        return toppingService.getToppingById(id);
    }

    @GetMapping("/restaurant/{restaurantId}")
    public List<Topping> getToppingsByRestaurant(@PathVariable Long restaurantId) {
        return toppingService.getToppingsByRestaurant(restaurantId);
    }

    @GetMapping("/restaurant/{restaurantId}/available")
    public List<Topping> getAvailableToppingsByRestaurant(@PathVariable Long restaurantId) {
        return toppingService.getAvailableToppingsByRestaurant(restaurantId);
    }

    @PostMapping
    public Topping createTopping(@RequestBody ToppingService.ToppingCreateRequest request) {
        return toppingService.createTopping(request);
    }

    @PutMapping("/{id}")
    public Topping updateTopping(
            @PathVariable Long id,
            @RequestBody ToppingService.ToppingUpdateRequest request) {
        return toppingService.updateTopping(id, request);
    }

    @PutMapping("/{id}/status")
    public Topping updateStatus(
            @PathVariable Long id,
            @RequestParam ToppingStatus status) {
        return toppingService.updateStatus(id, status);
    }

    @DeleteMapping("/{id}")
    public void deleteTopping(@PathVariable Long id) {
        toppingService.deleteTopping(id);
    }
}
