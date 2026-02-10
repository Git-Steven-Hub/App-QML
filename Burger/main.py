import PySide6
from PySide6.QtCore import qVersion
import os
import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl
from pathlib import Path

os.environ["QT_QUICK_CONTROLS_STYLE"] = "Basic"

def main():
	app = QApplication(sys.argv)
	print(sys.executable)
	base_dir = Path(__file__).resolve().parent
	qml_dir = base_dir / "qml"

	main_qml = qml_dir / "MainWindow.qml"

	# print("Python versión:", sys.version)
	# print("PySide6 versión:", PySide6.__version__)
	# print("Qt:", qVersion())

	engine = QQmlApplicationEngine()

	engine.addImportPath(str(qml_dir))

	engine.load(QUrl.fromLocalFile(str(main_qml)))

	if not engine.rootObjects():
		sys.exit(-1)

	sys.exit(app.exec())

if __name__ == "__main__":
	main()