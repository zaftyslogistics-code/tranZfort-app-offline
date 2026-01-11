import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/data/repositories/expense_repository.dart';
import 'package:tranzfort_tms/data/repositories/payment_repository.dart';
import 'package:tranzfort_tms/data/repositories/trip_repository.dart';
import 'package:tranzfort_tms/data/services/payment_service.dart';
import 'package:tranzfort_tms/data/services/trip_service.dart';

void main() {
  group('Business Logic Unit Tests', () {
    late AppDatabase db;
    late TripRepository tripRepo;
    late ExpenseRepository expenseRepo;
    late PaymentRepository paymentRepo;
    late PaymentService paymentService;
    late TripService tripService;

    setUp(() async {
      db = AppDatabase.forTesting();
      tripRepo = TripRepository(db);
      expenseRepo = ExpenseRepository(db);
      paymentRepo = PaymentRepository(db);
      paymentService = PaymentService(paymentRepo, tripRepo);
      tripService = TripService(tripRepo);
    });

    tearDown(() async {
      await db.close();
    });

    test('Ledger Balance Calculation Test', () async {
      // Create test party
      await db.into(db.parties).insert(PartiesCompanion.insert(
        id: 'party-1',
        name: 'Test Party',
        mobile: '1234567890',
        city: 'Test City',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Create test trip
      await db.into(db.trips).insert(TripsCompanion.insert(
        id: 'trip-1',
        fromLocation: 'A',
        toLocation: 'B',
        vehicleId: 'vehicle-1',
        driverId: 'driver-1',
        partyId: 'party-1',
        freightAmount: 5000.0,
        status: 'COMPLETED',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Add expenses
      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-1',
        tripId: 'trip-1',
        category: 'Fuel',
        amount: 1000.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-2',
        tripId: 'trip-1',
        category: 'Maintenance',
        amount: 500.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Add payments
      await db.into(db.payments).insert(PaymentsCompanion.insert(
        id: 'payment-1',
        partyId: 'party-1',
        amount: 2000.0,
        type: 'ADVANCE',
        mode: 'Cash',
        tripId: drift.Value('trip-1'),
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.payments).insert(PaymentsCompanion.insert(
        id: 'payment-2',
        partyId: 'party-1',
        amount: 1000.0,
        type: 'BALANCE',
        mode: 'Bank',
        tripId: drift.Value('trip-1'),
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Test trip balance
      final tripBalance = await paymentRepo.getPendingBalanceForTrip('trip-1');
      // Expected: 5000 (freight) - 1500 (expenses) - 3000 (payments) = 500
      expect(tripBalance, 500.0);

      // Test party balance
      final partyBalance = await paymentRepo.getPendingBalanceForParty('party-1');
      expect(partyBalance, 500.0);

      print('✅ Ledger balance calculations correct');
    });

    test('Trip Profitability Test', () async {
      // Create test trip with known values
      await db.into(db.trips).insert(TripsCompanion.insert(
        id: 'trip-profit-1',
        fromLocation: 'A',
        toLocation: 'B',
        vehicleId: 'vehicle-1',
        driverId: 'driver-1',
        partyId: 'party-1',
        freightAmount: 10000.0,
        status: 'COMPLETED',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Add expenses
      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-profit-1',
        tripId: 'trip-profit-1',
        category: 'Fuel',
        amount: 3000.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-profit-2',
        tripId: 'trip-profit-1',
        category: 'Toll',
        amount: 500.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Calculate profitability
      final trip = await tripRepo.getTripById('trip-profit-1');
      final expenses = await expenseRepo.getExpensesByTrip('trip-profit-1');
      final totalExpenses = expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
      final profitability = tripService.calculateTripProfitability(trip!, totalExpenses);

      // Expected: 10000 - 3500 = 6500
      expect(profitability, 6500.0);

      print('✅ Trip profitability calculation correct');
    });

    test('Payment Validation Test', () async {
      // Test valid payment data
      expect(paymentRepo.validatePaymentData(
        partyId: 'party-1',
        amount: 1000.0,
        type: 'ADVANCE',
        mode: 'Cash',
      ), true);

      // Test invalid payment data
      expect(paymentRepo.validatePaymentData(
        partyId: '', // Empty
        amount: 1000.0,
        type: 'ADVANCE',
        mode: 'Cash',
      ), false);

      expect(paymentRepo.validatePaymentData(
        partyId: 'party-1',
        amount: -100.0, // Negative
        type: 'ADVANCE',
        mode: 'Cash',
      ), false);

      expect(paymentRepo.validatePaymentData(
        partyId: 'party-1',
        amount: 0.0, // Zero
        type: 'ADVANCE',
        mode: 'Cash',
      ), false);

      print('✅ Payment validation working correctly');
    });

    test('Vehicle Availability Test', () async {
      // Create test vehicle
      await db.into(db.vehicles).insert(VehiclesCompanion.insert(
        id: 'vehicle-avail-1',
        truckNumber: 'AVAIL-001',
        truckType: 'Truck',
        capacity: 1000.0,
        fuelType: 'Diesel',
        registrationNumber: 'REG-001',
        status: 'IDLE',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Create test driver
      await db.into(db.drivers).insert(DriversCompanion.insert(
        id: 'driver-avail-1',
        name: 'Test Driver',
        phone: '1234567890',
        licenseNumber: 'LIC-001',
        licenseType: 'Heavy',
        status: 'ACTIVE',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Test availability when idle
      expect(await tripRepo.isVehicleAvailable('vehicle-avail-1'), true);
      expect(await tripRepo.isDriverAvailable('driver-avail-1'), true);

      // Create active trip
      await db.into(db.trips).insert(TripsCompanion.insert(
        id: 'trip-avail-1',
        fromLocation: 'A',
        toLocation: 'B',
        vehicleId: 'vehicle-avail-1',
        driverId: 'driver-avail-1',
        partyId: 'party-1',
        freightAmount: 5000.0,
        status: 'ACTIVE',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Test availability when on trip
      expect(await tripRepo.isVehicleAvailable('vehicle-avail-1'), false);
      expect(await tripRepo.isDriverAvailable('driver-avail-1'), false);

      print('✅ Vehicle/driver availability checks working');
    });

  });
}
