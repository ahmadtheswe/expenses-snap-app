import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:expenses_snap_app/models/expense.dart';
import 'package:expenses_snap_app/screens/expense_form_page.dart';
import 'package:expenses_snap_app/services/open_ai_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isProcessing = false;
  final OpenAIService _openAIService = OpenAIService();

  // For image preview
  XFile? _capturedImage;
  bool _isPreviewMode = false;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        _showError('No cameras found');
        return;
      }

      // Initialize the camera controller with the first camera
      _controller = CameraController(_cameras[0], ResolutionPreset.high, enableAudio: false);

      // Initialize and listen for errors
      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      _showError('Failed to initialize camera: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile image = await _controller!.takePicture();

      if (mounted) {
        setState(() {
          _capturedImage = image;
          _isPreviewMode = true;
          _isProcessing = false;
        });
      }
    } catch (e) {
      _showError('Failed to take picture: $e');
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _acceptImage() async {
    if (_capturedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Create a File object from the captured XFile
      final File imageFile = File(_capturedImage!.path);

      // Process the image with OpenAI
      final aiResult = await _openAIService.sendImageToOpenAI(imageFile);

      // Extract amount from the total
      double amount = 0.0;
      if (aiResult.total != null && aiResult.total!.isNotEmpty) {
        // Remove currency symbols and non-numeric characters except decimal points
        final numericString = aiResult.total!.replaceAll(RegExp(r'[^0-9.]'), '');
        amount = double.tryParse(numericString) ?? 0.0;
      }

      // Create an expense object from the OpenAI results
      final expense = Expense(
        name: aiResult.label ?? 'Bill from camera',
        amount: amount,
        createdAt: DateTime.now(),
        expenseType: 'Need',
      );

      if (mounted) {
        // Navigate to ExpenseFormPage with pre-filled data
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => ExpenseFormPage(initialExpense: expense)));
      }
    } catch (e) {
      _showError('Failed to analyze image: $e');

      // If analysis fails, create a basic expense
      final expense = Expense(name: 'Bill from camera', amount: 0.0, createdAt: DateTime.now(), expenseType: 'Need');

      if (mounted) {
        // Navigate to ExpenseFormPage with basic data
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => ExpenseFormPage(initialExpense: expense)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _retakePicture() {
    setState(() {
      _capturedImage = null;
      _isPreviewMode = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Take Bill Picture')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_isPreviewMode && _capturedImage != null) {
      return _buildPreviewScreen();
    } else {
      return _buildCameraScreen();
    }
  }

  Widget _buildCameraScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Take Bill Picture')),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller!)),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Back button
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),

                // Capture button
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _takePicture,
                  icon: const Icon(Icons.camera),
                  label: _isProcessing ? const Text('Processing...') : const Text('Capture'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Bill Picture')),
      body: Column(
        children: [
          Expanded(child: Image.file(File(_capturedImage!.path), fit: BoxFit.contain)),
          if (_isAnalyzing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [CircularProgressIndicator(), SizedBox(height: 8), Text('Analyzing receipt with AI...')],
              ),
            ),
          if (!_isAnalyzing)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Retake button
                  ElevatedButton.icon(
                    onPressed: _retakePicture,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  ),

                  // Use this image button
                  ElevatedButton.icon(
                    onPressed: _acceptImage,
                    icon: const Icon(Icons.check),
                    label: const Text('Use This Image'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
