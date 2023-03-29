import 'package:test/test.dart';
import 'package:flutter_apprun/flutter_apprun.dart';

void main() {
  bool called = false;

  app.on('test', (data) {
    expect(data, 'test');
    called = true;
  });

  test('AppRunRun global event test', () {
    app.run('test', 'test');
    expect(called, true);
  });

}
