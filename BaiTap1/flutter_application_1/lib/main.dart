import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
        ),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '0';

  static const List<String> _buttons = [
    'C', '⌫', '÷', '×',
    '7', '8', '9', '-',
    '4', '5', '6', '+',
    '1', '2', '3', '=',
    '0', '.',
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
        return;
      }

      if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        return;
      }

      if (value == '=') {
        if (_expression.isEmpty) return;
        try {
          final evaluated = _evaluateExpression(_expression);
          _result = evaluated.toString();
        } catch (e) {
          _result = 'Error';
        }
        return;
      }

      if (_expression.isEmpty && (value == '+' || value == '-' || value == '×' || value == '÷')) {
        return;
      }

      _expression += value;
    });
  }

  late String _exp;
  late int _pos;

  double _evaluateExpression(String input) {
    _exp = input.replaceAll('×', '*').replaceAll('÷', '/');
    _pos = 0;

    final result = _parseExpression();
    if (_pos < _exp.length) throw FormatException('Unexpected token ${_exp[_pos]}');
    return result;
  }

  double _parseExpression() {
    double x = _parseTerm();
    while (_pos < _exp.length) {
      if (_exp[_pos] == '+') {
        _pos++;
        x += _parseTerm();
      } else if (_exp[_pos] == '-') {
        _pos++;
        x -= _parseTerm();
      } else {
        break;
      }
    }
    return x;
  }

  double _parseTerm() {
    double x = _parseFactor();
    while (_pos < _exp.length) {
      if (_exp[_pos] == '*') {
        _pos++;
        x *= _parseFactor();
      } else if (_exp[_pos] == '/') {
        _pos++;
        final denom = _parseFactor();
        if (denom == 0) throw Exception('Division by zero');
        x /= denom;
      } else {
        break;
      }
    }
    return x;
  }

  double _parseFactor() {
    if (_pos >= _exp.length) {
      throw FormatException('Unexpected end');
    }

    if (_exp[_pos] == '(') {
      _pos++;
      final x = _parseExpression();
      if (_pos >= _exp.length || _exp[_pos] != ')') {
        throw FormatException('Missing )');
      }
      _pos++;
      return x;
    }

    final start = _pos;
    while (_pos < _exp.length && RegExp(r'[0-9.]').hasMatch(_exp[_pos])) {
      _pos++;
    }

    if (start == _pos) {
      throw FormatException('Invalid expression at position $_pos');
    }

    final numberStr = _exp.substring(start, _pos);
    return double.parse(numberStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              color: Colors.black87,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _expression.isEmpty ? '0' : _expression,
                    style: const TextStyle(color: Colors.white70, fontSize: 32),
                    maxLines: 2,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _result,
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              final label = _buttons[index];
              final isOperator = ['÷', '×', '-', '+', '=', 'C', '⌫'].contains(label);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOperator ? Colors.blueGrey : Colors.grey[850],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _onButtonPressed(label),
                  child: Text(label),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
