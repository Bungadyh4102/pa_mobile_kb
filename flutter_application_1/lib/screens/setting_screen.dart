import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'info_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _currentIndex = 3;

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InfoScreen()),
        );
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: Column(
        children: [
          // ============================ HEADER ============================
          Container(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFF4D4D), Color(0xffFF7B7B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Avatar Glow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.red, size: 32),
                  ),
                ),
              ],
            ),
          ),

          // ============================ CONTENT ============================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tim Kami',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),

                  _buildHoverMember(
                    name: 'Annisa Rosaliyanti',
                    role: '2309106127',
                  ),
                  const SizedBox(height: 16),

                  _buildHoverMember(
                    name: 'Brayen Pranajaya Kesuma',
                    role: '2309106128',
                  ),
                  const SizedBox(height: 16),

                  _buildHoverMember(
                    name: 'Nazwa Bunga Syadiyah',
                    role: '2309106133',
                  ),
                  const SizedBox(height: 16),

                  _buildHoverMember(
                    name: 'Nurwadah',
                    role: '2309106138',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ============================ BOTTOM NAVBAR ============================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }

  // ============================ CARD TANPA DESKRIPSI + NEON BORDER ============================
  Widget _buildHoverMember({
    required String name,
    required String role,
  }) {
    return StatefulBuilder(
      builder: (context, setInner) {

        return GestureDetector(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            transform: Matrix4.identity()..scale(1.0),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),

              // 🔥 NEON RED BORDER + GLOW
              border: Border.all(
                color: Colors.redAccent,
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ],

              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.95),
                ],
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_pin_circle,
                        color: Colors.red.shade400, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  role,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
