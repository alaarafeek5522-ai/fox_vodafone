import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/vodafone_service.dart';
import '../widgets/top_wave_design.dart';
import '../widgets/diagonal_lines.dart';
import '../widgets/sim_card_3d.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  String? _phoneNumber;
  String? _accessToken;
  String _statusMessage = "اضغط على الزر للبدء";
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _extractAndOpen() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "جاري الاتصال...";
    });

    try {
      final data = await VodafoneService.extractData();
      setState(() {
        _phoneNumber = data['phoneNumber'];
        _accessToken = data['accessToken'];
        _statusMessage = "تم الاتصال بنجاح";
        _isLoading = false;
      });
      _navigateToWebView();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "حدث خطأ. حاول مرة أخرى";
      });
      _showErrorDialog(e.toString());
    }
  }

  void _navigateToWebView() {
    final url = VodafoneService.buildFinalUrl(_accessToken!, _phoneNumber!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Vodafone",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: const Color(0xFFC62828),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Container(
                height: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFF8B0000), Color(0xFFC62828)],
                  ),
                ),
              ),
              Expanded(
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadRequest(Uri.parse(url)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("خطأ", textAlign: TextAlign.center),
        content: Text(error, textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("حاول مرة أخرى", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              height: MediaQuery.of(context).size.height * 0.35,
              child: const TopWaveDesign(),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnim.value,
                          child: Opacity(
                            opacity: _fadeAnim.value,
                            child: child,
                          ),
                        );
                      },
                      child: const SimCard3D(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                    const DiagonalLines(),
                    const SizedBox(height: 40),
                    _buildStatusSection(),
                    const SizedBox(height: 30),
                    _buildExtractButton(),
                    const SizedBox(height: 40),
                    _buildDecorElements(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _statusMessage,
              key: ValueKey(_statusMessage),
              style: TextStyle(
                color: _isLoading ? const Color(0xFF8B0000) : const Color(0xFF333333),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _isLoading ? 200 : 0,
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFF8B0000), Color(0xFFC62828)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: _isLoading ? Matrix4.identity().scaled(1.05) : Matrix4.identity(),
      child: GestureDetector(
        onTap: _isLoading ? null : _extractAndOpen,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFF8B0000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B0000).withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      key: ValueKey('loading'),
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.play_arrow_rounded,
                      key: ValueKey('play'),
                      size: 60,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorElements() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Icon(Icons.more_vert, color: Colors.black.withOpacity(0.1), size: 12),
          ),
          Positioned(
            right: 0,
            child: Icon(Icons.more_horiz, color: Colors.black.withOpacity(0.1), size: 12),
          ),
          Positioned(
            right: 30, top: 30,
            child: Icon(Icons.close, color: Colors.black.withOpacity(0.1), size: 10),
          ),
          Positioned(
            left: 30, top: 30,
            child: Icon(Icons.play_arrow, color: Colors.black.withOpacity(0.1), size: 8),
          ),
        ],
      ),
    );
  }
}
