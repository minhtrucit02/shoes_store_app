import 'package:flutter/material.dart';

class OnboardingTemplate extends StatelessWidget {
  final String image, title, description;
  final int index;
  final VoidCallback onNext;

  const OnboardingTemplate({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.index,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final indicators = List.generate(
      3,
          (i) => Container(
        width: i == index ? 30 : 15,
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: i == index ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: onNext,
                  child: Text('Skip', style: TextStyle(color: Colors.grey[600])),
                ),
              ),
              Center(
                child: SizedBox(height: 400, child: Image.asset(image, fit: BoxFit.contain)),
              ),
              const SizedBox(height: 32),
              Text(title, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: indicators),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Next', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
