from database.database_manager import DataBase
from PySide6.QtCore import Qt, QAbstractListModel, QModelIndex, QByteArray, Signal, Property, Slot

class SalesModel(QAbstractListModel):
    
    countsChanged = Signal()

    #Roles para tomarlos en QML
    OrderIdRole = Qt.UserRole + 1
    TimeRole = Qt.UserRole + 2
    ClientNameRole = Qt.UserRole + 3
    ClientPhoneRole = Qt.UserRole + 4
    PaymentMethodRole = Qt.UserRole + 5
    TotalRole = Qt.UserRole + 6
    StatusRole = Qt.UserRole + 7

    def __init__(self):
        super().__init__()

        self.db = DataBase()

        self.orders = []
        self.load_orders()

    @Slot()
    def load_orders(self):
        """
        Función que se encarga de cargar las ordenes en sus filas correspondientes.
        Se comienza con un reseteo de modelo y una limpieza de la lista orders[],
        con un for se asigna su fila para luego ser agregado nuevamente a la lista orders[].
        """
        self.beginResetModel()
        self.orders.clear()
        
        rows = self.db.get_orders()
        
        for row in rows: 
            order = {
                "orderId": row[0],
                "Time": row[1],
                "ClientName": row[2],
                "ClientPhone": row[3],
                "PaymentMethod": row[4],
                "Total": row[5],
                "Status": row[6]
            }
            self.orders.append(order)
            
        self.endResetModel()

    def rowCount(self, parent=QModelIndex()):
        if parent.isValid():
            return 0
        return len(self.orders)

    def data(self, index, role):
        if not index.isValid():
            return None

        order = self.orders[index.row()]

        if role == self.OrderIdRole:
            return order["orderId"]
        
        if role == self.TimeRole:
            return order["Time"]
        
        if role == self.ClientNameRole:
            return order["ClientName"]
        
        if role == self.ClientPhoneRole:
            return order["ClientPhone"]
        
        if role == self.PaymentMethodRole:
            return order["PaymentMethod"]
        
        if role == self.TotalRole:
            return order["Total"]
        
        if role == self.StatusRole:
            return order["Status"]

        return None

    def roleNames(self):
        """
        Función que se encarga de transformar los nombres en números para que QML los pueda leer.
        """
        return {
            self.OrderIdRole: QByteArray(b"orderId"),
            self.TimeRole: QByteArray(b"Time"),
            self.ClientNameRole: QByteArray(b"ClientName"),
            self.ClientPhoneRole: QByteArray(b"ClientPhone"),
            self.PaymentMethodRole: QByteArray(b"PaymentMethod"),
            self.TotalRole: QByteArray(b"Total"),
            self.StatusRole: QByteArray(b"Status"),
        }

    @Slot(int)
    def completeOrder(self, order_id):
        """
        Función que se encarga de completar la orden mediante un for.
        Itera en la lista orders[] y si en el apartado del "Status" dice "Completado",
        se emite la orden para actualizarlo en vivo en QML.
        """
        for row, order in enumerate(self.orders):
            if order["orderId"] == order_id:
                order["Status"] = "Completado"
                
                self.db.update_status(order_id, "Completado")
                
                self.dataChanged.emit(
                    self.index(row, 0),
                    self.index(row, 0),
                    [self.StatusRole]
                )
                break
        self.countsChanged.emit()

    @Slot(int)
    def cancelOrder(self, order_id):
        """
        Función que se encarga de cancelar la orden mediante un for.
        Itera en la lista orders[] y si en el apartado del "Status" dice "Cancelado",
        se emite la orden para actualizarlo en vivo en QML.
        """
        for row, order in enumerate(self.orders):
            if order["orderId"] == order_id:
                order["Status"] = "Cancelado"
                
                self.db.update_status(order_id, "Cancelado")
                
                self.dataChanged.emit(
                    self.index(row, 0),
                    self.index(row, 0),
                    [self.StatusRole]
                )
                break
        self.countsChanged.emit()

    def getEnCursoCount(self):
        return sum(1 for o in self.orders if o["Status"] == "En curso")
    
    def getCompletadoCount(self):
        return sum(1 for o in self.orders if o["Status"] == "Completado")
    
    def getCanceladoCount(self):
        return sum(1 for o in self.orders if o["Status"] == "Cancelado")
    
    def getTotalCount(self):
        return len(self.orders)
    
    enCursoCount = Property(int, getEnCursoCount, notify=countsChanged)
    completadoCount = Property(int, getCompletadoCount, notify=countsChanged)
    canceladoCount = Property(int, getCanceladoCount, notify=countsChanged)
    totalCount = Property(int, getTotalCount, notify=countsChanged)

    @Slot(result=int)
    def totalDay(self):
        return sum(o["Total"] for o in self.orders)