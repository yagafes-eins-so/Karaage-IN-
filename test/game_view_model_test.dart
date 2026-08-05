import 'package:flutter_test/flutter_test.dart';
import 'package:karaage_in/viewmodels/game_view_model.dart';

void main() {
  group('GameViewModel scoring', () {
    test('a plain success awards 100 points', () {
      final vm = GameViewModel()..startGame();
      vm.registerThrow(success: true, noBounce: false, centerHit: false);
      expect(vm.totalScore, 100);
    });

    test('bonuses stack: no-bounce + center adds 150', () {
      final vm = GameViewModel()..startGame();
      vm.registerThrow(success: true, noBounce: true, centerHit: true);
      expect(vm.totalScore, 100 + 50 + 100);
    });

    test('a miss awards nothing', () {
      final vm = GameViewModel()..startGame();
      vm.registerThrow(success: false, noBounce: false, centerHit: false);
      expect(vm.totalScore, 0);
    });

    test('5 successes trigger the 1000pt Perfect bonus', () {
      final vm = GameViewModel()..startGame();
      for (int i = 0; i < 5; i++) {
        vm.registerThrow(success: true, noBounce: false, centerHit: false);
      }
      expect(vm.totalScore, 5 * 100 + 1000);
      expect(vm.phase, SessionPhase.result);
    });

    test('throws beyond the limit are ignored', () {
      final vm = GameViewModel()..startGame();
      for (int i = 0; i < 5; i++) {
        vm.registerThrow(success: false, noBounce: false, centerHit: false);
      }
      final scoreAfterFive = vm.totalScore;
      vm.registerThrow(success: true, noBounce: true, centerHit: true);
      expect(vm.totalScore, scoreAfterFive);
    });
  });
}
