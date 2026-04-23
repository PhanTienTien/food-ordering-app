package com.tientien.foodapp.review.service.impl;

import com.tientien.foodapp.common.exception.NotFoundException;
import com.tientien.foodapp.menuitems.entity.MenuItem;
import com.tientien.foodapp.menuitems.repository.MenuItemRepository;
import com.tientien.foodapp.order.entity.Order;
import com.tientien.foodapp.order.repository.OrderRepository;
import com.tientien.foodapp.restaurant.entity.Restaurant;
import com.tientien.foodapp.restaurant.repository.RestaurantRepository;
import com.tientien.foodapp.review.entity.Review;
import com.tientien.foodapp.review.repository.ReviewRepository;
import com.tientien.foodapp.review.service.ReviewService;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;
    private final MenuItemRepository menuItemRepository;
    private final RestaurantRepository restaurantRepository;

    @Override
    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }

    @Override
    public Review getReviewById(Long id) {
        return reviewRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Review not found"));
    }

    @Override
    public List<Review> getReviewsByUser(Long userId) {
        return reviewRepository.findByUserId(userId);
    }

    @Override
    public List<Review> getReviewsByMenuItem(Long menuItemId) {
        return reviewRepository.findByMenuItemId(menuItemId);
    }

    @Override
    public List<Review> getReviewsByRestaurant(Long restaurantId) {
        return reviewRepository.findByOrderRestaurantId(restaurantId);
    }

    @Override
    public Review createReview(ReviewCreateRequest request) {
        User user = userRepository.findById(request.userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        Order order = orderRepository.findById(request.orderId)
                .orElseThrow(() -> new NotFoundException("Order not found"));

        // Check if user already reviewed this order
        if (!reviewRepository.findByOrderId(request.orderId).isEmpty()) {
            throw new RuntimeException("Order already reviewed");
        }

        // Validate rating
        if (request.rating < 1 || request.rating > 5) {
            throw new RuntimeException("Rating must be between 1 and 5");
        }

        Review review = new Review();
        review.setUser(user);
        review.setOrder(order);
        review.setRating(request.rating);
        review.setComment(request.comment);

        return reviewRepository.save(review);
    }

    @Override
    public Review updateReview(Long id, ReviewUpdateRequest request) {
        Review review = getReviewById(id);

        if (request.rating != null) {
            if (request.rating < 1 || request.rating > 5) {
                throw new RuntimeException("Rating must be between 1 and 5");
            }
            review.setRating(request.rating);
        }

        if (request.comment != null) {
            review.setComment(request.comment);
        }

        return reviewRepository.save(review);
    }

    @Override
    public void deleteReview(Long id) {
        Review review = getReviewById(id);
        reviewRepository.delete(review);
    }

    @Override
    public Double getAverageRatingForMenuItem(Long menuItemId) {
        List<Review> reviews = reviewRepository.findByMenuItemId(menuItemId);
        if (reviews.isEmpty()) {
            return 0.0;
        }
        return reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
    }

    @Override
    public Double getAverageRatingForRestaurant(Long restaurantId) {
        List<Review> reviews = reviewRepository.findByOrderRestaurantId(restaurantId);
        if (reviews.isEmpty()) {
            return 0.0;
        }
        return reviews.stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
    }
}
