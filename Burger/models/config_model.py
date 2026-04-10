import json
import logging
from pathlib import Path
from PySide6.QtCore import QObject, Signal, Property, Slot

class ConfigModel(QObject):
    
    logger = logging.getLogger("ConfigModel")
    configChanged = Signal()
    
    def __init__(self):
        super().__init__()
        
        try:
            self.config_path = Path(__file__).resolve().parent.parent / "data" / "config.json"
            with open(self.config_path, "r", encoding="utf-8") as f:
                self.config = json.load(f)
            
            self.configChanged.emit()    
            
        except Exception as e:
            self.logger.error(f"Error al cargar configuración: {e}")
            self.config = {"business" : {"name" : "", "close_time" : "21:00", "delivery_fee" : 0}}
    
    def get_info(self):
        return self.config.get("business", {})
    
    def get_business_name(self):
        return self.get_info().get("name", "")
    
    def get_close_time(self):
        return self.get_info().get("close_time", "")
    
    def get_delivery_fee(self):
        return self.get_info().get("delivery_fee", 0)
    
    @Slot(str, str, str)
    def save_info(self, name, close_time, delivery_fee):
        try:
            delivery_fee = float(delivery_fee) if delivery_fee else 0
            
            self.config["business"] = {
                "name": name,
                "close_time": close_time,
                "delivery_fee": delivery_fee
            }
            
            with open(self.config_path, "w", encoding="utf-8") as f:
                json.dump(self.config, f, indent=4)
                
            self.configChanged.emit()
                
        except Exception as e:
            self.logger.error(f"Error al guardar configuración: {e}")
            
    def set_business_name(self, name):
        self.save_info(name, self.get_close_time(), self.get_delivery_fee())
    
    def set_close_time(self, close_time):
        self.save_info(self.get_business_name(), close_time, self.get_delivery_fee())
        
    def set_delivery_fee(self, delivery_fee):
        self.save_info(self.get_business_name(), self.get_close_time(), delivery_fee)
            
    businessName = Property(str, get_business_name, notify=configChanged)
    closeTime = Property(str, get_close_time, notify=configChanged)
    deliveryFee = Property(int, get_delivery_fee, notify=configChanged)