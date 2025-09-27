import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:io' show File, Platform;
import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

/// Struktur data untuk 1 hasil deteksi
class Detection {
  final double x1, y1, x2, y2;
  final String label;
  final double confidence;

  Detection({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
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
    final outputShape = _interpreter.getOutputTensor(0).shape; // [1, 9, N]
    final numAttrs = outputShape[1]; // 4 + num_classes
    final numPreds = outputShape[2]; // jumlah kandidat box

    var output = List.filled(
      1 * numAttrs * numPreds,
      0.0,
    ).reshape([1, numAttrs, numPreds]);

    _interpreter.run(input, output);

    /// --- TRANSPOSE OUTPUT [1,9,N] → [N,9] ---
    List<List<double>> predictions = List.generate(
      numPreds,
      (i) => List.generate(numAttrs, (j) => output[0][j][i].toDouble()),
    );

    print("🔢 Output shape: ${predictions.length} x ${predictions[0].length}");
    print("🔍 Sample pred[0]: ${predictions[0]}");

    /// --- POSTPROCESS ---
    detections.value = _postprocess(
      predictions,
      labels,
      origW: width.toDouble(),
      origH: height.toDouble(),
      confThreshold: 0.4,
      iouThreshold: 0.5,
    );

    print("📦 Final detections: ${detections.length}");
    for (var d in detections) {
      print(
        " → ${d.label} (${d.confidence.toStringAsFixed(2)}) [${d.x1.toInt()},${d.y1.toInt()},${d.x2.toInt()},${d.y2.toInt()}]",
      );
    }
  }

  // ======================
  // === Postprocessing ===
  // ======================

  List<Detection> _postprocess(
    List<List<double>> output,
    List<String> labels, {
    required double origW,
    required double origH,
    double confThreshold = 0.4,
    double iouThreshold = 0.5,
  }) {
    final boxes = <List<double>>[];
    final scores = <double>[];
    final classIds = <int>[];

    for (var pred in output) {
      final xc = pred[0] * origW;
      final yc = pred[1] * origH;
      final w = pred[2] * origW;
      final h = pred[3] * origH;

      final classScores = pred.sublist(4);
      final clsId = _argmax(classScores);
      final conf = classScores[clsId];

      if (conf > confThreshold) {
        final x1 = xc - w / 2;
        final y1 = yc - h / 2;
        final x2 = xc + w / 2;
        final y2 = yc + h / 2;

        boxes.add([x1, y1, x2, y2]);
        scores.add(conf);
        classIds.add(clsId);
      }
    }

    if (boxes.isEmpty) return [];

    final keep = _nms(boxes, scores, iouThreshold);

    final results = <Detection>[];
    for (var i in keep) {
      results.add(
        Detection(
          x1: boxes[i][0],
          y1: boxes[i][1],
          x2: boxes[i][2],
          y2: boxes[i][3],
          label: (classIds[i] < labels.length)
              ? labels[classIds[i]]
              : "unknown",
          confidence: scores[i],
        ),
      );
    }

    return results;
  }

  List<int> _nms(List<List<double>> boxes, List<double> scores, double iouTh) {
    final idxs = List<int>.generate(scores.length, (i) => i).toList();
    idxs.sort((a, b) => scores[b].compareTo(scores[a]));

    final keep = <int>[];

    while (idxs.isNotEmpty) {
      final i = idxs.removeAt(0);
      keep.add(i);

      final remaining = <int>[];
      for (final j in idxs) {
        final xx1 = math.max(boxes[i][0], boxes[j][0]);
        final yy1 = math.max(boxes[i][1], boxes[j][1]);
        final xx2 = math.min(boxes[i][2], boxes[j][2]);
        final yy2 = math.min(boxes[i][3], boxes[j][3]);

        final interW = math.max(0.0, xx2 - xx1);
        final interH = math.max(0.0, yy2 - yy1);
        final interArea = interW * interH;

        final areaI = (boxes[i][2] - boxes[i][0]) * (boxes[i][3] - boxes[i][1]);
        final areaJ = (boxes[j][2] - boxes[j][0]) * (boxes[j][3] - boxes[j][1]);
        final union = areaI + areaJ - interArea;

        final iou = union <= 0 ? 0.0 : interArea / union;
        if (iou < iouTh) remaining.add(j);
      }
      idxs
        ..clear()
        ..addAll(remaining);
    }

    return keep;
  }

  int _argmax(List<double> array) {
    double maxVal = -double.infinity;
    int maxIdx = -1;
    for (int i = 0; i < array.length; i++) {
      if (array[i] > maxVal) {
        maxVal = array[i];
        maxIdx = i;
      }
    }
    return maxIdx;
  }
}
