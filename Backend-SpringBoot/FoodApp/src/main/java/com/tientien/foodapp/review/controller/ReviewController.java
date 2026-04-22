package com.tientien.foodapp.review.controller;

import com.tientien.foodapp.review.entity.Review;
import com.tientien.foodapp.review.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @GetMapping
    public List<Review> getAllReviews() {
        return reviewService.getAllReviews();
    }

    @GetMapping("/{id}")
    public Review getReviewById(@PathVariable Long id) {
        return reviewService.getReviewById(id);
    }

    @GetMapping("/user/{userId}")
    public List<Review> getReviewsByUser(@PathVariable Long userId) {
        return reviewService.getReviewsByUser(userId);
    }

    @GetMapping("/menu-item/{menuItemId}")
    public List<Review> getReviewsByMenuItem(@PathVariable Long menuItemId) {
        return reviewService.getReviewsByMenuItem(menuItemId);
    }

    @GetMapping("/restaurant/{restaurantId}")
    public List<Review> getReviewsByRestaurant(@PathVariable Long restaurantId) {
        return reviewService.getReviewsByRestaurant(restaurantId);
    }

    @GetMapping("/menu-item/{menuItemId}/average-rating")
    public Double getAverageRatingForMenuItem(@PathVariable Long menuItemId) {
        return reviewService.getAverageRatingForMenuItem(menuItemId);
    }

    @GetMapping("/restaurant/{restaurantId}/average-rating")
    public Double getAverageRatingForRestaurant(@PathVariable Long restaurantId) {
        return reviewService.getAverageRatingForRestaurant(restaurantId);
    }

    @PostMapping
    public Review createReview(@RequestBody ReviewService.ReviewCreateRequest request) {
        return reviewService.createReview(request);
    }

    @PutMapping("/{id}")
    public Review updateReview(
            @PathVariable Long id,
            @RequestBody ReviewService.ReviewUpdateRequest request) {
        return reviewService.updateReview(id, request);
    }

    @DeleteMapping("/{id}")
    public void deleteReview(@PathVariable Long id) {
        reviewService.deleteReview(id);
    }
}
