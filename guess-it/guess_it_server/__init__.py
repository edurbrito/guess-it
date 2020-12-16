
import json
from random import randint
from datetime import datetime, timedelta
from difflib import SequenceMatcher

from flask import Flask, render_template, request
from extensions import db, AdminCode, Schedule, GuessItSession, GameRound, Definition, Player, text

class Worker():

    def __init__(self, db):  
        self.db = db

        self.messages = []          
        for j in range(25):
            self.messages.append("")
        self.currentMessage = 0

        self.players = []

        self.words = []
        self.currentWord = 0
        self.lastWord = 0
        self.currentDefinition = [""]
        self.currentPoints = [0]
        self.active = 1
            
    def setWords(self, words):
        self.words = words

    def addWord(self, word):
        self.words.append(word)

    def addPlayer(self, player):
        self.players.append(player)

    def addPoints(self):
        self.currentPoints.append(1)

    def getLeader(self):
        return self.players[self.currentWord % len(self.players)]

    def addMessage(self, msg):
        self.messages[self.currentMessage % 25] = msg
        self.currentMessage += 1

    def setDefinition(self, definition):
        self.currentDefinition.append(definition)

    def getCurrentWord(self):
        return self.words[self.currentWord].word.replace(" ", "").lower()

    def getCurrentState(self, nickname):
        try:
            time = datetime.now().strftime("%Y-%m-%d %H:%M")
            schedule = Schedule.query.filter(Schedule.dateHourEnd >= time).order_by(text("dateHour desc")).first()
            session = GuessItSession.query.filter(GuessItSession.Schedule == schedule).one()
            if schedule != None and session != None:
                self.active = 1
                if schedule.dateHour > time or len(self.players) == 0: 
                    self.currentWord = 0
                    return "Next session starts at " + schedule.dateHour

                self.words = GameRound.query.filter(GameRound.GuessItSession == session)
                
                found = False
                for i in range(self.words.count()):
                    if self.words[i].time > time:
                        if i > 0 and self.words[i - 1].time <= time:
                            self.currentWord = i
                            if self.currentWord != self.lastWord:
                                self.words[self.lastWord].addPoints(sum(self.currentPoints))
                                definition = Definition.query.filter(Definition.GameRound == self.words[self.lastWord]).one()
                                definition.definition = ", ".join(self.currentDefinition[1:])
                                if(definition.definition != ""):
                                    db.session.commit()
                                self.currentDefinition = [""]
                                self.currentPoints = [0]
                                self.lastWord = self.currentWord
                                self.messages = []          
                                for j in range(25):
                                    self.messages.append("")
                                self.currentMessage = 0
                        found = True
                        break
                
                if not found: 
                    if self.active:
                        self.words[self.currentWord].addPoints(sum(self.currentPoints))
                        definition = Definition.query.filter(Definition.GameRound == self.words[self.currentWord]).one()
                        definition.definition = ", ".join(self.currentDefinition[1:])
                        if(definition.definition != ""):
                            db.session.commit()
                        self.currentDefinition = [""]
                        self.currentPoints = [0]
                    self.messages = []          
                    for j in range(25):
                        self.messages.append("")
                    self.currentMessage = 0
                    self.active = 0
                    self.words = []
                    self.currentWord = 0
                    self.lastWord = 0
                    return "Session has ended"

                if nickname == self.getLeader():
                    return json.dumps({"leader": True, "leaderName": self.getLeader(), "definition" : self.currentDefinition[len(self.currentDefinition) - 1], "word" : self.words[self.currentWord].word, "messages": self.messages})
                else:
                    return json.dumps({"leader": False, "leaderName": self.getLeader(), "definition" : self.currentDefinition[len(self.currentDefinition) - 1], "word" : self.words[self.currentWord].shadow_word, "messages": self.messages})

            else:
                self.messages = []          
                for j in range(25):
                    self.messages.append("")
                self.currentMessage = 0
                self.words = []
                self.currentWord = 0
                self.lastWord = 0
                self.active = 0
                return "No sessions coming"
        except Exception as e:
            self.messages = []          
            for j in range(25):
                self.messages.append("")
            self.currentMessage = 0
            self.words = []
            self.currentWord = 0
            self.lastWord = 0
            self.active = 0
            return "No sessions coming"
        

