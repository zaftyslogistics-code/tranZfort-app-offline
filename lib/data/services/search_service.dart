import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';
import '../repositories/expense_repository.dart';
import '../repositories/payment_repository.dart';
import '../repositories/document_repository.dart';
import '../repositories/trip_repository.dart';
import '../repositories/vehicle_repository.dart';
import '../repositories/driver_repository.dart';
import '../repositories/party_repository.dart';

class SearchService {
  final ExpenseRepository _expenseRepo;
  final PaymentRepository _paymentRepo;
  final DocumentRepository _documentRepo;
  final TripRepository _tripRepo;
  final VehicleRepository _vehicleRepo;
  final DriverRepository _driverRepo;
  final PartyRepository _partyRepo;

  SearchService(
    this._expenseRepo,
    this._paymentRepo,
    this._documentRepo,
    this._tripRepo,
    this._vehicleRepo,
    this._driverRepo,
    this._partyRepo,
  );

  // Search across all entities
  Future<List<SearchResult>> searchAll(String query) async {
    final results = <SearchResult>[];
    
    // Search expenses
    final expenses = await _expenseRepo.searchExpenses(query);
    results.addAll(expenses.map((expense) => SearchResult(
      id: expense.id,
      type: 'expense',
      title: expense.category,
      subtitle: '₹${expense.amount.toStringAsFixed(2)}',
      description: 'Expense: ${expense.category} - ₹${expense.amount.toStringAsFixed(2)}',
      metadata: {
        'category': expense.category,
        'amount': expense.amount,
        'paidMode': expense.paidMode,
        'createdAt': expense.createdAt?.toIso8601String(),
      },
    )));

    // Search payments
    final payments = await _paymentRepo.searchPayments(query);
    results.addAll(payments.map((payment) => SearchResult(
      id: payment.id,
      type: 'payment',
      title: payment.type,
      subtitle: '₹${payment.amount.toStringAsFixed(2)}',
      description: 'Payment: ${payment.type} - ₹${payment.amount.toStringAsFixed(2)}',
      metadata: {
        'type': payment.type,
        'amount': payment.amount,
        'mode': payment.mode,
        'createdAt': payment.createdAt?.toIso8601String(),
      },
    )));

    // Search documents
    final documents = await _documentRepo.searchDocuments(query);
    results.addAll(documents.map((document) => SearchResult(
      id: document.id,
      type: 'document',
      title: document.name,
      subtitle: document.type,
      description: 'Document: ${document.name} - ${document.type}',
      metadata: {
        'type': document.type,
        'entityType': document.entityType,
        'entityId': document.entityId,
        'fileSize': document.fileSize,
        'createdAt': document.createdAt?.toIso8601String(),
      },
    )));

    return results;
  }

