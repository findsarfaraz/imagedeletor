import 'package:imagedeletor/model/favorite_folder_model.dart';

abstract class FolderScreenState {
  const FolderScreenState();
}

class FolderScreenInitial extends FolderScreenState {
  const FolderScreenInitial();
}

class FolderScreenLoading extends FolderScreenState {
  const FolderScreenLoading();
}

class FolderScreenLoaded extends FolderScreenState {
  List<FavoriteFolderModel> favoriteFolderModel;
  FolderScreenLoaded(this.favoriteFolderModel);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FolderScreenLoaded &&
        o.favoriteFolderModel == favoriteFolderModel;
  }

  @override
  int get hashCode => favoriteFolderModel.hashCode;
}

class FolderScreenError extends FolderScreenState {
  final String message;
  const FolderScreenError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FolderScreenError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
