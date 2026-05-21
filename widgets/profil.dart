import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 155, 243),
        title: const Text(
          'Profil Développeur',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 252, 253, 253),
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 👤 PHOTO DE PROFIL
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),

            const SizedBox(height: 20),

            // 👤 NOM COMPLET
            Center(
              child: Text(
                'KIENDREBEOGO Basnewende Emmanuel',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 8),

            // 💻 PROFIL DEVELOPPEUR
            const Text(
              'Développeur Flutter & Applications Mobiles',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // 📞 TELEPHONEurl_launcher: ^6.2.5
            _buildInfoCard(
              icon: Icons.phone,
              title: 'Téléphone',
              value: '+226 77937199',
            ),

            const SizedBox(height: 15),

            // 💬 WHATSAPP
            _buildInfoCard(
              icon: Icons.chat,
              title: 'WhatsApp',
              value: '+226 51476176',
            ),

            const SizedBox(height: 15),

            // 📧 EMAIL
            _buildInfoCard(
              icon: Icons.email,
              title: 'Email',
              value: 'kiendrebeogobasnewendeemmanuel@gmail.com',
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget carte info réutilisable
  static Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(2, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}