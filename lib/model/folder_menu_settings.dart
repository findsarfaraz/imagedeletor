import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderViewModel extends ChangeNotifier {
  List<String> menuSettings;
  int change;

  FolderViewModel(this.menuSettings, this.change);

  updateMenuSettings(int index) {
    switch (index) {
      case 0:
        {
          if (menuSettings[0] == "0") {
            menuSettings[0]= "1";
            menuSettings[1] = "0";
            change = 0;
          }
        }
        break;
      case 1:
        {
          if (menuSettings[1] == "0") {
            menuSettings[0] = "0";
            menuSettings[1] = "1";
            change = 0;
          }
        }
        break;
      case 2:
        {
          if (menuSettings[2] == "0" || menuSettings[2] == "2") {
            menuSettings[2] = "1";
            menuSettings[3] = "0";
            menuSettings[4] = "0";
            menuSettings[5] = "0";
            change = 0;
          } else if (menuSettings[2] == "1") {
            menuSettings[2] = "2";
            menuSettings[3] = "0";
            menuSettings[4] = "0";
            menuSettings[5] = "0";
            change = 0;
          }
        }
        break;
      case 3:
        {
          if (menuSettings[3] == "0" || menuSettings[3] == "2") {
            menuSettings[2] = "0";
            menuSettings[3] = "1";
            menuSettings[4] = "0";
            menuSettings[5] = "0";
            change = 0;
          } else if (menuSettings[3] == "1") {
            menuSettings[2] = "0";
            menuSettings[3] = "2";
            menuSettings[4] = "0";
            menuSettings[5] = "0";
            change = 0;
          }
        }
        break;
      case 4:
        {
          if (menuSettings[4] == "0" || menuSettings[4] == "2") {
            menuSettings[2] = "0";
            menuSettings[3] = "0";
            menuSettings[4] = "1";
            menuSettings[5] = "0";
            change = 0;
          } else if (menuSettings[4] == "1") {
            menuSettings[2] = "0";
            menuSettings[3] = "0";
            menuSettings[4] = "2";
            menuSettings[5] = "0";
            change = 0;
          }
        }
        break;
      case 5:
        {
          if (menuSettings[5] == "0" || menuSettings[5] == "2") {
            menuSettings[2] = "0";
            menuSettings[3] = "0";
            menuSettings[4] = "0";
            menuSettings[5] = "1";
            change = 0;
          } else if (menuSettings[5] == "1") {
            menuSettings[2] = "0";
            menuSettings[3] = "0";
            menuSettings[4] = "0";
            menuSettings[5] = "2";
            change = 0;
          }
        }
        break;
      case 6:
        {
          if (menuSettings[6] == "0") {
            menuSettings[6] = "1";
            menuSettings[7] = "0";
            menuSettings[8] = "0";
            menuSettings[9] = "0";
            menuSettings[10] = "0";
            change = 0;
          }
        }
        break;
      case 7:
        {
          if (menuSettings[7] == "0") {
            menuSettings[6] = "0";
            menuSettings[7] = "1";
            menuSettings[8] = "0";
            menuSettings[9] = "0";
            menuSettings[10] = "0";
            change = 0;
          }
        }
        break;
      case 8:
        {
          if (menuSettings[8] == "0") {
            menuSettings[6] = "0";
            menuSettings[7] = "0";
            menuSettings[8] = "1";
            menuSettings[9] = "0";
            menuSettings[10] = "0";
            change = 0;
          }
        }
        break;
      case 9:
        {
          if (menuSettings[9] == "0") {
            menuSettings[6] = "0";
            menuSettings[7] = "0";
            menuSettings[8] = "0";
            menuSettings[9] = "1";
            menuSettings[10] = "0";
            change = 0;
          }
        }
        break;
      case 10:
        {
          if (menuSettings[10] == "0") {
            menuSettings[6] = "0";
            menuSettings[7] = "0";
            menuSettings[8] = "0";
            menuSettings[9] = "0";
            menuSettings[10] = "1";
            change = 0;
          }
        }`
        break;
    }
    notifyListeners();
  }

  updateCheckBoxValue() {
    if (change == 0) {
      change = 1;
    } else {
      change = 0;
    }
    notifyListeners();
  }
}
