package com.tientien.foodapp.topping.service.impl;

import com.tientien.foodapp.common.exception.NotFoundException;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import com.tientien.foodapp.topping.entity.Topping;
import com.tientien.foodapp.topping.enums.ToppingStatus;
import com.tientien.foodapp.topping.repository.ToppingRepository;
import com.tientien.foodapp.topping.service.ToppingService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ToppingServiceImpl implements ToppingService {

    private final ToppingRepository toppingRepository;
    private final RestaurantRepository restaurantRepository;

    @Override
    public List<Topping> getAllToppings() {
        return toppingRepository.findAll();
    }

    @Override
    public Topping getToppingById(Long id) {
        return toppingRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Topping not found with id: " + id));
    }

    @Override
    public List<Topping> getToppingsByRestaurant(Long restaurantId) {
        return toppingRepository.findByRestaurantId(restaurantId);
    }

    @Override
    public List<Topping> getAvailableToppingsByRestaurant(Long restaurantId) {
        return toppingRepository.findByRestaurantIdAndStatus(restaurantId, ToppingStatus.AVAILABLE);
    }

    @Override
    public Topping createTopping(ToppingCreateRequest request) {
        Restaurant restaurant = restaurantRepository.findById(request.restaurantId)
                .orElseThrow(() -> new NotFoundException("Restaurant not found"));

        Topping topping = new Topping();
        topping.setName(request.name);
        topping.setPrice(request.price);
        topping.setDescription(request.description);
        topping.setImage(request.image);
        topping.setStatus(ToppingStatus.AVAILABLE);
        topping.setRestaurant(restaurant);

        return toppingRepository.save(topping);
    }

    @Override
    public Topping updateTopping(Long id, ToppingUpdateRequest request) {
        Topping topping = getToppingById(id);

        if (request.name != null) topping.setName(request.name);
        if (request.price != null) topping.setPrice(request.price);
        if (request.description != null) topping.setDescription(request.description);
        if (request.image != null) topping.setImage(request.image);
        if (request.status != null) topping.setStatus(request.status);

        return toppingRepository.save(topping);
    }

    @Override
    public Topping updateStatus(Long id, ToppingStatus status) {
        Topping topping = getToppingById(id);
        topping.setStatus(status);
        return toppingRepository.save(topping);
    }

    @Override
    public void deleteTopping(Long id) {
        Topping topping = getToppingById(id);
        toppingRepository.delete(topping);
    }
}
