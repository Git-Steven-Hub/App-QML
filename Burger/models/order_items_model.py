from database.database_manager import DataBase
from PySide6.QtCore import Qt, QAbstractListModel, QModelIndex, QByteArray, Slot


class OrderItemsModel(QAbstractListModel):
    
    #Roles para tomarlos en QML
    ItemIdRole = Qt.UserRole + 1
    ItemTypeRole = Qt.UserRole + 2
    CategoryIdRole = Qt.UserRole + 3
    CategoryNameRole = Qt.UserRole + 4
    NameRole = Qt.UserRole + 5
    UnitPriceRole = Qt.UserRole + 6
    QuantityRole = Qt.UserRole + 7
    
    def __init__(self):
        super().__init__()
        
        self.db = DataBase()
        
        self.items = []
    
    @Slot(int)
    def load_items(self, order_id):
        self.beginResetModel()
        self.items.clear()
        
        rows = self.db.get_orders_items(order_id)
        
        for row in rows: 
            item = {
                "ItemId": row[0],
                "ItemType": row[2],
                "category_id": row[3],
                "category_name": row[4],
                "Name": row[5],
                "UnitPrice": row[6],
                "Quantity": row[7]
            }
            self.items.append(item)
            
        self.endResetModel()
        
    def rowCount(self, parent=QModelIndex()):
        if parent.isValid():
            return 0
        return len(self.items)
    
    def data(self, index, role):
        if not index.isValid():
            return None
        
        item = self.items[index.row()]
        
        if role == self.ItemIdRole:
            return item["ItemId"]
        
        if role == self.ItemTypeRole:
            return item["ItemType"]
        
        if role == self.CategoryIdRole:
            return item["category_id"]
        
        if role == self.CategoryNameRole:
            return item["category_name"]
        
        if role == self.NameRole:
            return item["Name"]
        
        if role == self.UnitPriceRole:
            return item["UnitPrice"]
        
        if role == self.QuantityRole:
            return item["Quantity"]
        
    def roleNames(self):
        return {
            self.ItemIdRole: QByteArray(b"ItemId"),
            self.ItemTypeRole: QByteArray(b"ItemType"),
            self.CategoryIdRole: QByteArray(b"categoryId"),
            self.CategoryNameRole: QByteArray(b"categoryName"),
            self.NameRole: QByteArray(b"Name"),
            self.UnitPriceRole: QByteArray(b"UnitPrice"),
            self.QuantityRole: QByteArray(b"Quantity"),
        }