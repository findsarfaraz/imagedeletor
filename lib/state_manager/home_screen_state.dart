import 'package:imagedeletor/model/disk_size_model.dart';

abstract class HomeScreenState {
  const HomeScreenState();
}

class HomeScreenInitial extends HomeScreenState {
  const HomeScreenInitial();
}

class HomeScreenLoading extends HomeScreenState {
  const HomeScreenLoading();
}

class HomeScreenLoaded extends HomeScreenState {
  final DiskSizeModel sizeInfo;
  HomeScreenLoaded(this.sizeInfo);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeScreenLoaded && o.sizeInfo == sizeInfo;
  }

  @override
  int get hashCode => sizeInfo.hashCode;
}

class HomeScreenError extends HomeScreenState {
  final String message;
  const HomeScreenError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeScreenError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
