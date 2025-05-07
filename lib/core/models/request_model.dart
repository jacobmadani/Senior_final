import 'package:mobile_project/core/models/request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestModel extends Request {
  RequestModel({
    required super.id,
    required super.recipientId,
    required super.title,
    required super.description,
    required super.category,
    required super.urgency,
    required super.location,
    required super.date,
    required super.status,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] as String,
      recipientId: map['recipient_id'] as String,
      title: map['title'] as String,
      description:
          map['details'] as String, // Updated to match the 'details' column
      category: map['category'] as String,
      urgency: map['urgency_level'] as String,
      location: map['location'] as String,
      date: DateTime.parse(map['created_at'] as String),
      status: map['status'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipient_id': Supabase.instance.client.auth.currentUser?.id,
      'title': title,
      'details': description,
      'category': category,
      'urgency_level': urgency,
      'location': location,
      'created_at': date.toIso8601String(),
      'status': status,
    };
  }
}
