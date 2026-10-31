import QtQml 2.2
import QtQuick 2.0
import QtQuick.Controls 2.5

import ComputerModel 1.0

Menu {
    property ComputerModel computerModel
    property var hiddenComputers: []

    id: unhidePcMenu
    title: qsTr("Unhide PC")
    width: {
        var maxItemWidth = implicitWidth
        for (var i = 0; i < count; i++) {
            maxItemWidth = Math.max(maxItemWidth, itemAt(i).implicitWidth)
        }
        return maxItemWidth + leftPadding + rightPadding
    }

    onAboutToShow: {
        hiddenComputers = computerModel.getHiddenComputers()
    }

    MenuItem {
        text: qsTr("There are no hidden PCs.")
        enabled: false
        visible: hiddenComputers.length === 0
        height: visible ? implicitHeight : 0
    }

    Instantiator {
        model: hiddenComputers

        delegate: NavigableMenuItem {
            text: modelData.label
            onTriggered: {
                // The model reset destroys the PC menu that contains this item, so wait until the trigger is done.
                Qt.callLater(computerModel.unhideComputer, modelData.uuid)
            }
        }

        function addMenuItem(index, object) {
            unhidePcMenu.insertItem(index + 1, object)
        }

        function removeMenuItem(index, object) {
            unhidePcMenu.removeItem(object)
        }

        // Signal handlers can't declare parameters before Qt 5.15.
        Component.onCompleted: {
            objectAdded.connect(addMenuItem)
            objectRemoved.connect(removeMenuItem)
        }
    }
}
