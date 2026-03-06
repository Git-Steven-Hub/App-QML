from database.database_manager import DataBase
from PySide6.QtCore import Qt, QAbstractListModel, QModelIndex, Property, Signal, QByteArray, Slot

class CartModel(QAbstractListModel):

    #Roles para tomarlos en QML
    IdRole = Qt.UserRole + 1
    NameRole = Qt.UserRole + 2
    PriceRole = Qt.UserRole + 3
    QuantityRole = Qt.UserRole + 4
    CategoryIdRole = Qt.UserRole + 5
    CategoryNameRole = Qt.UserRole + 6

    totalChanged = Signal()
    
    def __init__(self):
        super().__init__()
        self._items = []
        
        self.db = DataBase()
        
    def rowCount(self, parent=QModelIndex()):
        return len(self._items)
    
    def data(self, index, role):
        if not index.isValid():
            return None

        item = self._items[index.row()]
        
        if role == self.IdRole:
            return item["Id"]
        
        if role == self.NameRole:
            return item["Name"]
        
        if role == self.PriceRole:
            return item["Price"]
        
        if role == self.QuantityRole:
            return item["Quantity"]
        
        if role == self.CategoryIdRole:
            return item["category_id"]
        
        if role == self.CategoryNameRole:
            return item["category_name"]

        return None
    
    def roleNames(self):
        return {
            self.IdRole: QByteArray(b"Id"),
            self.NameRole: QByteArray(b"Name"),
            self.PriceRole: QByteArray(b"Price"),
            self.QuantityRole: QByteArray(b"Quantity"),
            self.CategoryIdRole: QByteArray(b"category_id"),
            self.CategoryNameRole: QByteArray(b"category_name"),
        }
    
    def getTotal(self):
        """
        Función que se encarga de tomar el total del pedido. 
        Suma el precio de cada ítem y lo multiplica por la cantidad de ítems tomados.
        """
        return sum(item.get("Price", 0) * item.get("Quantity", 0) for item in self._items)
    
    total = Property(float, getTotal, notify=totalChanged)
    
    @Slot(str, int, str, str, float)
    def addProduct(self, product_id, category_id, category_name, name, price):
        """
        Función que se encarga de añadir los productos. 
        Itera con un for en _items[], si encuentra que el Id es el mismo que de algún producto,
        lo suma a la cantidad y emite una señal para que cambie en vivo en QML.
        Luego de eso inserta las filas correspondientes y los items son agregados.
        """
        for row, item in enumerate(self._items):
            if item["Id"] == product_id:
                item["Quantity"] += 1
                
                index = self.index(row)
                self.dataChanged.emit(index, index, [self.QuantityRole])
                
                self.totalChanged.emit()
                return
        
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        
        self._items.append({
            "Id": product_id,
            "CategoryId": category_id,
            "CategoryName": category_name,
            "Name": name,
            "Price": price,
            "Quantity": 1,
        })
        self.endInsertRows()
        
        self.totalChanged.emit()
    
    @Slot(int)
    def removeProduct(self, row):
        if 0 <= row < len(self._items):
            self.beginRemoveRows(QModelIndex(), row, row)
            self._items.pop(row)
            self.endRemoveRows()
            self.totalChanged.emit()

    @Slot()
    def confirmOrder(self):
        if not self._items:
            return
        
        total = self.total
        items_to_save = []
        
        for item in self._items:
            items_to_save.append({
                "item_id": item["Id"],
                "item_type": "product",
                "category_id": item["CategoryId"],
                "category_name": item["CategoryName"],
                "name": item["Name"],
                "unit_price": item["Price"],
                "quantity": item["Quantity"]
            })
        
        self.db.insert_order(items_to_save, total)
        
        self.clear()

    @Slot()
    def clear(self):
        self.beginResetModel()
        self._items.clear()
        self.endResetModel()
        self.totalChanged.emit()