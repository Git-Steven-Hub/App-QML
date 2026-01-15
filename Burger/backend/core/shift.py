from datetime import datetime
from order import Order

class Shift:
    def __init__(self):
        self.started_at = datetime.now()
        self.closed_at = None
        self.orders: list[Order] = []
        
    def close(self):
        self.closed_at = datetime.now()
        
    @property
    def total_sales(self) -> float:
        return sum(order.total for order in self.orders if order.status == "paid")