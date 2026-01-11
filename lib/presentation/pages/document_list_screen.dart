import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/document_provider.dart';
import '../providers/vehicle_provider.dart';
import '../providers/driver_provider.dart';
import '../providers/party_provider.dart';
import '../providers/trip_provider.dart';
import 'document_form_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';

class DocumentListScreen extends ConsumerWidget {
  const DocumentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'all':
                  // TODO: Show all documents
                  break;
                case 'by_type':
                  // TODO: Show type filter
                  break;
                case 'by_entity':
                  // TODO: Show entity filter
                  break;
                case 'recent':
                  // TODO: Show recent documents
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.list, size: 16),
                    SizedBox(width: 8),
                    Text('All Documents'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'by_type',
                child: Row(
                  children: [
                    Icon(Icons.category, size: 16),
                    SizedBox(width: 8),
                    Text('By Type'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'by_entity',
                child: Row(
                  children: [
                    Icon(Icons.folder, size: 16),
                    SizedBox(width: 8),
                    Text('By Entity'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'recent',
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16),
                    SizedBox(width: 8),
                    Text('Recent'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: documents.when(
        data: (documentList) => documentList.isEmpty
            ? _buildEmptyState(context)
            : _buildDocumentList(context, documentList),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DocumentFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppTheme.infoGradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.insert_drive_file,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No documents added yet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first document to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DocumentFormScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Document'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList(BuildContext context, List<Document> documents) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return _DocumentCard(document: document);
      },
    );
  }
}

class _DocumentCard extends ConsumerWidget {
  final Document document;

  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(documentServiceProvider);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              _getDocumentTypeColor(document.type).withOpacity(0.05),
            ],
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getDocumentTypeGradient(document.type),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getDocumentTypeIcon(document.type),
              color: Colors.white,
              size: 20,
            ),
          ),
          title: Text(
            document.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    _getEntityTypeIcon(document.entityType),
                    size: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${document.entityType} - ${document.entityId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.description,
                    size: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    document.type,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getDocumentTypeColor(document.type),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      service.getFileExtension(document.filePath).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                service.formatFileSize(document.fileSize),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                service.formatFileSize(document.fileSize),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      // TODO: View document
                      break;
                    case 'share':
                      // TODO: Share document
                      break;
                    case 'edit':
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DocumentFormScreen(document: document),
                        ),
                      );
                      break;
                    case 'delete':
                      _showDeleteDialog(context, ref);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 16),
                        const SizedBox(width: 8),
                        const Text('View'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 16),
                        const SizedBox(width: 8),
                        const Text('Share'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        const SizedBox(width: 8),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: AppTheme.dangerColor),
                        const SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppTheme.dangerColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            // TODO: Navigate to document details
          },
        ),
      ),
    );
  }

  Color _getDocumentTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'VEHICLE_REGISTRATION':
        return Colors.blue;
      case 'VEHICLE_INSURANCE':
        return Colors.green;
      case 'DRIVER_LICENSE':
        return Colors.purple;
      case 'DRIVER_ID_PROOF':
        return Colors.orange;
      case 'PARTY_GST_CERTIFICATE':
        return Colors.teal;
      case 'PARTY_PAN_CARD':
        return Colors.indigo;
      case 'PARTY_AADHAR_CARD':
        return Colors.red;
      case 'TRIP_DOCUMENT':
        return Colors.brown;
      case 'EXPENSE_BILL':
        return AppTheme.warningColor;
      case 'PAYMENT_RECEIPT':
        return AppTheme.successColor;
      case 'AGREEMENT':
        return Colors.pink;
      case 'PERMIT':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  List<Color> _getDocumentTypeGradient(String type) {
    switch (type.toUpperCase()) {
      case 'VEHICLE_REGISTRATION':
        return [Colors.blue.shade400, Colors.blue.shade300];
      case 'VEHICLE_INSURANCE':
        return [Colors.green.shade400, Colors.green.shade300];
      case 'DRIVER_LICENSE':
        return [Colors.purple.shade400, Colors.purple.shade300];
      case 'DRIVER_ID_PROOF':
        return [Colors.orange.shade400, Colors.orange.shade300];
      case 'PARTY_GST_CERTIFICATE':
        return [Colors.teal.shade400, Colors.teal.shade300];
      case 'PARTY_PAN_CARD':
        return [Colors.indigo.shade400, Colors.indigo.shade300];
      case 'PARTY_AADHAR_CARD':
        return [Colors.red.shade400, Colors.red.shade300];
      case 'TRIP_DOCUMENT':
        return [Colors.brown.shade400, Colors.brown.shade300];
      case 'EXPENSE_BILL':
        return AppTheme.warningGradient;
      case 'PAYMENT_RECEIPT':
        return AppTheme.successGradient;
      case 'AGREEMENT':
        return [Colors.pink.shade400, Colors.pink.shade300];
      case 'PERMIT':
        return [Colors.cyan.shade400, Colors.cyan.shade300];
      default:
        return [Colors.grey.shade400, Colors.grey.shade300];
    }
  }

  IconData _getDocumentTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'VEHICLE_REGISTRATION':
        return Icons.directions_car;
      case 'VEHICLE_INSURANCE':
        return Icons.security;
      case 'DRIVER_LICENSE':
        return Icons.badge;
      case 'DRIVER_ID_PROOF':
        return Icons.person;
      case 'PARTY_GST_CERTIFICATE':
        return Icons.receipt;
      case 'PARTY_PAN_CARD':
        return Icons.credit_card;
      case 'PARTY_AADHAR_CARD':
        return Icons.fingerprint;
      case 'TRIP_DOCUMENT':
        return Icons.map;
      case 'EXPENSE_BILL':
        return Icons.receipt_long;
      case 'PAYMENT_RECEIPT':
        return Icons.account_balance_wallet;
      case 'AGREEMENT':
        return Icons.description;
      case 'PERMIT':
        return Icons.verified;
      default:
        return Icons.insert_drive_file;
    }
  }

  IconData _getEntityTypeIcon(String entityType) {
    switch (entityType.toUpperCase()) {
      case 'VEHICLE':
        return Icons.local_shipping;
      case 'DRIVER':
        return Icons.people;
      case 'PARTY':
        return Icons.business;
      case 'TRIP':
        return Icons.directions;
      case 'EXPENSE':
        return Icons.receipt_long;
      case 'PAYMENT':
        return Icons.account_balance_wallet;
      default:
        return Icons.folder;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete this document?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(documentServiceProvider).deleteDocument(document.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
