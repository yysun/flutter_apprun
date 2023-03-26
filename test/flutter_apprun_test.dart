import 'package:test/test.dart';
import 'package:flutter_apprun/flutter_apprun.dart';

void main() {
  bool called = false;

  AppRun.on('test', (data) {
    expect(data, 'test');
    called = true;
  });

  test('AppRunRun global event test', () {
    AppRun.run('test', 'test');
    expect(called, true);
  });

}
