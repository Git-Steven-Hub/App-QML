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
        self.orders_id = {}
        
        self.count_EnCurso = 0
        self.count_Completado = 0
        self.count_Cancelado = 0
        
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
        self.orders_id.clear()
        
        self.count_EnCurso = 0
        self.count_Completado = 0
        self.count_Cancelado = 0
        
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
            self.orders_id[order["orderId"]] = order
            
            self.increment_counts(order["Status"])
            
        self.endResetModel()
        
    def increment_counts(self, status):
        """
        Función que se encarga de incrementar los contadores de cada estado.
        """
        if status == "En curso":
            self.count_EnCurso += 1
        
        elif status == "Completado":
            self.count_Completado += 1
            
        elif status == "Cancelado":
            self.count_Cancelado += 1
            
    def decrement_counts(self, status):
        """
        Función que se encarga de decrementar los contadores de cada estado.
        """
        if status == "En curso":
            self.count_EnCurso -= 1
        
        elif status == "Completado":
            self.count_Completado -= 1
            
        elif status == "Cancelado":
            self.count_Cancelado -= 1
        
    def get_order_index(self, order_id):
        """
        Función que se encarga en buscar el índice de la orden por ID - 0(1)
        """
        order = self.orders_id.get(order_id)
        
        if order is None:
            return -1
        
        return self.orders.index(order)

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
        order = self.orders_id.get(order_id)
        
        if order is None:
            return
        
        old_status = order["Status"]
        row = self.orders.index(order)
        
        order["Status"] = "Completado"
        self.db.update_status(order_id, "Completado")
        
        self.decrement_counts(old_status)
        self.increment_counts("Completado")
        
        self.dataChanged.emit(
            self.index(row, 0),
            self.index(row, 0),
            [self.StatusRole]
        )
                
        self.countsChanged.emit()

    @Slot(int)
    def cancelOrder(self, order_id):
        """
        Función que se encarga de cancelar la orden.
        Actualiza el estado, los contadores y emite la señal para QML.
        """
        order = self.orders_id.get(order_id)
        
        if order is None:
            return
        
        old_status = order["Status"]
        row = self.orders.index(order)
        
        order["Status"] = "Cancelado"
        self.db.update_status(order_id, "Cancelado")
        
        self.decrement_counts(old_status)
        self.increment_counts("Cancelado")
        
        self.dataChanged.emit(
            self.index(row, 0),
            self.index(row, 0),
            [self.StatusRole]
        )

        self.countsChanged.emit()

    def getEnCursoCount(self):
        return self.count_EnCurso
    
    def getCompletadoCount(self):
        return self.count_Completado
    
    def getCanceladoCount(self):
        return self.count_Cancelado
    
    def getTotalCount(self):
        return len(self.orders)
    
    enCursoCount = Property(int, getEnCursoCount, notify=countsChanged)
    completadoCount = Property(int, getCompletadoCount, notify=countsChanged)
    canceladoCount = Property(int, getCanceladoCount, notify=countsChanged)
    totalCount = Property(int, getTotalCount, notify=countsChanged)

    @Slot(result=int)
    def totalDay(self):
        return sum(o["Total"] for o in self.orders if o["Status"] != "Cancelado")