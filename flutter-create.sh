#! /bin/bash
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
flutter create . --platforms ios,android,windows,linux,macos,web,winuwp
