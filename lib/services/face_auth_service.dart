import 'dart:math';

class FaceAuthService {
  double compareEmbeddings(List<dynamic> e1, List<dynamic> e2) {
    if (e1.length != e2.length) return 0.0;

    double sum = 0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow(e1[i] - e2[i], 2);
    }
    return 1 / (1 + sqrt(sum));
  }
}
