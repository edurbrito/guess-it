# coding: utf-8
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import CheckConstraint, Column, Date, ForeignKey, Integer, String, UniqueConstraint, text
from sqlalchemy.orm import relationship
from sqlalchemy.sql.sqltypes import NullType
from sqlalchemy.ext.declarative import declarative_base

db = SQLAlchemy()
Base = declarative_base()
metadata = Base.metadata

class AdminCode(db.Model, Base):
    __tablename__ = 'AdminCode'

    code = Column(Integer, primary_key=True)


class Schedule(db.Model, Base):
    __tablename__ = 'Schedule'
    __table_args__ = (
        CheckConstraint("dateHour IS strftime('%Y-%m-%d %H:%M', dateHour)"),
        CheckConstraint("dateHourEnd IS strftime('%Y-%m-%d %H:%M', dateHourEnd)"),
    )

    id = Column(Integer, primary_key=True)
    dateHour = Column(String(50), nullable=False)
    dateHourEnd = Column(String(50), nullable=False)
    duration = Column(Integer, nullable=False, server_default=text("10"))


class GuessItSession(db.Model, Base):
    __tablename__ = 'GuessItSession'

    id = Column(Integer, primary_key=True)
    schedule = Column(ForeignKey('Schedule.id'), nullable=False)

    Schedule = relationship('Schedule')


class GameRound(db.Model, Base):
    __tablename__ = 'GameRound'

    id = Column(Integer, primary_key=True)
    time = Column(String(50), nullable=False)
    points = Column(Integer, server_default=text("0"))
    word = Column(String(50), nullable=False)
    shadow_word = Column(String(50), nullable=False)
    guessItSession = Column(ForeignKey('GuessItSession.id'), nullable=False)

    GuessItSession = relationship('GuessItSession')

    def addPoints(self, points):
        self.points = points


class Definition(db.Model, Base):
    __tablename__ = 'Definition'
    __table_args__ = (
        UniqueConstraint('definition', 'gameRound'),
    )

    id = Column(Integer, primary_key=True)
    definition = Column(String(100))
    gameRound = Column(ForeignKey('GameRound.id'), nullable=False)

    GameRound = relationship('GameRound')

    def definitions():
        definitions = db.session.query(Definition, GameRound).filter(Definition.gameRound == GameRound.id).order_by(text("points desc")).all()
        return [ {'word' : g.word, 'definition' : d.definition} for (d,g) in definitions]

class Player(db.Model, Base):
    __tablename__ = 'Player'
    __table_args__ = (
        CheckConstraint("points >= 0"),
    )

    nickname = Column(String(100), primary_key=True)
    points = Column(Integer, server_default=text("0"))

    def addPoints(self):
        self.points += 1

    def leaderboard():
        players = Player.query.order_by(text("points desc"))
        return [ {'nickname' : p.nickname, 'points' : p.points} for p in players]
