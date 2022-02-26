class ComponentDirt {
  static const int dependents = 1 << 0;

  /// General flag for components are dirty (if this is up, the update cycle
  /// runs). It gets automatically applied with any other dirt.
  static const int components = 1 << 1;

  /// Draw order needs to be re-computed.
  static const int drawOrder = 1 << 2;

  /// Draw order needs to be re-computed.
  static const int naturalDrawOrder = 1 << 3;

  /// Path is dirty and needs to be rebuilt.
  static const int path = 1 << 4;

  /// Text shape is dirty, the shaper needs to re-run.
  static const int textShape = 1 << 4;

  /// Vertices have changed, re-order cached lists.
  static const int vertices = 1 << 5;

  /// Used by any component that needs to recompute their local transform.
  /// Usually components that have their transform dirty will also have their
  /// worldTransform dirty.
  static const int transform = 1 << 6;

  /// Used by any component that needs to update its world transform.
  static const int worldTransform = 1 << 7;

  /// Dirt used to mark some stored paint needs to be rebuilt or that we just
  /// want to trigger an update cycle so painting occurs.
  static const int paint = 1 << 8;

  /// Used by the gradients track when the stops need to be re-ordered.
  static const int stops = 1 << 9;

  /// Used by ClippingShape to help Shape know when to recalculate its list of
  /// clipping sources.
  static const int clip = 1 << 10;

  /// Set when blend modes need to be updated.
  static const int blendMode = 1 << 11;
}
