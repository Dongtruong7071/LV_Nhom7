from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_admin
from models import OrderItem as OrderItemModel
from schemas import OrderItem as OrderItemSchema
from typing import List

router = APIRouter(prefix="/order-items", tags=["order-items"])

# Lấy tất cả order items hoặc theo order_id
@router.get("/", response_model=List[OrderItemSchema])
def read_all_order_items(db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    return db.query(OrderItemModel).all()

# Lấy order items theo order_id
@router.get("/{order_id}", response_model=List[OrderItemSchema])
def read_order_items(order_id: int, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    return db.query(OrderItemModel).filter(OrderItemModel.order_id == order_id).all()