def create_app(config_file="settings.py"):
    app = Flask(__name__)
    app.config.from_pyfile(config_file)

    def getShadowWord(word):
        nrands = len(word) // 3
        temp_word = ['_' for i in word]
        for i in range(0, nrands):
            while(True):
                nrand = randint(0, len(word) - 1)
                if temp_word[nrand] == '_':
                    temp_word[nrand] = word[nrand]
                    break
        return "".join(temp_word)

    @app.route('/')
    def home_page():
        return 'Server \'{}\' active at {}'.format(app.config.get('FLASK_APP', ''), str(datetime.now()))

    @app.route('/ping')
    def pong():
        return 'pong'

    db.init_app(app)
    worker = Worker(db)

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
            now = datetime.now().strftime("%Y-%m-%d %H:%M")

            # if dateHour <= now: 
            #     raise Exception()

            duration = _session.get('duration')
            _words = _session.get('words')
            word_time = int(duration/len(_words))

            dateHourEnd = str(datetime.strptime(
                dateHour, "%Y-%m-%d %H:%M") + timedelta(seconds=(word_time + duration)*60 + 10 * len(_words)))
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

            i = 1

            for word in _words:
                time = str(datetime.strptime(
                dateHour, "%Y-%m-%d %H:%M") + timedelta(seconds=i*word_time*60 + 10))
                time = time[0:len(time) - 3]

                gameRound = GameRound(
                    time=time, word=word, shadow_word=getShadowWord(word), GuessItSession=guessItSession)
                definition = Definition(definition=None, GameRound=gameRound)
                db.session.add(gameRound)
                db.session.add(definition)
                i += 1

            db.session.commit()
            return "success"
        except Exception as e:
            print(e)
            return "fail"

    @app.route('/new-player/<nickname>')
    def new_player(nickname):
        try:
            player = Player(nickname=nickname)
            worker.addPlayer(player.nickname)
            db.session.add(player)
            db.session.commit()
            return 'success'
        except:
            return 'fail'

    @app.route('/new-message/<message>')
    def new_message(message):
        try:
            if not worker.active:
                raise Exception("Worker not active")

            # {"nickname": "nicknameeeee", "message": "messageeee"}
            _message = json.loads(message)
            nickname = _message.get('nickname')
            msg = _message.get('message')
            
            player = Player.query.filter_by(nickname=nickname).first()
            if player is None:
                raise Exception("Player not exists")
            
            if nickname != worker.getLeader():
                if msg == worker.words[worker.currentWord].word or worker.getCurrentWord() in msg.replace(" ", "").lower():
                    msg = "YOU GOT IT!!"
                    player.addPoints()
                    worker.addPoints()
                else:
                    ratio = SequenceMatcher(a=worker.getCurrentWord(),b=msg.replace(" ", "").lower()).ratio()
                    if ratio > 0.95:
                        msg = "YOU GOT IT!!"
                        player.addPoints()
                        worker.addPoints()
                    elif ratio > 0.7:
                        msg = "YOU ARE CLOSE!!"

                worker.addMessage({"nickname" : nickname + ': ', "msg" : msg})
                db.session.commit()
            else:
                ratio = SequenceMatcher(a=worker.getCurrentWord(),b=msg.replace(" ", "").lower()).ratio()
                if msg == worker.getCurrentWord() or worker.getCurrentWord() in msg.replace(" ", "").lower() or ratio > 0.7:
                    raise Exception("Leader cannot say the word")
                
                worker.setDefinition(msg)                     

            return msg

        except Exception as e:
            print(e)
            return "fail"
    
    @app.route('/get-messages/<nickname>')
    def get_messages(nickname):
        return worker.getCurrentState(nickname)
    
    @app.route('/get-leaderboard')
    def get_leaderboard():
        return json.dumps(Player.leaderboard())

    @app.route('/get-definitions')
    def get_definitions():
        return json.dumps(Definition.definitions())
        
    # Adding some data to the database when the server inits
    with app.app_context():
        try:
            db.drop_all()
            db.create_all()

            code1 = AdminCode(code=12345)

            p1 = Player(nickname="eduardo")
            p2 = Player(nickname="pedro")
            p3 = Player(nickname="paulo")
            p4 = Player(nickname="ponte")
            p5 = Player(nickname="daniel")

            worker.addPlayer(p1.nickname)
            worker.addPlayer(p2.nickname)
            worker.addPlayer(p3.nickname)
            worker.addPlayer(p4.nickname)
            worker.addPlayer(p5.nickname)
            time = str(datetime.strptime(datetime.now().strftime("%Y-%m-%d %H:%M"), "%Y-%m-%d %H:%M") + timedelta(seconds=10))
            time = time[0:len(time) - 3]

            new_game_session('{"dateHour": "' + time  + '", "duration": 3, "words": ["software", "flutter", "agile"]}')

            db.session.add(code1)
            db.session.add(p1)
            db.session.add(p2)
            db.session.add(p3)
            db.session.add(p4)
            db.session.add(p5)
            db.session.commit()

        except Exception as e:
            print(e, "on init")

    return app