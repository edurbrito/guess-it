import webbrowser
from time import sleep

def get(url):
    try:
        webbrowser.open(url)
    except:
        pass

def get_all():
    get('http://0.0.0.0:8081/get-messages/eduardo')
    get('http://0.0.0.0:8081/get-messages/daniel')
    get('http://0.0.0.0:8081/get-messages/ponte')
    get('http://0.0.0.0:8081/get-messages/pedro')

def players():
    
    get('http://0.0.0.0:8081/get-messages/eduardo')
    sleep(2)
    get_all()
    sleep(5)
    get('http://0.0.0.0:8081/new-message/{"nickname": "eduardo", "message": "Something you can code or program"}')
    
    get_all()
    sleep(10)
    get('http://0.0.0.0:8081/new-message/{"nickname": "daniel", "message": "progrm"}')
    
    get_all()
    sleep(2)
    get('http://0.0.0.0:8081/new-message/{"nickname": "ponte", "message": "program"}')
    
    get_all()
    sleep(6)
    get('http://0.0.0.0:8081/new-message/{"nickname": "pedro", "message": "softwre"}')

    get_all()
    sleep(2)
    get('http://0.0.0.0:8081/new-message/{"nickname": "pedro", "message": "software"}')
    
    get_all()
    sleep(5)
    get('http://0.0.0.0:8081/new-message/{"nickname": "daniel", "message": "ahhh stupid"}')
    
    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "daniel", "message": "software"}')

    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "ponte", "message": "softwr"}')

    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "ponte", "message": "software"}')

    get_all()
    sleep(10)
    get('http://0.0.0.0:8081/new-message/{"nickname": "pedro", "message": "A growing framework"}')

    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "daniel", "message": "what"}')

    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "pedro", "message": "For building apps"}')

    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "eduardo", "message": "adnroid"}')

    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "ponte", "message": "flutter"}')

    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "daniel", "message": "flutter"}')

    get_all()
    sleep(3)
    get('http://0.0.0.0:8081/new-message/{"nickname": "eduardo", "message": "dont know"}')

players()