from PySide6.QtCore import QObject, Slot

class Backend(QObject):
    @Slot(str)
    def orderBurger(self, name):
        print(f"Pedido recibido: {name}")