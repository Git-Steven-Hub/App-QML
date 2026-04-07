from PySide6.QtCore import QSortFilterProxyModel, Slot, Property, Signal

class SalesFilterProxyModel(QSortFilterProxyModel):
    
    totalChanged = Signal()
    
    def __init__(self):
        super().__init__()
        
        self.status_filter = "Todos"
        self.cached_total = 0
        self.cache_valid = False
        
        
        self.dataChanged.connect(self.invalidate_cache)
        self.rowsInserted.connect(self.invalidate_cache)
        self.rowsRemoved.connect(self.invalidate_cache)
        self.modelReset.connect(self.invalidate_cache)
        
    def invalidate_cache(self):
        self.cache_valid = False
        self.totalChanged.emit()
        
    def recalculate_total(self):
        total = 0
        
        for row in range(self.rowCount()):
            idx = self.index(row, 0)
            status = self.data(idx, self.sourceModel().StatusRole)
            amount = self.data(idx, self.sourceModel().TotalRole)
            
            if status != "Cancelado":
                total += amount
        
        self.cached_total = total
        self.cache_valid = True
                
    @Slot(str)
    def setStatusFilter(self, status):
        """
        Función que se encarga de aplicar el estado en vivo en QML.
        """
        self.status_filter = status
        self.invalidateFilter()
        self.totalChanged.emit()
        
    def getTotalFiltered(self):
        """
        Función que se encarga de filtar el total de los pedidos excluyendo los que están cancelados.
        Itera con un for entre las filas y mientras que sean diferentes al estado "Cancelado",
        se suman para dar el total del día.
        """
        if not self.cache_valid:
            self.recalculate_total()
            
        return self.cached_total
        
    totalFiltered = Property(int, getTotalFiltered, notify=totalChanged)
        
    def filterAcceptsRow(self, source_row, source_parent):
        if self.status_filter == "Todos":
            return True
        
        index = self.sourceModel().index(source_row, 0, source_parent)
        status = self.sourceModel().data(index, self.sourceModel().StatusRole)
        
        return status == self.status_filter