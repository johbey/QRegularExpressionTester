#include "regexhighlighter.h"

RegexHighlighter::RegexHighlighter(QObject* parent)
    :
    QSyntaxHighlighter(parent),
    m_textDocument(nullptr)
{
}

void RegexHighlighter::highlightBlock(const QString& text)
{
    int start = previousBlockState();
    if (start < 0)
    {
        start = 0;
    }
    emit highlightBlock(QVariant(text), start);
    setCurrentBlockState(start + text.count() + 1); // + 1 for the new line
}

QQuickTextDocument* RegexHighlighter::textDocument() const
{
    return m_textDocument;
}

void RegexHighlighter::setTextDocument(QQuickTextDocument* textDocument)
{
    if (textDocument == m_textDocument)
    {
        return;
    }

    m_textDocument = textDocument;

    QTextDocument* doc = m_textDocument->textDocument();
    setDocument(doc);

    emit textDocumentChanged();
}

void RegexHighlighter::setFormat(int start, int count, const QVariant& format)
{
    if (format.canConvert(QVariant::Color))
    {
        QSyntaxHighlighter::setFormat(start, count, format.value<QColor>());
    }
}
