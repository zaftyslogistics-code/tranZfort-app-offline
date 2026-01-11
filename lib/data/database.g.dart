// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _truckNumberMeta =
      const VerificationMeta('truckNumber');
  @override
  late final GeneratedColumn<String> truckNumber = GeneratedColumn<String>(
      'truck_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _truckTypeMeta =
      const VerificationMeta('truckType');
  @override
  late final GeneratedColumn<String> truckType = GeneratedColumn<String>(
      'truck_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<double> capacity = GeneratedColumn<double>(
      'capacity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fuelTypeMeta =
      const VerificationMeta('fuelType');
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
      'fuel_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String> registrationNumber =
      GeneratedColumn<String>('registration_number', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _insuranceExpiryMeta =
      const VerificationMeta('insuranceExpiry');
  @override
  late final GeneratedColumn<DateTime> insuranceExpiry =
      GeneratedColumn<DateTime>('insurance_expiry', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _fitnessExpiryMeta =
      const VerificationMeta('fitnessExpiry');
  @override
  late final GeneratedColumn<DateTime> fitnessExpiry =
      GeneratedColumn<DateTime>('fitness_expiry', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _assignedDriverIdMeta =
      const VerificationMeta('assignedDriverId');
  @override
  late final GeneratedColumn<String> assignedDriverId = GeneratedColumn<String>(
      'assigned_driver_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentLocationMeta =
      const VerificationMeta('currentLocation');
  @override
  late final GeneratedColumn<String> currentLocation = GeneratedColumn<String>(
      'current_location', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalKmMeta =
      const VerificationMeta('totalKm');
  @override
  late final GeneratedColumn<double> totalKm = GeneratedColumn<double>(
      'total_km', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lastServiceDateMeta =
      const VerificationMeta('lastServiceDate');
  @override
  late final GeneratedColumn<DateTime> lastServiceDate =
      GeneratedColumn<DateTime>('last_service_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        truckNumber,
        truckType,
        capacity,
        fuelType,
        registrationNumber,
        insuranceExpiry,
        fitnessExpiry,
        assignedDriverId,
        status,
        currentLocation,
        totalKm,
        lastServiceDate,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(Insertable<Vehicle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('truck_number')) {
      context.handle(
          _truckNumberMeta,
          truckNumber.isAcceptableOrUnknown(
              data['truck_number']!, _truckNumberMeta));
    } else if (isInserting) {
      context.missing(_truckNumberMeta);
    }
    if (data.containsKey('truck_type')) {
      context.handle(_truckTypeMeta,
          truckType.isAcceptableOrUnknown(data['truck_type']!, _truckTypeMeta));
    } else if (isInserting) {
      context.missing(_truckTypeMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('fuel_type')) {
      context.handle(_fuelTypeMeta,
          fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta));
    } else if (isInserting) {
      context.missing(_fuelTypeMeta);
    }
    if (data.containsKey('registration_number')) {
      context.handle(
          _registrationNumberMeta,
          registrationNumber.isAcceptableOrUnknown(
              data['registration_number']!, _registrationNumberMeta));
    } else if (isInserting) {
      context.missing(_registrationNumberMeta);
    }
    if (data.containsKey('insurance_expiry')) {
      context.handle(
          _insuranceExpiryMeta,
          insuranceExpiry.isAcceptableOrUnknown(
              data['insurance_expiry']!, _insuranceExpiryMeta));
    }
    if (data.containsKey('fitness_expiry')) {
      context.handle(
          _fitnessExpiryMeta,
          fitnessExpiry.isAcceptableOrUnknown(
              data['fitness_expiry']!, _fitnessExpiryMeta));
    }
    if (data.containsKey('assigned_driver_id')) {
      context.handle(
          _assignedDriverIdMeta,
          assignedDriverId.isAcceptableOrUnknown(
              data['assigned_driver_id']!, _assignedDriverIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('current_location')) {
      context.handle(
          _currentLocationMeta,
          currentLocation.isAcceptableOrUnknown(
              data['current_location']!, _currentLocationMeta));
    }
    if (data.containsKey('total_km')) {
      context.handle(_totalKmMeta,
          totalKm.isAcceptableOrUnknown(data['total_km']!, _totalKmMeta));
    }
    if (data.containsKey('last_service_date')) {
      context.handle(
          _lastServiceDateMeta,
          lastServiceDate.isAcceptableOrUnknown(
              data['last_service_date']!, _lastServiceDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      truckNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}truck_number'])!,
      truckType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}truck_type'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}capacity'])!,
      fuelType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fuel_type'])!,
      registrationNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}registration_number'])!,
      insuranceExpiry: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}insurance_expiry']),
      fitnessExpiry: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fitness_expiry']),
      assignedDriverId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}assigned_driver_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      currentLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_location']),
      totalKm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_km']),
      lastServiceDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_service_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final String id;
  final String truckNumber;
  final String truckType;
  final double capacity;
  final String fuelType;
  final String registrationNumber;
  final DateTime? insuranceExpiry;
  final DateTime? fitnessExpiry;
  final String? assignedDriverId;
  final String status;
  final String? currentLocation;
  final double? totalKm;
  final DateTime? lastServiceDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Vehicle(
      {required this.id,
      required this.truckNumber,
      required this.truckType,
      required this.capacity,
      required this.fuelType,
      required this.registrationNumber,
      this.insuranceExpiry,
      this.fitnessExpiry,
      this.assignedDriverId,
      required this.status,
      this.currentLocation,
      this.totalKm,
      this.lastServiceDate,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['truck_number'] = Variable<String>(truckNumber);
    map['truck_type'] = Variable<String>(truckType);
    map['capacity'] = Variable<double>(capacity);
    map['fuel_type'] = Variable<String>(fuelType);
    map['registration_number'] = Variable<String>(registrationNumber);
    if (!nullToAbsent || insuranceExpiry != null) {
      map['insurance_expiry'] = Variable<DateTime>(insuranceExpiry);
    }
    if (!nullToAbsent || fitnessExpiry != null) {
      map['fitness_expiry'] = Variable<DateTime>(fitnessExpiry);
    }
    if (!nullToAbsent || assignedDriverId != null) {
      map['assigned_driver_id'] = Variable<String>(assignedDriverId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || currentLocation != null) {
      map['current_location'] = Variable<String>(currentLocation);
    }
    if (!nullToAbsent || totalKm != null) {
      map['total_km'] = Variable<double>(totalKm);
    }
    if (!nullToAbsent || lastServiceDate != null) {
      map['last_service_date'] = Variable<DateTime>(lastServiceDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      truckNumber: Value(truckNumber),
      truckType: Value(truckType),
      capacity: Value(capacity),
      fuelType: Value(fuelType),
      registrationNumber: Value(registrationNumber),
      insuranceExpiry: insuranceExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceExpiry),
      fitnessExpiry: fitnessExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(fitnessExpiry),
      assignedDriverId: assignedDriverId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedDriverId),
      status: Value(status),
      currentLocation: currentLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(currentLocation),
      totalKm: totalKm == null && nullToAbsent
          ? const Value.absent()
          : Value(totalKm),
      lastServiceDate: lastServiceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastServiceDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<String>(json['id']),
      truckNumber: serializer.fromJson<String>(json['truckNumber']),
      truckType: serializer.fromJson<String>(json['truckType']),
      capacity: serializer.fromJson<double>(json['capacity']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      registrationNumber:
          serializer.fromJson<String>(json['registrationNumber']),
      insuranceExpiry: serializer.fromJson<DateTime?>(json['insuranceExpiry']),
      fitnessExpiry: serializer.fromJson<DateTime?>(json['fitnessExpiry']),
      assignedDriverId: serializer.fromJson<String?>(json['assignedDriverId']),
      status: serializer.fromJson<String>(json['status']),
      currentLocation: serializer.fromJson<String?>(json['currentLocation']),
      totalKm: serializer.fromJson<double?>(json['totalKm']),
      lastServiceDate: serializer.fromJson<DateTime?>(json['lastServiceDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'truckNumber': serializer.toJson<String>(truckNumber),
      'truckType': serializer.toJson<String>(truckType),
      'capacity': serializer.toJson<double>(capacity),
      'fuelType': serializer.toJson<String>(fuelType),
      'registrationNumber': serializer.toJson<String>(registrationNumber),
      'insuranceExpiry': serializer.toJson<DateTime?>(insuranceExpiry),
      'fitnessExpiry': serializer.toJson<DateTime?>(fitnessExpiry),
      'assignedDriverId': serializer.toJson<String?>(assignedDriverId),
      'status': serializer.toJson<String>(status),
      'currentLocation': serializer.toJson<String?>(currentLocation),
      'totalKm': serializer.toJson<double?>(totalKm),
      'lastServiceDate': serializer.toJson<DateTime?>(lastServiceDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Vehicle copyWith(
          {String? id,
          String? truckNumber,
          String? truckType,
          double? capacity,
          String? fuelType,
          String? registrationNumber,
          Value<DateTime?> insuranceExpiry = const Value.absent(),
          Value<DateTime?> fitnessExpiry = const Value.absent(),
          Value<String?> assignedDriverId = const Value.absent(),
          String? status,
          Value<String?> currentLocation = const Value.absent(),
          Value<double?> totalKm = const Value.absent(),
          Value<DateTime?> lastServiceDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Vehicle(
        id: id ?? this.id,
        truckNumber: truckNumber ?? this.truckNumber,
        truckType: truckType ?? this.truckType,
        capacity: capacity ?? this.capacity,
        fuelType: fuelType ?? this.fuelType,
        registrationNumber: registrationNumber ?? this.registrationNumber,
        insuranceExpiry: insuranceExpiry.present
            ? insuranceExpiry.value
            : this.insuranceExpiry,
        fitnessExpiry:
            fitnessExpiry.present ? fitnessExpiry.value : this.fitnessExpiry,
        assignedDriverId: assignedDriverId.present
            ? assignedDriverId.value
            : this.assignedDriverId,
        status: status ?? this.status,
        currentLocation: currentLocation.present
            ? currentLocation.value
            : this.currentLocation,
        totalKm: totalKm.present ? totalKm.value : this.totalKm,
        lastServiceDate: lastServiceDate.present
            ? lastServiceDate.value
            : this.lastServiceDate,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      truckNumber:
          data.truckNumber.present ? data.truckNumber.value : this.truckNumber,
      truckType: data.truckType.present ? data.truckType.value : this.truckType,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      registrationNumber: data.registrationNumber.present
          ? data.registrationNumber.value
          : this.registrationNumber,
      insuranceExpiry: data.insuranceExpiry.present
          ? data.insuranceExpiry.value
          : this.insuranceExpiry,
      fitnessExpiry: data.fitnessExpiry.present
          ? data.fitnessExpiry.value
          : this.fitnessExpiry,
      assignedDriverId: data.assignedDriverId.present
          ? data.assignedDriverId.value
          : this.assignedDriverId,
      status: data.status.present ? data.status.value : this.status,
      currentLocation: data.currentLocation.present
          ? data.currentLocation.value
          : this.currentLocation,
      totalKm: data.totalKm.present ? data.totalKm.value : this.totalKm,
      lastServiceDate: data.lastServiceDate.present
          ? data.lastServiceDate.value
          : this.lastServiceDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('truckNumber: $truckNumber, ')
          ..write('truckType: $truckType, ')
          ..write('capacity: $capacity, ')
          ..write('fuelType: $fuelType, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('insuranceExpiry: $insuranceExpiry, ')
          ..write('fitnessExpiry: $fitnessExpiry, ')
          ..write('assignedDriverId: $assignedDriverId, ')
          ..write('status: $status, ')
          ..write('currentLocation: $currentLocation, ')
          ..write('totalKm: $totalKm, ')
          ..write('lastServiceDate: $lastServiceDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      truckNumber,
      truckType,
      capacity,
      fuelType,
      registrationNumber,
      insuranceExpiry,
      fitnessExpiry,
      assignedDriverId,
      status,
      currentLocation,
      totalKm,
      lastServiceDate,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.truckNumber == this.truckNumber &&
          other.truckType == this.truckType &&
          other.capacity == this.capacity &&
          other.fuelType == this.fuelType &&
          other.registrationNumber == this.registrationNumber &&
          other.insuranceExpiry == this.insuranceExpiry &&
          other.fitnessExpiry == this.fitnessExpiry &&
          other.assignedDriverId == this.assignedDriverId &&
          other.status == this.status &&
          other.currentLocation == this.currentLocation &&
          other.totalKm == this.totalKm &&
          other.lastServiceDate == this.lastServiceDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<String> id;
  final Value<String> truckNumber;
  final Value<String> truckType;
  final Value<double> capacity;
  final Value<String> fuelType;
  final Value<String> registrationNumber;
  final Value<DateTime?> insuranceExpiry;
  final Value<DateTime?> fitnessExpiry;
  final Value<String?> assignedDriverId;
  final Value<String> status;
  final Value<String?> currentLocation;
  final Value<double?> totalKm;
  final Value<DateTime?> lastServiceDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.truckNumber = const Value.absent(),
    this.truckType = const Value.absent(),
    this.capacity = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.insuranceExpiry = const Value.absent(),
    this.fitnessExpiry = const Value.absent(),
    this.assignedDriverId = const Value.absent(),
    this.status = const Value.absent(),
    this.currentLocation = const Value.absent(),
    this.totalKm = const Value.absent(),
    this.lastServiceDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required String truckNumber,
    required String truckType,
    required double capacity,
    required String fuelType,
    required String registrationNumber,
    this.insuranceExpiry = const Value.absent(),
    this.fitnessExpiry = const Value.absent(),
    this.assignedDriverId = const Value.absent(),
    required String status,
    this.currentLocation = const Value.absent(),
    this.totalKm = const Value.absent(),
    this.lastServiceDate = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        truckNumber = Value(truckNumber),
        truckType = Value(truckType),
        capacity = Value(capacity),
        fuelType = Value(fuelType),
        registrationNumber = Value(registrationNumber),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Vehicle> custom({
    Expression<String>? id,
    Expression<String>? truckNumber,
    Expression<String>? truckType,
    Expression<double>? capacity,
    Expression<String>? fuelType,
    Expression<String>? registrationNumber,
    Expression<DateTime>? insuranceExpiry,
    Expression<DateTime>? fitnessExpiry,
    Expression<String>? assignedDriverId,
    Expression<String>? status,
    Expression<String>? currentLocation,
    Expression<double>? totalKm,
    Expression<DateTime>? lastServiceDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (truckNumber != null) 'truck_number': truckNumber,
      if (truckType != null) 'truck_type': truckType,
      if (capacity != null) 'capacity': capacity,
      if (fuelType != null) 'fuel_type': fuelType,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (insuranceExpiry != null) 'insurance_expiry': insuranceExpiry,
      if (fitnessExpiry != null) 'fitness_expiry': fitnessExpiry,
      if (assignedDriverId != null) 'assigned_driver_id': assignedDriverId,
      if (status != null) 'status': status,
      if (currentLocation != null) 'current_location': currentLocation,
      if (totalKm != null) 'total_km': totalKm,
      if (lastServiceDate != null) 'last_service_date': lastServiceDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith(
      {Value<String>? id,
      Value<String>? truckNumber,
      Value<String>? truckType,
      Value<double>? capacity,
      Value<String>? fuelType,
      Value<String>? registrationNumber,
      Value<DateTime?>? insuranceExpiry,
      Value<DateTime?>? fitnessExpiry,
      Value<String?>? assignedDriverId,
      Value<String>? status,
      Value<String?>? currentLocation,
      Value<double?>? totalKm,
      Value<DateTime?>? lastServiceDate,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return VehiclesCompanion(
      id: id ?? this.id,
      truckNumber: truckNumber ?? this.truckNumber,
      truckType: truckType ?? this.truckType,
      capacity: capacity ?? this.capacity,
      fuelType: fuelType ?? this.fuelType,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      fitnessExpiry: fitnessExpiry ?? this.fitnessExpiry,
      assignedDriverId: assignedDriverId ?? this.assignedDriverId,
      status: status ?? this.status,
      currentLocation: currentLocation ?? this.currentLocation,
      totalKm: totalKm ?? this.totalKm,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (truckNumber.present) {
      map['truck_number'] = Variable<String>(truckNumber.value);
    }
    if (truckType.present) {
      map['truck_type'] = Variable<String>(truckType.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<double>(capacity.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String>(registrationNumber.value);
    }
    if (insuranceExpiry.present) {
      map['insurance_expiry'] = Variable<DateTime>(insuranceExpiry.value);
    }
    if (fitnessExpiry.present) {
      map['fitness_expiry'] = Variable<DateTime>(fitnessExpiry.value);
    }
    if (assignedDriverId.present) {
      map['assigned_driver_id'] = Variable<String>(assignedDriverId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currentLocation.present) {
      map['current_location'] = Variable<String>(currentLocation.value);
    }
    if (totalKm.present) {
      map['total_km'] = Variable<double>(totalKm.value);
    }
    if (lastServiceDate.present) {
      map['last_service_date'] = Variable<DateTime>(lastServiceDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('truckNumber: $truckNumber, ')
          ..write('truckType: $truckType, ')
          ..write('capacity: $capacity, ')
          ..write('fuelType: $fuelType, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('insuranceExpiry: $insuranceExpiry, ')
          ..write('fitnessExpiry: $fitnessExpiry, ')
          ..write('assignedDriverId: $assignedDriverId, ')
          ..write('status: $status, ')
          ..write('currentLocation: $currentLocation, ')
          ..write('totalKm: $totalKm, ')
          ..write('lastServiceDate: $lastServiceDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DriversTable extends Drivers with TableInfo<$DriversTable, Driver> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _licenseNumberMeta =
      const VerificationMeta('licenseNumber');
  @override
  late final GeneratedColumn<String> licenseNumber = GeneratedColumn<String>(
      'license_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _licenseTypeMeta =
      const VerificationMeta('licenseType');
  @override
  late final GeneratedColumn<String> licenseType = GeneratedColumn<String>(
      'license_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _licenseExpiryMeta =
      const VerificationMeta('licenseExpiry');
  @override
  late final GeneratedColumn<DateTime> licenseExpiry =
      GeneratedColumn<DateTime>('license_expiry', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emergencyContactMeta =
      const VerificationMeta('emergencyContact');
  @override
  late final GeneratedColumn<String> emergencyContact = GeneratedColumn<String>(
      'emergency_contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        licenseNumber,
        licenseType,
        licenseExpiry,
        address,
        emergencyContact,
        status,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drivers';
  @override
  VerificationContext validateIntegrity(Insertable<Driver> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('license_number')) {
      context.handle(
          _licenseNumberMeta,
          licenseNumber.isAcceptableOrUnknown(
              data['license_number']!, _licenseNumberMeta));
    } else if (isInserting) {
      context.missing(_licenseNumberMeta);
    }
    if (data.containsKey('license_type')) {
      context.handle(
          _licenseTypeMeta,
          licenseType.isAcceptableOrUnknown(
              data['license_type']!, _licenseTypeMeta));
    } else if (isInserting) {
      context.missing(_licenseTypeMeta);
    }
    if (data.containsKey('license_expiry')) {
      context.handle(
          _licenseExpiryMeta,
          licenseExpiry.isAcceptableOrUnknown(
              data['license_expiry']!, _licenseExpiryMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('emergency_contact')) {
      context.handle(
          _emergencyContactMeta,
          emergencyContact.isAcceptableOrUnknown(
              data['emergency_contact']!, _emergencyContactMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Driver map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Driver(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      licenseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license_number'])!,
      licenseType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license_type'])!,
      licenseExpiry: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}license_expiry']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      emergencyContact: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}emergency_contact']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DriversTable createAlias(String alias) {
    return $DriversTable(attachedDatabase, alias);
  }
}

class Driver extends DataClass implements Insertable<Driver> {
  final String id;
  final String name;
  final String phone;
  final String licenseNumber;
  final String licenseType;
  final DateTime? licenseExpiry;
  final String? address;
  final String? emergencyContact;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Driver(
      {required this.id,
      required this.name,
      required this.phone,
      required this.licenseNumber,
      required this.licenseType,
      this.licenseExpiry,
      this.address,
      this.emergencyContact,
      required this.status,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['license_number'] = Variable<String>(licenseNumber);
    map['license_type'] = Variable<String>(licenseType);
    if (!nullToAbsent || licenseExpiry != null) {
      map['license_expiry'] = Variable<DateTime>(licenseExpiry);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || emergencyContact != null) {
      map['emergency_contact'] = Variable<String>(emergencyContact);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DriversCompanion toCompanion(bool nullToAbsent) {
    return DriversCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      licenseNumber: Value(licenseNumber),
      licenseType: Value(licenseType),
      licenseExpiry: licenseExpiry == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseExpiry),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      emergencyContact: emergencyContact == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContact),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Driver(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      licenseNumber: serializer.fromJson<String>(json['licenseNumber']),
      licenseType: serializer.fromJson<String>(json['licenseType']),
      licenseExpiry: serializer.fromJson<DateTime?>(json['licenseExpiry']),
      address: serializer.fromJson<String?>(json['address']),
      emergencyContact: serializer.fromJson<String?>(json['emergencyContact']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'licenseNumber': serializer.toJson<String>(licenseNumber),
      'licenseType': serializer.toJson<String>(licenseType),
      'licenseExpiry': serializer.toJson<DateTime?>(licenseExpiry),
      'address': serializer.toJson<String?>(address),
      'emergencyContact': serializer.toJson<String?>(emergencyContact),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Driver copyWith(
          {String? id,
          String? name,
          String? phone,
          String? licenseNumber,
          String? licenseType,
          Value<DateTime?> licenseExpiry = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> emergencyContact = const Value.absent(),
          String? status,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Driver(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        licenseNumber: licenseNumber ?? this.licenseNumber,
        licenseType: licenseType ?? this.licenseType,
        licenseExpiry:
            licenseExpiry.present ? licenseExpiry.value : this.licenseExpiry,
        address: address.present ? address.value : this.address,
        emergencyContact: emergencyContact.present
            ? emergencyContact.value
            : this.emergencyContact,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Driver copyWithCompanion(DriversCompanion data) {
    return Driver(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      licenseNumber: data.licenseNumber.present
          ? data.licenseNumber.value
          : this.licenseNumber,
      licenseType:
          data.licenseType.present ? data.licenseType.value : this.licenseType,
      licenseExpiry: data.licenseExpiry.present
          ? data.licenseExpiry.value
          : this.licenseExpiry,
      address: data.address.present ? data.address.value : this.address,
      emergencyContact: data.emergencyContact.present
          ? data.emergencyContact.value
          : this.emergencyContact,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Driver(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('licenseType: $licenseType, ')
          ..write('licenseExpiry: $licenseExpiry, ')
          ..write('address: $address, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      phone,
      licenseNumber,
      licenseType,
      licenseExpiry,
      address,
      emergencyContact,
      status,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Driver &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.licenseNumber == this.licenseNumber &&
          other.licenseType == this.licenseType &&
          other.licenseExpiry == this.licenseExpiry &&
          other.address == this.address &&
          other.emergencyContact == this.emergencyContact &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DriversCompanion extends UpdateCompanion<Driver> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> licenseNumber;
  final Value<String> licenseType;
  final Value<DateTime?> licenseExpiry;
  final Value<String?> address;
  final Value<String?> emergencyContact;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DriversCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.licenseNumber = const Value.absent(),
    this.licenseType = const Value.absent(),
    this.licenseExpiry = const Value.absent(),
    this.address = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriversCompanion.insert({
    required String id,
    required String name,
    required String phone,
    required String licenseNumber,
    required String licenseType,
    this.licenseExpiry = const Value.absent(),
    this.address = const Value.absent(),
    this.emergencyContact = const Value.absent(),
    required String status,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        phone = Value(phone),
        licenseNumber = Value(licenseNumber),
        licenseType = Value(licenseType),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Driver> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? licenseNumber,
    Expression<String>? licenseType,
    Expression<DateTime>? licenseExpiry,
    Expression<String>? address,
    Expression<String>? emergencyContact,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (licenseType != null) 'license_type': licenseType,
      if (licenseExpiry != null) 'license_expiry': licenseExpiry,
      if (address != null) 'address': address,
      if (emergencyContact != null) 'emergency_contact': emergencyContact,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriversCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? phone,
      Value<String>? licenseNumber,
      Value<String>? licenseType,
      Value<DateTime?>? licenseExpiry,
      Value<String?>? address,
      Value<String?>? emergencyContact,
      Value<String>? status,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DriversCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseType: licenseType ?? this.licenseType,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (licenseNumber.present) {
      map['license_number'] = Variable<String>(licenseNumber.value);
    }
    if (licenseType.present) {
      map['license_type'] = Variable<String>(licenseType.value);
    }
    if (licenseExpiry.present) {
      map['license_expiry'] = Variable<DateTime>(licenseExpiry.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (emergencyContact.present) {
      map['emergency_contact'] = Variable<String>(emergencyContact.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriversCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('licenseType: $licenseType, ')
          ..write('licenseExpiry: $licenseExpiry, ')
          ..write('address: $address, ')
          ..write('emergencyContact: $emergencyContact, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartiesTable extends Parties with TableInfo<$PartiesTable, Party> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
      'mobile', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gstMeta = const VerificationMeta('gst');
  @override
  late final GeneratedColumn<String> gst = GeneratedColumn<String>(
      'gst', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, mobile, city, gst, notes, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parties';
  @override
  VerificationContext validateIntegrity(Insertable<Party> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mobile')) {
      context.handle(_mobileMeta,
          mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta));
    } else if (isInserting) {
      context.missing(_mobileMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('gst')) {
      context.handle(
          _gstMeta, gst.isAcceptableOrUnknown(data['gst']!, _gstMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Party map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Party(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      gst: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gst']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PartiesTable createAlias(String alias) {
    return $PartiesTable(attachedDatabase, alias);
  }
}

class Party extends DataClass implements Insertable<Party> {
  final String id;
  final String name;
  final String mobile;
  final String city;
  final String? gst;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Party(
      {required this.id,
      required this.name,
      required this.mobile,
      required this.city,
      this.gst,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['mobile'] = Variable<String>(mobile);
    map['city'] = Variable<String>(city);
    if (!nullToAbsent || gst != null) {
      map['gst'] = Variable<String>(gst);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PartiesCompanion toCompanion(bool nullToAbsent) {
    return PartiesCompanion(
      id: Value(id),
      name: Value(name),
      mobile: Value(mobile),
      city: Value(city),
      gst: gst == null && nullToAbsent ? const Value.absent() : Value(gst),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Party.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Party(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mobile: serializer.fromJson<String>(json['mobile']),
      city: serializer.fromJson<String>(json['city']),
      gst: serializer.fromJson<String?>(json['gst']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'mobile': serializer.toJson<String>(mobile),
      'city': serializer.toJson<String>(city),
      'gst': serializer.toJson<String?>(gst),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Party copyWith(
          {String? id,
          String? name,
          String? mobile,
          String? city,
          Value<String?> gst = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Party(
        id: id ?? this.id,
        name: name ?? this.name,
        mobile: mobile ?? this.mobile,
        city: city ?? this.city,
        gst: gst.present ? gst.value : this.gst,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Party copyWithCompanion(PartiesCompanion data) {
    return Party(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      city: data.city.present ? data.city.value : this.city,
      gst: data.gst.present ? data.gst.value : this.gst,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Party(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mobile: $mobile, ')
          ..write('city: $city, ')
          ..write('gst: $gst, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, mobile, city, gst, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Party &&
          other.id == this.id &&
          other.name == this.name &&
          other.mobile == this.mobile &&
          other.city == this.city &&
          other.gst == this.gst &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartiesCompanion extends UpdateCompanion<Party> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> mobile;
  final Value<String> city;
  final Value<String?> gst;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PartiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mobile = const Value.absent(),
    this.city = const Value.absent(),
    this.gst = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartiesCompanion.insert({
    required String id,
    required String name,
    required String mobile,
    required String city,
    this.gst = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        mobile = Value(mobile),
        city = Value(city),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Party> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? mobile,
    Expression<String>? city,
    Expression<String>? gst,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mobile != null) 'mobile': mobile,
      if (city != null) 'city': city,
      if (gst != null) 'gst': gst,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? mobile,
      Value<String>? city,
      Value<String?>? gst,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PartiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      city: city ?? this.city,
      gst: gst ?? this.gst,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (gst.present) {
      map['gst'] = Variable<String>(gst.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mobile: $mobile, ')
          ..write('city: $city, ')
          ..write('gst: $gst, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromLocationMeta =
      const VerificationMeta('fromLocation');
  @override
  late final GeneratedColumn<String> fromLocation = GeneratedColumn<String>(
      'from_location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toLocationMeta =
      const VerificationMeta('toLocation');
  @override
  late final GeneratedColumn<String> toLocation = GeneratedColumn<String>(
      'to_location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vehicleIdMeta =
      const VerificationMeta('vehicleId');
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
      'vehicle_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _driverIdMeta =
      const VerificationMeta('driverId');
  @override
  late final GeneratedColumn<String> driverId = GeneratedColumn<String>(
      'driver_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partyIdMeta =
      const VerificationMeta('partyId');
  @override
  late final GeneratedColumn<String> partyId = GeneratedColumn<String>(
      'party_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _freightAmountMeta =
      const VerificationMeta('freightAmount');
  @override
  late final GeneratedColumn<double> freightAmount = GeneratedColumn<double>(
      'freight_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _advanceAmountMeta =
      const VerificationMeta('advanceAmount');
  @override
  late final GeneratedColumn<double> advanceAmount = GeneratedColumn<double>(
      'advance_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expectedEndDateMeta =
      const VerificationMeta('expectedEndDate');
  @override
  late final GeneratedColumn<DateTime> expectedEndDate =
      GeneratedColumn<DateTime>('expected_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _actualEndDateMeta =
      const VerificationMeta('actualEndDate');
  @override
  late final GeneratedColumn<DateTime> actualEndDate =
      GeneratedColumn<DateTime>('actual_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fromLocation,
        toLocation,
        vehicleId,
        driverId,
        partyId,
        freightAmount,
        advanceAmount,
        status,
        startDate,
        expectedEndDate,
        actualEndDate,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(Insertable<Trip> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_location')) {
      context.handle(
          _fromLocationMeta,
          fromLocation.isAcceptableOrUnknown(
              data['from_location']!, _fromLocationMeta));
    } else if (isInserting) {
      context.missing(_fromLocationMeta);
    }
    if (data.containsKey('to_location')) {
      context.handle(
          _toLocationMeta,
          toLocation.isAcceptableOrUnknown(
              data['to_location']!, _toLocationMeta));
    } else if (isInserting) {
      context.missing(_toLocationMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(_vehicleIdMeta,
          vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta));
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('driver_id')) {
      context.handle(_driverIdMeta,
          driverId.isAcceptableOrUnknown(data['driver_id']!, _driverIdMeta));
    } else if (isInserting) {
      context.missing(_driverIdMeta);
    }
    if (data.containsKey('party_id')) {
      context.handle(_partyIdMeta,
          partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta));
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('freight_amount')) {
      context.handle(
          _freightAmountMeta,
          freightAmount.isAcceptableOrUnknown(
              data['freight_amount']!, _freightAmountMeta));
    } else if (isInserting) {
      context.missing(_freightAmountMeta);
    }
    if (data.containsKey('advance_amount')) {
      context.handle(
          _advanceAmountMeta,
          advanceAmount.isAcceptableOrUnknown(
              data['advance_amount']!, _advanceAmountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('expected_end_date')) {
      context.handle(
          _expectedEndDateMeta,
          expectedEndDate.isAcceptableOrUnknown(
              data['expected_end_date']!, _expectedEndDateMeta));
    }
    if (data.containsKey('actual_end_date')) {
      context.handle(
          _actualEndDateMeta,
          actualEndDate.isAcceptableOrUnknown(
              data['actual_end_date']!, _actualEndDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fromLocation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_location'])!,
      toLocation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_location'])!,
      vehicleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vehicle_id'])!,
      driverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}driver_id'])!,
      partyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}party_id'])!,
      freightAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}freight_amount'])!,
      advanceAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}advance_amount']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      expectedEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}expected_end_date']),
      actualEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}actual_end_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final String id;
  final String fromLocation;
  final String toLocation;
  final String vehicleId;
  final String driverId;
  final String partyId;
  final double freightAmount;
  final double? advanceAmount;
  final String status;
  final DateTime startDate;
  final DateTime? expectedEndDate;
  final DateTime? actualEndDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Trip(
      {required this.id,
      required this.fromLocation,
      required this.toLocation,
      required this.vehicleId,
      required this.driverId,
      required this.partyId,
      required this.freightAmount,
      this.advanceAmount,
      required this.status,
      required this.startDate,
      this.expectedEndDate,
      this.actualEndDate,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_location'] = Variable<String>(fromLocation);
    map['to_location'] = Variable<String>(toLocation);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['driver_id'] = Variable<String>(driverId);
    map['party_id'] = Variable<String>(partyId);
    map['freight_amount'] = Variable<double>(freightAmount);
    if (!nullToAbsent || advanceAmount != null) {
      map['advance_amount'] = Variable<double>(advanceAmount);
    }
    map['status'] = Variable<String>(status);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || expectedEndDate != null) {
      map['expected_end_date'] = Variable<DateTime>(expectedEndDate);
    }
    if (!nullToAbsent || actualEndDate != null) {
      map['actual_end_date'] = Variable<DateTime>(actualEndDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      fromLocation: Value(fromLocation),
      toLocation: Value(toLocation),
      vehicleId: Value(vehicleId),
      driverId: Value(driverId),
      partyId: Value(partyId),
      freightAmount: Value(freightAmount),
      advanceAmount: advanceAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(advanceAmount),
      status: Value(status),
      startDate: Value(startDate),
      expectedEndDate: expectedEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedEndDate),
      actualEndDate: actualEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actualEndDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<String>(json['id']),
      fromLocation: serializer.fromJson<String>(json['fromLocation']),
      toLocation: serializer.fromJson<String>(json['toLocation']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      driverId: serializer.fromJson<String>(json['driverId']),
      partyId: serializer.fromJson<String>(json['partyId']),
      freightAmount: serializer.fromJson<double>(json['freightAmount']),
      advanceAmount: serializer.fromJson<double?>(json['advanceAmount']),
      status: serializer.fromJson<String>(json['status']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      expectedEndDate: serializer.fromJson<DateTime?>(json['expectedEndDate']),
      actualEndDate: serializer.fromJson<DateTime?>(json['actualEndDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromLocation': serializer.toJson<String>(fromLocation),
      'toLocation': serializer.toJson<String>(toLocation),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'driverId': serializer.toJson<String>(driverId),
      'partyId': serializer.toJson<String>(partyId),
      'freightAmount': serializer.toJson<double>(freightAmount),
      'advanceAmount': serializer.toJson<double?>(advanceAmount),
      'status': serializer.toJson<String>(status),
      'startDate': serializer.toJson<DateTime>(startDate),
      'expectedEndDate': serializer.toJson<DateTime?>(expectedEndDate),
      'actualEndDate': serializer.toJson<DateTime?>(actualEndDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Trip copyWith(
          {String? id,
          String? fromLocation,
          String? toLocation,
          String? vehicleId,
          String? driverId,
          String? partyId,
          double? freightAmount,
          Value<double?> advanceAmount = const Value.absent(),
          String? status,
          DateTime? startDate,
          Value<DateTime?> expectedEndDate = const Value.absent(),
          Value<DateTime?> actualEndDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Trip(
        id: id ?? this.id,
        fromLocation: fromLocation ?? this.fromLocation,
        toLocation: toLocation ?? this.toLocation,
        vehicleId: vehicleId ?? this.vehicleId,
        driverId: driverId ?? this.driverId,
        partyId: partyId ?? this.partyId,
        freightAmount: freightAmount ?? this.freightAmount,
        advanceAmount:
            advanceAmount.present ? advanceAmount.value : this.advanceAmount,
        status: status ?? this.status,
        startDate: startDate ?? this.startDate,
        expectedEndDate: expectedEndDate.present
            ? expectedEndDate.value
            : this.expectedEndDate,
        actualEndDate:
            actualEndDate.present ? actualEndDate.value : this.actualEndDate,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      fromLocation: data.fromLocation.present
          ? data.fromLocation.value
          : this.fromLocation,
      toLocation:
          data.toLocation.present ? data.toLocation.value : this.toLocation,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      driverId: data.driverId.present ? data.driverId.value : this.driverId,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      freightAmount: data.freightAmount.present
          ? data.freightAmount.value
          : this.freightAmount,
      advanceAmount: data.advanceAmount.present
          ? data.advanceAmount.value
          : this.advanceAmount,
      status: data.status.present ? data.status.value : this.status,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      expectedEndDate: data.expectedEndDate.present
          ? data.expectedEndDate.value
          : this.expectedEndDate,
      actualEndDate: data.actualEndDate.present
          ? data.actualEndDate.value
          : this.actualEndDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('fromLocation: $fromLocation, ')
          ..write('toLocation: $toLocation, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('driverId: $driverId, ')
          ..write('partyId: $partyId, ')
          ..write('freightAmount: $freightAmount, ')
          ..write('advanceAmount: $advanceAmount, ')
          ..write('status: $status, ')
          ..write('startDate: $startDate, ')
          ..write('expectedEndDate: $expectedEndDate, ')
          ..write('actualEndDate: $actualEndDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      fromLocation,
      toLocation,
      vehicleId,
      driverId,
      partyId,
      freightAmount,
      advanceAmount,
      status,
      startDate,
      expectedEndDate,
      actualEndDate,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.fromLocation == this.fromLocation &&
          other.toLocation == this.toLocation &&
          other.vehicleId == this.vehicleId &&
          other.driverId == this.driverId &&
          other.partyId == this.partyId &&
          other.freightAmount == this.freightAmount &&
          other.advanceAmount == this.advanceAmount &&
          other.status == this.status &&
          other.startDate == this.startDate &&
          other.expectedEndDate == this.expectedEndDate &&
          other.actualEndDate == this.actualEndDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<String> id;
  final Value<String> fromLocation;
  final Value<String> toLocation;
  final Value<String> vehicleId;
  final Value<String> driverId;
  final Value<String> partyId;
  final Value<double> freightAmount;
  final Value<double?> advanceAmount;
  final Value<String> status;
  final Value<DateTime> startDate;
  final Value<DateTime?> expectedEndDate;
  final Value<DateTime?> actualEndDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.fromLocation = const Value.absent(),
    this.toLocation = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.driverId = const Value.absent(),
    this.partyId = const Value.absent(),
    this.freightAmount = const Value.absent(),
    this.advanceAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.startDate = const Value.absent(),
    this.expectedEndDate = const Value.absent(),
    this.actualEndDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsCompanion.insert({
    required String id,
    required String fromLocation,
    required String toLocation,
    required String vehicleId,
    required String driverId,
    required String partyId,
    required double freightAmount,
    this.advanceAmount = const Value.absent(),
    required String status,
    required DateTime startDate,
    this.expectedEndDate = const Value.absent(),
    this.actualEndDate = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        fromLocation = Value(fromLocation),
        toLocation = Value(toLocation),
        vehicleId = Value(vehicleId),
        driverId = Value(driverId),
        partyId = Value(partyId),
        freightAmount = Value(freightAmount),
        status = Value(status),
        startDate = Value(startDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Trip> custom({
    Expression<String>? id,
    Expression<String>? fromLocation,
    Expression<String>? toLocation,
    Expression<String>? vehicleId,
    Expression<String>? driverId,
    Expression<String>? partyId,
    Expression<double>? freightAmount,
    Expression<double>? advanceAmount,
    Expression<String>? status,
    Expression<DateTime>? startDate,
    Expression<DateTime>? expectedEndDate,
    Expression<DateTime>? actualEndDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromLocation != null) 'from_location': fromLocation,
      if (toLocation != null) 'to_location': toLocation,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (driverId != null) 'driver_id': driverId,
      if (partyId != null) 'party_id': partyId,
      if (freightAmount != null) 'freight_amount': freightAmount,
      if (advanceAmount != null) 'advance_amount': advanceAmount,
      if (status != null) 'status': status,
      if (startDate != null) 'start_date': startDate,
      if (expectedEndDate != null) 'expected_end_date': expectedEndDate,
      if (actualEndDate != null) 'actual_end_date': actualEndDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsCompanion copyWith(
      {Value<String>? id,
      Value<String>? fromLocation,
      Value<String>? toLocation,
      Value<String>? vehicleId,
      Value<String>? driverId,
      Value<String>? partyId,
      Value<double>? freightAmount,
      Value<double?>? advanceAmount,
      Value<String>? status,
      Value<DateTime>? startDate,
      Value<DateTime?>? expectedEndDate,
      Value<DateTime?>? actualEndDate,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TripsCompanion(
      id: id ?? this.id,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      vehicleId: vehicleId ?? this.vehicleId,
      driverId: driverId ?? this.driverId,
      partyId: partyId ?? this.partyId,
      freightAmount: freightAmount ?? this.freightAmount,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      expectedEndDate: expectedEndDate ?? this.expectedEndDate,
      actualEndDate: actualEndDate ?? this.actualEndDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromLocation.present) {
      map['from_location'] = Variable<String>(fromLocation.value);
    }
    if (toLocation.present) {
      map['to_location'] = Variable<String>(toLocation.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (driverId.present) {
      map['driver_id'] = Variable<String>(driverId.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<String>(partyId.value);
    }
    if (freightAmount.present) {
      map['freight_amount'] = Variable<double>(freightAmount.value);
    }
    if (advanceAmount.present) {
      map['advance_amount'] = Variable<double>(advanceAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (expectedEndDate.present) {
      map['expected_end_date'] = Variable<DateTime>(expectedEndDate.value);
    }
    if (actualEndDate.present) {
      map['actual_end_date'] = Variable<DateTime>(actualEndDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('fromLocation: $fromLocation, ')
          ..write('toLocation: $toLocation, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('driverId: $driverId, ')
          ..write('partyId: $partyId, ')
          ..write('freightAmount: $freightAmount, ')
          ..write('advanceAmount: $advanceAmount, ')
          ..write('status: $status, ')
          ..write('startDate: $startDate, ')
          ..write('expectedEndDate: $expectedEndDate, ')
          ..write('actualEndDate: $actualEndDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
      'trip_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paidModeMeta =
      const VerificationMeta('paidMode');
  @override
  late final GeneratedColumn<String> paidMode = GeneratedColumn<String>(
      'paid_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _billImagePathMeta =
      const VerificationMeta('billImagePath');
  @override
  late final GeneratedColumn<String> billImagePath = GeneratedColumn<String>(
      'bill_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tripId,
        category,
        amount,
        paidMode,
        billImagePath,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(_tripIdMeta,
          tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta));
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('paid_mode')) {
      context.handle(_paidModeMeta,
          paidMode.isAcceptableOrUnknown(data['paid_mode']!, _paidModeMeta));
    } else if (isInserting) {
      context.missing(_paidModeMeta);
    }
    if (data.containsKey('bill_image_path')) {
      context.handle(
          _billImagePathMeta,
          billImagePath.isAcceptableOrUnknown(
              data['bill_image_path']!, _billImagePathMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tripId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trip_id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paidMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}paid_mode'])!,
      billImagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_image_path']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final String tripId;
  final String category;
  final double amount;
  final String paidMode;
  final String? billImagePath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Expense(
      {required this.id,
      required this.tripId,
      required this.category,
      required this.amount,
      required this.paidMode,
      this.billImagePath,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    map['paid_mode'] = Variable<String>(paidMode);
    if (!nullToAbsent || billImagePath != null) {
      map['bill_image_path'] = Variable<String>(billImagePath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      tripId: Value(tripId),
      category: Value(category),
      amount: Value(amount),
      paidMode: Value(paidMode),
      billImagePath: billImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(billImagePath),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      paidMode: serializer.fromJson<String>(json['paidMode']),
      billImagePath: serializer.fromJson<String?>(json['billImagePath']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'paidMode': serializer.toJson<String>(paidMode),
      'billImagePath': serializer.toJson<String?>(billImagePath),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Expense copyWith(
          {String? id,
          String? tripId,
          String? category,
          double? amount,
          String? paidMode,
          Value<String?> billImagePath = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Expense(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        paidMode: paidMode ?? this.paidMode,
        billImagePath:
            billImagePath.present ? billImagePath.value : this.billImagePath,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      paidMode: data.paidMode.present ? data.paidMode.value : this.paidMode,
      billImagePath: data.billImagePath.present
          ? data.billImagePath.value
          : this.billImagePath,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('paidMode: $paidMode, ')
          ..write('billImagePath: $billImagePath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tripId, category, amount, paidMode,
      billImagePath, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.paidMode == this.paidMode &&
          other.billImagePath == this.billImagePath &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> category;
  final Value<double> amount;
  final Value<String> paidMode;
  final Value<String?> billImagePath;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.paidMode = const Value.absent(),
    this.billImagePath = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String tripId,
    required String category,
    required double amount,
    required String paidMode,
    this.billImagePath = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tripId = Value(tripId),
        category = Value(category),
        amount = Value(amount),
        paidMode = Value(paidMode),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? paidMode,
    Expression<String>? billImagePath,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (paidMode != null) 'paid_mode': paidMode,
      if (billImagePath != null) 'bill_image_path': billImagePath,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String>? tripId,
      Value<String>? category,
      Value<double>? amount,
      Value<String>? paidMode,
      Value<String?>? billImagePath,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      paidMode: paidMode ?? this.paidMode,
      billImagePath: billImagePath ?? this.billImagePath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paidMode.present) {
      map['paid_mode'] = Variable<String>(paidMode.value);
    }
    if (billImagePath.present) {
      map['bill_image_path'] = Variable<String>(billImagePath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('paidMode: $paidMode, ')
          ..write('billImagePath: $billImagePath, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
      'trip_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _partyIdMeta =
      const VerificationMeta('partyId');
  @override
  late final GeneratedColumn<String> partyId = GeneratedColumn<String>(
      'party_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tripId,
        partyId,
        amount,
        type,
        mode,
        date,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(_tripIdMeta,
          tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta));
    }
    if (data.containsKey('party_id')) {
      context.handle(_partyIdMeta,
          partyId.isAcceptableOrUnknown(data['party_id']!, _partyIdMeta));
    } else if (isInserting) {
      context.missing(_partyIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tripId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trip_id']),
      partyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}party_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String? tripId;
  final String partyId;
  final double amount;
  final String type;
  final String mode;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Payment(
      {required this.id,
      this.tripId,
      required this.partyId,
      required this.amount,
      required this.type,
      required this.mode,
      required this.date,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || tripId != null) {
      map['trip_id'] = Variable<String>(tripId);
    }
    map['party_id'] = Variable<String>(partyId);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['mode'] = Variable<String>(mode);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      tripId:
          tripId == null && nullToAbsent ? const Value.absent() : Value(tripId),
      partyId: Value(partyId),
      amount: Value(amount),
      type: Value(type),
      mode: Value(mode),
      date: Value(date),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String?>(json['tripId']),
      partyId: serializer.fromJson<String>(json['partyId']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      mode: serializer.fromJson<String>(json['mode']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String?>(tripId),
      'partyId': serializer.toJson<String>(partyId),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'mode': serializer.toJson<String>(mode),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Payment copyWith(
          {String? id,
          Value<String?> tripId = const Value.absent(),
          String? partyId,
          double? amount,
          String? type,
          String? mode,
          DateTime? date,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Payment(
        id: id ?? this.id,
        tripId: tripId.present ? tripId.value : this.tripId,
        partyId: partyId ?? this.partyId,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        mode: mode ?? this.mode,
        date: date ?? this.date,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      partyId: data.partyId.present ? data.partyId.value : this.partyId,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      mode: data.mode.present ? data.mode.value : this.mode,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('partyId: $partyId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('mode: $mode, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tripId, partyId, amount, type, mode, date,
      notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.partyId == this.partyId &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.mode == this.mode &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String?> tripId;
  final Value<String> partyId;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> mode;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.partyId = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.mode = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    this.tripId = const Value.absent(),
    required String partyId,
    required double amount,
    required String type,
    required String mode,
    required DateTime date,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        partyId = Value(partyId),
        amount = Value(amount),
        type = Value(type),
        mode = Value(mode),
        date = Value(date),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? partyId,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? mode,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (partyId != null) 'party_id': partyId,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (mode != null) 'mode': mode,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? tripId,
      Value<String>? partyId,
      Value<double>? amount,
      Value<String>? type,
      Value<String>? mode,
      Value<DateTime>? date,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      partyId: partyId ?? this.partyId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (partyId.present) {
      map['party_id'] = Variable<String>(partyId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('partyId: $partyId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('mode: $mode, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        entityType,
        entityId,
        filePath,
        description,
        fileSize,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final String id;
  final String name;
  final String type;
  final String entityType;
  final String entityId;
  final String filePath;
  final String description;
  final int fileSize;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Document(
      {required this.id,
      required this.name,
      required this.type,
      required this.entityType,
      required this.entityId,
      required this.filePath,
      required this.description,
      required this.fileSize,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['file_path'] = Variable<String>(filePath);
    map['description'] = Variable<String>(description);
    map['file_size'] = Variable<int>(fileSize);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      entityType: Value(entityType),
      entityId: Value(entityId),
      filePath: Value(filePath),
      description: Value(description),
      fileSize: Value(fileSize),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      description: serializer.fromJson<String>(json['description']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'filePath': serializer.toJson<String>(filePath),
      'description': serializer.toJson<String>(description),
      'fileSize': serializer.toJson<int>(fileSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Document copyWith(
          {String? id,
          String? name,
          String? type,
          String? entityType,
          String? entityId,
          String? filePath,
          String? description,
          int? fileSize,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Document(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        filePath: filePath ?? this.filePath,
        description: description ?? this.description,
        fileSize: fileSize ?? this.fileSize,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      description:
          data.description.present ? data.description.value : this.description,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('filePath: $filePath, ')
          ..write('description: $description, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, entityType, entityId,
      filePath, description, fileSize, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.filePath == this.filePath &&
          other.description == this.description &&
          other.fileSize == this.fileSize &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> filePath;
  final Value<String> description;
  final Value<int> fileSize;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.description = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String entityType,
    required String entityId,
    required String filePath,
    required String description,
    required int fileSize,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        entityType = Value(entityType),
        entityId = Value(entityId),
        filePath = Value(filePath),
        description = Value(description),
        fileSize = Value(fileSize),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Document> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? filePath,
    Expression<String>? description,
    Expression<int>? fileSize,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (filePath != null) 'file_path': filePath,
      if (description != null) 'description': description,
      if (fileSize != null) 'file_size': fileSize,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? filePath,
      Value<String>? description,
      Value<int>? fileSize,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DocumentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      filePath: filePath ?? this.filePath,
      description: description ?? this.description,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('filePath: $filePath, ')
          ..write('description: $description, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordHashMeta =
      const VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
      'password_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profilePictureMeta =
      const VerificationMeta('profilePicture');
  @override
  late final GeneratedColumn<String> profilePicture = GeneratedColumn<String>(
      'profile_picture', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastLoginAtMeta =
      const VerificationMeta('lastLoginAt');
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
      'last_login_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        email,
        passwordHash,
        firstName,
        lastName,
        role,
        phone,
        profilePicture,
        isActive,
        lastLoginAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
          _passwordHashMeta,
          passwordHash.isAcceptableOrUnknown(
              data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('profile_picture')) {
      context.handle(
          _profilePictureMeta,
          profilePicture.isAcceptableOrUnknown(
              data['profile_picture']!, _profilePictureMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
          _lastLoginAtMeta,
          lastLoginAt.isAcceptableOrUnknown(
              data['last_login_at']!, _lastLoginAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      passwordHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      profilePicture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_picture']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      lastLoginAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String username;
  final String email;
  final String passwordHash;
  final String firstName;
  final String lastName;
  final String role;
  final String? phone;
  final String? profilePicture;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.passwordHash,
      required this.firstName,
      required this.lastName,
      required this.role,
      this.phone,
      this.profilePicture,
      required this.isActive,
      this.lastLoginAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || profilePicture != null) {
      map['profile_picture'] = Variable<String>(profilePicture);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      email: Value(email),
      passwordHash: Value(passwordHash),
      firstName: Value(firstName),
      lastName: Value(lastName),
      role: Value(role),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      profilePicture: profilePicture == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePicture),
      isActive: Value(isActive),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      role: serializer.fromJson<String>(json['role']),
      phone: serializer.fromJson<String?>(json['phone']),
      profilePicture: serializer.fromJson<String?>(json['profilePicture']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'role': serializer.toJson<String>(role),
      'phone': serializer.toJson<String?>(phone),
      'profilePicture': serializer.toJson<String?>(profilePicture),
      'isActive': serializer.toJson<bool>(isActive),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith(
          {String? id,
          String? username,
          String? email,
          String? passwordHash,
          String? firstName,
          String? lastName,
          String? role,
          Value<String?> phone = const Value.absent(),
          Value<String?> profilePicture = const Value.absent(),
          bool? isActive,
          Value<DateTime?> lastLoginAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        role: role ?? this.role,
        phone: phone.present ? phone.value : this.phone,
        profilePicture:
            profilePicture.present ? profilePicture.value : this.profilePicture,
        isActive: isActive ?? this.isActive,
        lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
      profilePicture: data.profilePicture.present
          ? data.profilePicture.value
          : this.profilePicture,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastLoginAt:
          data.lastLoginAt.present ? data.lastLoginAt.value : this.lastLoginAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('isActive: $isActive, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      username,
      email,
      passwordHash,
      firstName,
      lastName,
      role,
      phone,
      profilePicture,
      isActive,
      lastLoginAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.role == this.role &&
          other.phone == this.phone &&
          other.profilePicture == this.profilePicture &&
          other.isActive == this.isActive &&
          other.lastLoginAt == this.lastLoginAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> role;
  final Value<String?> phone;
  final Value<String?> profilePicture;
  final Value<bool> isActive;
  final Value<DateTime?> lastLoginAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.profilePicture = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String username,
    required String email,
    required String passwordHash,
    required String firstName,
    required String lastName,
    required String role,
    this.phone = const Value.absent(),
    this.profilePicture = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        username = Value(username),
        email = Value(email),
        passwordHash = Value(passwordHash),
        firstName = Value(firstName),
        lastName = Value(lastName),
        role = Value(role),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? role,
    Expression<String>? phone,
    Expression<String>? profilePicture,
    Expression<bool>? isActive,
    Expression<DateTime>? lastLoginAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
      if (profilePicture != null) 'profile_picture': profilePicture,
      if (isActive != null) 'is_active': isActive,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String>? email,
      Value<String>? passwordHash,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String>? role,
      Value<String?>? phone,
      Value<String?>? profilePicture,
      Value<bool>? isActive,
      Value<DateTime?>? lastLoginAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profilePicture: profilePicture ?? this.profilePicture,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (profilePicture.present) {
      map['profile_picture'] = Variable<String>(profilePicture.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('isActive: $isActive, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSessionsTable extends UserSessions
    with TableInfo<$UserSessionsTable, UserSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionTokenMeta =
      const VerificationMeta('sessionToken');
  @override
  late final GeneratedColumn<String> sessionToken = GeneratedColumn<String>(
      'session_token', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, sessionToken, expiresAt, createdAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<UserSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('session_token')) {
      context.handle(
          _sessionTokenMeta,
          sessionToken.isAcceptableOrUnknown(
              data['session_token']!, _sessionTokenMeta));
    } else if (isInserting) {
      context.missing(_sessionTokenMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      sessionToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_token'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $UserSessionsTable createAlias(String alias) {
    return $UserSessionsTable(attachedDatabase, alias);
  }
}

class UserSession extends DataClass implements Insertable<UserSession> {
  final String id;
  final String userId;
  final String sessionToken;
  final DateTime expiresAt;
  final DateTime createdAt;
  final bool isActive;
  const UserSession(
      {required this.id,
      required this.userId,
      required this.sessionToken,
      required this.expiresAt,
      required this.createdAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['session_token'] = Variable<String>(sessionToken);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  UserSessionsCompanion toCompanion(bool nullToAbsent) {
    return UserSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      sessionToken: Value(sessionToken),
      expiresAt: Value(expiresAt),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory UserSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSession(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sessionToken: serializer.fromJson<String>(json['sessionToken']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sessionToken': serializer.toJson<String>(sessionToken),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  UserSession copyWith(
          {String? id,
          String? userId,
          String? sessionToken,
          DateTime? expiresAt,
          DateTime? createdAt,
          bool? isActive}) =>
      UserSession(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        sessionToken: sessionToken ?? this.sessionToken,
        expiresAt: expiresAt ?? this.expiresAt,
        createdAt: createdAt ?? this.createdAt,
        isActive: isActive ?? this.isActive,
      );
  UserSession copyWithCompanion(UserSessionsCompanion data) {
    return UserSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sessionToken: data.sessionToken.present
          ? data.sessionToken.value
          : this.sessionToken,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, sessionToken, expiresAt, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sessionToken == this.sessionToken &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class UserSessionsCompanion extends UpdateCompanion<UserSession> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sessionToken;
  final Value<DateTime> expiresAt;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const UserSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSessionsCompanion.insert({
    required String id,
    required String userId,
    required String sessionToken,
    required DateTime expiresAt,
    required DateTime createdAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        sessionToken = Value(sessionToken),
        expiresAt = Value(expiresAt),
        createdAt = Value(createdAt);
  static Insertable<UserSession> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sessionToken,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sessionToken != null) 'session_token': sessionToken,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? sessionToken,
      Value<DateTime>? expiresAt,
      Value<DateTime>? createdAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return UserSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionToken: sessionToken ?? this.sessionToken,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sessionToken.present) {
      map['session_token'] = Variable<String>(sessionToken.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPermissionsTable extends UserPermissions
    with TableInfo<$UserPermissionsTable, UserPermission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _permissionMeta =
      const VerificationMeta('permission');
  @override
  late final GeneratedColumn<String> permission = GeneratedColumn<String>(
      'permission', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, userId, permission, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_permissions';
  @override
  VerificationContext validateIntegrity(Insertable<UserPermission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('permission')) {
      context.handle(
          _permissionMeta,
          permission.isAcceptableOrUnknown(
              data['permission']!, _permissionMeta));
    } else if (isInserting) {
      context.missing(_permissionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPermission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPermission(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      permission: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}permission'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UserPermissionsTable createAlias(String alias) {
    return $UserPermissionsTable(attachedDatabase, alias);
  }
}

class UserPermission extends DataClass implements Insertable<UserPermission> {
  final String id;
  final String userId;
  final String permission;
  final DateTime createdAt;
  const UserPermission(
      {required this.id,
      required this.userId,
      required this.permission,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['permission'] = Variable<String>(permission);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserPermissionsCompanion toCompanion(bool nullToAbsent) {
    return UserPermissionsCompanion(
      id: Value(id),
      userId: Value(userId),
      permission: Value(permission),
      createdAt: Value(createdAt),
    );
  }

  factory UserPermission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPermission(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      permission: serializer.fromJson<String>(json['permission']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'permission': serializer.toJson<String>(permission),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserPermission copyWith(
          {String? id,
          String? userId,
          String? permission,
          DateTime? createdAt}) =>
      UserPermission(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        permission: permission ?? this.permission,
        createdAt: createdAt ?? this.createdAt,
      );
  UserPermission copyWithCompanion(UserPermissionsCompanion data) {
    return UserPermission(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      permission:
          data.permission.present ? data.permission.value : this.permission,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPermission(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('permission: $permission, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, permission, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPermission &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.permission == this.permission &&
          other.createdAt == this.createdAt);
}

class UserPermissionsCompanion extends UpdateCompanion<UserPermission> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> permission;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UserPermissionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.permission = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPermissionsCompanion.insert({
    required String id,
    required String userId,
    required String permission,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        permission = Value(permission),
        createdAt = Value(createdAt);
  static Insertable<UserPermission> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? permission,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (permission != null) 'permission': permission,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPermissionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? permission,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UserPermissionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      permission: permission ?? this.permission,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (permission.present) {
      map['permission'] = Variable<String>(permission.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPermissionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('permission: $permission, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogsTable extends ActivityLogs
    with TableInfo<$ActivityLogsTable, ActivityLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ipAddressMeta =
      const VerificationMeta('ipAddress');
  @override
  late final GeneratedColumn<String> ipAddress = GeneratedColumn<String>(
      'ip_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userAgentMeta =
      const VerificationMeta('userAgent');
  @override
  late final GeneratedColumn<String> userAgent = GeneratedColumn<String>(
      'user_agent', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        action,
        entityType,
        entityId,
        description,
        ipAddress,
        userAgent,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_logs';
  @override
  VerificationContext validateIntegrity(Insertable<ActivityLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('ip_address')) {
      context.handle(_ipAddressMeta,
          ipAddress.isAcceptableOrUnknown(data['ip_address']!, _ipAddressMeta));
    }
    if (data.containsKey('user_agent')) {
      context.handle(_userAgentMeta,
          userAgent.isAcceptableOrUnknown(data['user_agent']!, _userAgentMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type']),
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      ipAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ip_address']),
      userAgent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_agent']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ActivityLogsTable createAlias(String alias) {
    return $ActivityLogsTable(attachedDatabase, alias);
  }
}

class ActivityLog extends DataClass implements Insertable<ActivityLog> {
  final String id;
  final String userId;
  final String action;
  final String? entityType;
  final String? entityId;
  final String description;
  final String? ipAddress;
  final String? userAgent;
  final DateTime createdAt;
  const ActivityLog(
      {required this.id,
      required this.userId,
      required this.action,
      this.entityType,
      this.entityId,
      required this.description,
      this.ipAddress,
      this.userAgent,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || ipAddress != null) {
      map['ip_address'] = Variable<String>(ipAddress);
    }
    if (!nullToAbsent || userAgent != null) {
      map['user_agent'] = Variable<String>(userAgent);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityLogsCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      action: Value(action),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      description: Value(description),
      ipAddress: ipAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(ipAddress),
      userAgent: userAgent == null && nullToAbsent
          ? const Value.absent()
          : Value(userAgent),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String?>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      description: serializer.fromJson<String>(json['description']),
      ipAddress: serializer.fromJson<String?>(json['ipAddress']),
      userAgent: serializer.fromJson<String?>(json['userAgent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String?>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'description': serializer.toJson<String>(description),
      'ipAddress': serializer.toJson<String?>(ipAddress),
      'userAgent': serializer.toJson<String?>(userAgent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityLog copyWith(
          {String? id,
          String? userId,
          String? action,
          Value<String?> entityType = const Value.absent(),
          Value<String?> entityId = const Value.absent(),
          String? description,
          Value<String?> ipAddress = const Value.absent(),
          Value<String?> userAgent = const Value.absent(),
          DateTime? createdAt}) =>
      ActivityLog(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        action: action ?? this.action,
        entityType: entityType.present ? entityType.value : this.entityType,
        entityId: entityId.present ? entityId.value : this.entityId,
        description: description ?? this.description,
        ipAddress: ipAddress.present ? ipAddress.value : this.ipAddress,
        userAgent: userAgent.present ? userAgent.value : this.userAgent,
        createdAt: createdAt ?? this.createdAt,
      );
  ActivityLog copyWithCompanion(ActivityLogsCompanion data) {
    return ActivityLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      description:
          data.description.present ? data.description.value : this.description,
      ipAddress: data.ipAddress.present ? data.ipAddress.value : this.ipAddress,
      userAgent: data.userAgent.present ? data.userAgent.value : this.userAgent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('description: $description, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('userAgent: $userAgent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, action, entityType, entityId,
      description, ipAddress, userAgent, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.description == this.description &&
          other.ipAddress == this.ipAddress &&
          other.userAgent == this.userAgent &&
          other.createdAt == this.createdAt);
}

class ActivityLogsCompanion extends UpdateCompanion<ActivityLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> action;
  final Value<String?> entityType;
  final Value<String?> entityId;
  final Value<String> description;
  final Value<String?> ipAddress;
  final Value<String?> userAgent;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ActivityLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.description = const Value.absent(),
    this.ipAddress = const Value.absent(),
    this.userAgent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLogsCompanion.insert({
    required String id,
    required String userId,
    required String action,
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    required String description,
    this.ipAddress = const Value.absent(),
    this.userAgent = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        action = Value(action),
        description = Value(description),
        createdAt = Value(createdAt);
  static Insertable<ActivityLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? description,
    Expression<String>? ipAddress,
    Expression<String>? userAgent,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (description != null) 'description': description,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (userAgent != null) 'user_agent': userAgent,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? action,
      Value<String?>? entityType,
      Value<String?>? entityId,
      Value<String>? description,
      Value<String?>? ipAddress,
      Value<String?>? userAgent,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ActivityLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      description: description ?? this.description,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (ipAddress.present) {
      map['ip_address'] = Variable<String>(ipAddress.value);
    }
    if (userAgent.present) {
      map['user_agent'] = Variable<String>(userAgent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('description: $description, ')
          ..write('ipAddress: $ipAddress, ')
          ..write('userAgent: $userAgent, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SystemSettingsTable extends SystemSettings
    with TableInfo<$SystemSettingsTable, SystemSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, key, value, description, category, updatedBy, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'system_settings';
  @override
  VerificationContext validateIntegrity(Insertable<SystemSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SystemSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SystemSettingsTable createAlias(String alias) {
    return $SystemSettingsTable(attachedDatabase, alias);
  }
}

class SystemSetting extends DataClass implements Insertable<SystemSetting> {
  final String id;
  final String key;
  final String value;
  final String description;
  final String category;
  final String updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SystemSetting(
      {required this.id,
      required this.key,
      required this.value,
      required this.description,
      required this.category,
      required this.updatedBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['updated_by'] = Variable<String>(updatedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SystemSettingsCompanion toCompanion(bool nullToAbsent) {
    return SystemSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      description: Value(description),
      category: Value(category),
      updatedBy: Value(updatedBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SystemSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemSetting(
      id: serializer.fromJson<String>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SystemSetting copyWith(
          {String? id,
          String? key,
          String? value,
          String? description,
          String? category,
          String? updatedBy,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SystemSetting(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
        description: description ?? this.description,
        category: category ?? this.category,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SystemSetting copyWithCompanion(SystemSettingsCompanion data) {
    return SystemSetting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SystemSetting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, key, value, description, category, updatedBy, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemSetting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.description == this.description &&
          other.category == this.category &&
          other.updatedBy == this.updatedBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SystemSettingsCompanion extends UpdateCompanion<SystemSetting> {
  final Value<String> id;
  final Value<String> key;
  final Value<String> value;
  final Value<String> description;
  final Value<String> category;
  final Value<String> updatedBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SystemSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SystemSettingsCompanion.insert({
    required String id,
    required String key,
    required String value,
    required String description,
    required String category,
    required String updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        key = Value(key),
        value = Value(value),
        description = Value(description),
        category = Value(category),
        updatedBy = Value(updatedBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SystemSetting> custom({
    Expression<String>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? updatedBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SystemSettingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? key,
      Value<String>? value,
      Value<String>? description,
      Value<String>? category,
      Value<String>? updatedBy,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SystemSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      description: description ?? this.description,
      category: category ?? this.category,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduledReportsTable extends ScheduledReports
    with TableInfo<$ScheduledReportsTable, ScheduledReport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledReportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reportTypeMeta =
      const VerificationMeta('reportType');
  @override
  late final GeneratedColumn<String> reportType = GeneratedColumn<String>(
      'report_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleTypeMeta =
      const VerificationMeta('scheduleType');
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
      'schedule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleConfigMeta =
      const VerificationMeta('scheduleConfig');
  @override
  late final GeneratedColumn<String> scheduleConfig = GeneratedColumn<String>(
      'schedule_config', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientsMeta =
      const VerificationMeta('recipients');
  @override
  late final GeneratedColumn<String> recipients = GeneratedColumn<String>(
      'recipients', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
      'format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filtersMeta =
      const VerificationMeta('filters');
  @override
  late final GeneratedColumn<String> filters = GeneratedColumn<String>(
      'filters', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _nextRunAtMeta =
      const VerificationMeta('nextRunAt');
  @override
  late final GeneratedColumn<DateTime> nextRunAt = GeneratedColumn<DateTime>(
      'next_run_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastRunAtMeta =
      const VerificationMeta('lastRunAt');
  @override
  late final GeneratedColumn<DateTime> lastRunAt = GeneratedColumn<DateTime>(
      'last_run_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        reportType,
        scheduleType,
        scheduleConfig,
        recipients,
        format,
        filters,
        isActive,
        nextRunAt,
        lastRunAt,
        createdBy,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_reports';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduledReport> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('report_type')) {
      context.handle(
          _reportTypeMeta,
          reportType.isAcceptableOrUnknown(
              data['report_type']!, _reportTypeMeta));
    } else if (isInserting) {
      context.missing(_reportTypeMeta);
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
          _scheduleTypeMeta,
          scheduleType.isAcceptableOrUnknown(
              data['schedule_type']!, _scheduleTypeMeta));
    } else if (isInserting) {
      context.missing(_scheduleTypeMeta);
    }
    if (data.containsKey('schedule_config')) {
      context.handle(
          _scheduleConfigMeta,
          scheduleConfig.isAcceptableOrUnknown(
              data['schedule_config']!, _scheduleConfigMeta));
    } else if (isInserting) {
      context.missing(_scheduleConfigMeta);
    }
    if (data.containsKey('recipients')) {
      context.handle(
          _recipientsMeta,
          recipients.isAcceptableOrUnknown(
              data['recipients']!, _recipientsMeta));
    } else if (isInserting) {
      context.missing(_recipientsMeta);
    }
    if (data.containsKey('format')) {
      context.handle(_formatMeta,
          format.isAcceptableOrUnknown(data['format']!, _formatMeta));
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('filters')) {
      context.handle(_filtersMeta,
          filters.isAcceptableOrUnknown(data['filters']!, _filtersMeta));
    } else if (isInserting) {
      context.missing(_filtersMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('next_run_at')) {
      context.handle(
          _nextRunAtMeta,
          nextRunAt.isAcceptableOrUnknown(
              data['next_run_at']!, _nextRunAtMeta));
    } else if (isInserting) {
      context.missing(_nextRunAtMeta);
    }
    if (data.containsKey('last_run_at')) {
      context.handle(
          _lastRunAtMeta,
          lastRunAt.isAcceptableOrUnknown(
              data['last_run_at']!, _lastRunAtMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledReport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledReport(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      reportType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_type'])!,
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      scheduleConfig: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}schedule_config'])!,
      recipients: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipients'])!,
      format: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}format'])!,
      filters: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}filters'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      nextRunAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_run_at'])!,
      lastRunAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_run_at']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ScheduledReportsTable createAlias(String alias) {
    return $ScheduledReportsTable(attachedDatabase, alias);
  }
}

class ScheduledReport extends DataClass implements Insertable<ScheduledReport> {
  final String id;
  final String name;
  final String description;
  final String reportType;
  final String scheduleType;
  final String scheduleConfig;
  final String recipients;
  final String format;
  final String filters;
  final bool isActive;
  final DateTime nextRunAt;
  final DateTime? lastRunAt;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ScheduledReport(
      {required this.id,
      required this.name,
      required this.description,
      required this.reportType,
      required this.scheduleType,
      required this.scheduleConfig,
      required this.recipients,
      required this.format,
      required this.filters,
      required this.isActive,
      required this.nextRunAt,
      this.lastRunAt,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['report_type'] = Variable<String>(reportType);
    map['schedule_type'] = Variable<String>(scheduleType);
    map['schedule_config'] = Variable<String>(scheduleConfig);
    map['recipients'] = Variable<String>(recipients);
    map['format'] = Variable<String>(format);
    map['filters'] = Variable<String>(filters);
    map['is_active'] = Variable<bool>(isActive);
    map['next_run_at'] = Variable<DateTime>(nextRunAt);
    if (!nullToAbsent || lastRunAt != null) {
      map['last_run_at'] = Variable<DateTime>(lastRunAt);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScheduledReportsCompanion toCompanion(bool nullToAbsent) {
    return ScheduledReportsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      reportType: Value(reportType),
      scheduleType: Value(scheduleType),
      scheduleConfig: Value(scheduleConfig),
      recipients: Value(recipients),
      format: Value(format),
      filters: Value(filters),
      isActive: Value(isActive),
      nextRunAt: Value(nextRunAt),
      lastRunAt: lastRunAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRunAt),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ScheduledReport.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledReport(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      reportType: serializer.fromJson<String>(json['reportType']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      scheduleConfig: serializer.fromJson<String>(json['scheduleConfig']),
      recipients: serializer.fromJson<String>(json['recipients']),
      format: serializer.fromJson<String>(json['format']),
      filters: serializer.fromJson<String>(json['filters']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      nextRunAt: serializer.fromJson<DateTime>(json['nextRunAt']),
      lastRunAt: serializer.fromJson<DateTime?>(json['lastRunAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'reportType': serializer.toJson<String>(reportType),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'scheduleConfig': serializer.toJson<String>(scheduleConfig),
      'recipients': serializer.toJson<String>(recipients),
      'format': serializer.toJson<String>(format),
      'filters': serializer.toJson<String>(filters),
      'isActive': serializer.toJson<bool>(isActive),
      'nextRunAt': serializer.toJson<DateTime>(nextRunAt),
      'lastRunAt': serializer.toJson<DateTime?>(lastRunAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ScheduledReport copyWith(
          {String? id,
          String? name,
          String? description,
          String? reportType,
          String? scheduleType,
          String? scheduleConfig,
          String? recipients,
          String? format,
          String? filters,
          bool? isActive,
          DateTime? nextRunAt,
          Value<DateTime?> lastRunAt = const Value.absent(),
          String? createdBy,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ScheduledReport(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        reportType: reportType ?? this.reportType,
        scheduleType: scheduleType ?? this.scheduleType,
        scheduleConfig: scheduleConfig ?? this.scheduleConfig,
        recipients: recipients ?? this.recipients,
        format: format ?? this.format,
        filters: filters ?? this.filters,
        isActive: isActive ?? this.isActive,
        nextRunAt: nextRunAt ?? this.nextRunAt,
        lastRunAt: lastRunAt.present ? lastRunAt.value : this.lastRunAt,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ScheduledReport copyWithCompanion(ScheduledReportsCompanion data) {
    return ScheduledReport(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      reportType:
          data.reportType.present ? data.reportType.value : this.reportType,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      scheduleConfig: data.scheduleConfig.present
          ? data.scheduleConfig.value
          : this.scheduleConfig,
      recipients:
          data.recipients.present ? data.recipients.value : this.recipients,
      format: data.format.present ? data.format.value : this.format,
      filters: data.filters.present ? data.filters.value : this.filters,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      nextRunAt: data.nextRunAt.present ? data.nextRunAt.value : this.nextRunAt,
      lastRunAt: data.lastRunAt.present ? data.lastRunAt.value : this.lastRunAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledReport(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('reportType: $reportType, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('scheduleConfig: $scheduleConfig, ')
          ..write('recipients: $recipients, ')
          ..write('format: $format, ')
          ..write('filters: $filters, ')
          ..write('isActive: $isActive, ')
          ..write('nextRunAt: $nextRunAt, ')
          ..write('lastRunAt: $lastRunAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      reportType,
      scheduleType,
      scheduleConfig,
      recipients,
      format,
      filters,
      isActive,
      nextRunAt,
      lastRunAt,
      createdBy,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledReport &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.reportType == this.reportType &&
          other.scheduleType == this.scheduleType &&
          other.scheduleConfig == this.scheduleConfig &&
          other.recipients == this.recipients &&
          other.format == this.format &&
          other.filters == this.filters &&
          other.isActive == this.isActive &&
          other.nextRunAt == this.nextRunAt &&
          other.lastRunAt == this.lastRunAt &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ScheduledReportsCompanion extends UpdateCompanion<ScheduledReport> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> reportType;
  final Value<String> scheduleType;
  final Value<String> scheduleConfig;
  final Value<String> recipients;
  final Value<String> format;
  final Value<String> filters;
  final Value<bool> isActive;
  final Value<DateTime> nextRunAt;
  final Value<DateTime?> lastRunAt;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ScheduledReportsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.reportType = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.scheduleConfig = const Value.absent(),
    this.recipients = const Value.absent(),
    this.format = const Value.absent(),
    this.filters = const Value.absent(),
    this.isActive = const Value.absent(),
    this.nextRunAt = const Value.absent(),
    this.lastRunAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduledReportsCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String reportType,
    required String scheduleType,
    required String scheduleConfig,
    required String recipients,
    required String format,
    required String filters,
    this.isActive = const Value.absent(),
    required DateTime nextRunAt,
    this.lastRunAt = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        reportType = Value(reportType),
        scheduleType = Value(scheduleType),
        scheduleConfig = Value(scheduleConfig),
        recipients = Value(recipients),
        format = Value(format),
        filters = Value(filters),
        nextRunAt = Value(nextRunAt),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ScheduledReport> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? reportType,
    Expression<String>? scheduleType,
    Expression<String>? scheduleConfig,
    Expression<String>? recipients,
    Expression<String>? format,
    Expression<String>? filters,
    Expression<bool>? isActive,
    Expression<DateTime>? nextRunAt,
    Expression<DateTime>? lastRunAt,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (reportType != null) 'report_type': reportType,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (scheduleConfig != null) 'schedule_config': scheduleConfig,
      if (recipients != null) 'recipients': recipients,
      if (format != null) 'format': format,
      if (filters != null) 'filters': filters,
      if (isActive != null) 'is_active': isActive,
      if (nextRunAt != null) 'next_run_at': nextRunAt,
      if (lastRunAt != null) 'last_run_at': lastRunAt,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduledReportsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? reportType,
      Value<String>? scheduleType,
      Value<String>? scheduleConfig,
      Value<String>? recipients,
      Value<String>? format,
      Value<String>? filters,
      Value<bool>? isActive,
      Value<DateTime>? nextRunAt,
      Value<DateTime?>? lastRunAt,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ScheduledReportsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      reportType: reportType ?? this.reportType,
      scheduleType: scheduleType ?? this.scheduleType,
      scheduleConfig: scheduleConfig ?? this.scheduleConfig,
      recipients: recipients ?? this.recipients,
      format: format ?? this.format,
      filters: filters ?? this.filters,
      isActive: isActive ?? this.isActive,
      nextRunAt: nextRunAt ?? this.nextRunAt,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (reportType.present) {
      map['report_type'] = Variable<String>(reportType.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (scheduleConfig.present) {
      map['schedule_config'] = Variable<String>(scheduleConfig.value);
    }
    if (recipients.present) {
      map['recipients'] = Variable<String>(recipients.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (filters.present) {
      map['filters'] = Variable<String>(filters.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (nextRunAt.present) {
      map['next_run_at'] = Variable<DateTime>(nextRunAt.value);
    }
    if (lastRunAt.present) {
      map['last_run_at'] = Variable<DateTime>(lastRunAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledReportsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('reportType: $reportType, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('scheduleConfig: $scheduleConfig, ')
          ..write('recipients: $recipients, ')
          ..write('format: $format, ')
          ..write('filters: $filters, ')
          ..write('isActive: $isActive, ')
          ..write('nextRunAt: $nextRunAt, ')
          ..write('lastRunAt: $lastRunAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportExecutionsTable extends ReportExecutions
    with TableInfo<$ReportExecutionsTable, ReportExecution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportExecutionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledReportIdMeta =
      const VerificationMeta('scheduledReportId');
  @override
  late final GeneratedColumn<String> scheduledReportId =
      GeneratedColumn<String>('scheduled_report_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _executedByMeta =
      const VerificationMeta('executedBy');
  @override
  late final GeneratedColumn<String> executedBy = GeneratedColumn<String>(
      'executed_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        scheduledReportId,
        status,
        filePath,
        errorMessage,
        startedAt,
        completedAt,
        executedBy,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_executions';
  @override
  VerificationContext validateIntegrity(Insertable<ReportExecution> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('scheduled_report_id')) {
      context.handle(
          _scheduledReportIdMeta,
          scheduledReportId.isAcceptableOrUnknown(
              data['scheduled_report_id']!, _scheduledReportIdMeta));
    } else if (isInserting) {
      context.missing(_scheduledReportIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('executed_by')) {
      context.handle(
          _executedByMeta,
          executedBy.isAcceptableOrUnknown(
              data['executed_by']!, _executedByMeta));
    } else if (isInserting) {
      context.missing(_executedByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportExecution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportExecution(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      scheduledReportId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scheduled_report_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path']),
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      executedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}executed_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReportExecutionsTable createAlias(String alias) {
    return $ReportExecutionsTable(attachedDatabase, alias);
  }
}

class ReportExecution extends DataClass implements Insertable<ReportExecution> {
  final String id;
  final String scheduledReportId;
  final String status;
  final String? filePath;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String executedBy;
  final DateTime createdAt;
  const ReportExecution(
      {required this.id,
      required this.scheduledReportId,
      required this.status,
      this.filePath,
      this.errorMessage,
      required this.startedAt,
      this.completedAt,
      required this.executedBy,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['scheduled_report_id'] = Variable<String>(scheduledReportId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['executed_by'] = Variable<String>(executedBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReportExecutionsCompanion toCompanion(bool nullToAbsent) {
    return ReportExecutionsCompanion(
      id: Value(id),
      scheduledReportId: Value(scheduledReportId),
      status: Value(status),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      executedBy: Value(executedBy),
      createdAt: Value(createdAt),
    );
  }

  factory ReportExecution.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportExecution(
      id: serializer.fromJson<String>(json['id']),
      scheduledReportId: serializer.fromJson<String>(json['scheduledReportId']),
      status: serializer.fromJson<String>(json['status']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      executedBy: serializer.fromJson<String>(json['executedBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scheduledReportId': serializer.toJson<String>(scheduledReportId),
      'status': serializer.toJson<String>(status),
      'filePath': serializer.toJson<String?>(filePath),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'executedBy': serializer.toJson<String>(executedBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReportExecution copyWith(
          {String? id,
          String? scheduledReportId,
          String? status,
          Value<String?> filePath = const Value.absent(),
          Value<String?> errorMessage = const Value.absent(),
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          String? executedBy,
          DateTime? createdAt}) =>
      ReportExecution(
        id: id ?? this.id,
        scheduledReportId: scheduledReportId ?? this.scheduledReportId,
        status: status ?? this.status,
        filePath: filePath.present ? filePath.value : this.filePath,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        executedBy: executedBy ?? this.executedBy,
        createdAt: createdAt ?? this.createdAt,
      );
  ReportExecution copyWithCompanion(ReportExecutionsCompanion data) {
    return ReportExecution(
      id: data.id.present ? data.id.value : this.id,
      scheduledReportId: data.scheduledReportId.present
          ? data.scheduledReportId.value
          : this.scheduledReportId,
      status: data.status.present ? data.status.value : this.status,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      executedBy:
          data.executedBy.present ? data.executedBy.value : this.executedBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportExecution(')
          ..write('id: $id, ')
          ..write('scheduledReportId: $scheduledReportId, ')
          ..write('status: $status, ')
          ..write('filePath: $filePath, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('executedBy: $executedBy, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, scheduledReportId, status, filePath,
      errorMessage, startedAt, completedAt, executedBy, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportExecution &&
          other.id == this.id &&
          other.scheduledReportId == this.scheduledReportId &&
          other.status == this.status &&
          other.filePath == this.filePath &&
          other.errorMessage == this.errorMessage &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.executedBy == this.executedBy &&
          other.createdAt == this.createdAt);
}

class ReportExecutionsCompanion extends UpdateCompanion<ReportExecution> {
  final Value<String> id;
  final Value<String> scheduledReportId;
  final Value<String> status;
  final Value<String?> filePath;
  final Value<String?> errorMessage;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String> executedBy;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReportExecutionsCompanion({
    this.id = const Value.absent(),
    this.scheduledReportId = const Value.absent(),
    this.status = const Value.absent(),
    this.filePath = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.executedBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportExecutionsCompanion.insert({
    required String id,
    required String scheduledReportId,
    required String status,
    this.filePath = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required String executedBy,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        scheduledReportId = Value(scheduledReportId),
        status = Value(status),
        startedAt = Value(startedAt),
        executedBy = Value(executedBy),
        createdAt = Value(createdAt);
  static Insertable<ReportExecution> custom({
    Expression<String>? id,
    Expression<String>? scheduledReportId,
    Expression<String>? status,
    Expression<String>? filePath,
    Expression<String>? errorMessage,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? executedBy,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scheduledReportId != null) 'scheduled_report_id': scheduledReportId,
      if (status != null) 'status': status,
      if (filePath != null) 'file_path': filePath,
      if (errorMessage != null) 'error_message': errorMessage,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (executedBy != null) 'executed_by': executedBy,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportExecutionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? scheduledReportId,
      Value<String>? status,
      Value<String?>? filePath,
      Value<String?>? errorMessage,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<String>? executedBy,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ReportExecutionsCompanion(
      id: id ?? this.id,
      scheduledReportId: scheduledReportId ?? this.scheduledReportId,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      errorMessage: errorMessage ?? this.errorMessage,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      executedBy: executedBy ?? this.executedBy,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scheduledReportId.present) {
      map['scheduled_report_id'] = Variable<String>(scheduledReportId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (executedBy.present) {
      map['executed_by'] = Variable<String>(executedBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportExecutionsCompanion(')
          ..write('id: $id, ')
          ..write('scheduledReportId: $scheduledReportId, ')
          ..write('status: $status, ')
          ..write('filePath: $filePath, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('executedBy: $executedBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmailNotificationsTable extends EmailNotifications
    with TableInfo<$EmailNotificationsTable, EmailNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reportExecutionIdMeta =
      const VerificationMeta('reportExecutionId');
  @override
  late final GeneratedColumn<String> reportExecutionId =
      GeneratedColumn<String>('report_execution_id', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientMeta =
      const VerificationMeta('recipient');
  @override
  late final GeneratedColumn<String> recipient = GeneratedColumn<String>(
      'recipient', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subjectMeta =
      const VerificationMeta('subject');
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
      'subject', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
      'sent_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        reportExecutionId,
        recipient,
        subject,
        body,
        status,
        errorMessage,
        sentAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_notifications';
  @override
  VerificationContext validateIntegrity(Insertable<EmailNotification> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('report_execution_id')) {
      context.handle(
          _reportExecutionIdMeta,
          reportExecutionId.isAcceptableOrUnknown(
              data['report_execution_id']!, _reportExecutionIdMeta));
    } else if (isInserting) {
      context.missing(_reportExecutionIdMeta);
    }
    if (data.containsKey('recipient')) {
      context.handle(_recipientMeta,
          recipient.isAcceptableOrUnknown(data['recipient']!, _recipientMeta));
    } else if (isInserting) {
      context.missing(_recipientMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(_subjectMeta,
          subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta));
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('sent_at')) {
      context.handle(_sentAtMeta,
          sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailNotification(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      reportExecutionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}report_execution_id'])!,
      recipient: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipient'])!,
      subject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      sentAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sent_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EmailNotificationsTable createAlias(String alias) {
    return $EmailNotificationsTable(attachedDatabase, alias);
  }
}

class EmailNotification extends DataClass
    implements Insertable<EmailNotification> {
  final String id;
  final String reportExecutionId;
  final String recipient;
  final String subject;
  final String body;
  final String status;
  final String? errorMessage;
  final DateTime? sentAt;
  final DateTime createdAt;
  const EmailNotification(
      {required this.id,
      required this.reportExecutionId,
      required this.recipient,
      required this.subject,
      required this.body,
      required this.status,
      this.errorMessage,
      this.sentAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['report_execution_id'] = Variable<String>(reportExecutionId);
    map['recipient'] = Variable<String>(recipient);
    map['subject'] = Variable<String>(subject);
    map['body'] = Variable<String>(body);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EmailNotificationsCompanion toCompanion(bool nullToAbsent) {
    return EmailNotificationsCompanion(
      id: Value(id),
      reportExecutionId: Value(reportExecutionId),
      recipient: Value(recipient),
      subject: Value(subject),
      body: Value(body),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      sentAt:
          sentAt == null && nullToAbsent ? const Value.absent() : Value(sentAt),
      createdAt: Value(createdAt),
    );
  }

  factory EmailNotification.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailNotification(
      id: serializer.fromJson<String>(json['id']),
      reportExecutionId: serializer.fromJson<String>(json['reportExecutionId']),
      recipient: serializer.fromJson<String>(json['recipient']),
      subject: serializer.fromJson<String>(json['subject']),
      body: serializer.fromJson<String>(json['body']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reportExecutionId': serializer.toJson<String>(reportExecutionId),
      'recipient': serializer.toJson<String>(recipient),
      'subject': serializer.toJson<String>(subject),
      'body': serializer.toJson<String>(body),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EmailNotification copyWith(
          {String? id,
          String? reportExecutionId,
          String? recipient,
          String? subject,
          String? body,
          String? status,
          Value<String?> errorMessage = const Value.absent(),
          Value<DateTime?> sentAt = const Value.absent(),
          DateTime? createdAt}) =>
      EmailNotification(
        id: id ?? this.id,
        reportExecutionId: reportExecutionId ?? this.reportExecutionId,
        recipient: recipient ?? this.recipient,
        subject: subject ?? this.subject,
        body: body ?? this.body,
        status: status ?? this.status,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        sentAt: sentAt.present ? sentAt.value : this.sentAt,
        createdAt: createdAt ?? this.createdAt,
      );
  EmailNotification copyWithCompanion(EmailNotificationsCompanion data) {
    return EmailNotification(
      id: data.id.present ? data.id.value : this.id,
      reportExecutionId: data.reportExecutionId.present
          ? data.reportExecutionId.value
          : this.reportExecutionId,
      recipient: data.recipient.present ? data.recipient.value : this.recipient,
      subject: data.subject.present ? data.subject.value : this.subject,
      body: data.body.present ? data.body.value : this.body,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailNotification(')
          ..write('id: $id, ')
          ..write('reportExecutionId: $reportExecutionId, ')
          ..write('recipient: $recipient, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('sentAt: $sentAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, reportExecutionId, recipient, subject,
      body, status, errorMessage, sentAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailNotification &&
          other.id == this.id &&
          other.reportExecutionId == this.reportExecutionId &&
          other.recipient == this.recipient &&
          other.subject == this.subject &&
          other.body == this.body &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.sentAt == this.sentAt &&
          other.createdAt == this.createdAt);
}

class EmailNotificationsCompanion extends UpdateCompanion<EmailNotification> {
  final Value<String> id;
  final Value<String> reportExecutionId;
  final Value<String> recipient;
  final Value<String> subject;
  final Value<String> body;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<DateTime?> sentAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EmailNotificationsCompanion({
    this.id = const Value.absent(),
    this.reportExecutionId = const Value.absent(),
    this.recipient = const Value.absent(),
    this.subject = const Value.absent(),
    this.body = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmailNotificationsCompanion.insert({
    required String id,
    required String reportExecutionId,
    required String recipient,
    required String subject,
    required String body,
    required String status,
    this.errorMessage = const Value.absent(),
    this.sentAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        reportExecutionId = Value(reportExecutionId),
        recipient = Value(recipient),
        subject = Value(subject),
        body = Value(body),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<EmailNotification> custom({
    Expression<String>? id,
    Expression<String>? reportExecutionId,
    Expression<String>? recipient,
    Expression<String>? subject,
    Expression<String>? body,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<DateTime>? sentAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reportExecutionId != null) 'report_execution_id': reportExecutionId,
      if (recipient != null) 'recipient': recipient,
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (sentAt != null) 'sent_at': sentAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmailNotificationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? reportExecutionId,
      Value<String>? recipient,
      Value<String>? subject,
      Value<String>? body,
      Value<String>? status,
      Value<String?>? errorMessage,
      Value<DateTime?>? sentAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EmailNotificationsCompanion(
      id: id ?? this.id,
      reportExecutionId: reportExecutionId ?? this.reportExecutionId,
      recipient: recipient ?? this.recipient,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reportExecutionId.present) {
      map['report_execution_id'] = Variable<String>(reportExecutionId.value);
    }
    if (recipient.present) {
      map['recipient'] = Variable<String>(recipient.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('reportExecutionId: $reportExecutionId, ')
          ..write('recipient: $recipient, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('sentAt: $sentAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackupsTable extends Backups with TableInfo<$BackupsTable, Backup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checksumMeta =
      const VerificationMeta('checksum');
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
      'checksum', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _encryptionKeyMeta =
      const VerificationMeta('encryptionKey');
  @override
  late final GeneratedColumn<String> encryptionKey = GeneratedColumn<String>(
      'encryption_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isEncryptedMeta =
      const VerificationMeta('isEncrypted');
  @override
  late final GeneratedColumn<bool> isEncrypted = GeneratedColumn<bool>(
      'is_encrypted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_encrypted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCompressedMeta =
      const VerificationMeta('isCompressed');
  @override
  late final GeneratedColumn<bool> isCompressed = GeneratedColumn<bool>(
      'is_compressed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_compressed" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        type,
        filePath,
        fileSize,
        checksum,
        encryptionKey,
        isEncrypted,
        isCompressed,
        status,
        errorMessage,
        startedAt,
        completedAt,
        createdBy,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backups';
  @override
  VerificationContext validateIntegrity(Insertable<Backup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('checksum')) {
      context.handle(_checksumMeta,
          checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta));
    } else if (isInserting) {
      context.missing(_checksumMeta);
    }
    if (data.containsKey('encryption_key')) {
      context.handle(
          _encryptionKeyMeta,
          encryptionKey.isAcceptableOrUnknown(
              data['encryption_key']!, _encryptionKeyMeta));
    }
    if (data.containsKey('is_encrypted')) {
      context.handle(
          _isEncryptedMeta,
          isEncrypted.isAcceptableOrUnknown(
              data['is_encrypted']!, _isEncryptedMeta));
    }
    if (data.containsKey('is_compressed')) {
      context.handle(
          _isCompressedMeta,
          isCompressed.isAcceptableOrUnknown(
              data['is_compressed']!, _isCompressedMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Backup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Backup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      checksum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checksum'])!,
      encryptionKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encryption_key']),
      isEncrypted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_encrypted'])!,
      isCompressed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_compressed'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BackupsTable createAlias(String alias) {
    return $BackupsTable(attachedDatabase, alias);
  }
}

class Backup extends DataClass implements Insertable<Backup> {
  final String id;
  final String name;
  final String description;
  final String type;
  final String filePath;
  final int fileSize;
  final String checksum;
  final String? encryptionKey;
  final bool isEncrypted;
  final bool isCompressed;
  final String status;
  final String? errorMessage;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Backup(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required this.filePath,
      required this.fileSize,
      required this.checksum,
      this.encryptionKey,
      required this.isEncrypted,
      required this.isCompressed,
      required this.status,
      this.errorMessage,
      required this.startedAt,
      this.completedAt,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    map['file_path'] = Variable<String>(filePath);
    map['file_size'] = Variable<int>(fileSize);
    map['checksum'] = Variable<String>(checksum);
    if (!nullToAbsent || encryptionKey != null) {
      map['encryption_key'] = Variable<String>(encryptionKey);
    }
    map['is_encrypted'] = Variable<bool>(isEncrypted);
    map['is_compressed'] = Variable<bool>(isCompressed);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BackupsCompanion toCompanion(bool nullToAbsent) {
    return BackupsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      type: Value(type),
      filePath: Value(filePath),
      fileSize: Value(fileSize),
      checksum: Value(checksum),
      encryptionKey: encryptionKey == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptionKey),
      isEncrypted: Value(isEncrypted),
      isCompressed: Value(isCompressed),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Backup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Backup(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      checksum: serializer.fromJson<String>(json['checksum']),
      encryptionKey: serializer.fromJson<String?>(json['encryptionKey']),
      isEncrypted: serializer.fromJson<bool>(json['isEncrypted']),
      isCompressed: serializer.fromJson<bool>(json['isCompressed']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
      'filePath': serializer.toJson<String>(filePath),
      'fileSize': serializer.toJson<int>(fileSize),
      'checksum': serializer.toJson<String>(checksum),
      'encryptionKey': serializer.toJson<String?>(encryptionKey),
      'isEncrypted': serializer.toJson<bool>(isEncrypted),
      'isCompressed': serializer.toJson<bool>(isCompressed),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Backup copyWith(
          {String? id,
          String? name,
          String? description,
          String? type,
          String? filePath,
          int? fileSize,
          String? checksum,
          Value<String?> encryptionKey = const Value.absent(),
          bool? isEncrypted,
          bool? isCompressed,
          String? status,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          String? createdBy,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Backup(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        type: type ?? this.type,
        filePath: filePath ?? this.filePath,
        fileSize: fileSize ?? this.fileSize,
        checksum: checksum ?? this.checksum,
        encryptionKey:
            encryptionKey.present ? encryptionKey.value : this.encryptionKey,
        isEncrypted: isEncrypted ?? this.isEncrypted,
        isCompressed: isCompressed ?? this.isCompressed,
        status: status ?? this.status,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Backup copyWithCompanion(BackupsCompanion data) {
    return Backup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      encryptionKey: data.encryptionKey.present
          ? data.encryptionKey.value
          : this.encryptionKey,
      isEncrypted:
          data.isEncrypted.present ? data.isEncrypted.value : this.isEncrypted,
      isCompressed: data.isCompressed.present
          ? data.isCompressed.value
          : this.isCompressed,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Backup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('checksum: $checksum, ')
          ..write('encryptionKey: $encryptionKey, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('isCompressed: $isCompressed, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      type,
      filePath,
      fileSize,
      checksum,
      encryptionKey,
      isEncrypted,
      isCompressed,
      status,
      errorMessage,
      startedAt,
      completedAt,
      createdBy,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Backup &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.type == this.type &&
          other.filePath == this.filePath &&
          other.fileSize == this.fileSize &&
          other.checksum == this.checksum &&
          other.encryptionKey == this.encryptionKey &&
          other.isEncrypted == this.isEncrypted &&
          other.isCompressed == this.isCompressed &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BackupsCompanion extends UpdateCompanion<Backup> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> type;
  final Value<String> filePath;
  final Value<int> fileSize;
  final Value<String> checksum;
  final Value<String?> encryptionKey;
  final Value<bool> isEncrypted;
  final Value<bool> isCompressed;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BackupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.checksum = const Value.absent(),
    this.encryptionKey = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.isCompressed = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupsCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String type,
    required String filePath,
    required int fileSize,
    required String checksum,
    this.encryptionKey = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.isCompressed = const Value.absent(),
    required String status,
    this.errorMessage = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        type = Value(type),
        filePath = Value(filePath),
        fileSize = Value(fileSize),
        checksum = Value(checksum),
        status = Value(status),
        startedAt = Value(startedAt),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Backup> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? type,
    Expression<String>? filePath,
    Expression<int>? fileSize,
    Expression<String>? checksum,
    Expression<String>? encryptionKey,
    Expression<bool>? isEncrypted,
    Expression<bool>? isCompressed,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (filePath != null) 'file_path': filePath,
      if (fileSize != null) 'file_size': fileSize,
      if (checksum != null) 'checksum': checksum,
      if (encryptionKey != null) 'encryption_key': encryptionKey,
      if (isEncrypted != null) 'is_encrypted': isEncrypted,
      if (isCompressed != null) 'is_compressed': isCompressed,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? type,
      Value<String>? filePath,
      Value<int>? fileSize,
      Value<String>? checksum,
      Value<String?>? encryptionKey,
      Value<bool>? isEncrypted,
      Value<bool>? isCompressed,
      Value<String>? status,
      Value<String?>? errorMessage,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BackupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      checksum: checksum ?? this.checksum,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      isCompressed: isCompressed ?? this.isCompressed,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (encryptionKey.present) {
      map['encryption_key'] = Variable<String>(encryptionKey.value);
    }
    if (isEncrypted.present) {
      map['is_encrypted'] = Variable<bool>(isEncrypted.value);
    }
    if (isCompressed.present) {
      map['is_compressed'] = Variable<bool>(isCompressed.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('checksum: $checksum, ')
          ..write('encryptionKey: $encryptionKey, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('isCompressed: $isCompressed, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackupJobsTable extends BackupJobs
    with TableInfo<$BackupJobsTable, BackupJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _backupTypeMeta =
      const VerificationMeta('backupType');
  @override
  late final GeneratedColumn<String> backupType = GeneratedColumn<String>(
      'backup_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleTypeMeta =
      const VerificationMeta('scheduleType');
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
      'schedule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleConfigMeta =
      const VerificationMeta('scheduleConfig');
  @override
  late final GeneratedColumn<String> scheduleConfig = GeneratedColumn<String>(
      'schedule_config', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retentionPolicyMeta =
      const VerificationMeta('retentionPolicy');
  @override
  late final GeneratedColumn<String> retentionPolicy = GeneratedColumn<String>(
      'retention_policy', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetPathMeta =
      const VerificationMeta('targetPath');
  @override
  late final GeneratedColumn<String> targetPath = GeneratedColumn<String>(
      'target_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isEncryptedMeta =
      const VerificationMeta('isEncrypted');
  @override
  late final GeneratedColumn<bool> isEncrypted = GeneratedColumn<bool>(
      'is_encrypted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_encrypted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCompressedMeta =
      const VerificationMeta('isCompressed');
  @override
  late final GeneratedColumn<bool> isCompressed = GeneratedColumn<bool>(
      'is_compressed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_compressed" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _nextRunAtMeta =
      const VerificationMeta('nextRunAt');
  @override
  late final GeneratedColumn<DateTime> nextRunAt = GeneratedColumn<DateTime>(
      'next_run_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastRunAtMeta =
      const VerificationMeta('lastRunAt');
  @override
  late final GeneratedColumn<DateTime> lastRunAt = GeneratedColumn<DateTime>(
      'last_run_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastBackupIdMeta =
      const VerificationMeta('lastBackupId');
  @override
  late final GeneratedColumn<String> lastBackupId = GeneratedColumn<String>(
      'last_backup_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        backupType,
        scheduleType,
        scheduleConfig,
        retentionPolicy,
        targetPath,
        isEncrypted,
        isCompressed,
        isActive,
        nextRunAt,
        lastRunAt,
        lastBackupId,
        createdBy,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_jobs';
  @override
  VerificationContext validateIntegrity(Insertable<BackupJob> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('backup_type')) {
      context.handle(
          _backupTypeMeta,
          backupType.isAcceptableOrUnknown(
              data['backup_type']!, _backupTypeMeta));
    } else if (isInserting) {
      context.missing(_backupTypeMeta);
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
          _scheduleTypeMeta,
          scheduleType.isAcceptableOrUnknown(
              data['schedule_type']!, _scheduleTypeMeta));
    } else if (isInserting) {
      context.missing(_scheduleTypeMeta);
    }
    if (data.containsKey('schedule_config')) {
      context.handle(
          _scheduleConfigMeta,
          scheduleConfig.isAcceptableOrUnknown(
              data['schedule_config']!, _scheduleConfigMeta));
    } else if (isInserting) {
      context.missing(_scheduleConfigMeta);
    }
    if (data.containsKey('retention_policy')) {
      context.handle(
          _retentionPolicyMeta,
          retentionPolicy.isAcceptableOrUnknown(
              data['retention_policy']!, _retentionPolicyMeta));
    } else if (isInserting) {
      context.missing(_retentionPolicyMeta);
    }
    if (data.containsKey('target_path')) {
      context.handle(
          _targetPathMeta,
          targetPath.isAcceptableOrUnknown(
              data['target_path']!, _targetPathMeta));
    } else if (isInserting) {
      context.missing(_targetPathMeta);
    }
    if (data.containsKey('is_encrypted')) {
      context.handle(
          _isEncryptedMeta,
          isEncrypted.isAcceptableOrUnknown(
              data['is_encrypted']!, _isEncryptedMeta));
    }
    if (data.containsKey('is_compressed')) {
      context.handle(
          _isCompressedMeta,
          isCompressed.isAcceptableOrUnknown(
              data['is_compressed']!, _isCompressedMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('next_run_at')) {
      context.handle(
          _nextRunAtMeta,
          nextRunAt.isAcceptableOrUnknown(
              data['next_run_at']!, _nextRunAtMeta));
    } else if (isInserting) {
      context.missing(_nextRunAtMeta);
    }
    if (data.containsKey('last_run_at')) {
      context.handle(
          _lastRunAtMeta,
          lastRunAt.isAcceptableOrUnknown(
              data['last_run_at']!, _lastRunAtMeta));
    }
    if (data.containsKey('last_backup_id')) {
      context.handle(
          _lastBackupIdMeta,
          lastBackupId.isAcceptableOrUnknown(
              data['last_backup_id']!, _lastBackupIdMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BackupJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupJob(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      backupType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}backup_type'])!,
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      scheduleConfig: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}schedule_config'])!,
      retentionPolicy: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}retention_policy'])!,
      targetPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_path'])!,
      isEncrypted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_encrypted'])!,
      isCompressed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_compressed'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      nextRunAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_run_at'])!,
      lastRunAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_run_at']),
      lastBackupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_backup_id']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BackupJobsTable createAlias(String alias) {
    return $BackupJobsTable(attachedDatabase, alias);
  }
}

class BackupJob extends DataClass implements Insertable<BackupJob> {
  final String id;
  final String name;
  final String description;
  final String backupType;
  final String scheduleType;
  final String scheduleConfig;
  final String retentionPolicy;
  final String targetPath;
  final bool isEncrypted;
  final bool isCompressed;
  final bool isActive;
  final DateTime nextRunAt;
  final DateTime? lastRunAt;
  final String? lastBackupId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BackupJob(
      {required this.id,
      required this.name,
      required this.description,
      required this.backupType,
      required this.scheduleType,
      required this.scheduleConfig,
      required this.retentionPolicy,
      required this.targetPath,
      required this.isEncrypted,
      required this.isCompressed,
      required this.isActive,
      required this.nextRunAt,
      this.lastRunAt,
      this.lastBackupId,
      required this.createdBy,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['backup_type'] = Variable<String>(backupType);
    map['schedule_type'] = Variable<String>(scheduleType);
    map['schedule_config'] = Variable<String>(scheduleConfig);
    map['retention_policy'] = Variable<String>(retentionPolicy);
    map['target_path'] = Variable<String>(targetPath);
    map['is_encrypted'] = Variable<bool>(isEncrypted);
    map['is_compressed'] = Variable<bool>(isCompressed);
    map['is_active'] = Variable<bool>(isActive);
    map['next_run_at'] = Variable<DateTime>(nextRunAt);
    if (!nullToAbsent || lastRunAt != null) {
      map['last_run_at'] = Variable<DateTime>(lastRunAt);
    }
    if (!nullToAbsent || lastBackupId != null) {
      map['last_backup_id'] = Variable<String>(lastBackupId);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BackupJobsCompanion toCompanion(bool nullToAbsent) {
    return BackupJobsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      backupType: Value(backupType),
      scheduleType: Value(scheduleType),
      scheduleConfig: Value(scheduleConfig),
      retentionPolicy: Value(retentionPolicy),
      targetPath: Value(targetPath),
      isEncrypted: Value(isEncrypted),
      isCompressed: Value(isCompressed),
      isActive: Value(isActive),
      nextRunAt: Value(nextRunAt),
      lastRunAt: lastRunAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRunAt),
      lastBackupId: lastBackupId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBackupId),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BackupJob.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupJob(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      backupType: serializer.fromJson<String>(json['backupType']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      scheduleConfig: serializer.fromJson<String>(json['scheduleConfig']),
      retentionPolicy: serializer.fromJson<String>(json['retentionPolicy']),
      targetPath: serializer.fromJson<String>(json['targetPath']),
      isEncrypted: serializer.fromJson<bool>(json['isEncrypted']),
      isCompressed: serializer.fromJson<bool>(json['isCompressed']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      nextRunAt: serializer.fromJson<DateTime>(json['nextRunAt']),
      lastRunAt: serializer.fromJson<DateTime?>(json['lastRunAt']),
      lastBackupId: serializer.fromJson<String?>(json['lastBackupId']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'backupType': serializer.toJson<String>(backupType),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'scheduleConfig': serializer.toJson<String>(scheduleConfig),
      'retentionPolicy': serializer.toJson<String>(retentionPolicy),
      'targetPath': serializer.toJson<String>(targetPath),
      'isEncrypted': serializer.toJson<bool>(isEncrypted),
      'isCompressed': serializer.toJson<bool>(isCompressed),
      'isActive': serializer.toJson<bool>(isActive),
      'nextRunAt': serializer.toJson<DateTime>(nextRunAt),
      'lastRunAt': serializer.toJson<DateTime?>(lastRunAt),
      'lastBackupId': serializer.toJson<String?>(lastBackupId),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BackupJob copyWith(
          {String? id,
          String? name,
          String? description,
          String? backupType,
          String? scheduleType,
          String? scheduleConfig,
          String? retentionPolicy,
          String? targetPath,
          bool? isEncrypted,
          bool? isCompressed,
          bool? isActive,
          DateTime? nextRunAt,
          Value<DateTime?> lastRunAt = const Value.absent(),
          Value<String?> lastBackupId = const Value.absent(),
          String? createdBy,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BackupJob(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        backupType: backupType ?? this.backupType,
        scheduleType: scheduleType ?? this.scheduleType,
        scheduleConfig: scheduleConfig ?? this.scheduleConfig,
        retentionPolicy: retentionPolicy ?? this.retentionPolicy,
        targetPath: targetPath ?? this.targetPath,
        isEncrypted: isEncrypted ?? this.isEncrypted,
        isCompressed: isCompressed ?? this.isCompressed,
        isActive: isActive ?? this.isActive,
        nextRunAt: nextRunAt ?? this.nextRunAt,
        lastRunAt: lastRunAt.present ? lastRunAt.value : this.lastRunAt,
        lastBackupId:
            lastBackupId.present ? lastBackupId.value : this.lastBackupId,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BackupJob copyWithCompanion(BackupJobsCompanion data) {
    return BackupJob(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      backupType:
          data.backupType.present ? data.backupType.value : this.backupType,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      scheduleConfig: data.scheduleConfig.present
          ? data.scheduleConfig.value
          : this.scheduleConfig,
      retentionPolicy: data.retentionPolicy.present
          ? data.retentionPolicy.value
          : this.retentionPolicy,
      targetPath:
          data.targetPath.present ? data.targetPath.value : this.targetPath,
      isEncrypted:
          data.isEncrypted.present ? data.isEncrypted.value : this.isEncrypted,
      isCompressed: data.isCompressed.present
          ? data.isCompressed.value
          : this.isCompressed,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      nextRunAt: data.nextRunAt.present ? data.nextRunAt.value : this.nextRunAt,
      lastRunAt: data.lastRunAt.present ? data.lastRunAt.value : this.lastRunAt,
      lastBackupId: data.lastBackupId.present
          ? data.lastBackupId.value
          : this.lastBackupId,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupJob(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('backupType: $backupType, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('scheduleConfig: $scheduleConfig, ')
          ..write('retentionPolicy: $retentionPolicy, ')
          ..write('targetPath: $targetPath, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('isCompressed: $isCompressed, ')
          ..write('isActive: $isActive, ')
          ..write('nextRunAt: $nextRunAt, ')
          ..write('lastRunAt: $lastRunAt, ')
          ..write('lastBackupId: $lastBackupId, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      backupType,
      scheduleType,
      scheduleConfig,
      retentionPolicy,
      targetPath,
      isEncrypted,
      isCompressed,
      isActive,
      nextRunAt,
      lastRunAt,
      lastBackupId,
      createdBy,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupJob &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.backupType == this.backupType &&
          other.scheduleType == this.scheduleType &&
          other.scheduleConfig == this.scheduleConfig &&
          other.retentionPolicy == this.retentionPolicy &&
          other.targetPath == this.targetPath &&
          other.isEncrypted == this.isEncrypted &&
          other.isCompressed == this.isCompressed &&
          other.isActive == this.isActive &&
          other.nextRunAt == this.nextRunAt &&
          other.lastRunAt == this.lastRunAt &&
          other.lastBackupId == this.lastBackupId &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BackupJobsCompanion extends UpdateCompanion<BackupJob> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> backupType;
  final Value<String> scheduleType;
  final Value<String> scheduleConfig;
  final Value<String> retentionPolicy;
  final Value<String> targetPath;
  final Value<bool> isEncrypted;
  final Value<bool> isCompressed;
  final Value<bool> isActive;
  final Value<DateTime> nextRunAt;
  final Value<DateTime?> lastRunAt;
  final Value<String?> lastBackupId;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BackupJobsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.backupType = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.scheduleConfig = const Value.absent(),
    this.retentionPolicy = const Value.absent(),
    this.targetPath = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.isCompressed = const Value.absent(),
    this.isActive = const Value.absent(),
    this.nextRunAt = const Value.absent(),
    this.lastRunAt = const Value.absent(),
    this.lastBackupId = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupJobsCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String backupType,
    required String scheduleType,
    required String scheduleConfig,
    required String retentionPolicy,
    required String targetPath,
    this.isEncrypted = const Value.absent(),
    this.isCompressed = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime nextRunAt,
    this.lastRunAt = const Value.absent(),
    this.lastBackupId = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        backupType = Value(backupType),
        scheduleType = Value(scheduleType),
        scheduleConfig = Value(scheduleConfig),
        retentionPolicy = Value(retentionPolicy),
        targetPath = Value(targetPath),
        nextRunAt = Value(nextRunAt),
        createdBy = Value(createdBy),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<BackupJob> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? backupType,
    Expression<String>? scheduleType,
    Expression<String>? scheduleConfig,
    Expression<String>? retentionPolicy,
    Expression<String>? targetPath,
    Expression<bool>? isEncrypted,
    Expression<bool>? isCompressed,
    Expression<bool>? isActive,
    Expression<DateTime>? nextRunAt,
    Expression<DateTime>? lastRunAt,
    Expression<String>? lastBackupId,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (backupType != null) 'backup_type': backupType,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (scheduleConfig != null) 'schedule_config': scheduleConfig,
      if (retentionPolicy != null) 'retention_policy': retentionPolicy,
      if (targetPath != null) 'target_path': targetPath,
      if (isEncrypted != null) 'is_encrypted': isEncrypted,
      if (isCompressed != null) 'is_compressed': isCompressed,
      if (isActive != null) 'is_active': isActive,
      if (nextRunAt != null) 'next_run_at': nextRunAt,
      if (lastRunAt != null) 'last_run_at': lastRunAt,
      if (lastBackupId != null) 'last_backup_id': lastBackupId,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupJobsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? backupType,
      Value<String>? scheduleType,
      Value<String>? scheduleConfig,
      Value<String>? retentionPolicy,
      Value<String>? targetPath,
      Value<bool>? isEncrypted,
      Value<bool>? isCompressed,
      Value<bool>? isActive,
      Value<DateTime>? nextRunAt,
      Value<DateTime?>? lastRunAt,
      Value<String?>? lastBackupId,
      Value<String>? createdBy,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BackupJobsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      backupType: backupType ?? this.backupType,
      scheduleType: scheduleType ?? this.scheduleType,
      scheduleConfig: scheduleConfig ?? this.scheduleConfig,
      retentionPolicy: retentionPolicy ?? this.retentionPolicy,
      targetPath: targetPath ?? this.targetPath,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      isCompressed: isCompressed ?? this.isCompressed,
      isActive: isActive ?? this.isActive,
      nextRunAt: nextRunAt ?? this.nextRunAt,
      lastRunAt: lastRunAt ?? this.lastRunAt,
      lastBackupId: lastBackupId ?? this.lastBackupId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (backupType.present) {
      map['backup_type'] = Variable<String>(backupType.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (scheduleConfig.present) {
      map['schedule_config'] = Variable<String>(scheduleConfig.value);
    }
    if (retentionPolicy.present) {
      map['retention_policy'] = Variable<String>(retentionPolicy.value);
    }
    if (targetPath.present) {
      map['target_path'] = Variable<String>(targetPath.value);
    }
    if (isEncrypted.present) {
      map['is_encrypted'] = Variable<bool>(isEncrypted.value);
    }
    if (isCompressed.present) {
      map['is_compressed'] = Variable<bool>(isCompressed.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (nextRunAt.present) {
      map['next_run_at'] = Variable<DateTime>(nextRunAt.value);
    }
    if (lastRunAt.present) {
      map['last_run_at'] = Variable<DateTime>(lastRunAt.value);
    }
    if (lastBackupId.present) {
      map['last_backup_id'] = Variable<String>(lastBackupId.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupJobsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('backupType: $backupType, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('scheduleConfig: $scheduleConfig, ')
          ..write('retentionPolicy: $retentionPolicy, ')
          ..write('targetPath: $targetPath, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('isCompressed: $isCompressed, ')
          ..write('isActive: $isActive, ')
          ..write('nextRunAt: $nextRunAt, ')
          ..write('lastRunAt: $lastRunAt, ')
          ..write('lastBackupId: $lastBackupId, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutesTable extends Routes with TableInfo<$RoutesTable, Route> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _routeTypeMeta =
      const VerificationMeta('routeType');
  @override
  late final GeneratedColumn<String> routeType = GeneratedColumn<String>(
      'route_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _distanceMeta =
      const VerificationMeta('distance');
  @override
  late final GeneratedColumn<String> distance = GeneratedColumn<String>(
      'distance', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
      'duration', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        routeType,
        distance,
        duration,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(Insertable<Route> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('route_type')) {
      context.handle(_routeTypeMeta,
          routeType.isAcceptableOrUnknown(data['route_type']!, _routeTypeMeta));
    } else if (isInserting) {
      context.missing(_routeTypeMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    } else if (isInserting) {
      context.missing(_distanceMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Route map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Route(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      routeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route_type'])!,
      distance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}distance'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}duration'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RoutesTable createAlias(String alias) {
    return $RoutesTable(attachedDatabase, alias);
  }
}

class Route extends DataClass implements Insertable<Route> {
  final String id;
  final String name;
  final String description;
  final String routeType;
  final String distance;
  final String duration;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Route(
      {required this.id,
      required this.name,
      required this.description,
      required this.routeType,
      required this.distance,
      required this.duration,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['route_type'] = Variable<String>(routeType);
    map['distance'] = Variable<String>(distance);
    map['duration'] = Variable<String>(duration);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutesCompanion toCompanion(bool nullToAbsent) {
    return RoutesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      routeType: Value(routeType),
      distance: Value(distance),
      duration: Value(duration),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Route.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Route(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      routeType: serializer.fromJson<String>(json['routeType']),
      distance: serializer.fromJson<String>(json['distance']),
      duration: serializer.fromJson<String>(json['duration']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'routeType': serializer.toJson<String>(routeType),
      'distance': serializer.toJson<String>(distance),
      'duration': serializer.toJson<String>(duration),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Route copyWith(
          {String? id,
          String? name,
          String? description,
          String? routeType,
          String? distance,
          String? duration,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Route(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        routeType: routeType ?? this.routeType,
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Route copyWithCompanion(RoutesCompanion data) {
    return Route(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      routeType: data.routeType.present ? data.routeType.value : this.routeType,
      distance: data.distance.present ? data.distance.value : this.distance,
      duration: data.duration.present ? data.duration.value : this.duration,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Route(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('routeType: $routeType, ')
          ..write('distance: $distance, ')
          ..write('duration: $duration, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, routeType, distance,
      duration, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Route &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.routeType == this.routeType &&
          other.distance == this.distance &&
          other.duration == this.duration &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutesCompanion extends UpdateCompanion<Route> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> routeType;
  final Value<String> distance;
  final Value<String> duration;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.routeType = const Value.absent(),
    this.distance = const Value.absent(),
    this.duration = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutesCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String routeType,
    required String distance,
    required String duration,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        description = Value(description),
        routeType = Value(routeType),
        distance = Value(distance),
        duration = Value(duration),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Route> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? routeType,
    Expression<String>? distance,
    Expression<String>? duration,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (routeType != null) 'route_type': routeType,
      if (distance != null) 'distance': distance,
      if (duration != null) 'duration': duration,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? routeType,
      Value<String>? distance,
      Value<String>? duration,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RoutesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      routeType: routeType ?? this.routeType,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (routeType.present) {
      map['route_type'] = Variable<String>(routeType.value);
    }
    if (distance.present) {
      map['distance'] = Variable<String>(distance.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('routeType: $routeType, ')
          ..write('distance: $distance, ')
          ..write('duration: $duration, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RouteHistoryTable extends RouteHistory
    with TableInfo<$RouteHistoryTable, RouteHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RouteHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _routeIdMeta =
      const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<String> routeId = GeneratedColumn<String>(
      'route_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _driverIdMeta =
      const VerificationMeta('driverId');
  @override
  late final GeneratedColumn<String> driverId = GeneratedColumn<String>(
      'driver_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vehicleIdMeta =
      const VerificationMeta('vehicleId');
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
      'vehicle_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        routeId,
        driverId,
        vehicleId,
        startDate,
        endDate,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'route_history';
  @override
  VerificationContext validateIntegrity(Insertable<RouteHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta,
          routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('driver_id')) {
      context.handle(_driverIdMeta,
          driverId.isAcceptableOrUnknown(data['driver_id']!, _driverIdMeta));
    } else if (isInserting) {
      context.missing(_driverIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(_vehicleIdMeta,
          vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta));
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RouteHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RouteHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      routeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route_id'])!,
      driverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}driver_id'])!,
      vehicleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vehicle_id'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RouteHistoryTable createAlias(String alias) {
    return $RouteHistoryTable(attachedDatabase, alias);
  }
}

class RouteHistoryData extends DataClass
    implements Insertable<RouteHistoryData> {
  final String id;
  final String routeId;
  final String driverId;
  final String vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RouteHistoryData(
      {required this.id,
      required this.routeId,
      required this.driverId,
      required this.vehicleId,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['route_id'] = Variable<String>(routeId);
    map['driver_id'] = Variable<String>(driverId);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RouteHistoryCompanion toCompanion(bool nullToAbsent) {
    return RouteHistoryCompanion(
      id: Value(id),
      routeId: Value(routeId),
      driverId: Value(driverId),
      vehicleId: Value(vehicleId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RouteHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RouteHistoryData(
      id: serializer.fromJson<String>(json['id']),
      routeId: serializer.fromJson<String>(json['routeId']),
      driverId: serializer.fromJson<String>(json['driverId']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routeId': serializer.toJson<String>(routeId),
      'driverId': serializer.toJson<String>(driverId),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RouteHistoryData copyWith(
          {String? id,
          String? routeId,
          String? driverId,
          String? vehicleId,
          DateTime? startDate,
          DateTime? endDate,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      RouteHistoryData(
        id: id ?? this.id,
        routeId: routeId ?? this.routeId,
        driverId: driverId ?? this.driverId,
        vehicleId: vehicleId ?? this.vehicleId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RouteHistoryData copyWithCompanion(RouteHistoryCompanion data) {
    return RouteHistoryData(
      id: data.id.present ? data.id.value : this.id,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      driverId: data.driverId.present ? data.driverId.value : this.driverId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RouteHistoryData(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('driverId: $driverId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routeId, driverId, vehicleId, startDate,
      endDate, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RouteHistoryData &&
          other.id == this.id &&
          other.routeId == this.routeId &&
          other.driverId == this.driverId &&
          other.vehicleId == this.vehicleId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RouteHistoryCompanion extends UpdateCompanion<RouteHistoryData> {
  final Value<String> id;
  final Value<String> routeId;
  final Value<String> driverId;
  final Value<String> vehicleId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RouteHistoryCompanion({
    this.id = const Value.absent(),
    this.routeId = const Value.absent(),
    this.driverId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RouteHistoryCompanion.insert({
    required String id,
    required String routeId,
    required String driverId,
    required String vehicleId,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        routeId = Value(routeId),
        driverId = Value(driverId),
        vehicleId = Value(vehicleId),
        startDate = Value(startDate),
        endDate = Value(endDate),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RouteHistoryData> custom({
    Expression<String>? id,
    Expression<String>? routeId,
    Expression<String>? driverId,
    Expression<String>? vehicleId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routeId != null) 'route_id': routeId,
      if (driverId != null) 'driver_id': driverId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RouteHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? routeId,
      Value<String>? driverId,
      Value<String>? vehicleId,
      Value<DateTime>? startDate,
      Value<DateTime>? endDate,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RouteHistoryCompanion(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<String>(routeId.value);
    }
    if (driverId.present) {
      map['driver_id'] = Variable<String>(driverId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RouteHistoryCompanion(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('driverId: $driverId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FuelEntriesTable extends FuelEntries
    with TableInfo<$FuelEntriesTable, FuelEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vehicleIdMeta =
      const VerificationMeta('vehicleId');
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
      'vehicle_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fuelTypeMeta =
      const VerificationMeta('fuelType');
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
      'fuel_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityLitersMeta =
      const VerificationMeta('quantityLiters');
  @override
  late final GeneratedColumn<double> quantityLiters = GeneratedColumn<double>(
      'quantity_liters', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costPerLiterMeta =
      const VerificationMeta('costPerLiter');
  @override
  late final GeneratedColumn<double> costPerLiter = GeneratedColumn<double>(
      'cost_per_liter', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalCostMeta =
      const VerificationMeta('totalCost');
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
      'total_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _odometerReadingMeta =
      const VerificationMeta('odometerReading');
  @override
  late final GeneratedColumn<double> odometerReading = GeneratedColumn<double>(
      'odometer_reading', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fuelPumpNameMeta =
      const VerificationMeta('fuelPumpName');
  @override
  late final GeneratedColumn<String> fuelPumpName = GeneratedColumn<String>(
      'fuel_pump_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entryDateMeta =
      const VerificationMeta('entryDate');
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
      'entry_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        vehicleId,
        fuelType,
        quantityLiters,
        costPerLiter,
        totalCost,
        odometerReading,
        fuelPumpName,
        entryDate,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_entries';
  @override
  VerificationContext validateIntegrity(Insertable<FuelEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(_vehicleIdMeta,
          vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta));
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('fuel_type')) {
      context.handle(_fuelTypeMeta,
          fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta));
    } else if (isInserting) {
      context.missing(_fuelTypeMeta);
    }
    if (data.containsKey('quantity_liters')) {
      context.handle(
          _quantityLitersMeta,
          quantityLiters.isAcceptableOrUnknown(
              data['quantity_liters']!, _quantityLitersMeta));
    } else if (isInserting) {
      context.missing(_quantityLitersMeta);
    }
    if (data.containsKey('cost_per_liter')) {
      context.handle(
          _costPerLiterMeta,
          costPerLiter.isAcceptableOrUnknown(
              data['cost_per_liter']!, _costPerLiterMeta));
    } else if (isInserting) {
      context.missing(_costPerLiterMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(_totalCostMeta,
          totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta));
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('odometer_reading')) {
      context.handle(
          _odometerReadingMeta,
          odometerReading.isAcceptableOrUnknown(
              data['odometer_reading']!, _odometerReadingMeta));
    } else if (isInserting) {
      context.missing(_odometerReadingMeta);
    }
    if (data.containsKey('fuel_pump_name')) {
      context.handle(
          _fuelPumpNameMeta,
          fuelPumpName.isAcceptableOrUnknown(
              data['fuel_pump_name']!, _fuelPumpNameMeta));
    }
    if (data.containsKey('entry_date')) {
      context.handle(_entryDateMeta,
          entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta));
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FuelEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      vehicleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vehicle_id'])!,
      fuelType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fuel_type'])!,
      quantityLiters: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_liters'])!,
      costPerLiter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_per_liter'])!,
      totalCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cost'])!,
      odometerReading: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}odometer_reading'])!,
      fuelPumpName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fuel_pump_name']),
      entryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}entry_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FuelEntriesTable createAlias(String alias) {
    return $FuelEntriesTable(attachedDatabase, alias);
  }
}

class FuelEntry extends DataClass implements Insertable<FuelEntry> {
  final String id;
  final String vehicleId;
  final String fuelType;
  final double quantityLiters;
  final double costPerLiter;
  final double totalCost;
  final double odometerReading;
  final String? fuelPumpName;
  final DateTime entryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FuelEntry(
      {required this.id,
      required this.vehicleId,
      required this.fuelType,
      required this.quantityLiters,
      required this.costPerLiter,
      required this.totalCost,
      required this.odometerReading,
      this.fuelPumpName,
      required this.entryDate,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['fuel_type'] = Variable<String>(fuelType);
    map['quantity_liters'] = Variable<double>(quantityLiters);
    map['cost_per_liter'] = Variable<double>(costPerLiter);
    map['total_cost'] = Variable<double>(totalCost);
    map['odometer_reading'] = Variable<double>(odometerReading);
    if (!nullToAbsent || fuelPumpName != null) {
      map['fuel_pump_name'] = Variable<String>(fuelPumpName);
    }
    map['entry_date'] = Variable<DateTime>(entryDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FuelEntriesCompanion toCompanion(bool nullToAbsent) {
    return FuelEntriesCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      fuelType: Value(fuelType),
      quantityLiters: Value(quantityLiters),
      costPerLiter: Value(costPerLiter),
      totalCost: Value(totalCost),
      odometerReading: Value(odometerReading),
      fuelPumpName: fuelPumpName == null && nullToAbsent
          ? const Value.absent()
          : Value(fuelPumpName),
      entryDate: Value(entryDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FuelEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelEntry(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      quantityLiters: serializer.fromJson<double>(json['quantityLiters']),
      costPerLiter: serializer.fromJson<double>(json['costPerLiter']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      odometerReading: serializer.fromJson<double>(json['odometerReading']),
      fuelPumpName: serializer.fromJson<String?>(json['fuelPumpName']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'fuelType': serializer.toJson<String>(fuelType),
      'quantityLiters': serializer.toJson<double>(quantityLiters),
      'costPerLiter': serializer.toJson<double>(costPerLiter),
      'totalCost': serializer.toJson<double>(totalCost),
      'odometerReading': serializer.toJson<double>(odometerReading),
      'fuelPumpName': serializer.toJson<String?>(fuelPumpName),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FuelEntry copyWith(
          {String? id,
          String? vehicleId,
          String? fuelType,
          double? quantityLiters,
          double? costPerLiter,
          double? totalCost,
          double? odometerReading,
          Value<String?> fuelPumpName = const Value.absent(),
          DateTime? entryDate,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FuelEntry(
        id: id ?? this.id,
        vehicleId: vehicleId ?? this.vehicleId,
        fuelType: fuelType ?? this.fuelType,
        quantityLiters: quantityLiters ?? this.quantityLiters,
        costPerLiter: costPerLiter ?? this.costPerLiter,
        totalCost: totalCost ?? this.totalCost,
        odometerReading: odometerReading ?? this.odometerReading,
        fuelPumpName:
            fuelPumpName.present ? fuelPumpName.value : this.fuelPumpName,
        entryDate: entryDate ?? this.entryDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FuelEntry copyWithCompanion(FuelEntriesCompanion data) {
    return FuelEntry(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      quantityLiters: data.quantityLiters.present
          ? data.quantityLiters.value
          : this.quantityLiters,
      costPerLiter: data.costPerLiter.present
          ? data.costPerLiter.value
          : this.costPerLiter,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      odometerReading: data.odometerReading.present
          ? data.odometerReading.value
          : this.odometerReading,
      fuelPumpName: data.fuelPumpName.present
          ? data.fuelPumpName.value
          : this.fuelPumpName,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelEntry(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('fuelType: $fuelType, ')
          ..write('quantityLiters: $quantityLiters, ')
          ..write('costPerLiter: $costPerLiter, ')
          ..write('totalCost: $totalCost, ')
          ..write('odometerReading: $odometerReading, ')
          ..write('fuelPumpName: $fuelPumpName, ')
          ..write('entryDate: $entryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      vehicleId,
      fuelType,
      quantityLiters,
      costPerLiter,
      totalCost,
      odometerReading,
      fuelPumpName,
      entryDate,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelEntry &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.fuelType == this.fuelType &&
          other.quantityLiters == this.quantityLiters &&
          other.costPerLiter == this.costPerLiter &&
          other.totalCost == this.totalCost &&
          other.odometerReading == this.odometerReading &&
          other.fuelPumpName == this.fuelPumpName &&
          other.entryDate == this.entryDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FuelEntriesCompanion extends UpdateCompanion<FuelEntry> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> fuelType;
  final Value<double> quantityLiters;
  final Value<double> costPerLiter;
  final Value<double> totalCost;
  final Value<double> odometerReading;
  final Value<String?> fuelPumpName;
  final Value<DateTime> entryDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FuelEntriesCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.quantityLiters = const Value.absent(),
    this.costPerLiter = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.odometerReading = const Value.absent(),
    this.fuelPumpName = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FuelEntriesCompanion.insert({
    required String id,
    required String vehicleId,
    required String fuelType,
    required double quantityLiters,
    required double costPerLiter,
    required double totalCost,
    required double odometerReading,
    this.fuelPumpName = const Value.absent(),
    required DateTime entryDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        vehicleId = Value(vehicleId),
        fuelType = Value(fuelType),
        quantityLiters = Value(quantityLiters),
        costPerLiter = Value(costPerLiter),
        totalCost = Value(totalCost),
        odometerReading = Value(odometerReading),
        entryDate = Value(entryDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<FuelEntry> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? fuelType,
    Expression<double>? quantityLiters,
    Expression<double>? costPerLiter,
    Expression<double>? totalCost,
    Expression<double>? odometerReading,
    Expression<String>? fuelPumpName,
    Expression<DateTime>? entryDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (fuelType != null) 'fuel_type': fuelType,
      if (quantityLiters != null) 'quantity_liters': quantityLiters,
      if (costPerLiter != null) 'cost_per_liter': costPerLiter,
      if (totalCost != null) 'total_cost': totalCost,
      if (odometerReading != null) 'odometer_reading': odometerReading,
      if (fuelPumpName != null) 'fuel_pump_name': fuelPumpName,
      if (entryDate != null) 'entry_date': entryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FuelEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? vehicleId,
      Value<String>? fuelType,
      Value<double>? quantityLiters,
      Value<double>? costPerLiter,
      Value<double>? totalCost,
      Value<double>? odometerReading,
      Value<String?>? fuelPumpName,
      Value<DateTime>? entryDate,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FuelEntriesCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      fuelType: fuelType ?? this.fuelType,
      quantityLiters: quantityLiters ?? this.quantityLiters,
      costPerLiter: costPerLiter ?? this.costPerLiter,
      totalCost: totalCost ?? this.totalCost,
      odometerReading: odometerReading ?? this.odometerReading,
      fuelPumpName: fuelPumpName ?? this.fuelPumpName,
      entryDate: entryDate ?? this.entryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (quantityLiters.present) {
      map['quantity_liters'] = Variable<double>(quantityLiters.value);
    }
    if (costPerLiter.present) {
      map['cost_per_liter'] = Variable<double>(costPerLiter.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (odometerReading.present) {
      map['odometer_reading'] = Variable<double>(odometerReading.value);
    }
    if (fuelPumpName.present) {
      map['fuel_pump_name'] = Variable<String>(fuelPumpName.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelEntriesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('fuelType: $fuelType, ')
          ..write('quantityLiters: $quantityLiters, ')
          ..write('costPerLiter: $costPerLiter, ')
          ..write('totalCost: $totalCost, ')
          ..write('odometerReading: $odometerReading, ')
          ..write('fuelPumpName: $fuelPumpName, ')
          ..write('entryDate: $entryDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceSchedulesTable extends MaintenanceSchedules
    with TableInfo<$MaintenanceSchedulesTable, MaintenanceSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vehicleIdMeta =
      const VerificationMeta('vehicleId');
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
      'vehicle_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _maintenanceTypeMeta =
      const VerificationMeta('maintenanceType');
  @override
  late final GeneratedColumn<String> maintenanceType = GeneratedColumn<String>(
      'maintenance_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduleDateMeta =
      const VerificationMeta('scheduleDate');
  @override
  late final GeneratedColumn<DateTime> scheduleDate = GeneratedColumn<DateTime>(
      'schedule_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        vehicleId,
        maintenanceType,
        scheduleDate,
        dueDate,
        status,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_schedules';
  @override
  VerificationContext validateIntegrity(
      Insertable<MaintenanceSchedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(_vehicleIdMeta,
          vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta));
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('maintenance_type')) {
      context.handle(
          _maintenanceTypeMeta,
          maintenanceType.isAcceptableOrUnknown(
              data['maintenance_type']!, _maintenanceTypeMeta));
    } else if (isInserting) {
      context.missing(_maintenanceTypeMeta);
    }
    if (data.containsKey('schedule_date')) {
      context.handle(
          _scheduleDateMeta,
          scheduleDate.isAcceptableOrUnknown(
              data['schedule_date']!, _scheduleDateMeta));
    } else if (isInserting) {
      context.missing(_scheduleDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceSchedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      vehicleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vehicle_id'])!,
      maintenanceType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}maintenance_type'])!,
      scheduleDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}schedule_date'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MaintenanceSchedulesTable createAlias(String alias) {
    return $MaintenanceSchedulesTable(attachedDatabase, alias);
  }
}

class MaintenanceSchedule extends DataClass
    implements Insertable<MaintenanceSchedule> {
  final String id;
  final String vehicleId;
  final String maintenanceType;
  final DateTime scheduleDate;
  final DateTime dueDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MaintenanceSchedule(
      {required this.id,
      required this.vehicleId,
      required this.maintenanceType,
      required this.scheduleDate,
      required this.dueDate,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['maintenance_type'] = Variable<String>(maintenanceType);
    map['schedule_date'] = Variable<DateTime>(scheduleDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MaintenanceSchedulesCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceSchedulesCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      maintenanceType: Value(maintenanceType),
      scheduleDate: Value(scheduleDate),
      dueDate: Value(dueDate),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MaintenanceSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceSchedule(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      maintenanceType: serializer.fromJson<String>(json['maintenanceType']),
      scheduleDate: serializer.fromJson<DateTime>(json['scheduleDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'maintenanceType': serializer.toJson<String>(maintenanceType),
      'scheduleDate': serializer.toJson<DateTime>(scheduleDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MaintenanceSchedule copyWith(
          {String? id,
          String? vehicleId,
          String? maintenanceType,
          DateTime? scheduleDate,
          DateTime? dueDate,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MaintenanceSchedule(
        id: id ?? this.id,
        vehicleId: vehicleId ?? this.vehicleId,
        maintenanceType: maintenanceType ?? this.maintenanceType,
        scheduleDate: scheduleDate ?? this.scheduleDate,
        dueDate: dueDate ?? this.dueDate,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MaintenanceSchedule copyWithCompanion(MaintenanceSchedulesCompanion data) {
    return MaintenanceSchedule(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      maintenanceType: data.maintenanceType.present
          ? data.maintenanceType.value
          : this.maintenanceType,
      scheduleDate: data.scheduleDate.present
          ? data.scheduleDate.value
          : this.scheduleDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceSchedule(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('maintenanceType: $maintenanceType, ')
          ..write('scheduleDate: $scheduleDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vehicleId, maintenanceType, scheduleDate,
      dueDate, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceSchedule &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.maintenanceType == this.maintenanceType &&
          other.scheduleDate == this.scheduleDate &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MaintenanceSchedulesCompanion
    extends UpdateCompanion<MaintenanceSchedule> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> maintenanceType;
  final Value<DateTime> scheduleDate;
  final Value<DateTime> dueDate;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MaintenanceSchedulesCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.maintenanceType = const Value.absent(),
    this.scheduleDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceSchedulesCompanion.insert({
    required String id,
    required String vehicleId,
    required String maintenanceType,
    required DateTime scheduleDate,
    required DateTime dueDate,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        vehicleId = Value(vehicleId),
        maintenanceType = Value(maintenanceType),
        scheduleDate = Value(scheduleDate),
        dueDate = Value(dueDate),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MaintenanceSchedule> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? maintenanceType,
    Expression<DateTime>? scheduleDate,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (maintenanceType != null) 'maintenance_type': maintenanceType,
      if (scheduleDate != null) 'schedule_date': scheduleDate,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceSchedulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? vehicleId,
      Value<String>? maintenanceType,
      Value<DateTime>? scheduleDate,
      Value<DateTime>? dueDate,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MaintenanceSchedulesCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (maintenanceType.present) {
      map['maintenance_type'] = Variable<String>(maintenanceType.value);
    }
    if (scheduleDate.present) {
      map['schedule_date'] = Variable<DateTime>(scheduleDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('maintenanceType: $maintenanceType, ')
          ..write('scheduleDate: $scheduleDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GpsBreadcrumbsTable extends GpsBreadcrumbs
    with TableInfo<$GpsBreadcrumbsTable, GpsBreadcrumb> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GpsBreadcrumbsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
      'trip_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
      'speed', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tripId, latitude, longitude, timestamp, speed, accuracy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gps_breadcrumbs';
  @override
  VerificationContext validateIntegrity(Insertable<GpsBreadcrumb> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(_tripIdMeta,
          tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta));
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
          _speedMeta, speed.isAcceptableOrUnknown(data['speed']!, _speedMeta));
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GpsBreadcrumb map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GpsBreadcrumb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tripId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trip_id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      speed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy'])!,
    );
  }

  @override
  $GpsBreadcrumbsTable createAlias(String alias) {
    return $GpsBreadcrumbsTable(attachedDatabase, alias);
  }
}

class GpsBreadcrumb extends DataClass implements Insertable<GpsBreadcrumb> {
  final String id;
  final String tripId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double speed;
  final double accuracy;
  const GpsBreadcrumb(
      {required this.id,
      required this.tripId,
      required this.latitude,
      required this.longitude,
      required this.timestamp,
      required this.speed,
      required this.accuracy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['speed'] = Variable<double>(speed);
    map['accuracy'] = Variable<double>(accuracy);
    return map;
  }

  GpsBreadcrumbsCompanion toCompanion(bool nullToAbsent) {
    return GpsBreadcrumbsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      timestamp: Value(timestamp),
      speed: Value(speed),
      accuracy: Value(accuracy),
    );
  }

  factory GpsBreadcrumb.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GpsBreadcrumb(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      speed: serializer.fromJson<double>(json['speed']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'speed': serializer.toJson<double>(speed),
      'accuracy': serializer.toJson<double>(accuracy),
    };
  }

  GpsBreadcrumb copyWith(
          {String? id,
          String? tripId,
          double? latitude,
          double? longitude,
          DateTime? timestamp,
          double? speed,
          double? accuracy}) =>
      GpsBreadcrumb(
        id: id ?? this.id,
        tripId: tripId ?? this.tripId,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        timestamp: timestamp ?? this.timestamp,
        speed: speed ?? this.speed,
        accuracy: accuracy ?? this.accuracy,
      );
  GpsBreadcrumb copyWithCompanion(GpsBreadcrumbsCompanion data) {
    return GpsBreadcrumb(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      speed: data.speed.present ? data.speed.value : this.speed,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GpsBreadcrumb(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timestamp: $timestamp, ')
          ..write('speed: $speed, ')
          ..write('accuracy: $accuracy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tripId, latitude, longitude, timestamp, speed, accuracy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GpsBreadcrumb &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.timestamp == this.timestamp &&
          other.speed == this.speed &&
          other.accuracy == this.accuracy);
}

class GpsBreadcrumbsCompanion extends UpdateCompanion<GpsBreadcrumb> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> timestamp;
  final Value<double> speed;
  final Value<double> accuracy;
  final Value<int> rowid;
  const GpsBreadcrumbsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.speed = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GpsBreadcrumbsCompanion.insert({
    required String id,
    required String tripId,
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    required double speed,
    required double accuracy,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tripId = Value(tripId),
        latitude = Value(latitude),
        longitude = Value(longitude),
        timestamp = Value(timestamp),
        speed = Value(speed),
        accuracy = Value(accuracy);
  static Insertable<GpsBreadcrumb> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? timestamp,
    Expression<double>? speed,
    Expression<double>? accuracy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (timestamp != null) 'timestamp': timestamp,
      if (speed != null) 'speed': speed,
      if (accuracy != null) 'accuracy': accuracy,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GpsBreadcrumbsCompanion copyWith(
      {Value<String>? id,
      Value<String>? tripId,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<DateTime>? timestamp,
      Value<double>? speed,
      Value<double>? accuracy,
      Value<int>? rowid}) {
    return GpsBreadcrumbsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      speed: speed ?? this.speed,
      accuracy: accuracy ?? this.accuracy,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GpsBreadcrumbsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timestamp: $timestamp, ')
          ..write('speed: $speed, ')
          ..write('accuracy: $accuracy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $DriversTable drivers = $DriversTable(this);
  late final $PartiesTable parties = $PartiesTable(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserSessionsTable userSessions = $UserSessionsTable(this);
  late final $UserPermissionsTable userPermissions =
      $UserPermissionsTable(this);
  late final $ActivityLogsTable activityLogs = $ActivityLogsTable(this);
  late final $SystemSettingsTable systemSettings = $SystemSettingsTable(this);
  late final $ScheduledReportsTable scheduledReports =
      $ScheduledReportsTable(this);
  late final $ReportExecutionsTable reportExecutions =
      $ReportExecutionsTable(this);
  late final $EmailNotificationsTable emailNotifications =
      $EmailNotificationsTable(this);
  late final $BackupsTable backups = $BackupsTable(this);
  late final $BackupJobsTable backupJobs = $BackupJobsTable(this);
  late final $RoutesTable routes = $RoutesTable(this);
  late final $RouteHistoryTable routeHistory = $RouteHistoryTable(this);
  late final $FuelEntriesTable fuelEntries = $FuelEntriesTable(this);
  late final $MaintenanceSchedulesTable maintenanceSchedules =
      $MaintenanceSchedulesTable(this);
  late final $GpsBreadcrumbsTable gpsBreadcrumbs = $GpsBreadcrumbsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        vehicles,
        drivers,
        parties,
        trips,
        expenses,
        payments,
        documents,
        users,
        userSessions,
        userPermissions,
        activityLogs,
        systemSettings,
        scheduledReports,
        reportExecutions,
        emailNotifications,
        backups,
        backupJobs,
        routes,
        routeHistory,
        fuelEntries,
        maintenanceSchedules,
        gpsBreadcrumbs
      ];
}

typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  required String id,
  required String truckNumber,
  required String truckType,
  required double capacity,
  required String fuelType,
  required String registrationNumber,
  Value<DateTime?> insuranceExpiry,
  Value<DateTime?> fitnessExpiry,
  Value<String?> assignedDriverId,
  required String status,
  Value<String?> currentLocation,
  Value<double?> totalKm,
  Value<DateTime?> lastServiceDate,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<String> id,
  Value<String> truckNumber,
  Value<String> truckType,
  Value<double> capacity,
  Value<String> fuelType,
  Value<String> registrationNumber,
  Value<DateTime?> insuranceExpiry,
  Value<DateTime?> fitnessExpiry,
  Value<String?> assignedDriverId,
  Value<String> status,
  Value<String?> currentLocation,
  Value<double?> totalKm,
  Value<DateTime?> lastServiceDate,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get truckNumber => $composableBuilder(
      column: $table.truckNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get truckType => $composableBuilder(
      column: $table.truckType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fuelType => $composableBuilder(
      column: $table.fuelType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get registrationNumber => $composableBuilder(
      column: $table.registrationNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get insuranceExpiry => $composableBuilder(
      column: $table.insuranceExpiry,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fitnessExpiry => $composableBuilder(
      column: $table.fitnessExpiry, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignedDriverId => $composableBuilder(
      column: $table.assignedDriverId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentLocation => $composableBuilder(
      column: $table.currentLocation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalKm => $composableBuilder(
      column: $table.totalKm, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastServiceDate => $composableBuilder(
      column: $table.lastServiceDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get truckNumber => $composableBuilder(
      column: $table.truckNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get truckType => $composableBuilder(
      column: $table.truckType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fuelType => $composableBuilder(
      column: $table.fuelType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get registrationNumber => $composableBuilder(
      column: $table.registrationNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get insuranceExpiry => $composableBuilder(
      column: $table.insuranceExpiry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fitnessExpiry => $composableBuilder(
      column: $table.fitnessExpiry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedDriverId => $composableBuilder(
      column: $table.assignedDriverId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentLocation => $composableBuilder(
      column: $table.currentLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalKm => $composableBuilder(
      column: $table.totalKm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastServiceDate => $composableBuilder(
      column: $table.lastServiceDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get truckNumber => $composableBuilder(
      column: $table.truckNumber, builder: (column) => column);

  GeneratedColumn<String> get truckType =>
      $composableBuilder(column: $table.truckType, builder: (column) => column);

  GeneratedColumn<double> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<String> get registrationNumber => $composableBuilder(
      column: $table.registrationNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get insuranceExpiry => $composableBuilder(
      column: $table.insuranceExpiry, builder: (column) => column);

  GeneratedColumn<DateTime> get fitnessExpiry => $composableBuilder(
      column: $table.fitnessExpiry, builder: (column) => column);

  GeneratedColumn<String> get assignedDriverId => $composableBuilder(
      column: $table.assignedDriverId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get currentLocation => $composableBuilder(
      column: $table.currentLocation, builder: (column) => column);

  GeneratedColumn<double> get totalKm =>
      $composableBuilder(column: $table.totalKm, builder: (column) => column);

  GeneratedColumn<DateTime> get lastServiceDate => $composableBuilder(
      column: $table.lastServiceDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VehiclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VehiclesTable,
    Vehicle,
    $$VehiclesTableFilterComposer,
    $$VehiclesTableOrderingComposer,
    $$VehiclesTableAnnotationComposer,
    $$VehiclesTableCreateCompanionBuilder,
    $$VehiclesTableUpdateCompanionBuilder,
    (Vehicle, BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>),
    Vehicle,
    PrefetchHooks Function()> {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> truckNumber = const Value.absent(),
            Value<String> truckType = const Value.absent(),
            Value<double> capacity = const Value.absent(),
            Value<String> fuelType = const Value.absent(),
            Value<String> registrationNumber = const Value.absent(),
            Value<DateTime?> insuranceExpiry = const Value.absent(),
            Value<DateTime?> fitnessExpiry = const Value.absent(),
            Value<String?> assignedDriverId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> currentLocation = const Value.absent(),
            Value<double?> totalKm = const Value.absent(),
            Value<DateTime?> lastServiceDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VehiclesCompanion(
            id: id,
            truckNumber: truckNumber,
            truckType: truckType,
            capacity: capacity,
            fuelType: fuelType,
            registrationNumber: registrationNumber,
            insuranceExpiry: insuranceExpiry,
            fitnessExpiry: fitnessExpiry,
            assignedDriverId: assignedDriverId,
            status: status,
            currentLocation: currentLocation,
            totalKm: totalKm,
            lastServiceDate: lastServiceDate,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String truckNumber,
            required String truckType,
            required double capacity,
            required String fuelType,
            required String registrationNumber,
            Value<DateTime?> insuranceExpiry = const Value.absent(),
            Value<DateTime?> fitnessExpiry = const Value.absent(),
            Value<String?> assignedDriverId = const Value.absent(),
            required String status,
            Value<String?> currentLocation = const Value.absent(),
            Value<double?> totalKm = const Value.absent(),
            Value<DateTime?> lastServiceDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              VehiclesCompanion.insert(
            id: id,
            truckNumber: truckNumber,
            truckType: truckType,
            capacity: capacity,
            fuelType: fuelType,
            registrationNumber: registrationNumber,
            insuranceExpiry: insuranceExpiry,
            fitnessExpiry: fitnessExpiry,
            assignedDriverId: assignedDriverId,
            status: status,
            currentLocation: currentLocation,
            totalKm: totalKm,
            lastServiceDate: lastServiceDate,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VehiclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VehiclesTable,
    Vehicle,
    $$VehiclesTableFilterComposer,
    $$VehiclesTableOrderingComposer,
    $$VehiclesTableAnnotationComposer,
    $$VehiclesTableCreateCompanionBuilder,
    $$VehiclesTableUpdateCompanionBuilder,
    (Vehicle, BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>),
    Vehicle,
    PrefetchHooks Function()>;
typedef $$DriversTableCreateCompanionBuilder = DriversCompanion Function({
  required String id,
  required String name,
  required String phone,
  required String licenseNumber,
  required String licenseType,
  Value<DateTime?> licenseExpiry,
  Value<String?> address,
  Value<String?> emergencyContact,
  required String status,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DriversTableUpdateCompanionBuilder = DriversCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> phone,
  Value<String> licenseNumber,
  Value<String> licenseType,
  Value<DateTime?> licenseExpiry,
  Value<String?> address,
  Value<String?> emergencyContact,
  Value<String> status,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DriversTableFilterComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get licenseNumber => $composableBuilder(
      column: $table.licenseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get licenseType => $composableBuilder(
      column: $table.licenseType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get licenseExpiry => $composableBuilder(
      column: $table.licenseExpiry, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyContact => $composableBuilder(
      column: $table.emergencyContact,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DriversTableOrderingComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get licenseNumber => $composableBuilder(
      column: $table.licenseNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get licenseType => $composableBuilder(
      column: $table.licenseType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get licenseExpiry => $composableBuilder(
      column: $table.licenseExpiry,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyContact => $composableBuilder(
      column: $table.emergencyContact,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DriversTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get licenseNumber => $composableBuilder(
      column: $table.licenseNumber, builder: (column) => column);

  GeneratedColumn<String> get licenseType => $composableBuilder(
      column: $table.licenseType, builder: (column) => column);

  GeneratedColumn<DateTime> get licenseExpiry => $composableBuilder(
      column: $table.licenseExpiry, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get emergencyContact => $composableBuilder(
      column: $table.emergencyContact, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DriversTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DriversTable,
    Driver,
    $$DriversTableFilterComposer,
    $$DriversTableOrderingComposer,
    $$DriversTableAnnotationComposer,
    $$DriversTableCreateCompanionBuilder,
    $$DriversTableUpdateCompanionBuilder,
    (Driver, BaseReferences<_$AppDatabase, $DriversTable, Driver>),
    Driver,
    PrefetchHooks Function()> {
  $$DriversTableTableManager(_$AppDatabase db, $DriversTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> licenseNumber = const Value.absent(),
            Value<String> licenseType = const Value.absent(),
            Value<DateTime?> licenseExpiry = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> emergencyContact = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DriversCompanion(
            id: id,
            name: name,
            phone: phone,
            licenseNumber: licenseNumber,
            licenseType: licenseType,
            licenseExpiry: licenseExpiry,
            address: address,
            emergencyContact: emergencyContact,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String phone,
            required String licenseNumber,
            required String licenseType,
            Value<DateTime?> licenseExpiry = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> emergencyContact = const Value.absent(),
            required String status,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DriversCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            licenseNumber: licenseNumber,
            licenseType: licenseType,
            licenseExpiry: licenseExpiry,
            address: address,
            emergencyContact: emergencyContact,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DriversTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DriversTable,
    Driver,
    $$DriversTableFilterComposer,
    $$DriversTableOrderingComposer,
    $$DriversTableAnnotationComposer,
    $$DriversTableCreateCompanionBuilder,
    $$DriversTableUpdateCompanionBuilder,
    (Driver, BaseReferences<_$AppDatabase, $DriversTable, Driver>),
    Driver,
    PrefetchHooks Function()>;
typedef $$PartiesTableCreateCompanionBuilder = PartiesCompanion Function({
  required String id,
  required String name,
  required String mobile,
  required String city,
  Value<String?> gst,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PartiesTableUpdateCompanionBuilder = PartiesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> mobile,
  Value<String> city,
  Value<String?> gst,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PartiesTableFilterComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gst => $composableBuilder(
      column: $table.gst, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PartiesTableOrderingComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gst => $composableBuilder(
      column: $table.gst, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PartiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartiesTable> {
  $$PartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get gst =>
      $composableBuilder(column: $table.gst, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PartiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PartiesTable,
    Party,
    $$PartiesTableFilterComposer,
    $$PartiesTableOrderingComposer,
    $$PartiesTableAnnotationComposer,
    $$PartiesTableCreateCompanionBuilder,
    $$PartiesTableUpdateCompanionBuilder,
    (Party, BaseReferences<_$AppDatabase, $PartiesTable, Party>),
    Party,
    PrefetchHooks Function()> {
  $$PartiesTableTableManager(_$AppDatabase db, $PartiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> mobile = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<String?> gst = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PartiesCompanion(
            id: id,
            name: name,
            mobile: mobile,
            city: city,
            gst: gst,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String mobile,
            required String city,
            Value<String?> gst = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PartiesCompanion.insert(
            id: id,
            name: name,
            mobile: mobile,
            city: city,
            gst: gst,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PartiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PartiesTable,
    Party,
    $$PartiesTableFilterComposer,
    $$PartiesTableOrderingComposer,
    $$PartiesTableAnnotationComposer,
    $$PartiesTableCreateCompanionBuilder,
    $$PartiesTableUpdateCompanionBuilder,
    (Party, BaseReferences<_$AppDatabase, $PartiesTable, Party>),
    Party,
    PrefetchHooks Function()>;
typedef $$TripsTableCreateCompanionBuilder = TripsCompanion Function({
  required String id,
  required String fromLocation,
  required String toLocation,
  required String vehicleId,
  required String driverId,
  required String partyId,
  required double freightAmount,
  Value<double?> advanceAmount,
  required String status,
  required DateTime startDate,
  Value<DateTime?> expectedEndDate,
  Value<DateTime?> actualEndDate,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TripsTableUpdateCompanionBuilder = TripsCompanion Function({
  Value<String> id,
  Value<String> fromLocation,
  Value<String> toLocation,
  Value<String> vehicleId,
  Value<String> driverId,
  Value<String> partyId,
  Value<double> freightAmount,
  Value<double?> advanceAmount,
  Value<String> status,
  Value<DateTime> startDate,
  Value<DateTime?> expectedEndDate,
  Value<DateTime?> actualEndDate,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromLocation => $composableBuilder(
      column: $table.fromLocation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toLocation => $composableBuilder(
      column: $table.toLocation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vehicleId => $composableBuilder(
      column: $table.vehicleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get driverId => $composableBuilder(
      column: $table.driverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partyId => $composableBuilder(
      column: $table.partyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get freightAmount => $composableBuilder(
      column: $table.freightAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get advanceAmount => $composableBuilder(
      column: $table.advanceAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expectedEndDate => $composableBuilder(
      column: $table.expectedEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get actualEndDate => $composableBuilder(
      column: $table.actualEndDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromLocation => $composableBuilder(
      column: $table.fromLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toLocation => $composableBuilder(
      column: $table.toLocation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vehicleId => $composableBuilder(
      column: $table.vehicleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get driverId => $composableBuilder(
      column: $table.driverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partyId => $composableBuilder(
      column: $table.partyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get freightAmount => $composableBuilder(
      column: $table.freightAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get advanceAmount => $composableBuilder(
      column: $table.advanceAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expectedEndDate => $composableBuilder(
      column: $table.expectedEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualEndDate => $composableBuilder(
      column: $table.actualEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromLocation => $composableBuilder(
      column: $table.fromLocation, builder: (column) => column);

  GeneratedColumn<String> get toLocation => $composableBuilder(
      column: $table.toLocation, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get driverId =>
      $composableBuilder(column: $table.driverId, builder: (column) => column);

  GeneratedColumn<String> get partyId =>
      $composableBuilder(column: $table.partyId, builder: (column) => column);

  GeneratedColumn<double> get freightAmount => $composableBuilder(
      column: $table.freightAmount, builder: (column) => column);

  GeneratedColumn<double> get advanceAmount => $composableBuilder(
      column: $table.advanceAmount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedEndDate => $composableBuilder(
      column: $table.expectedEndDate, builder: (column) => column);

  GeneratedColumn<DateTime> get actualEndDate => $composableBuilder(
      column: $table.actualEndDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TripsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TripsTable,
    Trip,
    $$TripsTableFilterComposer,
    $$TripsTableOrderingComposer,
    $$TripsTableAnnotationComposer,
    $$TripsTableCreateCompanionBuilder,
    $$TripsTableUpdateCompanionBuilder,
    (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
    Trip,
    PrefetchHooks Function()> {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fromLocation = const Value.absent(),
            Value<String> toLocation = const Value.absent(),
            Value<String> vehicleId = const Value.absent(),
            Value<String> driverId = const Value.absent(),
            Value<String> partyId = const Value.absent(),
            Value<double> freightAmount = const Value.absent(),
            Value<double?> advanceAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> expectedEndDate = const Value.absent(),
            Value<DateTime?> actualEndDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TripsCompanion(
            id: id,
            fromLocation: fromLocation,
            toLocation: toLocation,
            vehicleId: vehicleId,
            driverId: driverId,
            partyId: partyId,
            freightAmount: freightAmount,
            advanceAmount: advanceAmount,
            status: status,
            startDate: startDate,
            expectedEndDate: expectedEndDate,
            actualEndDate: actualEndDate,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String fromLocation,
            required String toLocation,
            required String vehicleId,
            required String driverId,
            required String partyId,
            required double freightAmount,
            Value<double?> advanceAmount = const Value.absent(),
            required String status,
            required DateTime startDate,
            Value<DateTime?> expectedEndDate = const Value.absent(),
            Value<DateTime?> actualEndDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TripsCompanion.insert(
            id: id,
            fromLocation: fromLocation,
            toLocation: toLocation,
            vehicleId: vehicleId,
            driverId: driverId,
            partyId: partyId,
            freightAmount: freightAmount,
            advanceAmount: advanceAmount,
            status: status,
            startDate: startDate,
            expectedEndDate: expectedEndDate,
            actualEndDate: actualEndDate,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TripsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TripsTable,
    Trip,
    $$TripsTableFilterComposer,
    $$TripsTableOrderingComposer,
    $$TripsTableAnnotationComposer,
    $$TripsTableCreateCompanionBuilder,
    $$TripsTableUpdateCompanionBuilder,
    (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
    Trip,
    PrefetchHooks Function()>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  required String id,
  required String tripId,
  required String category,
  required double amount,
  required String paidMode,
  Value<String?> billImagePath,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<String> id,
  Value<String> tripId,
  Value<String> category,
  Value<double> amount,
  Value<String> paidMode,
  Value<String?> billImagePath,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tripId => $composableBuilder(
      column: $table.tripId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paidMode => $composableBuilder(
      column: $table.paidMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billImagePath => $composableBuilder(
      column: $table.billImagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tripId => $composableBuilder(
      column: $table.tripId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paidMode => $composableBuilder(
      column: $table.paidMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billImagePath => $composableBuilder(
      column: $table.billImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paidMode =>
      $composableBuilder(column: $table.paidMode, builder: (column) => column);

  GeneratedColumn<String> get billImagePath => $composableBuilder(
      column: $table.billImagePath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tripId = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> paidMode = const Value.absent(),
            Value<String?> billImagePath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            tripId: tripId,
            category: category,
            amount: amount,
            paidMode: paidMode,
            billImagePath: billImagePath,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String tripId,
            required String category,
            required double amount,
            required String paidMode,
            Value<String?> billImagePath = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            tripId: tripId,
            category: category,
            amount: amount,
            paidMode: paidMode,
            billImagePath: billImagePath,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  required String id,
  Value<String?> tripId,
  required String partyId,
  required double amount,
  required String type,
  required String mode,
  required DateTime date,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> id,
  Value<String?> tripId,
  Value<String> partyId,
  Value<double> amount,
  Value<String> type,
  Value<String> mode,
  Value<DateTime> date,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tripId => $composableBuilder(
      column: $table.tripId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partyId => $composableBuilder(
      column: $table.partyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tripId => $composableBuilder(
      column: $table.tripId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partyId => $composableBuilder(
      column: $table.partyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get partyId =>
      $composableBuilder(column: $table.partyId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
    Payment,
    PrefetchHooks Function()> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> tripId = const Value.absent(),
            Value<String> partyId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            tripId: tripId,
            partyId: partyId,
            amount: amount,
            type: type,
            mode: mode,
            date: date,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> tripId = const Value.absent(),
            required String partyId,
            required double amount,
            required String type,
            required String mode,
            required DateTime date,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            tripId: tripId,
            partyId: partyId,
            amount: amount,
            type: type,
            mode: mode,
            date: date,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
    Payment,
    PrefetchHooks Function()>;
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  required String id,
  required String name,
  required String type,
  required String entityType,
  required String entityId,
  required String filePath,
  required String description,
  required int fileSize,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> filePath,
  Value<String> description,
  Value<int> fileSize,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()> {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsCompanion(
            id: id,
            name: name,
            type: type,
            entityType: entityType,
            entityId: entityId,
            filePath: filePath,
            description: description,
            fileSize: fileSize,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required String entityType,
            required String entityId,
            required String filePath,
            required String description,
            required int fileSize,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsCompanion.insert(
            id: id,
            name: name,
            type: type,
            entityType: entityType,
            entityId: entityId,
            filePath: filePath,
            description: description,
            fileSize: fileSize,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String username,
  required String email,
  required String passwordHash,
  required String firstName,
  required String lastName,
  required String role,
  Value<String?> phone,
  Value<String?> profilePicture,
  Value<bool> isActive,
  Value<DateTime?> lastLoginAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> email,
  Value<String> passwordHash,
  Value<String> firstName,
  Value<String> lastName,
  Value<String> role,
  Value<String?> phone,
  Value<String?> profilePicture,
  Value<bool> isActive,
  Value<DateTime?> lastLoginAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profilePicture => $composableBuilder(
      column: $table.profilePicture,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profilePicture => $composableBuilder(
      column: $table.profilePicture,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
      column: $table.passwordHash, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get profilePicture => $composableBuilder(
      column: $table.profilePicture, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> passwordHash = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> profilePicture = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            email: email,
            passwordHash: passwordHash,
            firstName: firstName,
            lastName: lastName,
            role: role,
            phone: phone,
            profilePicture: profilePicture,
            isActive: isActive,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String username,
            required String email,
            required String passwordHash,
            required String firstName,
            required String lastName,
            required String role,
            Value<String?> phone = const Value.absent(),
            Value<String?> profilePicture = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            email: email,
            passwordHash: passwordHash,
            firstName: firstName,
            lastName: lastName,
            role: role,
            phone: phone,
            profilePicture: profilePicture,
            isActive: isActive,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$UserSessionsTableCreateCompanionBuilder = UserSessionsCompanion
    Function({
  required String id,
  required String userId,
  required String sessionToken,
  required DateTime expiresAt,
  required DateTime createdAt,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$UserSessionsTableUpdateCompanionBuilder = UserSessionsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> sessionToken,
  Value<DateTime> expiresAt,
  Value<DateTime> createdAt,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$UserSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSessionsTable> {
  $$UserSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionToken => $composableBuilder(
      column: $table.sessionToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$UserSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSessionsTable> {
  $$UserSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionToken => $composableBuilder(
      column: $table.sessionToken,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$UserSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSessionsTable> {
  $$UserSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sessionToken => $composableBuilder(
      column: $table.sessionToken, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$UserSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSessionsTable,
    UserSession,
    $$UserSessionsTableFilterComposer,
    $$UserSessionsTableOrderingComposer,
    $$UserSessionsTableAnnotationComposer,
    $$UserSessionsTableCreateCompanionBuilder,
    $$UserSessionsTableUpdateCompanionBuilder,
    (
      UserSession,
      BaseReferences<_$AppDatabase, $UserSessionsTable, UserSession>
    ),
    UserSession,
    PrefetchHooks Function()> {
  $$UserSessionsTableTableManager(_$AppDatabase db, $UserSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> sessionToken = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSessionsCompanion(
            id: id,
            userId: userId,
            sessionToken: sessionToken,
            expiresAt: expiresAt,
            createdAt: createdAt,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String sessionToken,
            required DateTime expiresAt,
            required DateTime createdAt,
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSessionsCompanion.insert(
            id: id,
            userId: userId,
            sessionToken: sessionToken,
            expiresAt: expiresAt,
            createdAt: createdAt,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSessionsTable,
    UserSession,
    $$UserSessionsTableFilterComposer,
    $$UserSessionsTableOrderingComposer,
    $$UserSessionsTableAnnotationComposer,
    $$UserSessionsTableCreateCompanionBuilder,
    $$UserSessionsTableUpdateCompanionBuilder,
    (
      UserSession,
      BaseReferences<_$AppDatabase, $UserSessionsTable, UserSession>
    ),
    UserSession,
    PrefetchHooks Function()>;
typedef $$UserPermissionsTableCreateCompanionBuilder = UserPermissionsCompanion
    Function({
  required String id,
  required String userId,
  required String permission,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$UserPermissionsTableUpdateCompanionBuilder = UserPermissionsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> permission,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$UserPermissionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserPermissionsTable> {
  $$UserPermissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UserPermissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPermissionsTable> {
  $$UserPermissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UserPermissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPermissionsTable> {
  $$UserPermissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get permission => $composableBuilder(
      column: $table.permission, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserPermissionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPermissionsTable,
    UserPermission,
    $$UserPermissionsTableFilterComposer,
    $$UserPermissionsTableOrderingComposer,
    $$UserPermissionsTableAnnotationComposer,
    $$UserPermissionsTableCreateCompanionBuilder,
    $$UserPermissionsTableUpdateCompanionBuilder,
    (
      UserPermission,
      BaseReferences<_$AppDatabase, $UserPermissionsTable, UserPermission>
    ),
    UserPermission,
    PrefetchHooks Function()> {
  $$UserPermissionsTableTableManager(
      _$AppDatabase db, $UserPermissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPermissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPermissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPermissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> permission = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPermissionsCompanion(
            id: id,
            userId: userId,
            permission: permission,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String permission,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPermissionsCompanion.insert(
            id: id,
            userId: userId,
            permission: permission,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserPermissionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserPermissionsTable,
    UserPermission,
    $$UserPermissionsTableFilterComposer,
    $$UserPermissionsTableOrderingComposer,
    $$UserPermissionsTableAnnotationComposer,
    $$UserPermissionsTableCreateCompanionBuilder,
    $$UserPermissionsTableUpdateCompanionBuilder,
    (
      UserPermission,
      BaseReferences<_$AppDatabase, $UserPermissionsTable, UserPermission>
    ),
    UserPermission,
    PrefetchHooks Function()>;
typedef $$ActivityLogsTableCreateCompanionBuilder = ActivityLogsCompanion
    Function({
  required String id,
  required String userId,
  required String action,
  Value<String?> entityType,
  Value<String?> entityId,
  required String description,
  Value<String?> ipAddress,
  Value<String?> userAgent,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ActivityLogsTableUpdateCompanionBuilder = ActivityLogsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> action,
  Value<String?> entityType,
  Value<String?> entityId,
  Value<String> description,
  Value<String?> ipAddress,
  Value<String?> userAgent,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ActivityLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ipAddress => $composableBuilder(
      column: $table.ipAddress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userAgent => $composableBuilder(
      column: $table.userAgent, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ActivityLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ipAddress => $composableBuilder(
      column: $table.ipAddress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userAgent => $composableBuilder(
      column: $table.userAgent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ActivityLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogsTable> {
  $$ActivityLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get ipAddress =>
      $composableBuilder(column: $table.ipAddress, builder: (column) => column);

  GeneratedColumn<String> get userAgent =>
      $composableBuilder(column: $table.userAgent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ActivityLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ActivityLogsTable,
    ActivityLog,
    $$ActivityLogsTableFilterComposer,
    $$ActivityLogsTableOrderingComposer,
    $$ActivityLogsTableAnnotationComposer,
    $$ActivityLogsTableCreateCompanionBuilder,
    $$ActivityLogsTableUpdateCompanionBuilder,
    (
      ActivityLog,
      BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLog>
    ),
    ActivityLog,
    PrefetchHooks Function()> {
  $$ActivityLogsTableTableManager(_$AppDatabase db, $ActivityLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> entityType = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> ipAddress = const Value.absent(),
            Value<String?> userAgent = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityLogsCompanion(
            id: id,
            userId: userId,
            action: action,
            entityType: entityType,
            entityId: entityId,
            description: description,
            ipAddress: ipAddress,
            userAgent: userAgent,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String action,
            Value<String?> entityType = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            required String description,
            Value<String?> ipAddress = const Value.absent(),
            Value<String?> userAgent = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ActivityLogsCompanion.insert(
            id: id,
            userId: userId,
            action: action,
            entityType: entityType,
            entityId: entityId,
            description: description,
            ipAddress: ipAddress,
            userAgent: userAgent,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActivityLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ActivityLogsTable,
    ActivityLog,
    $$ActivityLogsTableFilterComposer,
    $$ActivityLogsTableOrderingComposer,
    $$ActivityLogsTableAnnotationComposer,
    $$ActivityLogsTableCreateCompanionBuilder,
    $$ActivityLogsTableUpdateCompanionBuilder,
    (
      ActivityLog,
      BaseReferences<_$AppDatabase, $ActivityLogsTable, ActivityLog>
    ),
    ActivityLog,
    PrefetchHooks Function()>;
typedef $$SystemSettingsTableCreateCompanionBuilder = SystemSettingsCompanion
    Function({
  required String id,
  required String key,
  required String value,
  required String description,
  required String category,
  required String updatedBy,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SystemSettingsTableUpdateCompanionBuilder = SystemSettingsCompanion
    Function({
  Value<String> id,
  Value<String> key,
  Value<String> value,
  Value<String> description,
  Value<String> category,
  Value<String> updatedBy,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SystemSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SystemSettingsTable> {
  $$SystemSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SystemSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemSettingsTable> {
  $$SystemSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedBy => $composableBuilder(
      column: $table.updatedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SystemSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemSettingsTable> {
  $$SystemSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SystemSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SystemSettingsTable,
    SystemSetting,
    $$SystemSettingsTableFilterComposer,
    $$SystemSettingsTableOrderingComposer,
    $$SystemSettingsTableAnnotationComposer,
    $$SystemSettingsTableCreateCompanionBuilder,
    $$SystemSettingsTableUpdateCompanionBuilder,
    (
      SystemSetting,
      BaseReferences<_$AppDatabase, $SystemSettingsTable, SystemSetting>
    ),
    SystemSetting,
    PrefetchHooks Function()> {
  $$SystemSettingsTableTableManager(
      _$AppDatabase db, $SystemSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SystemSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> updatedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SystemSettingsCompanion(
            id: id,
            key: key,
            value: value,
            description: description,
            category: category,
            updatedBy: updatedBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String key,
            required String value,
            required String description,
            required String category,
            required String updatedBy,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SystemSettingsCompanion.insert(
            id: id,
            key: key,
            value: value,
            description: description,
            category: category,
            updatedBy: updatedBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SystemSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SystemSettingsTable,
    SystemSetting,
    $$SystemSettingsTableFilterComposer,
    $$SystemSettingsTableOrderingComposer,
    $$SystemSettingsTableAnnotationComposer,
    $$SystemSettingsTableCreateCompanionBuilder,
    $$SystemSettingsTableUpdateCompanionBuilder,
    (
      SystemSetting,
      BaseReferences<_$AppDatabase, $SystemSettingsTable, SystemSetting>
    ),
    SystemSetting,
    PrefetchHooks Function()>;
typedef $$ScheduledReportsTableCreateCompanionBuilder
    = ScheduledReportsCompanion Function({
  required String id,
  required String name,
  required String description,
  required String reportType,
  required String scheduleType,
  required String scheduleConfig,
  required String recipients,
  required String format,
  required String filters,
  Value<bool> isActive,
  required DateTime nextRunAt,
  Value<DateTime?> lastRunAt,
  required String createdBy,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ScheduledReportsTableUpdateCompanionBuilder
    = ScheduledReportsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> reportType,
  Value<String> scheduleType,
  Value<String> scheduleConfig,
  Value<String> recipients,
  Value<String> format,
  Value<String> filters,
  Value<bool> isActive,
  Value<DateTime> nextRunAt,
  Value<DateTime?> lastRunAt,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ScheduledReportsTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledReportsTable> {
  $$ScheduledReportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reportType => $composableBuilder(
      column: $table.reportType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleConfig => $composableBuilder(
      column: $table.scheduleConfig,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipients => $composableBuilder(
      column: $table.recipients, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get format => $composableBuilder(
      column: $table.format, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filters => $composableBuilder(
      column: $table.filters, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextRunAt => $composableBuilder(
      column: $table.nextRunAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastRunAt => $composableBuilder(
      column: $table.lastRunAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ScheduledReportsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledReportsTable> {
  $$ScheduledReportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reportType => $composableBuilder(
      column: $table.reportType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleConfig => $composableBuilder(
      column: $table.scheduleConfig,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipients => $composableBuilder(
      column: $table.recipients, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get format => $composableBuilder(
      column: $table.format, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filters => $composableBuilder(
      column: $table.filters, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextRunAt => $composableBuilder(
      column: $table.nextRunAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastRunAt => $composableBuilder(
      column: $table.lastRunAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ScheduledReportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledReportsTable> {
  $$ScheduledReportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get reportType => $composableBuilder(
      column: $table.reportType, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<String> get scheduleConfig => $composableBuilder(
      column: $table.scheduleConfig, builder: (column) => column);

  GeneratedColumn<String> get recipients => $composableBuilder(
      column: $table.recipients, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get filters =>
      $composableBuilder(column: $table.filters, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRunAt =>
      $composableBuilder(column: $table.nextRunAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRunAt =>
      $composableBuilder(column: $table.lastRunAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ScheduledReportsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduledReportsTable,
    ScheduledReport,
    $$ScheduledReportsTableFilterComposer,
    $$ScheduledReportsTableOrderingComposer,
    $$ScheduledReportsTableAnnotationComposer,
    $$ScheduledReportsTableCreateCompanionBuilder,
    $$ScheduledReportsTableUpdateCompanionBuilder,
    (
      ScheduledReport,
      BaseReferences<_$AppDatabase, $ScheduledReportsTable, ScheduledReport>
    ),
    ScheduledReport,
    PrefetchHooks Function()> {
  $$ScheduledReportsTableTableManager(
      _$AppDatabase db, $ScheduledReportsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledReportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledReportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledReportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> reportType = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<String> scheduleConfig = const Value.absent(),
            Value<String> recipients = const Value.absent(),
            Value<String> format = const Value.absent(),
            Value<String> filters = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> nextRunAt = const Value.absent(),
            Value<DateTime?> lastRunAt = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduledReportsCompanion(
            id: id,
            name: name,
            description: description,
            reportType: reportType,
            scheduleType: scheduleType,
            scheduleConfig: scheduleConfig,
            recipients: recipients,
            format: format,
            filters: filters,
            isActive: isActive,
            nextRunAt: nextRunAt,
            lastRunAt: lastRunAt,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required String reportType,
            required String scheduleType,
            required String scheduleConfig,
            required String recipients,
            required String format,
            required String filters,
            Value<bool> isActive = const Value.absent(),
            required DateTime nextRunAt,
            Value<DateTime?> lastRunAt = const Value.absent(),
            required String createdBy,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ScheduledReportsCompanion.insert(
            id: id,
            name: name,
            description: description,
            reportType: reportType,
            scheduleType: scheduleType,
            scheduleConfig: scheduleConfig,
            recipients: recipients,
            format: format,
            filters: filters,
            isActive: isActive,
            nextRunAt: nextRunAt,
            lastRunAt: lastRunAt,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScheduledReportsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScheduledReportsTable,
    ScheduledReport,
    $$ScheduledReportsTableFilterComposer,
    $$ScheduledReportsTableOrderingComposer,
    $$ScheduledReportsTableAnnotationComposer,
    $$ScheduledReportsTableCreateCompanionBuilder,
    $$ScheduledReportsTableUpdateCompanionBuilder,
    (
      ScheduledReport,
      BaseReferences<_$AppDatabase, $ScheduledReportsTable, ScheduledReport>
    ),
    ScheduledReport,
    PrefetchHooks Function()>;
typedef $$ReportExecutionsTableCreateCompanionBuilder
    = ReportExecutionsCompanion Function({
  required String id,
  required String scheduledReportId,
  required String status,
  Value<String?> filePath,
  Value<String?> errorMessage,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  required String executedBy,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ReportExecutionsTableUpdateCompanionBuilder
    = ReportExecutionsCompanion Function({
  Value<String> id,
  Value<String> scheduledReportId,
  Value<String> status,
  Value<String?> filePath,
  Value<String?> errorMessage,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<String> executedBy,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ReportExecutionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReportExecutionsTable> {
  $$ReportExecutionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduledReportId => $composableBuilder(
      column: $table.scheduledReportId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get executedBy => $composableBuilder(
      column: $table.executedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ReportExecutionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportExecutionsTable> {
  $$ReportExecutionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduledReportId => $composableBuilder(
      column: $table.scheduledReportId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get executedBy => $composableBuilder(
      column: $table.executedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ReportExecutionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportExecutionsTable> {
  $$ReportExecutionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduledReportId => $composableBuilder(
      column: $table.scheduledReportId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get executedBy => $composableBuilder(
      column: $table.executedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReportExecutionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReportExecutionsTable,
    ReportExecution,
    $$ReportExecutionsTableFilterComposer,
    $$ReportExecutionsTableOrderingComposer,
    $$ReportExecutionsTableAnnotationComposer,
    $$ReportExecutionsTableCreateCompanionBuilder,
    $$ReportExecutionsTableUpdateCompanionBuilder,
    (
      ReportExecution,
      BaseReferences<_$AppDatabase, $ReportExecutionsTable, ReportExecution>
    ),
    ReportExecution,
    PrefetchHooks Function()> {
  $$ReportExecutionsTableTableManager(
      _$AppDatabase db, $ReportExecutionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportExecutionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportExecutionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportExecutionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> scheduledReportId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String> executedBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReportExecutionsCompanion(
            id: id,
            scheduledReportId: scheduledReportId,
            status: status,
            filePath: filePath,
            errorMessage: errorMessage,
            startedAt: startedAt,
            completedAt: completedAt,
            executedBy: executedBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String scheduledReportId,
            required String status,
            Value<String?> filePath = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            required String executedBy,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReportExecutionsCompanion.insert(
            id: id,
            scheduledReportId: scheduledReportId,
            status: status,
            filePath: filePath,
            errorMessage: errorMessage,
            startedAt: startedAt,
            completedAt: completedAt,
            executedBy: executedBy,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReportExecutionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReportExecutionsTable,
    ReportExecution,
    $$ReportExecutionsTableFilterComposer,
    $$ReportExecutionsTableOrderingComposer,
    $$ReportExecutionsTableAnnotationComposer,
    $$ReportExecutionsTableCreateCompanionBuilder,
    $$ReportExecutionsTableUpdateCompanionBuilder,
    (
      ReportExecution,
      BaseReferences<_$AppDatabase, $ReportExecutionsTable, ReportExecution>
    ),
    ReportExecution,
    PrefetchHooks Function()>;
typedef $$EmailNotificationsTableCreateCompanionBuilder
    = EmailNotificationsCompanion Function({
  required String id,
  required String reportExecutionId,
  required String recipient,
  required String subject,
  required String body,
  required String status,
  Value<String?> errorMessage,
  Value<DateTime?> sentAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$EmailNotificationsTableUpdateCompanionBuilder
    = EmailNotificationsCompanion Function({
  Value<String> id,
  Value<String> reportExecutionId,
  Value<String> recipient,
  Value<String> subject,
  Value<String> body,
  Value<String> status,
  Value<String?> errorMessage,
  Value<DateTime?> sentAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$EmailNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $EmailNotificationsTable> {
  $$EmailNotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reportExecutionId => $composableBuilder(
      column: $table.reportExecutionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipient => $composableBuilder(
      column: $table.recipient, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$EmailNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailNotificationsTable> {
  $$EmailNotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reportExecutionId => $composableBuilder(
      column: $table.reportExecutionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipient => $composableBuilder(
      column: $table.recipient, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subject => $composableBuilder(
      column: $table.subject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
      column: $table.sentAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EmailNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailNotificationsTable> {
  $$EmailNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reportExecutionId => $composableBuilder(
      column: $table.reportExecutionId, builder: (column) => column);

  GeneratedColumn<String> get recipient =>
      $composableBuilder(column: $table.recipient, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EmailNotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EmailNotificationsTable,
    EmailNotification,
    $$EmailNotificationsTableFilterComposer,
    $$EmailNotificationsTableOrderingComposer,
    $$EmailNotificationsTableAnnotationComposer,
    $$EmailNotificationsTableCreateCompanionBuilder,
    $$EmailNotificationsTableUpdateCompanionBuilder,
    (
      EmailNotification,
      BaseReferences<_$AppDatabase, $EmailNotificationsTable, EmailNotification>
    ),
    EmailNotification,
    PrefetchHooks Function()> {
  $$EmailNotificationsTableTableManager(
      _$AppDatabase db, $EmailNotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmailNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmailNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmailNotificationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> reportExecutionId = const Value.absent(),
            Value<String> recipient = const Value.absent(),
            Value<String> subject = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime?> sentAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmailNotificationsCompanion(
            id: id,
            reportExecutionId: reportExecutionId,
            recipient: recipient,
            subject: subject,
            body: body,
            status: status,
            errorMessage: errorMessage,
            sentAt: sentAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String reportExecutionId,
            required String recipient,
            required String subject,
            required String body,
            required String status,
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime?> sentAt = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmailNotificationsCompanion.insert(
            id: id,
            reportExecutionId: reportExecutionId,
            recipient: recipient,
            subject: subject,
            body: body,
            status: status,
            errorMessage: errorMessage,
            sentAt: sentAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EmailNotificationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EmailNotificationsTable,
    EmailNotification,
    $$EmailNotificationsTableFilterComposer,
    $$EmailNotificationsTableOrderingComposer,
    $$EmailNotificationsTableAnnotationComposer,
    $$EmailNotificationsTableCreateCompanionBuilder,
    $$EmailNotificationsTableUpdateCompanionBuilder,
    (
      EmailNotification,
      BaseReferences<_$AppDatabase, $EmailNotificationsTable, EmailNotification>
    ),
    EmailNotification,
    PrefetchHooks Function()>;
typedef $$BackupsTableCreateCompanionBuilder = BackupsCompanion Function({
  required String id,
  required String name,
  required String description,
  required String type,
  required String filePath,
  required int fileSize,
  required String checksum,
  Value<String?> encryptionKey,
  Value<bool> isEncrypted,
  Value<bool> isCompressed,
  required String status,
  Value<String?> errorMessage,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  required String createdBy,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BackupsTableUpdateCompanionBuilder = BackupsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> type,
  Value<String> filePath,
  Value<int> fileSize,
  Value<String> checksum,
  Value<String?> encryptionKey,
  Value<bool> isEncrypted,
  Value<bool> isCompressed,
  Value<String> status,
  Value<String?> errorMessage,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BackupsTableFilterComposer
    extends Composer<_$AppDatabase, $BackupsTable> {
  $$BackupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptionKey => $composableBuilder(
      column: $table.encryptionKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompressed => $composableBuilder(
      column: $table.isCompressed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BackupsTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupsTable> {
  $$BackupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptionKey => $composableBuilder(
      column: $table.encryptionKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompressed => $composableBuilder(
      column: $table.isCompressed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BackupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupsTable> {
  $$BackupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<String> get encryptionKey => $composableBuilder(
      column: $table.encryptionKey, builder: (column) => column);

  GeneratedColumn<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => column);

  GeneratedColumn<bool> get isCompressed => $composableBuilder(
      column: $table.isCompressed, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BackupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackupsTable,
    Backup,
    $$BackupsTableFilterComposer,
    $$BackupsTableOrderingComposer,
    $$BackupsTableAnnotationComposer,
    $$BackupsTableCreateCompanionBuilder,
    $$BackupsTableUpdateCompanionBuilder,
    (Backup, BaseReferences<_$AppDatabase, $BackupsTable, Backup>),
    Backup,
    PrefetchHooks Function()> {
  $$BackupsTableTableManager(_$AppDatabase db, $BackupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<String> checksum = const Value.absent(),
            Value<String?> encryptionKey = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            Value<bool> isCompressed = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupsCompanion(
            id: id,
            name: name,
            description: description,
            type: type,
            filePath: filePath,
            fileSize: fileSize,
            checksum: checksum,
            encryptionKey: encryptionKey,
            isEncrypted: isEncrypted,
            isCompressed: isCompressed,
            status: status,
            errorMessage: errorMessage,
            startedAt: startedAt,
            completedAt: completedAt,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required String type,
            required String filePath,
            required int fileSize,
            required String checksum,
            Value<String?> encryptionKey = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            Value<bool> isCompressed = const Value.absent(),
            required String status,
            Value<String?> errorMessage = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            required String createdBy,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupsCompanion.insert(
            id: id,
            name: name,
            description: description,
            type: type,
            filePath: filePath,
            fileSize: fileSize,
            checksum: checksum,
            encryptionKey: encryptionKey,
            isEncrypted: isEncrypted,
            isCompressed: isCompressed,
            status: status,
            errorMessage: errorMessage,
            startedAt: startedAt,
            completedAt: completedAt,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BackupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BackupsTable,
    Backup,
    $$BackupsTableFilterComposer,
    $$BackupsTableOrderingComposer,
    $$BackupsTableAnnotationComposer,
    $$BackupsTableCreateCompanionBuilder,
    $$BackupsTableUpdateCompanionBuilder,
    (Backup, BaseReferences<_$AppDatabase, $BackupsTable, Backup>),
    Backup,
    PrefetchHooks Function()>;
typedef $$BackupJobsTableCreateCompanionBuilder = BackupJobsCompanion Function({
  required String id,
  required String name,
  required String description,
  required String backupType,
  required String scheduleType,
  required String scheduleConfig,
  required String retentionPolicy,
  required String targetPath,
  Value<bool> isEncrypted,
  Value<bool> isCompressed,
  Value<bool> isActive,
  required DateTime nextRunAt,
  Value<DateTime?> lastRunAt,
  Value<String?> lastBackupId,
  required String createdBy,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BackupJobsTableUpdateCompanionBuilder = BackupJobsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> backupType,
  Value<String> scheduleType,
  Value<String> scheduleConfig,
  Value<String> retentionPolicy,
  Value<String> targetPath,
  Value<bool> isEncrypted,
  Value<bool> isCompressed,
  Value<bool> isActive,
  Value<DateTime> nextRunAt,
  Value<DateTime?> lastRunAt,
  Value<String?> lastBackupId,
  Value<String> createdBy,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BackupJobsTableFilterComposer
    extends Composer<_$AppDatabase, $BackupJobsTable> {
  $$BackupJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backupType => $composableBuilder(
      column: $table.backupType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleConfig => $composableBuilder(
      column: $table.scheduleConfig,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get retentionPolicy => $composableBuilder(
      column: $table.retentionPolicy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetPath => $composableBuilder(
      column: $table.targetPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompressed => $composableBuilder(
      column: $table.isCompressed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextRunAt => $composableBuilder(
      column: $table.nextRunAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastRunAt => $composableBuilder(
      column: $table.lastRunAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastBackupId => $composableBuilder(
      column: $table.lastBackupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BackupJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupJobsTable> {
  $$BackupJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backupType => $composableBuilder(
      column: $table.backupType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleConfig => $composableBuilder(
      column: $table.scheduleConfig,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get retentionPolicy => $composableBuilder(
      column: $table.retentionPolicy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetPath => $composableBuilder(
      column: $table.targetPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompressed => $composableBuilder(
      column: $table.isCompressed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextRunAt => $composableBuilder(
      column: $table.nextRunAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastRunAt => $composableBuilder(
      column: $table.lastRunAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastBackupId => $composableBuilder(
      column: $table.lastBackupId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BackupJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupJobsTable> {
  $$BackupJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get backupType => $composableBuilder(
      column: $table.backupType, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<String> get scheduleConfig => $composableBuilder(
      column: $table.scheduleConfig, builder: (column) => column);

  GeneratedColumn<String> get retentionPolicy => $composableBuilder(
      column: $table.retentionPolicy, builder: (column) => column);

  GeneratedColumn<String> get targetPath => $composableBuilder(
      column: $table.targetPath, builder: (column) => column);

  GeneratedColumn<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => column);

  GeneratedColumn<bool> get isCompressed => $composableBuilder(
      column: $table.isCompressed, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRunAt =>
      $composableBuilder(column: $table.nextRunAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastRunAt =>
      $composableBuilder(column: $table.lastRunAt, builder: (column) => column);

  GeneratedColumn<String> get lastBackupId => $composableBuilder(
      column: $table.lastBackupId, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BackupJobsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackupJobsTable,
    BackupJob,
    $$BackupJobsTableFilterComposer,
    $$BackupJobsTableOrderingComposer,
    $$BackupJobsTableAnnotationComposer,
    $$BackupJobsTableCreateCompanionBuilder,
    $$BackupJobsTableUpdateCompanionBuilder,
    (BackupJob, BaseReferences<_$AppDatabase, $BackupJobsTable, BackupJob>),
    BackupJob,
    PrefetchHooks Function()> {
  $$BackupJobsTableTableManager(_$AppDatabase db, $BackupJobsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> backupType = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<String> scheduleConfig = const Value.absent(),
            Value<String> retentionPolicy = const Value.absent(),
            Value<String> targetPath = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            Value<bool> isCompressed = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> nextRunAt = const Value.absent(),
            Value<DateTime?> lastRunAt = const Value.absent(),
            Value<String?> lastBackupId = const Value.absent(),
            Value<String> createdBy = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupJobsCompanion(
            id: id,
            name: name,
            description: description,
            backupType: backupType,
            scheduleType: scheduleType,
            scheduleConfig: scheduleConfig,
            retentionPolicy: retentionPolicy,
            targetPath: targetPath,
            isEncrypted: isEncrypted,
            isCompressed: isCompressed,
            isActive: isActive,
            nextRunAt: nextRunAt,
            lastRunAt: lastRunAt,
            lastBackupId: lastBackupId,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required String backupType,
            required String scheduleType,
            required String scheduleConfig,
            required String retentionPolicy,
            required String targetPath,
            Value<bool> isEncrypted = const Value.absent(),
            Value<bool> isCompressed = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime nextRunAt,
            Value<DateTime?> lastRunAt = const Value.absent(),
            Value<String?> lastBackupId = const Value.absent(),
            required String createdBy,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupJobsCompanion.insert(
            id: id,
            name: name,
            description: description,
            backupType: backupType,
            scheduleType: scheduleType,
            scheduleConfig: scheduleConfig,
            retentionPolicy: retentionPolicy,
            targetPath: targetPath,
            isEncrypted: isEncrypted,
            isCompressed: isCompressed,
            isActive: isActive,
            nextRunAt: nextRunAt,
            lastRunAt: lastRunAt,
            lastBackupId: lastBackupId,
            createdBy: createdBy,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BackupJobsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BackupJobsTable,
    BackupJob,
    $$BackupJobsTableFilterComposer,
    $$BackupJobsTableOrderingComposer,
    $$BackupJobsTableAnnotationComposer,
    $$BackupJobsTableCreateCompanionBuilder,
    $$BackupJobsTableUpdateCompanionBuilder,
    (BackupJob, BaseReferences<_$AppDatabase, $BackupJobsTable, BackupJob>),
    BackupJob,
    PrefetchHooks Function()>;
typedef $$RoutesTableCreateCompanionBuilder = RoutesCompanion Function({
  required String id,
  required String name,
  required String description,
  required String routeType,
  required String distance,
  required String duration,
  required String status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RoutesTableUpdateCompanionBuilder = RoutesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> routeType,
  Value<String> distance,
  Value<String> duration,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$RoutesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routeType => $composableBuilder(
      column: $table.routeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RoutesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routeType => $composableBuilder(
      column: $table.routeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RoutesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get routeType =>
      $composableBuilder(column: $table.routeType, builder: (column) => column);

  GeneratedColumn<String> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RoutesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutesTable,
    Route,
    $$RoutesTableFilterComposer,
    $$RoutesTableOrderingComposer,
    $$RoutesTableAnnotationComposer,
    $$RoutesTableCreateCompanionBuilder,
    $$RoutesTableUpdateCompanionBuilder,
    (Route, BaseReferences<_$AppDatabase, $RoutesTable, Route>),
    Route,
    PrefetchHooks Function()> {
  $$RoutesTableTableManager(_$AppDatabase db, $RoutesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> routeType = const Value.absent(),
            Value<String> distance = const Value.absent(),
            Value<String> duration = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutesCompanion(
            id: id,
            name: name,
            description: description,
            routeType: routeType,
            distance: distance,
            duration: duration,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String description,
            required String routeType,
            required String distance,
            required String duration,
            required String status,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutesCompanion.insert(
            id: id,
            name: name,
            description: description,
            routeType: routeType,
            distance: distance,
            duration: duration,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RoutesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutesTable,
    Route,
    $$RoutesTableFilterComposer,
    $$RoutesTableOrderingComposer,
    $$RoutesTableAnnotationComposer,
    $$RoutesTableCreateCompanionBuilder,
    $$RoutesTableUpdateCompanionBuilder,
    (Route, BaseReferences<_$AppDatabase, $RoutesTable, Route>),
    Route,
    PrefetchHooks Function()>;
typedef $$RouteHistoryTableCreateCompanionBuilder = RouteHistoryCompanion
    Function({
  required String id,
  required String routeId,
  required String driverId,
  required String vehicleId,
  required DateTime startDate,
  required DateTime endDate,
  required String status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RouteHistoryTableUpdateCompanionBuilder = RouteHistoryCompanion
    Function({
  Value<String> id,
  Value<String> routeId,
  Value<String> driverId,
  Value<String> vehicleId,
  Value<DateTime> startDate,
  Value<DateTime> endDate,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$RouteHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $RouteHistoryTable> {
  $$RouteHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routeId => $composableBuilder(
      column: $table.routeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get driverId => $composableBuilder(
      column: $table.driverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vehicleId => $composableBuilder(
      column: $table.vehicleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RouteHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $RouteHistoryTable> {
  $$RouteHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routeId => $composableBuilder(
      column: $table.routeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get driverId => $composableBuilder(
      column: $table.driverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vehicleId => $composableBuilder(
      column: $table.vehicleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RouteHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $RouteHistoryTable> {
  $$RouteHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => column);

  GeneratedColumn<String> get driverId =>
      $composableBuilder(column: $table.driverId, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RouteHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RouteHistoryTable,
    RouteHistoryData,
    $$RouteHistoryTableFilterComposer,
    $$RouteHistoryTableOrderingComposer,
    $$RouteHistoryTableAnnotationComposer,
    $$RouteHistoryTableCreateCompanionBuilder,
    $$RouteHistoryTableUpdateCompanionBuilder,
    (
      RouteHistoryData,
      BaseReferences<_$AppDatabase, $RouteHistoryTable, RouteHistoryData>
    ),
    RouteHistoryData,
    PrefetchHooks Function()> {
  $$RouteHistoryTableTableManager(_$AppDatabase db, $RouteHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RouteHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RouteHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RouteHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> routeId = const Value.absent(),
            Value<String> driverId = const Value.absent(),
            Value<String> vehicleId = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> endDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RouteHistoryCompanion(
            id: id,
            routeId: routeId,
            driverId: driverId,
            vehicleId: vehicleId,
            startDate: startDate,
            endDate: endDate,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String routeId,
            required String driverId,
            required String vehicleId,
            required DateTime startDate,
            required DateTime endDate,
            required String status,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RouteHistoryCompanion.insert(
            id: id,
            routeId: routeId,
            driverId: driverId,
            vehicleId: vehicleId,
            startDate: startDate,
            endDate: endDate,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RouteHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RouteHistoryTable,
    RouteHistoryData,
    $$RouteHistoryTableFilterComposer,
    $$RouteHistoryTableOrderingComposer,
    $$RouteHistoryTableAnnotationComposer,
    $$RouteHistoryTableCreateCompanionBuilder,
    $$RouteHistoryTableUpdateCompanionBuilder,
    (
      RouteHistoryData,
      BaseReferences<_$AppDatabase, $RouteHistoryTable, RouteHistoryData>
    ),
    RouteHistoryData,
    PrefetchHooks Function()>;
typedef $$FuelEntriesTableCreateCompanionBuilder = FuelEntriesCompanion
    Function({
  required String id,
  required String vehicleId,
  required String fuelType,
  required double quantityLiters,
  required double costPerLiter,
  required double totalCost,
  required double odometerReading,
  Value<String?> fuelPumpName,
  required DateTime entryDate,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FuelEntriesTableUpdateCompanionBuilder = FuelEntriesCompanion
    Function({
  Value<String> id,
  Value<String> vehicleId,
  Value<String> fuelType,
  Value<double> quantityLiters,
  Value<double> costPerLiter,
  Value<double> totalCost,
  Value<double> odometerReading,
  Value<String?> fuelPumpName,
  Value<DateTime> entryDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FuelEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FuelEntriesTable> {
  $$FuelEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vehicleId => $composableBuilder(
      column: $table.vehicleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fuelType => $composableBuilder(
      column: $table.fuelType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantityLiters => $composableBuilder(
      column: $table.quantityLiters,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPerLiter => $composableBuilder(
      column: $table.costPerLiter, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCost => $composableBuilder(
      column: $table.totalCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get odometerReading => $composableBuilder(
      column: $table.odometerReading,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fuelPumpName => $composableBuilder(
      column: $table.fuelPumpName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
      column: $table.entryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FuelEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelEntriesTable> {
  $$FuelEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vehicleId => $composableBuilder(
      column: $table.vehicleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fuelType => $composableBuilder(
      column: $table.fuelType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantityLiters => $composableBuilder(
      column: $table.quantityLiters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPerLiter => $composableBuilder(
      column: $table.costPerLiter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCost => $composableBuilder(
      column: $table.totalCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get odometerReading => $composableBuilder(
      column: $table.odometerReading,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fuelPumpName => $composableBuilder(
      column: $table.fuelPumpName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
      column: $table.entryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FuelEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelEntriesTable> {
  $$FuelEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<double> get quantityLiters => $composableBuilder(
      column: $table.quantityLiters, builder: (column) => column);

  GeneratedColumn<double> get costPerLiter => $composableBuilder(
      column: $table.costPerLiter, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<double> get odometerReading => $composableBuilder(
      column: $table.odometerReading, builder: (column) => column);

  GeneratedColumn<String> get fuelPumpName => $composableBuilder(
      column: $table.fuelPumpName, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FuelEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FuelEntriesTable,
    FuelEntry,
    $$FuelEntriesTableFilterComposer,
    $$FuelEntriesTableOrderingComposer,
    $$FuelEntriesTableAnnotationComposer,
    $$FuelEntriesTableCreateCompanionBuilder,
    $$FuelEntriesTableUpdateCompanionBuilder,
    (FuelEntry, BaseReferences<_$AppDatabase, $FuelEntriesTable, FuelEntry>),
    FuelEntry,
    PrefetchHooks Function()> {
  $$FuelEntriesTableTableManager(_$AppDatabase db, $FuelEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> vehicleId = const Value.absent(),
            Value<String> fuelType = const Value.absent(),
            Value<double> quantityLiters = const Value.absent(),
            Value<double> costPerLiter = const Value.absent(),
            Value<double> totalCost = const Value.absent(),
            Value<double> odometerReading = const Value.absent(),
            Value<String?> fuelPumpName = const Value.absent(),
            Value<DateTime> entryDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FuelEntriesCompanion(
            id: id,
            vehicleId: vehicleId,
            fuelType: fuelType,
            quantityLiters: quantityLiters,
            costPerLiter: costPerLiter,
            totalCost: totalCost,
            odometerReading: odometerReading,
            fuelPumpName: fuelPumpName,
            entryDate: entryDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String vehicleId,
            required String fuelType,
            required double quantityLiters,
            required double costPerLiter,
            required double totalCost,
            required double odometerReading,
            Value<String?> fuelPumpName = const Value.absent(),
            required DateTime entryDate,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FuelEntriesCompanion.insert(
            id: id,
            vehicleId: vehicleId,
            fuelType: fuelType,
            quantityLiters: quantityLiters,
            costPerLiter: costPerLiter,
            totalCost: totalCost,
            odometerReading: odometerReading,
            fuelPumpName: fuelPumpName,
            entryDate: entryDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FuelEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FuelEntriesTable,
    FuelEntry,
    $$FuelEntriesTableFilterComposer,
    $$FuelEntriesTableOrderingComposer,
    $$FuelEntriesTableAnnotationComposer,
    $$FuelEntriesTableCreateCompanionBuilder,
    $$FuelEntriesTableUpdateCompanionBuilder,
    (FuelEntry, BaseReferences<_$AppDatabase, $FuelEntriesTable, FuelEntry>),
    FuelEntry,
    PrefetchHooks Function()>;
typedef $$MaintenanceSchedulesTableCreateCompanionBuilder
    = MaintenanceSchedulesCompanion Function({
  required String id,
  required String vehicleId,
  required String maintenanceType,
  required DateTime scheduleDate,
  required DateTime dueDate,
  required String status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MaintenanceSchedulesTableUpdateCompanionBuilder
    = MaintenanceSchedulesCompanion Function({
  Value<String> id,
  Value<String> vehicleId,
  Value<String> maintenanceType,
  Value<DateTime> scheduleDate,
  Value<DateTime> dueDate,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MaintenanceSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceSchedulesTable> {
  $$MaintenanceSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vehicleId => $composableBuilder(
      column: $table.vehicleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get maintenanceType => $composableBuilder(
      column: $table.maintenanceType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduleDate => $composableBuilder(
      column: $table.scheduleDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MaintenanceSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceSchedulesTable> {
  $$MaintenanceSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vehicleId => $composableBuilder(
      column: $table.vehicleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get maintenanceType => $composableBuilder(
      column: $table.maintenanceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduleDate => $composableBuilder(
      column: $table.scheduleDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MaintenanceSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceSchedulesTable> {
  $$MaintenanceSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get maintenanceType => $composableBuilder(
      column: $table.maintenanceType, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduleDate => $composableBuilder(
      column: $table.scheduleDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MaintenanceSchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaintenanceSchedulesTable,
    MaintenanceSchedule,
    $$MaintenanceSchedulesTableFilterComposer,
    $$MaintenanceSchedulesTableOrderingComposer,
    $$MaintenanceSchedulesTableAnnotationComposer,
    $$MaintenanceSchedulesTableCreateCompanionBuilder,
    $$MaintenanceSchedulesTableUpdateCompanionBuilder,
    (
      MaintenanceSchedule,
      BaseReferences<_$AppDatabase, $MaintenanceSchedulesTable,
          MaintenanceSchedule>
    ),
    MaintenanceSchedule,
    PrefetchHooks Function()> {
  $$MaintenanceSchedulesTableTableManager(
      _$AppDatabase db, $MaintenanceSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceSchedulesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceSchedulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> vehicleId = const Value.absent(),
            Value<String> maintenanceType = const Value.absent(),
            Value<DateTime> scheduleDate = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceSchedulesCompanion(
            id: id,
            vehicleId: vehicleId,
            maintenanceType: maintenanceType,
            scheduleDate: scheduleDate,
            dueDate: dueDate,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String vehicleId,
            required String maintenanceType,
            required DateTime scheduleDate,
            required DateTime dueDate,
            required String status,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MaintenanceSchedulesCompanion.insert(
            id: id,
            vehicleId: vehicleId,
            maintenanceType: maintenanceType,
            scheduleDate: scheduleDate,
            dueDate: dueDate,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MaintenanceSchedulesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MaintenanceSchedulesTable,
        MaintenanceSchedule,
        $$MaintenanceSchedulesTableFilterComposer,
        $$MaintenanceSchedulesTableOrderingComposer,
        $$MaintenanceSchedulesTableAnnotationComposer,
        $$MaintenanceSchedulesTableCreateCompanionBuilder,
        $$MaintenanceSchedulesTableUpdateCompanionBuilder,
        (
          MaintenanceSchedule,
          BaseReferences<_$AppDatabase, $MaintenanceSchedulesTable,
              MaintenanceSchedule>
        ),
        MaintenanceSchedule,
        PrefetchHooks Function()>;
typedef $$GpsBreadcrumbsTableCreateCompanionBuilder = GpsBreadcrumbsCompanion
    Function({
  required String id,
  required String tripId,
  required double latitude,
  required double longitude,
  required DateTime timestamp,
  required double speed,
  required double accuracy,
  Value<int> rowid,
});
typedef $$GpsBreadcrumbsTableUpdateCompanionBuilder = GpsBreadcrumbsCompanion
    Function({
  Value<String> id,
  Value<String> tripId,
  Value<double> latitude,
  Value<double> longitude,
  Value<DateTime> timestamp,
  Value<double> speed,
  Value<double> accuracy,
  Value<int> rowid,
});

class $$GpsBreadcrumbsTableFilterComposer
    extends Composer<_$AppDatabase, $GpsBreadcrumbsTable> {
  $$GpsBreadcrumbsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tripId => $composableBuilder(
      column: $table.tripId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get speed => $composableBuilder(
      column: $table.speed, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnFilters(column));
}

class $$GpsBreadcrumbsTableOrderingComposer
    extends Composer<_$AppDatabase, $GpsBreadcrumbsTable> {
  $$GpsBreadcrumbsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tripId => $composableBuilder(
      column: $table.tripId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get speed => $composableBuilder(
      column: $table.speed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnOrderings(column));
}

class $$GpsBreadcrumbsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GpsBreadcrumbsTable> {
  $$GpsBreadcrumbsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);
}

class $$GpsBreadcrumbsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GpsBreadcrumbsTable,
    GpsBreadcrumb,
    $$GpsBreadcrumbsTableFilterComposer,
    $$GpsBreadcrumbsTableOrderingComposer,
    $$GpsBreadcrumbsTableAnnotationComposer,
    $$GpsBreadcrumbsTableCreateCompanionBuilder,
    $$GpsBreadcrumbsTableUpdateCompanionBuilder,
    (
      GpsBreadcrumb,
      BaseReferences<_$AppDatabase, $GpsBreadcrumbsTable, GpsBreadcrumb>
    ),
    GpsBreadcrumb,
    PrefetchHooks Function()> {
  $$GpsBreadcrumbsTableTableManager(
      _$AppDatabase db, $GpsBreadcrumbsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GpsBreadcrumbsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GpsBreadcrumbsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GpsBreadcrumbsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tripId = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<double> speed = const Value.absent(),
            Value<double> accuracy = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GpsBreadcrumbsCompanion(
            id: id,
            tripId: tripId,
            latitude: latitude,
            longitude: longitude,
            timestamp: timestamp,
            speed: speed,
            accuracy: accuracy,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String tripId,
            required double latitude,
            required double longitude,
            required DateTime timestamp,
            required double speed,
            required double accuracy,
            Value<int> rowid = const Value.absent(),
          }) =>
              GpsBreadcrumbsCompanion.insert(
            id: id,
            tripId: tripId,
            latitude: latitude,
            longitude: longitude,
            timestamp: timestamp,
            speed: speed,
            accuracy: accuracy,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GpsBreadcrumbsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GpsBreadcrumbsTable,
    GpsBreadcrumb,
    $$GpsBreadcrumbsTableFilterComposer,
    $$GpsBreadcrumbsTableOrderingComposer,
    $$GpsBreadcrumbsTableAnnotationComposer,
    $$GpsBreadcrumbsTableCreateCompanionBuilder,
    $$GpsBreadcrumbsTableUpdateCompanionBuilder,
    (
      GpsBreadcrumb,
      BaseReferences<_$AppDatabase, $GpsBreadcrumbsTable, GpsBreadcrumb>
    ),
    GpsBreadcrumb,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db, _db.drivers);
  $$PartiesTableTableManager get parties =>
      $$PartiesTableTableManager(_db, _db.parties);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserSessionsTableTableManager get userSessions =>
      $$UserSessionsTableTableManager(_db, _db.userSessions);
  $$UserPermissionsTableTableManager get userPermissions =>
      $$UserPermissionsTableTableManager(_db, _db.userPermissions);
  $$ActivityLogsTableTableManager get activityLogs =>
      $$ActivityLogsTableTableManager(_db, _db.activityLogs);
  $$SystemSettingsTableTableManager get systemSettings =>
      $$SystemSettingsTableTableManager(_db, _db.systemSettings);
  $$ScheduledReportsTableTableManager get scheduledReports =>
      $$ScheduledReportsTableTableManager(_db, _db.scheduledReports);
  $$ReportExecutionsTableTableManager get reportExecutions =>
      $$ReportExecutionsTableTableManager(_db, _db.reportExecutions);
  $$EmailNotificationsTableTableManager get emailNotifications =>
      $$EmailNotificationsTableTableManager(_db, _db.emailNotifications);
  $$BackupsTableTableManager get backups =>
      $$BackupsTableTableManager(_db, _db.backups);
  $$BackupJobsTableTableManager get backupJobs =>
      $$BackupJobsTableTableManager(_db, _db.backupJobs);
  $$RoutesTableTableManager get routes =>
      $$RoutesTableTableManager(_db, _db.routes);
  $$RouteHistoryTableTableManager get routeHistory =>
      $$RouteHistoryTableTableManager(_db, _db.routeHistory);
  $$FuelEntriesTableTableManager get fuelEntries =>
      $$FuelEntriesTableTableManager(_db, _db.fuelEntries);
  $$MaintenanceSchedulesTableTableManager get maintenanceSchedules =>
      $$MaintenanceSchedulesTableTableManager(_db, _db.maintenanceSchedules);
  $$GpsBreadcrumbsTableTableManager get gpsBreadcrumbs =>
      $$GpsBreadcrumbsTableTableManager(_db, _db.gpsBreadcrumbs);
}
