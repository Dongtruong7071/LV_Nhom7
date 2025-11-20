from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from dependencies import get_db, get_current_admin
from models import ProductVariant as VariantModel, Product as ProductModel
from schemas import (
    ProductVariant as VariantSchema,
    ProductVariantCreate,
    ProductVariantUpdate
)

router = APIRouter(prefix="/variants", tags=["product_variants"])


@router.post("/", response_model=VariantSchema)
def create_variant(
    variant: ProductVariantCreate,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
):
    product = db.query(ProductModel).filter(ProductModel.id == variant.product_id).first()
    if not product:
        raise HTTPException(404, "Product not found")

    db_variant = VariantModel(**variant.dict())
    db.add(db_variant)
    db.commit()
    db.refresh(db_variant)
    return db_variant


@router.get("/", response_model=List[VariantSchema])
def read_variants(
    product_id: int = None,
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db)
):
    query = db.query(VariantModel)
    if product_id:
        query = query.filter(VariantModel.product_id == product_id)
    return query.offset(skip).limit(limit).all()


@router.get("/{variant_id}", response_model=VariantSchema)
def read_variant(variant_id: int, db: Session = Depends(get_db)):
    variant = db.query(VariantModel).filter(VariantModel.id == variant_id).first()
    if not variant:
        raise HTTPException(404, "Variant not found")
    return variant


@router.put("/{variant_id}", response_model=VariantSchema)

def update_variant(
    variant_id: int,
    variant: ProductVariantUpdate,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
):
    db_variant = db.query(VariantModel).filter(VariantModel.id == variant_id).first()
    if not db_variant:
        raise HTTPException(404, "Variant not found")

    update_data = variant.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_variant, key, value)

    db.commit()
    db.refresh(db_variant)
    return db_variant


@router.delete("/{variant_id}")
def delete_variant(
    variant_id: int,
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
):
    variant = db.query(VariantModel).filter(VariantModel.id == variant_id).first()
    if not variant:
        raise HTTPException(404, "Variant not found")

    db.delete(variant)
    db.commit()
    return {"message": "Variant deleted"}