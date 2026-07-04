from dataclasses import dataclass


@dataclass
class EtfMaster:
    code: str
    name: str
    market: str
    category: str
    sub_category: str = ""
    is_broad: int = 0
    is_theme: int = 0
    is_qdii: int = 0
    is_bond: int = 0
    is_money: int = 0
    status: str = "active"
    updated_at: str = ""

