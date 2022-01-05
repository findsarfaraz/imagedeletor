class DiskSizeModel {
  var _usedSize;
  var _totalSize;

  double get usedSize => _usedSize;
  double get totalSize => _totalSize;

  DiskSizeModel(this._usedSize, this._totalSize);

  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is DiskSizeModel &&
        o.usedSize == usedSize &&
        o.totalSize == totalSize;
  }

  @override
  int get hashCode => usedSize.hashCode ^ totalSize.hashCode;
}
