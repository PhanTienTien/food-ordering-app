package com.tientien.foodapp.review.service;

import com.tientien.foodapp.review.entity.Review;

import java.util.List;

public interface ReviewService {
    List<Review> getAllReviews();
    Review getReviewById(Long id);
    List<Review> getReviewsByUser(Long userId);
    List<Review> getReviewsByMenuItem(Long menuItemId);
    List<Review> getReviewsByRestaurant(Long restaurantId);
    Review createReview(ReviewCreateRequest request);
    Review updateReview(Long id, ReviewUpdateRequest request);
    void deleteReview(Long id);
    Double getAverageRatingForMenuItem(Long menuItemId);
    Double getAverageRatingForRestaurant(Long restaurantId);

    class ReviewCreateRequest {
        public Long userId;
        public Long orderId;
        public Integer rating;
        public String comment;
    }

    class ReviewUpdateRequest {
        public Integer rating;
        public String comment;
    }
}
