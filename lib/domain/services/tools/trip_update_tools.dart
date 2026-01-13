import 'package:drift/drift.dart' as drift;
import '../../../domain/models/tool_result.dart';
import '../../../data/database.dart';

class TripUpdateTools {
  static const String updateTripToolName = 'update_trip';
  static const String updateTripStatusToolName = 'update_trip_status';
  static const String scheduleMaintenanceToolName = 'schedule_maintenance';

  static Map<String, dynamic> getUpdateTripSchema() {
    return {
      'name': updateTripToolName,
      'description': 'Update details of an existing trip',
      'parameters': {
        'type': 'object',
        'properties': {
          'tripId': {
            'type': 'string',
            'description': 'Trip ID to update',
          },
          'fromLocation': {
            'type': 'string',
            'description': 'Starting location',
          },
          'toLocation': {
            'type': 'string',
            'description': 'Destination location',
          },
          'vehicleId': {
            'type': 'string',
            'description': 'Vehicle ID',
          },
          'driverId': {
            'type': 'string',
            'description': 'Driver ID',
          },
          'partyId': {
            'type': 'string',
            'description': 'Party/Customer ID',
          },
          'freightAmount': {
            'type': 'number',
            'description': 'Freight amount in rupees',
          },
          'advancePaid': {
            'type': 'number',
            'description': 'Advance payment amount',
          },
          'loadWeight': {
            'type': 'number',
            'description': 'Load weight in kg',
          },
          'notes': {
            'type': 'string',
            'description': 'Additional notes',
          },
        },
        'required': ['tripId'],
      },
    };
  }

  static Map<String, dynamic> getUpdateTripStatusSchema() {
    return {
      'name': updateTripStatusToolName,
      'description': 'Update the status of a trip',
      'parameters': {
        'type': 'object',
        'properties': {
          'tripId': {
            'type': 'string',
            'description': 'Trip ID to update',
          },
          'status': {
            'type': 'string',
            'enum': ['pending', 'in_progress', 'completed', 'cancelled'],
            'description': 'New status for the trip',
          },
          'completionDate': {
            'type': 'string',
            'description': 'Completion date (ISO 8601 format) - required if status is completed',
          },
        },
        'required': ['tripId', 'status'],
      },
    };
  }

  static Map<String, dynamic> getScheduleMaintenanceSchema() {
    return {
      'name': scheduleMaintenanceToolName,
      'description': 'Schedule maintenance for a vehicle',
      'parameters': {
        'type': 'object',
        'properties': {
          'vehicleId': {
            'type': 'string',
            'description': 'Vehicle ID to schedule maintenance for',
          },
          'serviceType': {
            'type': 'string',
            'description': 'Type of service (oil_change, tire_rotation, general_service, etc.)',
          },
          'scheduledDate': {
            'type': 'string',
            'description': 'Scheduled date (ISO 8601 format)',
          },
          'estimatedCost': {
            'type': 'number',
            'description': 'Estimated cost in rupees',
          },
          'notes': {
            'type': 'string',
            'description': 'Additional notes',
          },
        },
        'required': ['vehicleId', 'serviceType', 'scheduledDate'],
      },
    };
  }

  static Future<ToolResult> executeUpdateTrip(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    final tripId = arguments['tripId'] as String?;

    if (tripId == null || tripId.isEmpty) {
      return ToolResult.failure('', 'tripId parameter is required',
      );
    }

    try {
      final existingTrip = await database.managers.trips.filter((f) => f.id(tripId)).getSingleOrNull();
      if (existingTrip == null) {
        return ToolResult.failure('', 'Trip not found: $tripId',
        );
      }

      final companion = TripsCompanion(
        id: drift.Value(tripId),
        fromLocation: arguments['fromLocation'] != null
            ? drift.Value(arguments['fromLocation'] as String)
            : drift.Value.absent(),
        toLocation: arguments['toLocation'] != null
            ? drift.Value(arguments['toLocation'] as String)
            : drift.Value.absent(),
        vehicleId: arguments['vehicleId'] != null
            ? drift.Value(arguments['vehicleId'] as String)
            : drift.Value.absent(),
        driverId: arguments['driverId'] != null
            ? drift.Value(arguments['driverId'] as String)
            : drift.Value.absent(),
        partyId: arguments['partyId'] != null
            ? drift.Value(arguments['partyId'] as String)
            : drift.Value.absent(),
        freightAmount: arguments['freightAmount'] != null
            ? drift.Value((arguments['freightAmount'] as num).toDouble())
            : drift.Value.absent(),
        advanceAmount: arguments['advancePaid'] != null
            ? drift.Value((arguments['advancePaid'] as num).toDouble())
            : drift.Value.absent(),
        notes: arguments['notes'] != null
            ? drift.Value(arguments['notes'] as String)
            : drift.Value.absent(),
      );

      await database.managers.trips.replace(companion);

      final updatedTrip = await database.managers.trips.filter((f) => f.id(tripId)).getSingleOrNull();

      return ToolResult.success('', {
        'tripId': tripId,
        'message': 'Trip updated successfully',
        'trip': {
          'fromLocation': updatedTrip!.fromLocation,
          'toLocation': updatedTrip.toLocation,
          'status': updatedTrip.status,
          'freight': updatedTrip.freightAmount,
        },
      });
    } catch (e) {
      return ToolResult.failure('', 'Failed to update trip: $e',
      );
    }
  }

