from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_admin
from models import Brand as BrandModel
from schemas import Brand as BrandSchema, BrandCreate, BrandUpdate
from typing import List

router = APIRouter(prefix="/brands", tags=["brands"])

@router.post("/", response_model=BrandSchema)
def create_brand(brand: BrandCreate, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    db_brand = BrandModel(**brand.dict())
    db.add(db_brand)
    db.commit()
    db.refresh(db_brand)
    return db_brand

@router.get("/", response_model=List[BrandSchema])
def read_brands(db: Session = Depends(get_db)):
    return db.query(BrandModel).all()

@router.get("/{brand_id}", response_model=BrandSchema)
def read_brand(brand_id: int, db: Session = Depends(get_db)):
    brand = db.query(BrandModel).filter(BrandModel.id == brand_id).first()
    if not brand:
        raise HTTPException(404, "Brand not found")
    return brand

@router.put("/{brand_id}", response_model=BrandSchema)
def update_brand(brand_id: int, brand: BrandUpdate, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    db_brand = db.query(BrandModel).filter(BrandModel.id == brand_id).first()
    if not db_brand:
        raise HTTPException(404, "Brand not found")
    for key, value in brand.dict().items():
        setattr(db_brand, key, value)
    db.commit()
    db.refresh(db_brand)
    return db_brand

@router.delete("/{brand_id}")
def delete_brand(brand_id: int, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    brand = db.query(BrandModel).filter(BrandModel.id == brand_id).first()
    if not brand:
        raise HTTPException(404, "Brand not found")
    db.delete(brand)
    db.commit()
    return {"message": "Brand deleted"}