import os
import sys
from qml import resources_rc
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl
from models.sales_model import SalesModel
from models.sales_proxy_model import SalesFilterProxyModel
from models.cart_model import CartModel
from models.order_items_model import OrderItemsModel
from models.products_model import ProductsModel
from models.categories_model import CategoriesModel
from models.auth_model import AuthModel
from database.database_manager import DataBase
from pathlib import Path

os.environ["QT_QUICK_CONTROLS_STYLE"] = "Basic"

def main():
	app = QApplication(sys.argv)
	print(sys.executable)
	base_dir = Path(__file__).resolve().parent
	qml_dir = base_dir / "qml"

	main_qml = qml_dir / "MainWindow.qml"

	engine = QQmlApplicationEngine()

	db = DataBase()
	authmodel = AuthModel()

	authmodel.create_admin()
 
	products_model = ProductsModel()
	categories_model = CategoriesModel()
	cart_model = CartModel()
	sales_model = SalesModel()
	order_items_model = OrderItemsModel()
	proxy_model = SalesFilterProxyModel()

	proxy_model.setSourceModel(sales_model)

	engine.rootContext().setContextProperty("AuthModel", authmodel)
	engine.rootContext().setContextProperty("ProductsModel", products_model)
	engine.rootContext().setContextProperty("CategoriesModel", categories_model)
	engine.rootContext().setContextProperty("CartModel", cart_model)
	engine.rootContext().setContextProperty("SalesModel", sales_model)
	engine.rootContext().setContextProperty("OrderItemsModel", order_items_model)
	engine.rootContext().setContextProperty("SalesProxy", proxy_model)

	engine.addImportPath(str(qml_dir))

	engine.load(QUrl.fromLocalFile(str(main_qml)))

	def cleanup():
		"""
  		Función que se encarga de limpiar los modelos
  		y cerrar la conexión a la base de datos.
       """
		engine.rootContext().setContextProperty("AuthModel", None)
		engine.rootContext().setContextProperty("ProductsModel", None)
		engine.rootContext().setContextProperty("CategoriesModel", None)
		engine.rootContext().setContextProperty("CartModel", None)
		engine.rootContext().setContextProperty("SalesModel", None)
		engine.rootContext().setContextProperty("OrderItemsModel", None)
		engine.rootContext().setContextProperty("SalesProxy", None)
		db.close_system()

	app.aboutToQuit.connect(cleanup)
	sys.exit(app.exec())

if __name__ == "__main__":
	main()