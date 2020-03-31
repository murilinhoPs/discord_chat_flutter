import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import '../../pages/home/components/text_form.dart';

class TextBloc extends BlocBase {
  final _forms = TextForms();

  final _controller$ = BehaviorSubject<String>();

  Stream<String> get saida => _controller$.stream;
  Sink get entrada => _controller$.sink;

  changeFormData(String value) {
    _forms.controller.text = value;
    entrada.add(value);

    print(_controller$.value);
    print(_forms.controller.text);
  }

  final _idController = BehaviorSubject<String>();

  String get idValue => _idController.value;
  Stream<String> get idOutput => _idController.stream;
  Sink<String> get idEntry => _idController.sink;

  @override
  void dispose() {
    _controller$.close();
    _idController.close();
    super.dispose();
  }
}