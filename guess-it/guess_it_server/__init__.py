
import json
from datetime import datetime, timedelta
from difflib import SequenceMatcher

from flask import Flask, render_template, request

class Worker():

    def __init__(self):  
        self.messages = []          
        for j in range(25):
            self.messages.append("")
        self.currentMessage = 0

        self.players = []
        self.leader = "eduardo"

        self.words = []
        self.currentWord = 0
        self.currentDefinition = ""
        
        self.timer = None
    
    def addMessage(self, msg):
        self.messages[self.currentMessage % 25] = msg
        self.currentMessage += 1

    def setDefinition(self, definition):
        self.currentDefinition = definition

    def getCurrentWord(self):
        return self.words[self.currentWord].replace(" ", "").lower()

def create_app(config_file="settings.py"):
    app = Flask(__name__)
    app.config.from_pyfile(config_file)

    worker = Worker()
    worker.words = ['merda','bosta']

    @app.route('/')
    def home_page():
        return 'Server \'{}\' active at {}'.format(app.config.get('FLASK_APP', ''), str(datetime.now()))

    @app.route('/ping')
    def pong():
        return 'pong'

    from extensions import db, AdminCode, Schedule, GuessItSession, GameRound, Definition, Player

    db.init_app(app)

    with app.app_context():
        try:
            db.drop_all()
            db.create_all()

            code1 = AdminCode(code=12345)

            p1 = Player(nickname="eduardo")
            p2 = Player(nickname="pedro")

            db.session.add(code1)
            db.session.add(p1)
            db.session.add(p2)
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
            # {"dateHour": "2020-11-07 22:22", "duration": 10, "words": ["a", "b"]}
            _session = json.loads(session)
            dateHour = _session.get('dateHour')
            duration = _session.get('duration')
            _words = _session.get('words')
            word_time = int(duration/len(_words))

            dateHourEnd = str(datetime.strptime(
                dateHour, "%Y-%m-%d %H:%M") + timedelta(seconds=duration*60))
            dateHourEnd = dateHourEnd[0:len(dateHourEnd) - 3]

            unavailable = Schedule.query.all()
            for u in unavailable:
                if not(u.dateHour > dateHourEnd or u.dateHourEnd < dateHour):
                    raise Exception()

            if not isinstance(_words, list):
                raise Exception()

            schedule = Schedule(dateHour=dateHour,
                                duration=duration, dateHourEnd=dateHourEnd)
            guessItSession = GuessItSession(Schedule=schedule)

            db.session.add(schedule)
            db.session.add(guessItSession)

            for word in _words:
                gameRound = GameRound(
                    time=word_time, word=word, GuessItSession=guessItSession)
                definition = Definition(definition=None, GameRound=gameRound)
                db.session.add(gameRound)
                db.session.add(definition)

            db.session.commit()
            return "success"
        except Exception as e:
            print(e)
            return "fail"

    @app.route('/new-player/<nickname>')
    def new_player(nickname):
        try:
            player = Player(nickname=nickname)
            db.session.add(player)
            db.session.commit()
            return 'success'
        except:
            return 'fail'

    @app.route('/new-message/<message>')
    def new_message(message):
        try:
            # {"nickname": "nicknameeeee", "message": "messageeee"}
            _message = json.loads(message)
            nickname = _message.get('nickname')
            msg = _message.get('message')
            
            player = Player.query.filter_by(nickname=nickname).first()
            if player is None:
                raise Exception()
            
            if nickname != worker.leader:
                if msg == worker.currentWord or worker.getCurrentWord() in msg.replace(" ", "").lower():
                    msg = "YOU GOT IT!!"
                    player.addPoints()
                else:
                    ratio = SequenceMatcher(a=worker.getCurrentWord(),b=msg.replace(" ", "").lower()).ratio()
                    if ratio > 0.95:
                        msg = "YOU GOT IT!!"
                        player.addPoints()
                    elif ratio > 0.7:
                        msg = "YOU ARE CLOSE!!"

                worker.addMessage(nickname + " : " + msg)
                db.session.commit()
            else:
                ratio = SequenceMatcher(a=worker.getCurrentWord(),b=msg.replace(" ", "").lower()).ratio()
                if msg == worker.getCurrentWord() or worker.getCurrentWord() in msg.replace(" ", "").lower() or ratio > 0.7:
                    raise Exception()
                
                worker.setDefinition(msg)                     

            return json.dumps({'success': msg})

        except Exception as e:
            print(e)
            return "fail"
    
    @app.route('/get-messages/<nickname>')
    def get_messages(nickname):

        # if worker.timer == None:
        #     worker.timer = 3
        #     return "Next Session at "
        
        # timer -= 1
        if nickname == worker.leader:
            return json.dumps({"leader": True, "word" : worker.words[worker.currentWord], "messages": worker.messages})
        else:
            return json.dumps({"leader": False, "definitions" : worker.currentDefinition, "messages": worker.messages})
    
    return app