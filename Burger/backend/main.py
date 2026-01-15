import os
import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine

os.environ["QT_QUICK_CONTROLS_STYLE"] = "Basic"

app = QApplication(sys.argv)

engine = QQmlApplicationEngine()

base_dir = os.path.dirname(__file__)
qml_dir = os.path.join(base_dir, "../qml")
engine.addImportPath(qml_dir)

engine.load(os.path.join(qml_dir, "main.qml"))

if not engine.rootObjects():
    sys.exit(-1)

sys.exit(app.exec())