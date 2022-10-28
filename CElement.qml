import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: root

    color: 'transparent'

    property string text: ''
    property string hint: ''
    property string result: ''
    property string btn_1_text: ''
    property string btn_2_text: ''

    signal firstclick()
    signal secondclick()

    Row {
        anchors.fill: parent
        anchors.leftMargin: 30
        spacing: 20
        
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            font.pointSize: 18
        }

        TextField {
            id: field
            height: parent.height
            width: parent.width / 2
            background: Rectangle { border.width: 2; radius: field.height / 2; }
            font.pointSize: 14
            horizontalAlignment: TextField.AlignHCenter
            placeholderText: root.hint
            text: root.result
        }

        Button {
            id: btn1
            visible: root.btn_1_text != ''
            height: parent.height
            width: height
            background: Rectangle { border.width: 2; radius: btn1.height / 2; color: btn1.down ? 'grey' : 'white' }
            Text {
                anchors.centerIn: parent
                text: root.btn_1_text
                font.pointSize: 14
            }
            onReleased: {
                firstclick();
            }
        }

        Button {
            id: btn2
            visible: root.btn_2_text != ''
            height: parent.height
            width: height
            background: Rectangle { border.width: 2; radius: btn2.height / 2; color: btn2.down ? 'grey' : 'white' }
            Text {
                anchors.centerIn: parent
                text: root.btn_2_text
                font.pointSize: 14
            }
            onReleased: {
                secondclick();
            }
        }
    }
}