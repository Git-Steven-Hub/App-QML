pragma Singleton
import QtQuick

QtObject {
    //Brand
    property color primary: "#2563EB"
    property color secondary: "#F59E0B"
    property color accent: "#22C55E"

    //Surfaces
    property color background: "#020c16"
    property color surface: "#111827"
    property color surfaceAlt: "#1F2933"
    
    //UI
    property color divider: "#E5E7EB"

    //Buttons
    property color buttonPrimary: primary
    property color buttonSecondary: "#334155"
    property color buttonDanger: "#DC2626"

    //Status
    property color warning: "#bebc21"
    property color success: "#25ac47"

    //CheckBox
    property color checkBox: "#4CAF50"

    //Text
    property color textPrimary: "#0F172A"
    property color textSecondary: "#475569"
    property color textMuted: "#94A3B8"

    //Layout
    property int radius: 18
    property int radiusSmall: 4
    property int radiusLarge: 22
    property int spacing: 16
    property int padding: 32

    //Typography
    property int fontSmall: 12
    property int font: 14
    property int fontTitle: 24
}  