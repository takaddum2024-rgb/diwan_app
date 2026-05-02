import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poem_provider.dart';

class DraftsScreen extends StatefulWidget {
  const DraftsScreen({super.key});

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _poetController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _poetController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _savePoem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = Provider.of<PoemProvider>(context, listen: false);
    await provider.addUserPoem(
      title: _titleController.text.trim(),
      poetName: _poetController.text.trim(),
      content: _contentController.text.trim(),
    );

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ القصيدة بنجاح')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة قصيدة جديدة'),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: const Color(0xFFFFD700),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFF800000)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'أضف قصيدتك الخاصة. يمكنك تعديلها أو حذفها لاحقاً.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'عنوان القصيدة *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value?.trim().isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _poetController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'اسم الشاعر *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value?.trim().isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                textAlign: TextAlign.right,
                maxLines: 15,
                decoration: const InputDecoration(
                  labelText: 'نص القصيدة *',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    value?.trim().isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _savePoem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800000),
                    foregroundColor: const Color(0xFFFFD700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(
                          color: Color(0xFFFFD700))
                      : const Text('حفظ القصيدة',
                          style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
