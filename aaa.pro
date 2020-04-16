QT += quick

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        mainwindow.cpp \
        src/chess.cpp \
        src/chessmodel.cc \
        src/figurebishop.cc \
        src/figureintf.cc \
        src/figureking.cc \
        src/figureknight.cc \
        src/figurepawn.cc \
        src/figurequeen.cc \
        src/figurerook.cc \
        src/gameengine.cc \
        src/historymanager.cc \
        src/historymodel.cc \
        src/movepawn.cc \
        src/movepoints.cc \
        src/movevectors.cc \
        tile.cpp \
        validation.cpp

RESOURCES += qml.qrc
QT+=svg 

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    mainwindow.h \
    src/chessmodel.hpp \
    src/figurebishop.hpp \
    src/figureintf.hpp \
    src/figureking.hpp \
    src/figureknight.hpp \
    src/figurepawn.hpp \
    src/figurequeen.hpp \
    src/figurerook.hpp \
    src/gameengine.hpp \
    src/historymanager.hpp \
    src/historymodel.hpp \
    src/movepawn.hpp \
    src/movepoints.hpp \
    src/movevectors.hpp \
    tile.h \
    validation.h

FORMS += \
    mainwindow.ui

DISTFILES += \
    Images/bishop_black.svg \
    Images/bishop_white.svg \
    Images/exp.png \
    Images/king_black.svg \
    Images/king_white.svg \
    Images/knight_black.svg \
    Images/knight_white.svg \
    Images/pawn_black.svg \
    Images/pawn_white.svg \
    Images/profile.png \
    Images/queen_black.svg \
    Images/queen_white.svg \
    Images/rook_black.svg \
    Images/rook_white.svg \
    assets/bishop_black.svg \
    assets/bishop_white.svg \
    assets/exp.png \
    assets/king_black.svg \
    assets/king_white.svg \
    assets/knight_black.svg \
    assets/knight_white.svg \
    assets/pawn_black.svg \
    assets/pawn_white.svg \
    assets/profile.png \
    assets/queen_black.svg \
    assets/queen_white.svg \
    assets/rook_black.svg \
    assets/rook_white.svg \
    assets/svg/king_b.svg \
    assets/svg/king_w.svg \
    qml/Board.qml \
    qml/ChessFigure.qml \
    qml/GameFDialog.qml \
    qml/History.qml \
    qml/Window.qml
