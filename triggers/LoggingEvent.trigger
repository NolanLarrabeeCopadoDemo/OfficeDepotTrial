trigger LoggingEvent on LoggingEvent__e(after insert) {
    new LoggingEventHandler().run();
}