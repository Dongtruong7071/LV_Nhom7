from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_admin
from models import Category as CategoryModel
from schemas import Category as CategorySchema, CategoryCreate
from typing import List

router = APIRouter(prefix="/categories", tags=["categories"])

@router.post("/", response_model=CategorySchema)
def create_category(category: CategoryCreate, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    db_category = CategoryModel(**category.dict())
    db.add(db_category)
    db.commit()
    db.refresh(db_category)
    return db_category

@router.get("/", response_model=List[CategorySchema])
def read_categories(db: Session = Depends(get_db)):
    return db.query(CategoryModel).all()

@router.get("/{category_id}", response_model=CategorySchema)
def read_category(category_id: int, db: Session = Depends(get_db)):
    category = db.query(CategoryModel).filter(CategoryModel.id == category_id).first()
    if not category:
        raise HTTPException(404, "Category not found")
    return category

@router.put("/{category_id}", response_model=CategorySchema)
def update_category(category_id: int, category: CategoryCreate, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    db_category = db.query(CategoryModel).filter(CategoryModel.id == category_id).first()
    if not db_category:
        raise HTTPException(404, "Category not found")
    for key, value in category.dict().items():
        setattr(db_category, key, value)
    db.commit()
    db.refresh(db_category)
    return db_category

@router.delete("/{category_id}")
def delete_category(category_id: int, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    category = db.query(CategoryModel).filter(CategoryModel.id == category_id).first()
    if not category:
        raise HTTPException(404, "Category not found")
    db.delete(category)
    db.commit()
    return {"message": "Category deleted"}