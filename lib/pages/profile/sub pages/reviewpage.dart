import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Sizes size = Sizes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Your Reviews',
          style: TextStyle(fontFamily: 'Regular'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('reviews')
            .where('userId', isEqualTo: _auth.currentUser?.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index].data() as Map<String, dynamic>;
              final reviewId = reviews[index].id;
              return _buildReviewCard(review, reviewId);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16),
          Text(
            'No reviews yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start reviewing your experiences!',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Regular',
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, String reviewId) {
    final rating = (review['rating'] ?? 0).toDouble();
    final type = review['type'] ?? 'event'; // event, turf, dining
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                      color: _getTypeColor(type),
                    ),
                  ),
                ),
                Spacer(),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, size: 20),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(fontFamily: 'Regular')),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontFamily: 'Regular',
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditReviewDialog(review, reviewId);
                    } else if (value == 'delete') {
                      _deleteReview(reviewId);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12),

            // Place name
            Text(
              review['placeName'] ?? 'Unknown Place',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            SizedBox(height: 8),

            // Rating stars
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
                SizedBox(width: 8),
                Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Regular',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Review text
            if (review['review'] != null && review['review'].toString().isNotEmpty)
              Text(
                review['review'],
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Regular',
                  color: Colors.grey.shade700,
                ),
              ),
            
            SizedBox(height: 12),

            // Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  _formatDate(review['createdAt']),
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Regular',
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'event':
        return Colors.blue;
      case 'turf':
        return Colors.green;
      case 'dining':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showEditReviewDialog(Map<String, dynamic> review, String reviewId) {
    final reviewController = TextEditingController(text: review['review']);
    double rating = (review['rating'] ?? 0).toDouble();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Review', style: TextStyle(fontFamily: 'Regular')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rating', style: TextStyle(fontFamily: 'Regular')),
                SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          rating = (index + 1).toDouble();
                        });
                      },
                      child: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: reviewController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write your review...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(fontFamily: 'Regular')),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firestore.collection('reviews').doc(reviewId).update({
                  'rating': rating,
                  'review': reviewController.text.trim(),
                  'updatedAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Review updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: blackColor),
              child: Text(
                'Update',
                style: TextStyle(fontFamily: 'Regular', color: whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteReview(String reviewId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Review', style: TextStyle(fontFamily: 'Regular')),
        content: Text(
          'Are you sure you want to delete this review?',
          style: TextStyle(fontFamily: 'Regular'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(fontFamily: 'Regular')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(fontFamily: 'Regular')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _firestore.collection('reviews').doc(reviewId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Review deleted'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}