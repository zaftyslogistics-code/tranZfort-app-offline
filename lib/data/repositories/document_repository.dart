import 'package:drift/drift.dart';
import '../database.dart';

part 'document_repository.g.dart';

@DriftAccessor(tables: [Documents])
class DocumentRepository extends DatabaseAccessor<AppDatabase> with _$DocumentRepositoryMixin {
  DocumentRepository(AppDatabase db) : super(db);

  // Get all documents
  Future<List<Document>> getAllDocuments() => select(documents).get();

  // Get document by ID
  Future<Document?> getDocumentById(String id) =>
      (select(documents)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Get documents by entity type and ID
  Future<List<Document>> getDocumentsByEntity(String entityType, String entityId) =>
      (select(documents)..where((tbl) => (tbl.entityType.equals(entityType) & tbl.entityId.equals(entityId))))
          .get();

  // Get documents by type
  Future<List<Document>> getDocumentsByType(String type) =>
      (select(documents)..where((tbl) => tbl.type.equals(type))).get();

  // Add new document
  Future<void> addDocument(DocumentsCompanion document) => into(documents).insert(document);

  // Update document
  Future<void> updateDocument(Document document) => update(documents).replace(document);

  // Delete document
  Future<void> deleteDocument(String id) =>
      (delete(documents)..where((tbl) => tbl.id.equals(id))).go();

  // Get documents by date range
  Future<List<Document>> getDocumentsByDateRange(DateTime startDate, DateTime endDate) =>
      (select(documents)
            ..where((tbl) => tbl.createdAt.isBetweenValues(startDate, endDate)))
          .get();

  // Search documents by name or description
  Future<List<Document>> searchDocuments(String query) => (select(documents)
        ..where((tbl) => tbl.name.contains(query) | tbl.description.contains(query)))
      .get();

  // Get document count by type
  Future<int> getDocumentCountByType(String type) async {
    final documentList = await (select(documents)..where((tbl) => tbl.type.equals(type))).get();
    return documentList.length;
  }

  // Get unique document types
  Future<List<String>> getUniqueDocumentTypes() async {
    final allDocuments = await getAllDocuments();
    final types = allDocuments.map((document) => document.type).toSet().toList();
    types.sort();
    return types;
  }

  // Get document statistics
  Future<Map<String, int>> getDocumentStatistics() async {
    final allDocuments = await getAllDocuments();
    final types = <String, int>{};
    
    for (final document in allDocuments) {
      types[document.type] = (types[document.type] ?? 0) + 1;
    }
    
    types['TOTAL'] = allDocuments.length;
    return types;
  }

  // Get documents by entity type
  Future<List<Document>> getDocumentsByEntityType(String entityType) =>
      (select(documents)..where((tbl) => tbl.entityType.equals(entityType))).get();

  // Get recent documents (last 7 days)
  Future<List<Document>> getRecentDocuments() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return (select(documents)
          ..where((tbl) => tbl.createdAt.isBiggerThanValue(sevenDaysAgo))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  // Update document metadata
  Future<void> updateDocumentMetadata(String id, String name, String description) async {
    final document = await getDocumentById(id);
    if (document != null) {
      await updateDocument(document.copyWith(
        name: name,
        description: description,
        updatedAt: DateTime.now(),
      ));
    }
  }

  // Validate document data
  bool validateDocumentData({
    required String name,
    required String type,
    required String entityType,
    required String entityId,
    required String filePath,
  }) {
    // Basic validation
    if (name.isEmpty) return false;
    if (type.isEmpty) return false;
    if (entityType.isEmpty) return false;
    if (entityId.isEmpty) return false;
    if (filePath.isEmpty) return false;

    return true;
  }

  // Get documents for multiple entities
  Future<Map<String, List<Document>>> getDocumentsForEntities(
    List<String> entityIds,
    String entityType,
  ) async {
    final results = <String, List<Document>>{};
    
    for (final entityId in entityIds) {
      final documents = await getDocumentsByEntity(entityType, entityId);
      results[entityId] = documents;
    }
    
    return results;
  }

  // Get document summary
  Future<Map<String, dynamic>> getDocumentSummary(String documentId) async {
    final document = await getDocumentById(documentId);
    if (document == null) {
      throw Exception('Document not found');
    }
    
    return {
      'id': document.id,
      'name': document.name,
      'type': document.type,
      'entityType': document.entityType,
      'entityId': document.entityId,
      'filePath': document.filePath,
      'description': document.description,
      'fileSize': document.fileSize,
      'createdAt': document.createdAt,
      'updatedAt': document.updatedAt,
      'formattedFileSize': _formatFileSize(document.fileSize),
      'formattedDate': '${document.createdAt.day}/${document.createdAt.month}/${document.createdAt.year}',
    };
  }

  // Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Check if document exists for entity
  Future<bool> hasDocumentForEntity(String entityType, String entityId, String documentType) async {
    final documents = await getDocumentsByEntity(entityType, entityId);
    return documents.any((doc) => doc.type == documentType);
  }

  // Get document count by entity type
  Future<Map<String, int>> getDocumentCountByEntityType() async {
    final allDocuments = await getAllDocuments();
    final counts = <String, int>{};
    
    for (final document in allDocuments) {
      counts[document.entityType] = (counts[document.entityType] ?? 0) + 1;
    }
    
    return counts;
  }
}
