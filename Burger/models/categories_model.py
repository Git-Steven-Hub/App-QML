from database.database_manager import DataBase
from PySide6.QtCore import Qt, QAbstractListModel, QModelIndex, QByteArray, Slot

class CategoriesModel(QAbstractListModel):
    
    CategoryIdRole = Qt.UserRole + 1
    CategoryNameRole = Qt.UserRole + 2
    CategoryIconRole = Qt.UserRole + 3
    
    def __init__(self):
        super().__init__()
        
        self.db = DataBase()
        
        self.categories = []
        
        self.load_categories()
        
    @Slot()
    def load_categories(self):
        self.beginResetModel()
        self.categories.clear()
        
        rows = self.db.get_categories()
        
        for row in rows:
            category = {
                "id" : row[0],
                "name" : row[1],
                "icon" : row[2]
            }
            self.categories.append(category)
        
        self.endResetModel()
        
    def rowCount(self, parent=QModelIndex()):
        if parent.isValid():
            return 0
        
        return len(self.categories)
        
    def data(self, index, role):
        if not index.isValid():
            return None
        
        category = self.categories[index.row()]
        
        if role == self.CategoryIdRole:
            return category["id"]
        
        if role == self.CategoryNameRole:
            return category["name"]
        
        if role == self.CategoryIconRole:
            return category["icon"]
        
    def roleNames(self):
        return {
            self.CategoryIdRole: QByteArray(b"categoryId"),
            self.CategoryNameRole: QByteArray(b"categoryName"),
            self.CategoryIconRole: QByteArray(b"categoryIcon"),
        }