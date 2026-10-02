// Arterial — SDDM login theme
// Black / dark-grey / arterial-red, to match the Arterial KDE suite.
// splicer scorn (voidrane) · GPL-3.0-or-later
import QtQuick 2.15

Rectangle {
    id: root
    width: 1920; height: 1080
    color: "#050505"

    // palette
    readonly property color edge:  "#b30000"
    readonly property color hot:   "#e01b1b"
    readonly property color blood: "#8b0000"
    readonly property color plate: "#121212"
    readonly property color base:  "#0a0a0a"
    readonly property color text:  "#bdb4b4"
    readonly property color dim:   "#857c7c"
    readonly property color ghost: "#ece6e6"
    readonly property string mono: "Noto Sans Mono"

    property int sessionIndex: sessionModel ? sessionModel.lastIndex : 0

    // faint red vignette on near-black
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#050505" }
            GradientStop { position: 0.6; color: "#070202" }
            GradientStop { position: 1.0; color: "#0a0000" }
        }
    }

    // thin red screen frame
    Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: root.edge; opacity: 0.6 }
    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: root.edge; opacity: 0.6 }

    // large sigil watermark behind the panel
    Image {
        id: sigil
        source: "assets/sigil.svg"
        sourceSize: Qt.size(520, 520)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -40
        opacity: 0.16
        SequentialAnimation on opacity {
            running: true; loops: Animation.Infinite
            NumberAnimation { to: 0.22; duration: 2600; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.12; duration: 2600; easing.type: Easing.InOutSine }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 26
        width: 360

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "A R T E R I A L"
            color: root.ghost
            font.family: root.mono; font.pixelSize: 30; font.letterSpacing: 8
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(new Date(), "ddd dd MMM  ·  HH:mm")
            color: root.dim; font.family: root.mono; font.pixelSize: 13
            Timer { interval: 1000; running: true; repeat: true
                onTriggered: parent.text = Qt.formatDateTime(new Date(), "ddd dd MMM  ·  HH:mm") }
        }

        // login plate
        Rectangle {
            width: parent.width; height: 150
            color: root.base
            border.color: loginFocus.activeFocus || userFocus.activeFocus ? root.hot : root.edge
            border.width: 1
            Behavior on border.color { ColorAnimation { duration: 150 } }

            // red corner brackets
            Repeater {
                model: [[0,0,1,1],[1,0,-1,1],[0,1,1,-1],[1,1,-1,-1]]
                Item {
                    x: modelData[0] * (parent.width - 1)
                    y: modelData[1] * (parent.height - 1)
                    Rectangle { x: 0; y: 0; width: 8*modelData[2]; height: 2; color: root.hot }
                    Rectangle { x: 0; y: 0; width: 2; height: 8*modelData[3]; color: root.hot }
                }
            }

            Column {
                anchors.fill: parent; anchors.margins: 16; spacing: 12

                // username
                Rectangle {
                    width: parent.width; height: 34; color: "#0f0f0f"
                    border.color: userFocus.activeFocus ? root.hot : "#2e2e2e"; border.width: 1
                    Text { anchors.verticalCenter: parent.verticalCenter; x: 10
                        text: "user"; color: root.dim; font.family: root.mono; font.pixelSize: 12
                        visible: userField.text.length === 0 && !userFocus.activeFocus }
                    TextInput {
                        id: userField; focus: false
                        anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 10
                        verticalAlignment: TextInput.AlignVCenter
                        color: root.text; font.family: root.mono; font.pixelSize: 13
                        text: userModel ? userModel.data(userModel.index(userModel.lastIndex,0), Qt.UserRole + 1) || "" : ""
                        onAccepted: passField.forceActiveFocus()
                        FocusScope { id: userFocus; anchors.fill: parent; focus: userField.activeFocus }
                    }
                    MouseArea { anchors.fill: parent; onClicked: userField.forceActiveFocus() }
                }

                // password
                Rectangle {
                    width: parent.width; height: 34; color: "#0f0f0f"
                    border.color: loginFocus.activeFocus ? root.hot : "#2e2e2e"; border.width: 1
                    Text { anchors.verticalCenter: parent.verticalCenter; x: 10
                        text: "password"; color: root.dim; font.family: root.mono; font.pixelSize: 12
                        visible: passField.text.length === 0 && !passField.activeFocus }
                    TextInput {
                        id: passField
                        anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 10
                        verticalAlignment: TextInput.AlignVCenter
                        echoMode: TextInput.Password; passwordCharacter: "†"
                        color: root.text; font.family: root.mono; font.pixelSize: 13
                        onAccepted: root.doLogin()
                        FocusScope { id: loginFocus; anchors.fill: parent; focus: passField.activeFocus }
                    }
                    MouseArea { anchors.fill: parent; onClicked: passField.forceActiveFocus() }
                }

                // sign-in button
                Rectangle {
                    width: parent.width; height: 34
                    color: signArea.pressed ? root.blood : (signArea.containsMouse ? "#260000" : "#141414")
                    border.color: root.edge; border.width: 1
                    Behavior on color { ColorAnimation { duration: 120 } }
                    Text { anchors.centerIn: parent; text: "unlock"
                        color: signArea.containsMouse ? root.ghost : root.text
                        font.family: root.mono; font.pixelSize: 13; font.letterSpacing: 3 }
                    MouseArea { id: signArea; anchors.fill: parent; hoverEnabled: true; onClicked: root.doLogin() }
                }
            }
        }

        // message line
        Text {
            id: msg
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width; horizontalAlignment: Text.AlignHCenter
            color: root.hot; font.family: root.mono; font.pixelSize: 12
            text: ""; wrapMode: Text.WordWrap
        }
    }

    // bottom bar: session + power
    Row {
        anchors.right: parent.right; anchors.bottom: parent.bottom
        anchors.rightMargin: 28; anchors.bottomMargin: 20; spacing: 18

        Text {
            id: sessionLabel
            text: "session: " + root.sessionName()
            color: root.dim; font.family: root.mono; font.pixelSize: 12
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                onClicked: { if (sessionModel) { root.sessionIndex = (root.sessionIndex + 1) % sessionModel.rowCount();
                    sessionLabel.text = "session: " + root.sessionName() } } }
        }
        Text { text: "reboot"; color: root.dim; font.family: root.mono; font.pixelSize: 12
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.reboot() } }
        Text { text: "shutdown"; color: root.dim; font.family: root.mono; font.pixelSize: 12
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.powerOff() } }
    }

    function sessionName() {
        if (!sessionModel) return "default";
        try { return sessionModel.data(sessionModel.index(root.sessionIndex,0), Qt.UserRole + 4) || "session"; }
        catch (e) { return "session"; }
    }

    function doLogin() {
        msg.text = "";
        sddm.login(userField.text, passField.text, root.sessionIndex);
    }

    Connections {
        target: sddm
        function onLoginSucceeded() { msg.color = root.text; msg.text = "access granted" }
        function onLoginFailed() { msg.color = root.hot; msg.text = "access denied"; passField.text = ""; passField.forceActiveFocus() }
        function onInformationMessage(message) { msg.text = message }
    }

    Component.onCompleted: passField.forceActiveFocus()
}
