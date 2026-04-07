from database.database_manager import DataBase
from PySide6.QtCore import Qt, QAbstractListModel, QModelIndex, QByteArray, Slot

class ProductsModel(QAbstractListModel):
    
    ProductIdRole = Qt.UserRole + 1
    ProductCategoryIdRole = Qt.UserRole + 2
    ProductCategoryNameRole = Qt.UserRole +3
    ProductNameRole = Qt.UserRole + 4
    ProductPriceRole = Qt.UserRole + 5
    ProductIconRole = Qt.UserRole + 6
    
    def __init__(self):
        super().__init__()
        
        self.db = DataBase()
        
        self.products = []
        
        self.load_products()
        
    @Slot()
    def load_products(self):
        self.beginResetModel()
        self.products.clear()
        
        rows = self.db.get_products()
        
        for row in rows:
            product = {
                "id" : int(row[0]),
                "category_id" : int(row[1]),
                "category_name" : str(row[2]),
                "name" : str(row[3]),
                "price" : float(row[4]),
                "icon" : str(row[5]) if row[5] else ""
            }
            
            self.products.append(product)
        
        self.endResetModel()
        
    def rowCount(self, parent=QModelIndex()):
        if parent.isValid():
            return 0
        
        return len(self.products)
    
    def data(self, index, role):
        if not index.isValid():
            return None

        product = self.products[index.row()]
        
        if role == self.ProductIdRole:
            return product["id"]
        
        if role == self.ProductCategoryIdRole:
            return product["category_id"]
        
        if role == self.ProductCategoryNameRole:
            return product["category_name"]

        if role == self.ProductNameRole:
            return product["name"]
        
        if role == self.ProductPriceRole:
            return product["price"]
        
        if role == self.ProductIconRole:
            return product["icon"]
        
        return None
    
    def roleNames(self):
        return {
            self.ProductIdRole: QByteArray(b"productId"),
            self.ProductCategoryIdRole: QByteArray(b"productCategoryId"),
            self.ProductCategoryNameRole: QByteArray(b"productCategoryName"),
            self.ProductNameRole: QByteArray(b"productName"),
            self.ProductPriceRole: QByteArray(b"productPrice"),
            self.ProductIconRole: QByteArray(b"productIcon"),
        }