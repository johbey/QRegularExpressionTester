import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import RegexSearch 1.0
import RegexHighlighter 1.0

ApplicationWindow {
    visible: true
    width: 1000
    height: 600
    title: "QRegularExpression Tester"



    property var ignoreUpdate: false

    ColumnLayout {
        id: root
        anchors.fill: parent

        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 7

            handle: Rectangle {
                implicitWidth: 7
            }

            ColumnLayout  {
                id: inputLayout

                Label {
                    text: "Regular Expression"
                    font.pointSize: 12
                }

                // LineEdit for entering regex pattern
                TextField {
                    id: regexInput
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500
                    placeholderText: "Enter regular expression"
                    onTextChanged: updateRegex()
                    selectByMouse: true
                    font.pointSize: 15
                    focus: true
                }

                Button {
                    text: optionsListView.visible? "Hide QRegularExpression Options" : "Show QRegularExpression Options"
                    Layout.fillWidth: true
                    onClicked: {
                        optionsListView.visible = !optionsListView.visible
                    }
                    font.pointSize: 12
                }

                // ListView with CheckBox elements for regex options
                ListView {
                    id: optionsListView
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500
                    height: 9 * 30 + 6
                    visible: false

                    model: ListModel
                    {
                        ListElement { text: "QRegularExpression::CaseInsensitiveOption"; value: 0x0001; checked: false }
                        ListElement { text: "QRegularExpression::DotMatchesEverythingOption"; value: 0x0002; checked: false }
                        ListElement { text: "QRegularExpression::MultilineOption"; value: 0x0004; checked: false }
                        ListElement { text: "QRegularExpression::ExtendedPatternSyntaxOption"; value: 0x0008; checked: false }
                        ListElement { text: "QRegularExpression::InvertedGreedinessOption"; value: 0x0010; checked: false }
                        ListElement { text: "QRegularExpression::DontCaptureOption"; value: 0x0020; checked: false }
                        ListElement { text: "QRegularExpression::UseUnicodePropertiesOption"; value: 0x0040; checked: false }
                        ListElement { text: "QRegularExpression::OptimizeOnFirstUsageOption"; value: 0x0080; checked: false }
                        ListElement { text: "QRegularExpression::DontAutomaticallyOptimizeOption"; value: 0x0100; checked: false }
                    }

                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 500
                        height: 30

                        CheckBox {
                            text: model.text
                            checked: model.checked
                            onClicked:
                            {
                                model.checked = checked
                                updateRegex()
                            }
                            onToggled:
                            {
                                model.checked = checked
                                updateRegex()
                            }
                        }
                    }
                }

                Label {
                    text: "Test String"
                    font.pointSize: 12
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 500
                    Layout.fillHeight: true

                    // TextArea for entering text
                    TextArea {
                        id: textInput
                        Layout.fillWidth: true
                        Layout.preferredWidth: 500
                        Layout.fillHeight: true
                        onTextChanged: updateRegex()
                        selectByMouse: true
                        font.pointSize: 15
                        placeholderText: "Enter test string"
                        textFormat: TextEdit.PlainText
                    }

                }

                RegexHighlighter {
                    id: highlighter
                    textDocument: textInput.textDocument

                    onHighlightBlock: {

                        var startIndex = start
                        var matchStarts = regexSearch.matchStarts();
                        var matchLengths = regexSearch.matchLengths();

                        console.log(matchStarts)
                        console.log(matchLengths)

                        setFormat(0, textInput.text.length, "black")

                        // apply highlights of matches
                        for (var i = 0; i < matchStarts.length; ++i) {                            
                            var matchStart = matchStarts[i] - startIndex;
                            var matchLength = matchLengths[i];

                            //console.log(matchStart, matchLength)
                            setFormat(matchStart, matchLength, "royalblue")
                        }

                        var groupStarts = regexSearch.groupStarts();
                        var groupLengths = regexSearch.groupLengths();

                        // apply highlights of group with priority
                        for (var j = 0; j < groupStarts.length; ++j) {
                            var groupStart = groupStarts[j] - startIndex;
                            var groupLength = groupLengths[j];

                            setFormat(groupStart, groupLength, "olivedrab")
                        }
                    }
                }
        }

        ColumnLayout  {
            Layout.fillWidth: true

            ScrollView {
                Layout.fillWidth: true
                Layout.preferredWidth: 500
                Layout.fillHeight: true

                // TextArea for displaying matches and captured groups
                TextEdit {
                    id: resultTextArea

                    Layout.fillWidth: true
                    Layout.preferredWidth: 500
                    Layout.fillHeight: true

                    wrapMode: Text.Wrap
                    readOnly: true
                    selectByMouse: true

                    font.pointSize: 15
                    textFormat: TextEdit.RichText

                    text: "Enter a valid regex pattern"
                }
            }
        }

        }

        Label {
            text: "https://github.com/johbey"
            font.pointSize: 12
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.bottomMargin: 7
        }

    }

    RegexSearch {
        id: regexSearch
    }

    // Function to update the regex results
    function updateRegex() {

        if (ignoreUpdate)
        {
            return
        }

        var pattern = regexInput.text.trim() // Remove leading and trailing whitespaces
        var text = textInput.text

        var selectedOptions = [];
        for (var i = 0; i < optionsListView.model.count; ++i) {
            var option = optionsListView.model.get(i);
            if (option.checked) {
                selectedOptions.push(option.value);
            }
        }

        regexSearch.findMatches(pattern, text, selectedOptions);
        var matches = regexSearch.output();

        resultTextArea.text = matches.join("<br>");

        ignoreUpdate = true

        var cursorPos = textInput.cursorPosition
        var text = textInput.text
        textInput.text = ""
        textInput.text = text
        textInput.cursorPosition = cursorPos

        ignoreUpdate = false

    }
}
