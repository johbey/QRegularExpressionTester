// regexsearch.cpp
#include "regexsearch.h"

RegexSearch::RegexSearch(QQuickItem *parent)
    :
      QQuickItem(parent)
{}

void RegexSearch::findMatches(const QString& pattern,
                              const QString& text,
                              const QList<int>& options)
{
    m_output.clear();
    m_matchStarts.clear();
    m_matchLengths.clear();
    m_groupStarts.clear();
    m_groupLengths.clear();

    QStringList matches;
    QStringList groups;

    if (pattern.isEmpty())
    {
        m_output << "Enter a valid regex pattern";
        return;
    }

    QRegularExpression regex(pattern);

    QRegularExpression::PatternOptions regexOptions;
    for (auto option : options)
    {
        regexOptions.setFlag(static_cast<QRegularExpression::PatternOption>(option));
    }
    regex.setPatternOptions(regexOptions);

    // Perform regex matching using QRegularExpression
    auto matchIterator = regex.globalMatch(text);

    int matchIndex = 1;
    while (matchIterator.hasNext())
    {
        int groupIndex = 1;
        auto match = matchIterator.next();
        m_output << "<font color='lightgray'>"
            + QString("Match %1").arg(matchIndex++)
            + "</font>" << "<font color='royalblue'><xmp>"
            + match.captured(0).toHtmlEscaped()
            + "</xmp></font>";

        m_matchStarts << match.capturedStart(0);
        m_matchLengths << match.capturedLength(0);

        for (int i = 1; i <= match.lastCapturedIndex(); ++i)
        {
            m_output << "<font color='lightgray'>"
                + QString("Group %1").arg(groupIndex++)
                + "</font>" << "<font color='olivedrab'><xmp>"
                + match.captured(i).toHtmlEscaped()
                + "</xmp></font>";
            m_groupStarts << match.capturedStart(i);
            m_groupLengths << match.capturedLength(i);
        }

        m_output << ""; // this will be a new line after joining
    }

    if (matchIndex == 1)
    {
        m_output << "No matches found";
    }
}

QStringList RegexSearch::output()
{
    return m_output;
}

QList<int> RegexSearch::matchStarts()
{
    return m_matchStarts;
}

QList<int> RegexSearch::matchLengths()
{
    return m_matchLengths;
}

QList<int> RegexSearch::groupStarts()
{
    return m_groupStarts;
}

QList<int> RegexSearch::groupLengths()
{
    return m_groupLengths;
}
