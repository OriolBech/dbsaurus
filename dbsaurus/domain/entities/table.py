from dataclasses import dataclass
from typing import List, Optional

@dataclass
class Column:
    name: str
    data_type: str
    is_nullable: bool
    is_primary: bool
    default_value: Optional[str]

@dataclass
class Table:
    name: str
    columns: List[Column]
    
    @property
    def primary_key(self) -> Optional[str]:
        primary_columns = [col.name for col in self.columns if col.is_primary]
        return primary_columns[0] if primary_columns else None 