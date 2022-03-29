/// Helper to abstract changing weighted values on a vertex.
abstract class WeightedVertex {
  int get weights;
  int get weightIndices;
  set weights(int value);
  set weightIndices(int value);

  /// Set the weight of this vertex for a specific tendon.
  void setWeight(int tendonIndex, int tendonCount, double weight) {
    int tendonWeightIndex =
        _setTendonWeight(tendonIndex, (weight.clamp(0, 1) * 255).round());

    // re-normalize the list such that only bones with value are at the
    // start and they sum to 100%, if any need to change make sure to give
    // priority (not change) tendonIndex which we just tried to set.

    var tendonWeights = _tendonWeights;
    int totalWeight = tendonWeights.fold(
        0, (value, tendonWeight) => value + tendonWeight.weight);
    var vertexTendons =
        tendonWeights.where((tendonWeight) => tendonWeight.tendon != 0);

    const maxWeight = 255;

    var remainder = maxWeight - totalWeight;
    if (vertexTendons.length == 1) {
      // User is specifically setting a single tendon to a value, just pick
      // the next one up (modulate by the total number of tendons).
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
    // Sort weights such that tendons with value show up first and any with no
    // value (0 weight) are cleared to the 0 (no) tendon.
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
      (indices >> 24) & 0xFF,
    ];

    int setWeightIndex = -1;
    for (int i = 0; i < 4; i++) {
      if (bonesIndices[i] == tendonIndex + 1) {
        _rawSetWeight(i, weight);
        setWeightIndex = i;
        break;
      }
    }

    // This bone wasn't weighted for this vertex, go find the bone with the
    // least weight (or a 0 bone) and use it.
    if (setWeightIndex == -1) {
      int lowestWeight = double.maxFinite.toInt();
      for (int i = 0; i < 4; i++) {
        if (bonesIndices[i] == 0) {
          // this isn't set to a bone yet, use it!
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

  /// [tendonIndex] of 0 means no bound tendon, when bound to an actual tendon,
  /// it should be set to the skin's tendon's index + 1.
  void _setTendonIndex(int weightIndex, int tendonIndex) {
    assert(weightIndex < 4 && weightIndex >= 0);
    var indexValues = weightIndices;
    // Clear the bits for this weight value.
    indexValues &= ~(0xFF << (weightIndex * 8));
    // Set the bits for this weight value.
    weightIndices = indexValues | (tendonIndex << (weightIndex * 8));
  }

  int getTendon(int weightIndex) {
    assert(weightIndex < 4 && weightIndex >= 0);
    return (weightIndices >> (weightIndex * 8)) & 0xFF;
  }

  void _rawSetWeight(int weightIndex, int weightValue) {
    assert(weightIndex < 4 && weightIndex >= 0);
    var weightValues = weights;
    // Clear the bits for this weight value.
    weightValues &= ~(0xFF << (weightIndex * 8));
    // Set the bits for this weight value.
    weights = weightValues | (weightValue << (weightIndex * 8));
  }

  int _getRawWeight(int weightIndex) => (weights >> (weightIndex * 8)) & 0xFF;

  double getWeightAtIndex(int weightIndex) => _getRawWeight(weightIndex) / 255;

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
