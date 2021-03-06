import 'dart:html' as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

main() {
    configLogging();

    registerMdl();

    componentFactory().run().then((_) {

        final MaterialSlider slider2 = MaterialSlider.widget(dom.querySelector("#slider2"));
        final MaterialSlider slider4 = MaterialSlider.widget(dom.querySelector("#slider4"));

        slider2.onChange.listen((_) {
            slider4.value = slider2.value;
        });

    });
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}