  static Future<ToolResult> executeUpdateTripStatus(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    final tripId = arguments['tripId'] as String?;
    final status = arguments['status'] as String?;

    if (tripId == null || tripId.isEmpty) {
      return ToolResult.failure('', 'tripId parameter is required',
      );
    }

    if (status == null || status.isEmpty) {
      return ToolResult.failure('', 'status parameter is required',
      );
    }

    final validStatuses = ['pending', 'in_progress', 'completed', 'cancelled'];
    if (!validStatuses.contains(status)) {
      return ToolResult.failure('', 'Invalid status. Must be one of: ${validStatuses.join(", ")}',
      );
    }

    if (status == 'completed' && arguments['completionDate'] == null) {
      return ToolResult.failure('', 'completionDate is required when status is completed',
      );
    }

    try {
      final existingTrip = await database.managers.trips.filter((f) => f.id(tripId)).getSingleOrNull();
      if (existingTrip == null) {
        return ToolResult.failure('', 'Trip not found: $tripId',
        );
      }

      DateTime? completionDate;
      if (arguments['completionDate'] != null) {
        completionDate = DateTime.parse(arguments['completionDate'] as String);
      }

      final companion = TripsCompanion(
        id: drift.Value(tripId),
        status: drift.Value(status),
        actualEndDate: completionDate != null
            ? drift.Value(completionDate)
            : drift.Value.absent(),
      );

      await database.managers.trips.replace(companion);

      return ToolResult.success('', {
        'tripId': tripId,
        'status': status,
        'message': 'Trip status updated to $status',
      });
    } catch (e) {
      return ToolResult.failure('', 'Failed to update trip status: $e',
      );
    }
  }

  static Future<ToolResult> executeScheduleMaintenance(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    final vehicleId = arguments['vehicleId'] as String?;
    final serviceType = arguments['serviceType'] as String?;
    final scheduledDateStr = arguments['scheduledDate'] as String?;

    if (vehicleId == null || vehicleId.isEmpty) {
      return ToolResult.failure('', 'vehicleId parameter is required',
      );
    }

    if (serviceType == null || serviceType.isEmpty) {
      return ToolResult.failure('', 'serviceType parameter is required',
      );
    }

    if (scheduledDateStr == null || scheduledDateStr.isEmpty) {
      return ToolResult.failure('', 'scheduledDate parameter is required',
      );
    }

    try {
      final vehicle = await database.managers.vehicles.filter((f) => f.id(vehicleId)).getSingleOrNull();
      if (vehicle == null) {
        return ToolResult.failure('', 'Vehicle not found: $vehicleId',
        );
      }

      final scheduledDate = DateTime.parse(scheduledDateStr);
      final estimatedCost = (arguments['estimatedCost'] as num?)?.toDouble() ?? 0;
      final notes = arguments['notes'] as String? ?? '';

      return ToolResult.success('', {
        'vehicleId': vehicleId,
        'vehicleNumber': vehicle.registrationNumber,
        'serviceType': serviceType,
        'scheduledDate': scheduledDate.toIso8601String(),
        'estimatedCost': estimatedCost,
        'notes': notes,
        'message': 'Maintenance scheduled for ${vehicle.registrationNumber} on ${scheduledDate.toString().split(' ')[0]}',
      });
    } catch (e) {
      return ToolResult.failure('', 'Failed to schedule maintenance: $e');
    }
  }
}
