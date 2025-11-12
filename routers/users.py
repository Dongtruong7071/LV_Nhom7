from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from dependencies import get_db, get_current_admin
from models import User as UserModel
from schemas import User as UserSchema, UserCreate, UserUpdate, UserRoleUpdate
from typing import List
from firebase_admin import auth as firebase_auth

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/", response_model=List[UserSchema])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    return db.query(UserModel).offset(skip).limit(limit).all()

@router.get("/{user_id}", response_model=UserSchema)
def read_user(user_id: int, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if not user:
        raise HTTPException(404, "User not found")
    return user

@router.put("/{user_id}", response_model=UserSchema)
def update_user(user_id: int, user_data: UserUpdate, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if not user:
        raise HTTPException(404, "User not found")
    for key, value in user_data.dict().items():
        setattr(user, key, value)
    db.commit()
    db.refresh(user)
    return user

@router.delete("/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db), admin = Depends(get_current_admin)):
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if not user:
        raise HTTPException(404, "User not found")
    db.delete(user)
    db.commit()
    return {"message": "User deleted"}

@router.post("/", response_model=UserSchema)
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    existing_user = db.query(UserModel).filter(UserModel.firebase_uid == user.firebase_uid).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User with this Firebase UID already exists")

    db_user = UserModel(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@router.post("/set-role", response_model=dict)
def set_role(
    user_role: UserRoleUpdate,
    admin = Depends(get_current_admin)
):
    try:
        firebase_auth.set_custom_user_claims(user_role.uid, {"role": user_role.role})
        return {"success": True, "uid": user_role.uid, "role": user_role.role}
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to set role: {str(e)}")