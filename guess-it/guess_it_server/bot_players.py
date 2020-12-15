import webbrowser
from time import sleep

def get(url):
    try:
        webbrowser.open(url)
    except:
        pass

def get_all():
    get('http://localhost:8081/get-messages/eduardo')
    get('http://localhost:8081/get-messages/daniel')
    get('http://localhost:8081/get-messages/ponte')
    get('http://localhost:8081/get-messages/pedro')

def players():
    
    get('http://localhost:8081/get-messages/eduardo')
    sleep(2)
    get_all()
    sleep(5)
    get('http://localhost:8081/new-message/{"nickname": "eduardo", "message": "Something you can code or program"}')
    
    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "daniel", "message": "progrm"}')
    
    get_all()
    sleep(2)
    get('http://localhost:8081/new-message/{"nickname": "ponte", "message": "program"}')
    
    get_all()
    sleep(4)
    get('http://localhost:8081/new-message/{"nickname": "pedro", "message": "softwre"}')

    get_all()
    sleep(2)
    get('http://localhost:8081/new-message/{"nickname": "pedro", "message": "software"}')
    
    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "daniel", "message": "ahhh stupid"}')
    
    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "daniel", "message": "software"}')

    get_all()
    sleep(1)
    get('http://localhost:8081/new-message/{"nickname": "paulo", "message": "gotta goo cya"}')

    get_all()
    sleep(2)
    get('http://localhost:8081/new-message/{"nickname": "ponte", "message": "softwr"}')

    get_all()
    sleep(1)
    get('http://localhost:8081/new-message/{"nickname": "ponte", "message": "software"}')

    get_all()
    sleep(4)
    get_all()
    sleep(3)
    get_all()
    sleep(1)
    get('http://localhost:8081/new-message/{"nickname": "ponte", "message": "ready for another rouuuund"}')
    sleep(1)
    get('http://localhost:8081/new-message/{"nickname": "daniel", "message": "lets goo"}')
    sleep(1)
    get('http://localhost:8081/new-message/{"nickname": "pedro", "message": "A growing framework"}')
    sleep(1)
    get('http://localhost:8081/new-message/{"nickname": "pedro", "message": "An amazing library"}')

    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "daniel", "message": "what"}')

    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "pedro", "message": "For building apps"}')

    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "eduardo", "message": "adnroid"}')

    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "ponte", "message": "flutter"}')

    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "daniel", "message": "flutter"}')

    get_all()
    sleep(3)
    get('http://localhost:8081/new-message/{"nickname": "eduardo", "message": "dont know"}')

    get_all()
    sleep(1)
    get('http://localhost:8081/new-message/{"nickname": "eduardo", "message": "feup"}')

    get_all()
    sleep(1)
    get('http://localhost:8081/new-message/{"nickname": "eduardo", "message": "cant get it"}')

players()