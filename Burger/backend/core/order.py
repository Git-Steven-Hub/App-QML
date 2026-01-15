from typing import List
from order_item import OrderItem
from product import Product

class Order:
    def __init__(self):
        self.items: List(OrderItem) = []
        self.status: str = "open"
        
    def add_product(self, product: Product):
        for item in self.items:
            if item.product.id == product.id:
                item.increase()
                return
            
        self.items.append(OrderItem(product))
        
    def remove_product(self, product_id: int):
        self.items = [
            item for item in self.items
            if item.product.id != product_id
        ]
    
    def clear(self):
        self.items.clear()
        
    @property
    def total(self) -> float:
        return sum(item.subtotal for item in self.items)
    
    def pay(self):
        if not self.items:
            raise ValueError("No se puede pagar un pedido vacío")
        self.status = "paid"
    
    def cancel(self):
        self.status = "cancelled"