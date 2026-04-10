from database.database_manager import DataBase
from PySide6.QtCore import Qt, QAbstractListModel, QModelIndex, QByteArray, Slot


class OrderItemsModel(QAbstractListModel):
    
    #Roles para tomarlos en QML
    ItemIdRole = Qt.UserRole + 1
    ItemTypeRole = Qt.UserRole + 2
    CategoryIdRole = Qt.UserRole + 3
    CategoryNameRole = Qt.UserRole + 4
    NameRole = Qt.UserRole + 5
    NotesRole = Qt.UserRole + 6
    UnitPriceRole = Qt.UserRole + 7
    QuantityRole = Qt.UserRole + 8
    
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
                "item_id": row[1],
                "item_type": row[2],
                "category_id": row[3],
                "category_name": row[4],
                "name": row[5],
                "notes": row[6],
                "unit_price": row[7],
                "quantity": row[8]
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
            return item["item_id"]
        
        if role == self.ItemTypeRole:
            return item["item_type"]
        
        if role == self.CategoryIdRole:
            return item["category_id"]
        
        if role == self.CategoryNameRole:
            return item["category_name"]
        
        if role == self.NameRole:
            return item["name"]
        
        if role == self.NotesRole:
            return item["notes"]
        
        if role == self.UnitPriceRole:
            return item["unit_price"]
        
        if role == self.QuantityRole:
            return item["quantity"]
        
    def roleNames(self):
        return {
            self.ItemIdRole: QByteArray(b"item_id"),
            self.ItemTypeRole: QByteArray(b"item_type"),
            self.CategoryIdRole: QByteArray(b"category_id"),
            self.CategoryNameRole: QByteArray(b"category_name"),
            self.NameRole: QByteArray(b"name"),
            self.NotesRole: QByteArray(b"notes"),
            self.UnitPriceRole: QByteArray(b"unit_price"),
            self.QuantityRole: QByteArray(b"quantity"),
        }