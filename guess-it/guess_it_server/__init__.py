
from json import loads, dumps
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

    from extensions import db, AdminCode

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

    return app
