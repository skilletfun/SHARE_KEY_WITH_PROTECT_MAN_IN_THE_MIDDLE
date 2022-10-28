import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    id: root

    width: 900
    height: 600
    visible: true
    title: qsTr("CRYPTO")
    color: '#DEDEDE'

    onClosing: {
        Qt.callLater(Qt.quit);
    }

    property int step: -1
    property string name: '' 
    property var listdata: []
    property alias model: _model

    property string _g: ''
    property string _p: ''
    property string _ab: ''
    property string _x: ''
    property string _d: ''
    property string _e: ''
    property string _n: ''
    property string _cx: ''
    property string _cx1: ''
    property string _cx2: ''
    property string _k: ''

    Text {
        font.pointSize: 20
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        text: root.name
    }

    Rectangle {
        height: root.height / 1.5
        width: root.width / 1.25
        border.width: 2
        anchors.centerIn: parent
        radius: height / 6

        ListView {
            id: mainview
            width: parent.width - 80
            anchors.centerIn: parent
            height: contentHeight
            clip: true
            interactive: false
            spacing: 10
            model: _model

            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; to: 0; duration: 500 }
                    NumberAnimation { property: "y"; to: -80; duration: 500 }
                }
            }

            add: Transition {
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; to: 1; duration: 500 }
                    NumberAnimation { property: "y"; from: 200; duration: 500 }
                }
            }
            
            delegate: CElement {
                height: 60
                width: mainview.width
                text: _text
                hint: _hint
                result: _res
                btn_1_text: _b1
                btn_2_text: _b2

                onFirstclick: {
                    check_do_1(index, root.name);
                }

                onSecondclick: {
                    check_do_2(index, root.name);
                }
            }
        }
    }

    ListModel {
        id: _model
    }

    function next_item() {
        step += 1;
        _model.append({'_text': listdata[step][0], '_hint': listdata[step][1], '_res': listdata[step][2], '_b1': listdata[step][3], '_b2': listdata[step][4]});
    }

    Component.onCompleted: {
        next_item();        
    }
}