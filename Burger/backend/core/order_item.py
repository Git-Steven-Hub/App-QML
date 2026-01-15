from dataclasses import dataclass
from product import Product

@dataclass
class OrderItem:
    product: Product
    quantity: int = 1
    
    @property
    def subtotal(self) -> float:
        return self.product.price * self.quantity
    
    def increase(self, amount: int = 1):
        self.quantity += amount
    
    def decrease(self, amount: int = 1):
        self.quantity = max(0, self.quantity - amount)