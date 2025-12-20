import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  final bool disabled;
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: disabled
            ? null
            : () {
                onPressed();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8875FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Lato',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
