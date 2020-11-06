
import json
from datetime import datetime

from flask import Flask, render_template


def create_app(config_file="settings.py"):
    app = Flask(__name__)
    app.config.from_pyfile(config_file)

    @app.route('/')
    def home_page():
        return 'Server \'{}\' active at {}'.format(app.config.get('FLASK_APP', ''), str(datetime.now()))

    @app.route('/ping')
    def pong():
        return 'pong'

    from extensions import db, AdminCode, Schedule, GuessItSession, GameRound

    db.init_app(app)

    with app.app_context():
        try:
            db.drop_all()
            db.create_all()

            code1 = AdminCode(code=12345)

            db.session.add(code1)
            db.session.commit()

        except Exception as e:
            print(e, "on init")

    @app.route('/admin-code/<code>')
    def admin_code(code):
        adminCode = AdminCode.query.filter_by(code=code).first()
        if adminCode is not None:
            return "success"
        else:
            return "fail"

    @app.route('/new-game-session/<session>')
    def new_game_session(session):
        try:
            _session = json.loads(session) # {"dateHour": "2020-11-07 22:22", "duration": 10, "words": ["a", "b"]}

            duration = _session.get('duration')
            word_time = int(duration/len(_session.get('words')))
            schedule = Schedule(dateHour=_session.get('dateHour'), duration=duration)
            guessItSession = GuessItSession(Schedule=schedule)

            db.session.add(schedule)
            db.session.add(guessItSession)

            for word in _session.get('words'):
                gameRound = GameRound(time=word_time, word=word, GuessItSession=guessItSession)
                db.session.add(gameRound)
            
            db.session.commit()
            return "success"
        except Exception as e:
            return "fail"

    @app.route('/admin-words/<words>')
    def admin_words(words):
        try:
            _words = json.loads(words)
            if isinstance(_words, list):
                return "success"
            else:
                return "fail"
        except:
            return "fail"

    return app