  // Search with filters
  Future<List<SearchResult>> searchWithFilters(SearchFilters filters) async {
    final results = <SearchResult>[];

    if (filters.includeExpenses) {
      results.addAll(await _searchExpensesWithFilters(filters));
    }

    if (filters.includePayments) {
      results.addAll(await _searchPaymentsWithFilters(filters));
    }

    if (filters.includeDocuments) {
      results.addAll(await _searchDocumentsWithFilters(filters));
    }

    // Sort by relevance
    results.sort((a, b) {
      if (filters.query.isNotEmpty) {
        final aRelevance = _calculateRelevance(a, filters.query);
        final bRelevance = _calculateRelevance(b, filters.query);
        return bRelevance.compareTo(aRelevance);
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return results;
  }

  // Search expenses with filters
  Future<List<SearchResult>> _searchExpensesWithFilters(SearchFilters filters) async {
    final expenses = await _expenseRepo.getAllExpenses();
    final filteredExpenses = <Expense>[];

    for (final expense in expenses) {
      bool matches = true;

      // Text search
      if (filters.query.isNotEmpty) {
        final searchText = '${expense.category} ${expense.paidMode}'.toLowerCase();
        if (!searchText.contains(filters.query.toLowerCase())) {
          matches = false;
        }
      }

      // Category filter
      if (filters.expenseCategory != null && expense.category != filters.expenseCategory) {
        matches = false;
      }

      // Paid mode filter
      if (filters.expensePaidMode != null && expense.paidMode != filters.expensePaidMode) {
        matches = false;
      }

      // Amount range filter
      if (filters.minAmount != null && expense.amount < filters.minAmount!) {
        matches = false;
      }
      if (filters.maxAmount != null && expense.amount > filters.maxAmount!) {
        matches = false;
      }

      // Date range filter
      if (filters.startDate != null && expense.createdAt.isBefore(filters.startDate!)) {
        matches = false;
      }
      if (filters.endDate != null && expense.createdAt.isAfter(filters.endDate!)) {
        matches = false;
      }

      if (matches) {
        filteredExpenses.add(expense);
      }
    }

    return filteredExpenses.map((expense) => SearchResult(
      id: expense.id,
      type: 'expense',
      title: expense.category,
      subtitle: '₹${expense.amount.toStringAsFixed(2)}',
      description: 'Expense: ${expense.category} - ₹${expense.amount.toStringAsFixed(2)}',
      metadata: {
        'category': expense.category,
        'amount': expense.amount,
        'paidMode': expense.paidMode,
        'createdAt': expense.createdAt?.toIso8601String(),
      },
    )).toList();
  }

  // Search payments with filters
  Future<List<SearchResult>> _searchPaymentsWithFilters(SearchFilters filters) async {
    final payments = await _paymentRepo.getAllPayments();
    final filteredPayments = <Payment>[];

    for (final payment in payments) {
      bool matches = true;

      // Text search
      if (filters.query.isNotEmpty) {
        final searchText = '${payment.type} ${payment.mode}'.toLowerCase();
        if (!searchText.contains(filters.query.toLowerCase())) {
          matches = false;
        }
      }

      // Type filter
      if (filters.paymentType != null && payment.type != filters.paymentType) {
        matches = false;
      }

      // Mode filter
      if (filters.paymentMode != null && payment.mode != filters.paymentMode) {
        matches = false;
      }

      // Amount range filter
      if (filters.minAmount != null && payment.amount < filters.minAmount!) {
        matches = false;
      }
      if (filters.maxAmount != null && payment.amount > filters.maxAmount!) {
        matches = false;
      }

      // Date range filter
      if (filters.startDate != null && payment.createdAt.isBefore(filters.startDate!)) {
        matches = false;
      }
      if (filters.endDate != null && payment.createdAt.isAfter(filters.endDate!)) {
        matches = false;
      }

      if (matches) {
        filteredPayments.add(payment);
      }
    }

    return filteredPayments.map((payment) => SearchResult(
      id: payment.id,
      type: 'payment',
      title: payment.type,
      subtitle: '₹${payment.amount.toStringAsFixed(2)}',
      description: 'Payment: ${payment.type} - ₹${payment.amount.toStringAsFixed(2)}',
      metadata: {
        'type': payment.type,
        'amount': payment.amount,
        'mode': payment.mode,
        'createdAt': payment.createdAt?.toIso8601String(),
      },
    )).toList();
  }

  // Search documents with filters
  Future<List<SearchResult>> _searchDocumentsWithFilters(SearchFilters filters) async {
    final documents = await _documentRepo.getAllDocuments();
    final filteredDocuments = <Document>[];

    for (final document in documents) {
      bool matches = true;

      // Text search
      if (filters.query.isNotEmpty) {
        final searchText = '${document.name} ${document.type} ${document.description}'.toLowerCase();
        if (!searchText.contains(filters.query.toLowerCase())) {
          matches = false;
        }
      }

      // Type filter
      if (filters.documentType != null && document.type != filters.documentType) {
        matches = false;
      }

      // Entity type filter
      if (filters.entityType != null && document.entityType != filters.entityType) {
        matches = false;
      }

      // File size range filter
      if (filters.minFileSize != null && document.fileSize < filters.minFileSize!) {
        matches = false;
      }
      if (filters.maxFileSize != null && document.fileSize > filters.maxFileSize!) {
        matches = false;
      }

      // Date range filter
      if (filters.startDate != null && document.createdAt.isBefore(filters.startDate!)) {
        matches = false;
      }
      if (filters.endDate != null && document.createdAt.isAfter(filters.endDate!)) {
        matches = false;
      }

      if (matches) {
        filteredDocuments.add(document);
      }
    }

    return filteredDocuments.map((document) => SearchResult(
      id: document.id,
      type: 'document',
      title: document.name,
      subtitle: document.type,
      description: 'Document: ${document.name} - ${document.type}',
      metadata: {
        'type': document.type,
        'entityType': document.entityType,
        'entityId': document.entityId,
        'fileSize': document.fileSize,
        'createdAt': document.createdAt?.toIso8601String(),
      },
    )).toList();
  }

  // Calculate search relevance score
  int _calculateRelevance(SearchResult result, String query) {
    int score = 0;
    final queryLower = query.toLowerCase();
    
    // Title match
    if (result.title.toLowerCase().contains(queryLower)) {
      score += 10;
    }
    
    // Type match
    if (result.type.toLowerCase().contains(queryLower)) {
      score += 5;
    }
    
    // Description match
    if (result.description.toLowerCase().contains(queryLower)) {
      score += 3;
    }
    
    return score;
  }

  // Get search suggestions
  Future<List<String>> getSearchSuggestions(String query) async {
    if (query.length < 2) {
      return [];
    }

    final suggestions = <String>[];
    
    // Get expense categories
    final expenseCategories = await _expenseRepo.getUniqueCategories();
    suggestions.addAll(expenseCategories.where((cat) => cat.toLowerCase().contains(query.toLowerCase())));
    
    // Get payment types
    final paymentTypes = await _paymentRepo.getUniquePaymentTypes();
    suggestions.addAll(paymentTypes.where((type) => type.toLowerCase().contains(query.toLowerCase())));
    
    // Get payment modes
    final paymentModes = await _paymentRepo.getUniquePaymentModes();
    suggestions.addAll(paymentModes.where((mode) => mode.toLowerCase().contains(query.toLowerCase())));
    
    // Get document types
    final documentTypes = await _documentRepo.getUniqueDocumentTypes();
    suggestions.addAll(documentTypes.where((type) => type.toLowerCase().contains(query.toLowerCase())));
    
    return suggestions.take(10).toList();
  }
}

class SearchFilters {
  final String query;
  final bool includeExpenses;
  final bool includePayments;
  final bool includeDocuments;
  final String? expenseCategory;
  final String? expensePaidMode;
  final String? paymentType;
  final String? paymentMode;
  final String? documentType;
  final String? entityType;
  final double? minAmount;
  final double? maxAmount;
  final int? minFileSize;
  final int? maxFileSize;
  final DateTime? startDate;
  final DateTime? endDate;

  SearchFilters({
    required this.query,
    this.includeExpenses = true,
    this.includePayments = true,
    this.includeDocuments = true,
    this.expenseCategory,
    this.expensePaidMode,
    this.paymentType,
    this.paymentMode,
    this.documentType,
    this.entityType,
    this.minAmount,
    this.maxAmount,
    this.minFileSize,
    this.maxFileSize,
    this.startDate,
    this.endDate,
  });
}

class SearchResult {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String description;
  final Map<String, dynamic> metadata;

  SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.metadata,
  });

  DateTime get createdAt {
    final createdAtStr = metadata['createdAt'] as String?;
    return createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();
  }
}
