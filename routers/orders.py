from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_admin, get_current_user
from models import Order as OrderModel, OrderItem as OrderItemModel
from schemas import Order as OrderSchema, OrderCreate, OrderItem as OrderItemSchema, OrderUpdate
from typing import List

router = APIRouter(prefix="/orders", tags=["orders"])

@router.post("/", response_model=OrderSchema)
def create_order(order: OrderCreate, db: Session = Depends(get_db), user = Depends(get_current_user)):
    db_order = OrderModel(
        user_id=user.id,
        total_amount=order.total_amount,
        status=order.status,
        shipping_address=order.shipping_address
    )
    db.add(db_order)
    db.flush()

    for item in order.items:
        db_item = OrderItemModel(
            order_id=db_order.id,
            product_id=item.product_id,
            quantity=item.quantity,
            price=item.price
        )
        db.add(db_item)
    db.commit()
    db.refresh(db_order)
    return db_order

@router.get("/", response_model=List[OrderSchema])
def read_orders(skip: int = 0, limit: int = 100, status: str = None, db: Session = Depends(get_db), user = Depends(get_current_user)):
    query = db.query(OrderModel)
    if user.role != 'admin':
        query = query.filter(OrderModel.user_id == user.id)
    if status:
        query = query.filter(OrderModel.status == status)
    return query.offset(skip).limit(limit).all()

@router.get("/{order_id}", response_model=OrderSchema)
def read_order(order_id: int, db: Session = Depends(get_db), user = Depends(get_current_user)):
    order = db.query(OrderModel).filter(OrderModel.id == order_id).first()
    if not order:
        raise HTTPException(404, "Order not found")
    if user.role != 'admin' and order.user_id != user.id:
        raise HTTPException(403, "Not authorized")
    return order



@router.put("/{order_id}", response_model=OrderSchema)
def update_order(
    order_id: int,
    order_update: OrderUpdate,
    db: Session = Depends(get_db),
    admin = Depends(get_current_admin)
):
    order = db.query(OrderModel).filter(OrderModel.id == order_id).first()
    if not order:
        raise HTTPException(404, "Order not found")

    update_data = order_update.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(order, key, value)

    db.commit()
    db.refresh(order)
    return order
