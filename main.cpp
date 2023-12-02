#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "regexsearch.h"
#include "regexhighlighter.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Register the RegexSearch class for QML
    qmlRegisterType<RegexSearch>("RegexSearch", 1, 0, "RegexSearch");
    qmlRegisterType<RegexHighlighter>("RegexHighlighter", 1, 0, "RegexHighlighter");


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
