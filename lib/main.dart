import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:logging_config/logging_config.dart';

import 'app.dart';

void main() {
  configureLogging(LogConfig.root(Level.INFO));
  runApp(const App());
}
