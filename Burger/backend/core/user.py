from dataclasses import dataclass

@dataclass
class User:
    username: str
    role: str
    
    @property
    def is_admin(self) -> bool:
        return self.role == "admin"