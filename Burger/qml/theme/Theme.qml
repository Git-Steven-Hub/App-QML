pragma Singleton
import QtQuick

QtObject {
    // Brand
    property color primary: "#2D6AE3"
    property color secondary: "#F59E0B"
    property color surface: "#111111"

    // Base UI
    property color background: "#F1F5F9"
    property color card: "#648e96"
    property color divider: "#E5E7EB"

    // Text
    property color textPrimary: "#0F172A"
    property color textSecondary: "#475569"

    // Feedback
    property color success: "#22C55E"
    property color error: "#EF4444"
    property color warning: "#F59E0B"

    // Layout
    property int radius: 14
    property int radiusLarge: 18
    property int spacing: 16
    property int padding: 12

    //Typography
    property int fontSmall: 12
    property int font: 14
    property int fontTintle: 18
}  