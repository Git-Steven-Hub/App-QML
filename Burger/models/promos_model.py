from database.database_manager import DataBase
from PySide6.QtCore import Qt, QAbstractListModel, QModelIndex, QByteArray, Slot

class PromosModel(QAbstractListModel):
    
    PromoIdRole = Qt.UserRole + 1
    PromoCategoryIdRole = Qt.UserRole + 2
    PromoCategoryNameRole = Qt.UserRole + 3
    PromoNameRole = Qt.UserRole + 4
    PromoDescriptionRole = Qt.UserRole + 5
    PromoPriceRole = Qt.UserRole + 6
    PromoIconRole = Qt.UserRole + 7
    
    def __init__(self):
        super().__init__()
        
        self.db = DataBase()
        
        self.promos = []
        
        self.load_promos()
        
    @Slot()
    def load_promos(self):
        self.beginResetModel()
        self.promos.clear()
        
        rows = self.db.get_promos()
        
        for row in rows:
            promo = {
                "id" : int(row[0]),
                "category_id" : int(row[1]),
                "category_name" : str(row[2]),
                "name" : str(row[3]),
                "description" : str(row[4]),
                "price" : float(row[5]),
                "icon" : str(row[6]) if row[6] else ""
            }
            
            self.promos.append(promo)
            
        self.endResetModel()
    
    def rowCount(self, parent=QModelIndex()):
        if parent.isValid():
            return 0

        return len(self.promos)
    
    def data(self, index, role):
        if not index.isValid():
            return None
        
        promo = self.promos[index.row()]
        
        if role == self.PromoIdRole:
            return promo["id"]
        
        if role == self.PromoCategoryIdRole:
            return promo["category_id"]
        
        if role == self.PromoCategoryNameRole:
            return promo["category_name"]
        
        if role == self.PromoNameRole:
            return promo["name"]
        
        if role == self.PromoDescriptionRole:
            return promo["description"]
        
        if role == self.PromoPriceRole:
            return promo["price"]
        
        if role == self.PromoIconRole:
            return promo["icon"]
        
        return None
    
    def roleNames(self):
        return {
            self.PromoIdRole: QByteArray(b"productId"),
            self.PromoCategoryIdRole: QByteArray(b"productCategoryId"),
            self.PromoCategoryNameRole: QByteArray(b"productCategoryName"),
            self.PromoNameRole: QByteArray(b"productName"),
            self.PromoDescriptionRole: QByteArray(b"description"),
            self.PromoPriceRole: QByteArray(b"productPrice"),
            self.PromoIconRole: QByteArray(b"productIcon"),
        }