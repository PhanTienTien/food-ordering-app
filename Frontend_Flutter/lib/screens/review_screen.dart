import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final int menuItemId;

  const ReviewScreen({required this.menuItemId, super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  final ReviewService _reviewService = ReviewService();
  List<Review> reviews = [];
  bool isLoading = true;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final loadedReviews = await _reviewService.getReviewsByMenuItem(
        widget.menuItemId,
      );
      final avgRating = await _reviewService.getAverageRating(
        widget.menuItemId,
      );
      setState(() {
        reviews = loadedReviews;
        averageRating = avgRating;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Đánh giá'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _RatingSummary(
                  averageRating: averageRating,
                  reviewCount: reviews.length,
                ),
                Expanded(
                  child: reviews.isEmpty
                      ? Center(child: Text('Chưa có đánh giá nào'))
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return _ReviewCard(review: reviews[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _RatingSummary extends StatelessWidget {
  final double averageRating;
  final int reviewCount;

  const _RatingSummary({
    required this.averageRating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < averageRating.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '$reviewCount',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('đánh giá'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.userName ?? 'Người dùng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (review.rating ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(review.comment ?? ''),
            SizedBox(height: 4),
            Text(
              review.createdAt ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
