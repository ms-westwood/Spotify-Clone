from fastapi import APIRouter, UploadFile, File, Form, Depends
from middleware.auth_middleware import auth_middleware
from sqlalchemy.orm import Session
from database import get_db
import cloudinary
import cloudinary.uploader
import uuid
import os
from models.song import Song
from dotenv import load_dotenv


load_dotenv()


router = APIRouter()

cloudinary.config(
    cloud_name=os.getenv("CLOUDINARY_NAME"),
    api_key=os.getenv("CLOUDINARY_KEY"),
    api_secret=os.getenv("CLOUDINARY_SECRET"),
    secure = True    
)

@router.post('/upload', status_code=201)
def upload_song(song: UploadFile = File(...),
                 thumbnail: UploadFile = File(...), 
                 artist: str = Form(...), 
                 song_name: str = Form(...), 
                 hex_code: str = Form(...),
                 db: Session = Depends(get_db),
                 auth_dict = Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}')
    print(song_res)
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}')
    
    new_song = Song(id=song_id, song_name=song_name, artist=artist, hex_code=hex_code, song_url=song_res['secure_url'], thumbnail_url=thumbnail_res['secure_url'])
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song
