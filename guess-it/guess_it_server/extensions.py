# coding: utf-8
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Column, Integer
from sqlalchemy.ext.declarative import declarative_base

db = SQLAlchemy()
Base = declarative_base()
metadata = Base.metadata


class AdminCode(db.Model, Base):
    __tablename__ = 'AdminCode'

    code = Column(Integer, primary_key=True)

    def as_dict(self):
        return {"code" : self.code }

