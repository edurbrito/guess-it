
from json import loads, dumps
from datetime import datetime

from flask import Flask, render_template


def create_app(config_file="settings.py"):
    app = Flask(__name__)
    app.config.from_pyfile(config_file)

    @app.route('/')
    def home_page():
        return 'Server \'{}\' active at {}'.format(app.config.get('FLASK_APP',''),str(datetime.now()))

    @app.route('/ping')
    def pong():
        return 'pong'

    return app
