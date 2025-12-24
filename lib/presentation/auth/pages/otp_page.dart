import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'reset_password_page.dart';
import '../../news/pages/home_page.dart';
import '../../news/bloc/news_bloc.dart';
import '../../news/bloc/news_event.dart';
import '../../../main.dart';

class OTPPage extends StatefulWidget {
  final String email;
  final bool isPasswordReset;

  const OTPPage({
    super.key,
    required this.email,
    this.isPasswordReset = false,
  });

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  bool _isLoading = false;
  bool _canResend = false;
  int _remainingSeconds = 60;
  Timer? _timer;

  final String _mockOTP = "1234";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _remainingSeconds = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    return '${seconds}s';
  }

  void _onNumberPressed(String number) {
    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        _controllers[i].text = number;
        if (i < _controllers.length - 1) {
          _focusNodes[i + 1].requestFocus();
        } else {
          _handleVerifyOTP();
        }
        break;
      }
    }
  }

  void _onBackspacePressed() {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        _controllers[i].clear();
        if (i > 0) {
          _focusNodes[i - 1].requestFocus();
        }
        break;
      }
    }
  }

  // void _handleVerifyOTP() async {
  //   final otp = _controllers.map((c) => c.text).join();

  //   if (otp.length != 4) {
  //     _showError('Please enter 4-digit OTP');
  //     return;
  //   }

  //   setState(() => _isLoading = true);
  //   await Future.delayed(const Duration(seconds: 1));
  //   setState(() => _isLoading = false);

  //   if (!_canResend && _remainingSeconds == 0) {
  //     _showError('OTP expired, please request a new one');
  //     return;
  //   }

  //   if (otp == _mockOTP) {
  //     if (mounted) {
  //       if (widget.isPasswordReset) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const ResetPasswordPage(),
  //           ),
  //         );
  //       } else {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => BlocProvider(
  //               create: (context) => NewsBloc()..add(LoadTrendingNews()),
  //               child: const HomePage(),
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   } else {
  //     _showError('Invalid OTP. Please try again.');
  //     _clearOTP();
  //   }
  // }

  void _handleVerifyOTP() async {
    final otp = _controllers.map((c) => c.text).join();

    if (otp.length != 4) {
      _showError('Please enter 4-digit OTP');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!_canResend && _remainingSeconds == 0) {
      _showError('OTP expired, please request a new one');
      return;
    }

    if (otp == _mockOTP) {
      if (mounted) {
        if (widget.isPasswordReset) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ResetPasswordPage(),
            ),
          );
        } else {
          // Navigate to Main Navigation (Home with bottom nav)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigation(),
            ),
          );
        }
      }
    } else {
      _showError('Invalid OTP. Please try again.');
      _clearOTP();
    }
  }

  void _clearOTP() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _handleResendOTP() async {
    if (!_canResend) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    _startTimer();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent to ${widget.email}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildNumberKey(String number) {
    return InkWell(
      onTap: () => _onNumberPressed(number),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (number != '0') ...[
              const SizedBox(height: 2),
              Text(
                _getLetters(number),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getLetters(String number) {
    const Map<String, String> letters = {
      '2': 'ABC',
      '3': 'DEF',
      '4': 'GHI',
      '5': 'JKL',
      '6': 'MNO',
      '7': 'PQRS',
      '8': 'TUV',
      '9': 'WXYZ',
    };
    return letters[number] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'OTP Verification',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF666666),
                      ),
                      children: [
                        const TextSpan(text: 'Enter the OTP sent to '),
                        TextSpan(
                          text: '+${widget.email}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.none,
                          maxLength: 1,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF0066FF),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!_canResend) ...[
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF666666),
                        ),
                        children: [
                          const TextSpan(text: 'Resend code in '),
                          TextSpan(
                            text: _formatTime(_remainingSeconds),
                            style: const TextStyle(
                              color: Color(0xFFFF4444),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    TextButton(
                      onPressed: _handleResendOTP,
                      child: Text(
                        'Resend OTP',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF0066FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xFFD1D5DB),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildNumberKey('1')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildNumberKey('2')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildNumberKey('3')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildNumberKey('4')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildNumberKey('5')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildNumberKey('6')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildNumberKey('7')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildNumberKey('8')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildNumberKey('9')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    const SizedBox(width: 8),
                    Expanded(child: _buildNumberKey('0')),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: _onBackspacePressed,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.backspace_outlined,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
