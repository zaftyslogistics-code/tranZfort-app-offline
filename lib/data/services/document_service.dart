import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../database.dart';
import '../repositories/document_repository.dart';

class DocumentService {
  final DocumentRepository _repository;
  final Uuid _uuid = const Uuid();

  DocumentService(this._repository);

  // Get all documents
  Future<List<Document>> getAllDocuments() => _repository.getAllDocuments();

  // Get document by ID
  Future<Document?> getDocumentById(String id) => _repository.getDocumentById(id);

  // Create new document
  Future<void> createDocument({
    required String name,
    required String type,
    required String entityType,
    required String entityId,
    required String filePath,
    String? description,
    int? fileSize,
  }) async {
    // Validate document data
    if (!_repository.validateDocumentData(
      name: name,
      type: type,
      entityType: entityType,
      entityId: entityId,
      filePath: filePath,
    )) {
      throw Exception('Invalid document data');
    }

    final document = DocumentsCompanion.insert(
      id: _uuid.v4(),
      name: name,
      type: type,
      entityType: entityType,
      entityId: entityId,
      filePath: filePath,
      description: description ?? '',
      fileSize: fileSize ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.addDocument(document);
  }

  // Update document
  Future<void> updateDocument({
    required String id,
    String? name,
    String? type,
    String? entityType,
    String? entityId,
    String? filePath,
    String? description,
    int? fileSize,
  }) async {
    final existingDocument = await _repository.getDocumentById(id);
    if (existingDocument == null) {
      throw Exception('Document not found');
    }

    // Validate document data if provided
    if (name != null || type != null || entityType != null || entityId != null || filePath != null) {
      final nameToUse = name ?? existingDocument.name;
      final typeToUse = type ?? existingDocument.type;
      final entityTypeToUse = entityType ?? existingDocument.entityType;
      final entityIdToUse = entityId ?? existingDocument.entityId;
      final filePathToUse = filePath ?? existingDocument.filePath;

      if (!_repository.validateDocumentData(
        name: nameToUse,
        type: typeToUse,
        entityType: entityTypeToUse,
        entityId: entityIdToUse,
        filePath: filePathToUse,
      )) {
        throw Exception('Invalid document data');
      }
    }

    final updatedDocument = DocumentsCompanion(
      id: Value(id),
      name: Value(name ?? existingDocument.name),
      type: Value(type ?? existingDocument.type),
      entityType: Value(entityType ?? existingDocument.entityType),
      entityId: Value(entityId ?? existingDocument.entityId),
      filePath: Value(filePath ?? existingDocument.filePath),
      description: description != null ? Value(description) : Value(existingDocument.description),
      fileSize: fileSize != null ? Value(fileSize) : Value(existingDocument.fileSize),
      updatedAt: Value(DateTime.now()),
    );

    // Convert companion to document for update
    final documentToUpdate = await _repository.getDocumentById(id);
    if (documentToUpdate == null) {
      throw Exception('Document not found');
    }
    
    final updated = documentToUpdate.copyWith(
      name: name ?? documentToUpdate.name,
      type: type ?? documentToUpdate.type,
      entityType: entityType ?? documentToUpdate.entityType,
      entityId: entityId ?? documentToUpdate.entityId,
      filePath: filePath ?? documentToUpdate.filePath,
      description: description ?? documentToUpdate.description,
      fileSize: fileSize ?? documentToUpdate.fileSize,
      updatedAt: DateTime.now(),
    );
    
    await _repository.updateDocument(updated);
  }

  // Delete document
  Future<void> deleteDocument(String id) async {
    final document = await _repository.getDocumentById(id);
    if (document == null) {
      throw Exception('Document not found');
    }

    // Delete the actual file first
    await deleteFile(document.filePath);
    
    // Then delete the database record
    await _repository.deleteDocument(id);
    
    print('Document $id and its file deleted successfully');
  }

  // Get documents by entity
  Future<List<Document>> getDocumentsByEntity(String entityType, String entityId) =>
      _repository.getDocumentsByEntity(entityType, entityId);

  // Get documents by type
  Future<List<Document>> getDocumentsByType(String type) => _repository.getDocumentsByType(type);

  // Search documents
  Future<List<Document>> searchDocuments(String query) => _repository.searchDocuments(query);

  // Get unique document types
  Future<List<String>> getUniqueDocumentTypes() => _repository.getUniqueDocumentTypes();

  // Get document statistics
  Future<Map<String, int>> getDocumentStatistics() => _repository.getDocumentStatistics();

  // Get documents by entity type
  Future<List<Document>> getDocumentsByEntityType(String entityType) =>
      _repository.getDocumentsByEntityType(entityType);

  // Get recent documents
  Future<List<Document>> getRecentDocuments() => _repository.getRecentDocuments();

  // Get documents by date range
  Future<List<Document>> getDocumentsByDateRange(DateTime startDate, DateTime endDate) =>
      _repository.getDocumentsByDateRange(startDate, endDate);

  // Update document metadata
  Future<void> updateDocumentMetadata(String id, String name, String description) =>
      _repository.updateDocumentMetadata(id, name, description);

  // Get document types with predefined options
  List<String> getPredefinedDocumentTypes() {
    return [
      'VEHICLE_REGISTRATION',
      'VEHICLE_INSURANCE',
      'VEIVER_LICENSE',
      'DRIVER_LICENSE',
      'DRIVER_ID_PROOF',
      'PARTY_GST_CERTIFICATE',
      'PARTY_PAN_CARD',
      'PARTY_AADHAR_CARD',
      'TRIP_DOCUMENT',
      'EXPENSE_BILL',
      'PAYMENT_RECEIPT',
      'AGREEMENT',
      'PERMIT',
      'OTHER',
    ];
  }

  // Get entity types with predefined options
  List<String> getPredefinedEntityTypes() {
    return [
      'VEHICLE',
      'DRIVER',
      'PARTY',
      'TRIP',
      'EXPENSE',
      'PAYMENT',
      'OTHER',
    ];
  }

  // Validate document type
  bool isValidDocumentType(String type) {
    return getPredefinedDocumentTypes().contains(type);
  }

  // Validate entity type
  bool isValidEntityType(String entityType) {
    return getPredefinedEntityTypes().contains(entityType);
  }

  // Get document summary
  Future<Map<String, dynamic>> getDocumentSummary(String documentId) =>
      _repository.getDocumentSummary(documentId);

  // Get document type icon
  String getDocumentTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'VEHICLE_REGISTRATION':
        return 'directions_car';
      case 'VEHICLE_INSURANCE':
        return 'security';
      case 'DRIVER_LICENSE':
        return 'badge';
      case 'DRIVER_ID_PROOF':
        return 'person';
      case 'PARTY_GST_CERTIFICATE':
        return 'receipt';
      case 'PARTY_PAN_CARD':
        return 'credit_card';
      case 'PARTY_AADHAR_CARD':
        return 'fingerprint';
      case 'TRIP_DOCUMENT':
        return 'map';
      case 'EXPENSE_BILL':
        return 'receipt_long';
      case 'PAYMENT_RECEIPT':
        return 'account_balance_wallet';
      case 'AGREEMENT':
        return 'description';
      case 'PERMIT':
        return 'verified';
      default:
        return 'insert_drive_file';
    }
  }

  // Get entity type icon
  String getEntityTypeIcon(String entityType) {
    switch (entityType.toUpperCase()) {
      case 'VEHICLE':
        return 'local_shipping';
      case 'DRIVER':
        return 'people';
      case 'PARTY':
        return 'business';
      case 'TRIP':
        return 'directions';
      case 'EXPENSE':
        return 'receipt_long';
      case 'PAYMENT':
        return 'account_balance_wallet';
      default:
        return 'folder';
    }
  }

  // Format file size
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Check if document exists for entity
  Future<bool> hasDocumentForEntity(String entityType, String entityId, String documentType) =>
      _repository.hasDocumentForEntity(entityType, entityId, documentType);

  // Get documents for multiple entities
  Future<Map<String, List<Document>>> getDocumentsForEntities(
    List<String> entityIds,
    String entityType,
  ) => _repository.getDocumentsForEntities(entityIds, entityType);

  // Get document count by entity type
  Future<Map<String, int>> getDocumentCountByEntityType() => _repository.getDocumentCountByEntityType();

  // Generate document share text
  String generateDocumentShareText(Document document) {
    return '''
Document Information
==================
Name: ${document.name}
Type: ${document.type}
Entity: ${document.entityType} - ${document.entityId}
Description: ${document.description}
File Size: ${formatFileSize(document.fileSize)}
Created: ${document.createdAt.day}/${document.createdAt.month}/${document.createdAt.year}
==================
Shared from Tranzfort TMS
    ''';
  }

  // Get document performance metrics
  Future<Map<String, dynamic>> getDocumentPerformance(String entityType) async {
    final documents = await getDocumentsByEntityType(entityType);
    final totalSize = documents.fold<int>(0, (sum, doc) => sum + doc.fileSize);
    
    // Group by document type
    final typeBreakdown = <String, int>{};
    for (final document in documents) {
      typeBreakdown[document.type] = (typeBreakdown[document.type] ?? 0) + 1;
    }
    
    return {
      'totalDocuments': documents.length,
      'totalSize': totalSize,
      'averageSize': documents.isEmpty ? 0 : totalSize ~/ documents.length,
      'typeBreakdown': typeBreakdown,
      'mostRecentDocument': documents.isEmpty ? null : documents.first,
    };
  }

  // Validate file path
  bool isValidFilePath(String filePath) {
    // Basic validation - check if path is not empty and has valid extension
    if (filePath.isEmpty) return false;
    
    final validExtensions = ['.pdf', '.jpg', '.jpeg', '.png', '.doc', '.docx', '.xls', '.xlsx'];
    return validExtensions.any((ext) => filePath.toLowerCase().endsWith(ext));
  }

  // Get file extension from path
  String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  // Check if file is image
  bool isImageFile(String filePath) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
    return imageExtensions.contains(getFileExtension(filePath));
  }

  // Check if file is PDF
  bool isPdfFile(String filePath) {
    return getFileExtension(filePath) == 'pdf';
  }

  // Get document preview type
  String getDocumentPreviewType(String filePath) {
    if (isImageFile(filePath)) return 'IMAGE';
    if (isPdfFile(filePath)) return 'PDF';
    return 'OTHER';
  }

  // Save file to app documents directory
  Future<String> saveFile(String sourcePath, String fileName) async {
    try {
      // Validate source file exists
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('Source file does not exist: $sourcePath');
      }
      
      final appDir = await getApplicationDocumentsDirectory();
      final documentsDir = Directory(p.join(appDir.path, 'documents'));
      
      // Create documents directory if it doesn't exist
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }
      
      // Generate unique filename to avoid conflicts
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(fileName);
      final uniqueFileName = '${timestamp}_$fileName';
      final destinationPath = p.join(documentsDir.path, uniqueFileName);
      
      // Copy file to app documents directory
      await sourceFile.copy(destinationPath);
      
      print('Document saved to: $destinationPath');
      return destinationPath;
    } catch (e) {
      print('Error saving document: $e');
      rethrow;
    }
  }

  // Delete actual file from storage
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('Document file deleted: $filePath');
      }
    } catch (e) {
      print('Error deleting document file: $e');
      // Don't rethrow - we still want to delete the DB record
    }
  }

  // Check if document file exists and can be opened
  Future<bool> canOpenDocument(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      print('Error checking document file: $e');
      return false;
    }
  }

  // Get document file size
  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }
}
