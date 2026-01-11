import 'package:flutter_test/flutter_test.dart';
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/data/repositories/driver_repository.dart';
import 'package:tranzfort_tms/data/repositories/expense_repository.dart';
import 'package:tranzfort_tms/data/repositories/party_repository.dart';
import 'package:tranzfort_tms/data/repositories/payment_repository.dart';
import 'package:tranzfort_tms/data/repositories/trip_repository.dart';
import 'package:tranzfort_tms/data/repositories/vehicle_repository.dart';
import 'package:tranzfort_tms/data/services/vehicle_service.dart';
import 'package:tranzfort_tms/data/services/driver_service.dart';
import 'package:tranzfort_tms/data/services/party_service.dart';
import 'package:tranzfort_tms/data/services/trip_service.dart';
import 'package:tranzfort_tms/data/services/expense_service.dart';
import 'package:tranzfort_tms/data/services/payment_service.dart';

void main() {
  group('Phase 1 Smoke Tests', () {
    late AppDatabase db;
    late VehicleRepository vehicleRepo;
    late DriverRepository driverRepo;
    late PartyRepository partyRepo;
    late TripRepository tripRepo;
    late ExpenseRepository expenseRepo;
    late PaymentRepository paymentRepo;
    late VehicleService vehicleService;
    late DriverService driverService;
    late PartyService partyService;
    late TripService tripService;
    late ExpenseService expenseService;
    late PaymentService paymentService;

    setUpAll(() async {
      // Initialize database and services
      db = AppDatabase.forTesting();
      vehicleRepo = VehicleRepository(db);
      driverRepo = DriverRepository(db);
      partyRepo = PartyRepository(db);
      tripRepo = TripRepository(db);
      expenseRepo = ExpenseRepository(db);
      paymentRepo = PaymentRepository(db);

      vehicleService = VehicleService(vehicleRepo);
      driverService = DriverService(driverRepo);
      partyService = PartyService(partyRepo);
      tripService = TripService(tripRepo);
      expenseService = ExpenseService(expenseRepo, tripRepo);
      paymentService = PaymentService(paymentRepo, tripRepo);
    });

    tearDownAll(() async {
      await db.close();
    });

    test('Complete Transport Flow Test', () async {
      print('🚗 Testing Vehicle Creation...');
      await vehicleService.createVehicle(
        truckNumber: 'TEST-001',
        truckType: 'Truck',
        capacity: 1000.0,
        fuelType: 'Diesel',
        registrationNumber: 'REG-001',
      );
      
      final vehicles = await vehicleService.getAllVehicles();
      expect(vehicles.length, 1);
      expect(vehicles.first.truckNumber, 'TEST-001');
      print('✅ Vehicle created successfully');

      // 2. Test Driver Creation
      print('👨‍✈️ Testing Driver Creation...');
      await driverService.createDriver(
        name: 'Test Driver',
        phone: '1234567890',
        licenseNumber: 'LIC-001',
        licenseType: 'Heavy',
      );
      
      final drivers = await driverService.getAllDrivers();
      expect(drivers.length, 1);
      expect(drivers.first.name, 'Test Driver');
      print('✅ Driver created successfully');

      // 3. Test Party Creation
      print('🏢 Testing Party Creation...');
      await partyService.createParty(
        name: 'Test Party',
        mobile: '9876543210',
        city: 'Test City',
      );
      
      final parties = await partyService.getAllParties();
      expect(parties.length, 1);
      expect(parties.first.name, 'Test Party');
      print('✅ Party created successfully');

      // 4. Test Trip Creation
      print('🚛 Testing Trip Creation...');
      await tripService.createTrip(
        fromLocation: 'City A',
        toLocation: 'City B',
        vehicleId: vehicles.first.id,
        driverId: drivers.first.id,
        partyId: parties.first.id,
        freightAmount: 5000.0,
      );
      
      final trips = await tripService.getAllTrips();
      expect(trips.length, 1);
      expect(trips.first.freightAmount, 5000.0);
      expect(trips.first.status, 'ACTIVE');
      print('✅ Trip created successfully');

      // 5. Test Expense Creation
      print('💰 Testing Expense Creation...');
      await expenseService.createExpense(
        tripId: trips.first.id,
        category: 'Fuel',
        amount: 1000.0,
        paidMode: 'Cash',
      );
      
      final expenses = await expenseService.getAllExpenses();
      expect(expenses.length, 1);
      expect(expenses.first.amount, 1000.0);
      print('✅ Expense created successfully');

      // 6. Test Payment Creation
      print('💳 Testing Payment Creation...');
      await paymentService.createPayment(
        partyId: parties.first.id,
        amount: 2000.0,
        type: 'ADVANCE',
        mode: 'Cash',
        tripId: trips.first.id,
      );
      
      final payments = await paymentService.getAllPayments();
      expect(payments.length, 1);
      expect(payments.first.amount, 2000.0);
      print('✅ Payment created successfully');

      // 7. Test Ledger Calculations
      print('🧮 Testing Ledger Calculations...');
      final tripBalance = await paymentService.getPendingBalanceForTrip(trips.first.id);
      final partyBalance = await paymentService.getPendingBalanceForParty(parties.first.id);
      
      // Expected: Freight(5000) - Expenses(1000) - Payments(2000) = 2000
      expect(tripBalance, 2000.0);
      expect(partyBalance, 2000.0);
      print('✅ Ledger calculations correct');

      // 8. Test Trip Completion
      print('🏁 Testing Trip Completion...');
      await tripService.completeTrip(trips.first.id);
      
      final completedTrip = await tripService.getTripById(trips.first.id);
      expect(completedTrip?.status, 'COMPLETED');
      expect(completedTrip?.actualEndDate, isNotNull);
      print('✅ Trip completed successfully');
      print('\n🎉 ALL TESTS PASSED! Phase 1 is working correctly.');
    });

    test('Edge Cases and Error Handling', () async {
      print('\n🔍 Testing Edge Cases...');

      // Test 1: Try to create vehicle with duplicate truck number
      print('Testing duplicate truck number...');
      try {
        await vehicleService.createVehicle(
          truckNumber: 'TEST-001', // Same as previous test
          truckType: 'Truck',
          capacity: 1000.0,
          fuelType: 'Diesel',
          registrationNumber: 'REG-002',
        );
        fail('Should have thrown exception for duplicate truck number');
      } catch (e) {
        expect(e.toString(), contains('Truck number must be unique'));
      }
      
      // Should still have only 1 vehicle (duplicate rejected)
      final vehicles = await vehicleService.getAllVehicles();
      expect(vehicles.length, 1);
      print('✅ Duplicate truck number rejected');

      // Test 2: Try to delete active trip
      print('Testing active trip deletion...');
      await tripService.createTrip(
        fromLocation: 'City X',
        toLocation: 'City Y',
        vehicleId: (await vehicleService.getAllVehicles()).first.id,
        driverId: (await driverService.getAllDrivers()).first.id,
        partyId: (await partyService.getAllParties()).first.id,
        freightAmount: 1000.0,
      );

      final trips = await tripService.getAllTrips();
      final activeTrip = trips.firstWhere((t) => t.status == 'ACTIVE');
      try {
        await tripService.deleteTrip(activeTrip.id);
        fail('Should have thrown exception for deleting active trip');
      } catch (e) {
        expect(e.toString(), contains('Cannot delete an active trip'));
        print('✅ Active trip deletion blocked');
      }

      // Test 3: Try to complete already completed trip
      print('Testing double trip completion...');
      try {
        await tripService.completeTrip(trips.first.id);
        fail('Should have thrown exception for completing completed trip');
      } catch (e) {
        expect(e.toString(), contains('Only active trips can be completed'));
        print('✅ Double trip completion blocked');
      }

      // Test 4: Try to create payment with invalid data
      print('Testing invalid payment creation...');
      try {
        await paymentService.createPayment(
          partyId: '', // Empty party ID
          amount: -100.0, // Negative amount
          type: '',
          mode: '',
        );
        fail('Should have thrown exception for invalid payment data');
      } catch (e) {
        expect(e.toString(), contains('Invalid payment data'));
        print('✅ Invalid payment data rejected');
      }

      print('✅ All edge cases handled correctly');
    });
  });
}
