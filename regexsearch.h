// regexsearch.h
#ifndef REGEXSEARCH_H
#define REGEXSEARCH_H

#include <QQuickItem>
#include <QRegularExpression>
#include <QStringList>

class RegexSearch : public QQuickItem
{
    Q_OBJECT

public:
    RegexSearch(QQuickItem *parent = nullptr);

public slots:
    void findMatches(const QString &pattern, const QString &text, const QList<int> &options);
    QStringList output();
    QList<int> matchStarts();
    QList<int> matchLengths();
    QList<int> groupStarts();
    QList<int> groupLengths();

public:
    QStringList m_output;
    QList<int> m_matchStarts;
    QList<int> m_matchLengths;
    QList<int> m_groupStarts;
    QList<int> m_groupLengths;
};

#endif // REGEXSEARCH_H
