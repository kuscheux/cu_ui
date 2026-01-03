import 'package:flutter/widgets.dart';

/// Device frame with realistic mobile bezels
class DeviceFrame extends StatelessWidget {
  final Widget child;
  final DeviceType type;

  const DeviceFrame({
    super.key,
    required this.child,
    this.type = DeviceType.iphone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(48),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(44),
        child: Container(
          width: 375,
          height: 812,
          decoration: const BoxDecoration(
            color: Color(0xFF000000),
          ),
          child: Stack(
            children: [
              // Screen content
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: child,
                ),
              ),

              // Top notch / dynamic island
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildNotch(),
              ),

              // Home indicator
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotch() {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 34,
        margin: const EdgeInsets.only(top: 10),
        child: Center(
          child: Container(
            width: 126,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Camera
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF333333),
                      width: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Device types
enum DeviceType {
  iphone,
  android,
  tablet,
}
