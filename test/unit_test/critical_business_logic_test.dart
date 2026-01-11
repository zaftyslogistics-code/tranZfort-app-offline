import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as drift;
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/data/repositories/expense_repository.dart';
import 'package:tranzfort_tms/data/repositories/payment_repository.dart';
import 'package:tranzfort_tms/data/repositories/trip_repository.dart';
import 'package:tranzfort_tms/data/services/payment_service.dart';
import 'package:tranzfort_tms/data/services/trip_service.dart';
import 'package:tranzfort_tms/data/services/expense_service.dart';

void main() {
  group('Critical Business Logic Tests', () {
    late AppDatabase db;
    late TripRepository tripRepo;
    late ExpenseRepository expenseRepo;
    late PaymentRepository paymentRepo;
    late PaymentService paymentService;
    late TripService tripService;
    late ExpenseService expenseService;

    setUp(() async {
      db = AppDatabase.forTesting();
      tripRepo = TripRepository(db);
      expenseRepo = ExpenseRepository(db);
      paymentRepo = PaymentRepository(db);
      paymentService = PaymentService(paymentRepo, tripRepo);
      tripService = TripService(tripRepo);
      expenseService = ExpenseService(expenseRepo, tripRepo);
    });

    tearDown(() async {
      await db.close();
    });

    test('Trip total calculation - Freight - Expenses - Payments', () async {
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
        status: 'ACTIVE',
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

      // Test trip balance calculation
      final tripBalance = await paymentRepo.getPendingBalanceForTrip('trip-1');
      // Expected: 5000 (freight) - 1500 (expenses) - 3000 (payments) = 500
      expect(tripBalance, 500.0);

      print('✅ Trip balance calculation correct: $tripBalance');
    });

    test('Ledger balance update after payment and expense', () async {
      // Create test party and trip
      await db.into(db.parties).insert(PartiesCompanion.insert(
        id: 'party-2',
        name: 'Test Party 2',
        mobile: '9876543210',
        city: 'Test City',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.trips).insert(TripsCompanion.insert(
        id: 'trip-2',
        fromLocation: 'C',
        toLocation: 'D',
        vehicleId: 'vehicle-2',
        driverId: 'driver-2',
        partyId: 'party-2',
        freightAmount: 3000.0,
        status: 'ACTIVE',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Initial balance should be full freight amount
      final initialBalance = await paymentRepo.getPendingBalanceForTrip('trip-2');
      expect(initialBalance, 3000.0);

      // Add expense
      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-3',
        tripId: 'trip-2',
        category: 'Fuel',
        amount: 800.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Balance after expense: 3000 - 800 = 2200
      final balanceAfterExpense = await paymentRepo.getPendingBalanceForTrip('trip-2');
      expect(balanceAfterExpense, 2200.0);

      // Add payment
      await db.into(db.payments).insert(PaymentsCompanion.insert(
        id: 'payment-3',
        partyId: 'party-2',
        amount: 1200.0,
        type: 'ADVANCE',
        mode: 'Cash',
        tripId: drift.Value('trip-2'),
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Final balance: 3000 - 800 - 1200 = 1000
      final finalBalance = await paymentRepo.getPendingBalanceForTrip('trip-2');
      expect(finalBalance, 1000.0);

      print('✅ Ledger balance updates correctly: $finalBalance');
    });

    test('Payment after expense scenario', () async {
      // Create test party and trip
      await db.into(db.parties).insert(PartiesCompanion.insert(
        id: 'party-3',
        name: 'Test Party 3',
        mobile: '5555555555',
        city: 'Test City',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.trips).insert(TripsCompanion.insert(
        id: 'trip-3',
        fromLocation: 'E',
        toLocation: 'F',
        vehicleId: 'vehicle-3',
        driverId: 'driver-3',
        partyId: 'party-3',
        freightAmount: 4000.0,
        status: 'ACTIVE',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Add multiple expenses first
      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-4',
        tripId: 'trip-3',
        category: 'Fuel',
        amount: 1200.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-5',
        tripId: 'trip-3',
        category: 'Toll',
        amount: 300.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Total expenses: 1500
      // Expected balance: 4000 - 1500 = 2500
      final balanceAfterExpenses = await paymentRepo.getPendingBalanceForTrip('trip-3');
      expect(balanceAfterExpenses, 2500.0);

      // Now add payment
      await db.into(db.payments).insert(PaymentsCompanion.insert(
        id: 'payment-4',
        partyId: 'party-3',
        amount: 1500.0,
        type: 'ADVANCE',
        mode: 'Bank',
        tripId: drift.Value('trip-3'),
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Final balance: 4000 - 1500 - 1500 = 1000
      final finalBalance = await paymentRepo.getPendingBalanceForTrip('trip-3');
      expect(finalBalance, 1000.0);

      print('✅ Payment after expense scenario correct: $finalBalance');
    });

    test('Empty expenses and payments handling', () async {
      // Create test party and trip
      await db.into(db.parties).insert(PartiesCompanion.insert(
        id: 'party-4',
        name: 'Test Party 4',
        mobile: '1111111111',
        city: 'Test City',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.trips).insert(TripsCompanion.insert(
        id: 'trip-4',
        fromLocation: 'G',
        toLocation: 'H',
        vehicleId: 'vehicle-4',
        driverId: 'driver-4',
        partyId: 'party-4',
        freightAmount: 2000.0,
        status: 'ACTIVE',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // No expenses or payments added
      // Balance should be full freight amount
      final balance = await paymentRepo.getPendingBalanceForTrip('trip-4');
      expect(balance, 2000.0);

      print('✅ Empty expenses/payments handled correctly: $balance');
    });

    test('Trip completion validation', () async {
      // Create test trip
      await db.into(db.trips).insert(TripsCompanion.insert(
        id: 'trip-5',
        fromLocation: 'I',
        toLocation: 'J',
        vehicleId: 'vehicle-5',
        driverId: 'driver-5',
        partyId: 'party-5',
        freightAmount: 1000.0,
        status: 'ACTIVE',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Should be able to complete active trip
      await tripService.completeTrip('trip-5');
      
      final completedTrip = await tripRepo.getTripById('trip-5');
      expect(completedTrip?.status, 'COMPLETED');
      expect(completedTrip?.actualEndDate, isNotNull);

      // Should not be able to complete already completed trip
      try {
        await tripService.completeTrip('trip-5');
        fail('Should have thrown exception for completing completed trip');
      } catch (e) {
        expect(e.toString(), contains('Only active trips can be completed'));
      }

      print('✅ Trip completion validation works correctly');
    });

    test('Negative balance edge case', () async {
      // Create test party and trip
      await db.into(db.parties).insert(PartiesCompanion.insert(
        id: 'party-6',
        name: 'Test Party 6',
        mobile: '2222222222',
        city: 'Test City',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.trips).insert(TripsCompanion.insert(
        id: 'trip-6',
        fromLocation: 'K',
        toLocation: 'L',
        vehicleId: 'vehicle-6',
        driverId: 'driver-6',
        partyId: 'party-6',
        freightAmount: 1000.0, // Low freight amount
        status: 'ACTIVE',
        startDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Add expenses that exceed freight amount
      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-6',
        tripId: 'trip-6',
        category: 'Fuel',
        amount: 800.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      await db.into(db.expenses).insert(ExpensesCompanion.insert(
        id: 'expense-7',
        tripId: 'trip-6',
        category: 'Maintenance',
        amount: 500.0,
        paidMode: 'Cash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Add payment
      await db.into(db.payments).insert(PaymentsCompanion.insert(
        id: 'payment-5',
        partyId: 'party-6',
        amount: 200.0,
        type: 'ADVANCE',
        mode: 'Cash',
        tripId: drift.Value('trip-6'),
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

      // Balance: 1000 - 1300 - 200 = -500 (negative balance)
      final balance = await paymentRepo.getPendingBalanceForTrip('trip-6');
      expect(balance, -500.0);

      print('✅ Negative balance edge case handled: $balance');
    });
  });
}
