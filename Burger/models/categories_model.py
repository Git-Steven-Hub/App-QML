from database.database_manager import DataBase
from PySide6.QtCore import Qt, QAbstractListModel, QModelIndex, QByteArray, Slot

class CategoriesModel(QAbstractListModel):
    
    CategoryIdRole = Qt.UserRole + 1
    CategoryNameRole = Qt.UserRole + 2
    CategoryIconRole = Qt.UserRole + 3
    CategoryNotesRole = Qt.UserRole + 4
    
    def __init__(self):
        super().__init__()
        
        self.db = DataBase()
        
        self.categories = []
        
        self.load_categories()
        
    @Slot()
    def load_categories(self):
        self.beginResetModel()
        self.categories.clear()
            
        json_data = self.db.load_json_data()
        
        for notes in json_data["categories"]:
            self.categories.append({
                "categoryId": notes["id"],
                "categoryName": notes["name"],
                "categoryIcon": notes["icon"],
                "categoryNotes": notes.get("notes", [])
            })
            
        self.endResetModel()
        
    @Slot(int, result=list)
    def get_category_notes(self, category_id):
        category_id = int(category_id)
        
        for category in self.categories:
            if category.get("categoryId") == category_id:
                return category.get("categoryNotes", [])
        return []
        
    def rowCount(self, parent=QModelIndex()):
        if parent.isValid():
            return 0
        
        return len(self.categories)
        
    def data(self, index, role):
        if not index.isValid():
            return None
        
        category = self.categories[index.row()]
        
        if role == self.CategoryIdRole:
            return category.get("categoryId")
        
        if role == self.CategoryNameRole:
            return category.get("categoryName")
        
        if role == self.CategoryIconRole:
            return category.get("categoryIcon")
        
        if role == self.CategoryNotesRole:
            return category.get("categoryNotes", [])
        
    def roleNames(self):
        return {
            self.CategoryIdRole: QByteArray(b"categoryId"),
            self.CategoryNameRole: QByteArray(b"categoryName"),
            self.CategoryIconRole: QByteArray(b"categoryIcon"),
            self.CategoryNotesRole: QByteArray(b"categoryNotes"),
        }