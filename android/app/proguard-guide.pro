# Keep TensorFlow Lite GPU delegate classes
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-keepclassmembers class org.tensorflow.lite.** { *; }

# Suppress warnings for missing classes
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options
