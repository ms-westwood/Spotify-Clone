from models.base import Base
from sqlalchemy import Column, TEXT, ForeignKey
from sqlalchemy.orm import relationship

class Favorite(Base):
    __tablename__ = "favorites"
    
    id = Column(TEXT, primary_key=True)
    song_id = Column(TEXT, ForeignKey("songs.id"))
    user_id = Column(TEXT, ForeignKey("users.id"))
    
    # link to Song
    song = relationship("Song", back_populates="favorites")  