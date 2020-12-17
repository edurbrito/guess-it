import os
import tempfile
import pytest
from datetime import datetime, timedelta

from __init__ import create_app
app = create_app()

@pytest.fixture
def client():
    db_fd, app.config['DATABASE'] = tempfile.mkstemp()
    app.config['TESTING'] = True
    with app.test_client() as client:
        with app.app_context():
            pass
        yield client
    os.close(db_fd)
    os.unlink(app.config['DATABASE'])

def test_ping_pong(client):
    rv = client.get('/ping')
    assert b'pong' in rv.data

def test_server_init(client):
    rv = client.get('/')
    assert 'Server \'{}\' active at'.format(app.config.get('FLASK_APP', '')) in rv.data.decode('utf8')

def test_admin_code(client):
    rv = client.get('/admin-code/12345')
    assert b'success' in rv.data
    rv = client.get('/admin-code/1234')
    assert b'fail' in rv.data
    rv = client.get('/admin-code/1')
    assert b'fail' in rv.data
    rv = client.get('/admin-code/ahasghags')
    assert b'fail' in rv.data

def test_new_game_session(client):
    time = str(datetime.strptime(datetime.now().strftime("%Y-%m-%d %H:%M"), "%Y-%m-%d %H:%M") + timedelta(seconds=10))
    time = time[0:len(time) - 3]

    rv = client.get('/new-game-session/' + '{"dateHour": "' + time  + '", "duration": 2, "words": ["albertina", "b"]}')
    assert b'fail' in rv.data

def test_new_player(client):
    rv = client.get("/new-player/pedro")
    assert b'fail' in rv.data
    rv = client.get("/new-player/eduardo")
    assert b'fail' in rv.data
    rv = client.get("/new-player/joaquim")
    assert b'success' in rv.data

def test_get_messages(client):
    rv = client.get("/get-messages/pedro")
    assert b'{"leader": false, "leaderName": "eduardo", "definition": "", "word":' in rv.data
    assert b'"messages": ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]}' in rv.data
    rv = client.get("/get-messages/eduardo")
    assert b'{"leader": true, "leaderName": "eduardo", "definition": "", "word": "software", "messages": ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]}' in rv.data
    rv = client.get("/get-messages/manel")
    assert b'{"leader": false, "leaderName": "eduardo", "definition": "", "word":' in rv.data
    assert b'"messages": ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]}' in rv.data

def test_new_message(client):
    rv = client.get('/new-message/{"nickname": "nicknameeeee", "message": "messageeee"}')
    assert b'fail' in rv.data
    rv = client.get('/new-message/{"nickname": "eduardo", "message": "messageeee"}')
    assert b'messageeee' in rv.data
    rv = client.get('/new-message/{"nickname": "pedro", "message": "messageeee"}')
    assert b'messageeee' in rv.data
    rv = client.get('/new-message/{"nickname": "pedro", "message": "software"}')
    assert b'YOU GOT IT!!' in rv.data
    rv = client.get('/new-message/{"nickname": "joaquim", "message": "sodtwre"}')
    assert b'YOU ARE CLOSE!!' in rv.data

    rv = client.get("/get-messages/pedro")
    assert b'{"leader": false, "leaderName": "eduardo", "definition": "messageeee",' in rv.data

def test_leaderboard(client):
    rv = client.get("/get-leaderboard")
    assert b'[{"nickname": "pedro", "points": 1}, {"nickname": "eduardo", "points": 0}, {"nickname": "paulo", "points": 0}, {"nickname": "ponte", "points": 0}, {"nickname": "daniel", "points": 0}, {"nickname": "joaquim", "points": 0}]' in rv.data

def test_get_definitions(client):
    rv = client.get("/get-definitions")
    assert b'[{"word": "software", "definition": null}, {"word": "flutter", "definition": null}, {"word": "agile", "definition": null}]' in rv.data

