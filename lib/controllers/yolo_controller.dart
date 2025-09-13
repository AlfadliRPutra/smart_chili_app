import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:io' show File, Platform;
import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

/// Struktur data untuk 1 hasil deteksi
class Detection {
  final double x, y, w, h;
  final String label;
  final double confidence;

  Detection({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.label,
    required this.confidence,
  });
}

class YoloController extends GetxController {
  late Interpreter _interpreter;
  var isModelLoaded = false.obs;
  var detections = <Detection>[].obs;
  var labels = <String>[];

  late List<int> inputShape; // [1, H, W, 3]

  @override
  void onInit() {
    super.onInit();
    loadModel();
    loadLabels();
  }

  /// Load model TFLite (cross-platform)
  Future<void> loadModel() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _interpreter = await Interpreter.fromAsset('model.tflite');
      } else {
        _interpreter = Interpreter.fromFile(File('assets/model.tflite'));
      }

      inputShape = _interpreter.getInputTensor(0).shape; // e.g. [1,736,736,3]

      isModelLoaded.value = true;
      print("✅ YOLO model loaded, input shape: $inputShape");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  /// Load labels
  Future<void> loadLabels() async {
    try {
      final raw = await rootBundle.loadString('assets/labels.txt');
      labels = raw.split('\n').where((e) => e.trim().isNotEmpty).toList();
      print("✅ Labels loaded: ${labels.length}");
    } catch (e) {
      print("❌ Error loading labels: $e");
    }
  }

  /// Decode + resize + normalize image
  Float32List preprocess(Uint8List inputBytes) {
    final decoded = img.decodeImage(inputBytes);
    if (decoded == null) throw Exception("Failed to decode image");

    final height = inputShape[1];
    final width = inputShape[2];

    final resized = img.copyResize(decoded, width: width, height: height);

    final floatList = Float32List(width * height * 3);
    int index = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = resized.getPixel(x, y);
        floatList[index++] = pixel.r / 255.0;
        floatList[index++] = pixel.g / 255.0;
        floatList[index++] = pixel.b / 255.0;
      }
    }
    return floatList;
  }

  /// Jalankan prediksi
  Future<void> predict(Uint8List inputBytes) async {
    if (!isModelLoaded.value) return;

    final height = inputShape[1];
    final width = inputShape[2];

    /// --- INPUT SHAPE ---
    var input = preprocess(inputBytes).reshape([1, height, width, 3]);

    /// --- OUTPUT SHAPE ---
    final outputShape = _interpreter.getOutputTensor(0).shape;
    final numAttrs = outputShape[1];
    final numAnchors = outputShape[2];

    var output = List.filled(
      1 * numAttrs * numAnchors,
      0.0,
    ).reshape([1, numAttrs, numAnchors]);

    _interpreter.run(input, output);

    /// --- TRANSPOSE OUTPUT ---
    List<List<double>> predictions = List.generate(
      numAnchors,
      (i) => List.generate(numAttrs, (j) => output[0][j][i].toDouble()),
    );

    /// Debug print (cek struktur prediksi pertama)
    if (predictions.isNotEmpty) {
      print(
        "🔍 Sample pred length = ${predictions[0].length}, values = ${predictions[0]}",
      );
    }

    /// --- POSTPROCESS ---
    detections.value = processOutput(
      predictions,
      labels,
      confThreshold: 0.4,
      iouThreshold: 0.5,
    );
  }

  // ======================
  // === Postprocessing ===
  // ======================

  double sigmoid(double x) => 1 / (1 + math.exp(-x));

  List<Detection> processOutput(
    List<List<double>> output,
    List<String> labels, {
    double confThreshold = 0.4,
    double iouThreshold = 0.5,
  }) {
    final results = <Detection>[];

    for (int i = 0; i < output.length; i++) {
      final pred = output[i];

      if (pred.length < 6) continue; // minimal: x,y,w,h,obj_conf,1 kelas

      final x = pred[0];
      final y = pred[1];
      final w = pred[2];
      final h = pred[3];
      final objConf = sigmoid(pred[4]);

      final numClasses = pred.length - 5; // auto detect jumlah kelas
      double maxClassScore = 0;
      int classIndex = -1;

      for (int c = 0; c < numClasses; c++) {
        final score = sigmoid(pred[5 + c]);
        if (score > maxClassScore) {
          maxClassScore = score;
          classIndex = c;
        }
      }

      final confidence = objConf * maxClassScore;
      if (confidence > confThreshold &&
          classIndex != -1 &&
          classIndex < labels.length) {
        results.add(
          Detection(
            x: x - w / 2,
            y: y - h / 2,
            w: w,
            h: h,
            label: labels[classIndex],
            confidence: confidence,
          ),
        );
      }
    }

    return nonMaxSuppression(results, iouThreshold);
  }

  List<Detection> nonMaxSuppression(
    List<Detection> detections,
    double iouThreshold,
  ) {
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    final results = <Detection>[];

    while (detections.isNotEmpty) {
      final best = detections.removeAt(0);
      results.add(best);
      detections.removeWhere((d) => boxIoU(best, d) > iouThreshold);
    }

    return results;
  }

  double boxIoU(Detection a, Detection b) {
    final x1 = math.max(a.x, b.x);
    final y1 = math.max(a.y, b.y);
    final x2 = math.min(a.x + a.w, b.x + b.w);
    final y2 = math.min(a.y + a.h, b.y + b.h);

    final interArea = math.max(0, x2 - x1) * math.max(0, y2 - y1);
    final unionArea = (a.w * a.h) + (b.w * b.h) - interArea;
    return unionArea <= 0 ? 0 : interArea / unionArea;
  }
}
