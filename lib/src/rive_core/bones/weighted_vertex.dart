abstract class WeightedVertex {
  int get weights;
  int get weightIndices;
  set weights(int value);
  set weightIndices(int value);
  void setWeight(int tendonIndex, int tendonCount, double weight) {
    int tendonWeightIndex =
        _setTendonWeight(tendonIndex, (weight.clamp(0, 1) * 255).round());
    var tendonWeights = _tendonWeights;
    int totalWeight = tendonWeights.fold(
        0, (value, tendonWeight) => value + tendonWeight.weight);
    var vertexTendons =
        tendonWeights.where((tendonWeight) => tendonWeight.tendon != 0);
    const maxWeight = 255;
    var remainder = maxWeight - totalWeight;
    if (vertexTendons.length == 1) {
      var patchTendonIndex = (tendonIndex + 1) % tendonCount;
      _setTendonWeight(
          patchTendonIndex, tendonCount == 1 ? maxWeight : remainder);
    } else {
      var distributeTendons =
          vertexTendons.where((tendon) => tendon.index != tendonWeightIndex);
      for (final patchTendon in distributeTendons) {
        var patchedWeight = patchTendon.weight + remainder;
        if (patchedWeight < 0) {
          remainder = patchedWeight;
          patchedWeight = 0;
        } else if (patchedWeight > 255) {
          remainder = patchedWeight - 255;
          patchedWeight = 255;
        } else {
          remainder = 0;
        }
        _rawSetWeight(patchTendon.index, patchedWeight);
        patchTendon.weight = patchedWeight;
      }
    }
    _sortWeights();
  }

  void _sortWeights() {
    var tendonWeights = _tendonWeights;
    tendonWeights.sort((a, b) => b.weight.compareTo(a.weight));
    for (int i = 0; i < tendonWeights.length; i++) {
      final tw = tendonWeights[i];
      _setTendonIndex(i, tw.weight == 0 ? 0 : tw.tendon);
      _rawSetWeight(i, tw.weight);
    }
  }

  List<_WeightHelper> get _tendonWeights => [
        _WeightHelper(0, weightIndices & 0xFF, _getRawWeight(0)),
        _WeightHelper(1, (weightIndices >> 8) & 0xFF, _getRawWeight(1)),
        _WeightHelper(2, (weightIndices >> 16) & 0xFF, _getRawWeight(2)),
        _WeightHelper(3, (weightIndices >> 24) & 0xFF, _getRawWeight(3))
      ];
  int _setTendonWeight(int tendonIndex, int weight) {
    var indices = weightIndices;
    var bonesIndices = [
      indices & 0xFF,
      (indices >> 8) & 0xFF,
      (indices >> 16) & 0xFF,
      (indices >> 24) & 0xFF
    ];
    int setWeightIndex = -1;
    for (int i = 0; i < 4; i++) {
      if (bonesIndices[i] == tendonIndex + 1) {
        _rawSetWeight(i, weight);
        setWeightIndex = i;
        break;
      }
    }
    if (setWeightIndex == -1) {
      int lowestWeight = double.maxFinite.toInt();
      for (int i = 0; i < 4; i++) {
        if (bonesIndices[i] == 0) {
          setWeightIndex = i;
          break;
        }
        var weight = _getRawWeight(i);
        if (weight < lowestWeight) {
          setWeightIndex = i;
          lowestWeight = weight;
        }
      }
      _setTendonIndex(setWeightIndex, tendonIndex + 1);
      _rawSetWeight(setWeightIndex, weight);
    }
    return setWeightIndex;
  }

  void _setTendonIndex(int weightIndex, int tendonIndex) {
    assert(weightIndex < 4 && weightIndex >= 0);
    var indexValues = weightIndices;
    indexValues &= ~(0xFF << (weightIndex * 8));
    weightIndices = indexValues | (tendonIndex << (weightIndex * 8));
  }

  int getTendon(int weightIndex) {
    assert(weightIndex < 4 && weightIndex >= 0);
    return (weightIndices >> (weightIndex * 8)) & 0xFF;
  }

  void _rawSetWeight(int weightIndex, int weightValue) {
    assert(weightIndex < 4 && weightIndex >= 0);
    var weightValues = weights;
    weightValues &= ~(0xFF << (weightIndex * 8));
    weights = weightValues | (weightValue << (weightIndex * 8));
  }

  int _getRawWeight(int weightIndex) => (weights >> (weightIndex * 8)) & 0xFF;
  double getWeight(int tendonIndex) {
    for (int i = 0; i < 4; i++) {
      if (getTendon(i) == tendonIndex + 1) {
        return _getRawWeight(i) / 255;
      }
    }
    return 0;
  }
}

class _WeightHelper {
  final int index;
  final int tendon;
  int weight;
  _WeightHelper(this.index, this.tendon, this.weight);
}
