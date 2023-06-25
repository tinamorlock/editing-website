import os

from flask import Flask

# FLASK_APP = 'tinamarie'

def create_app(test_config=None):

    # creates and configures the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
        DATABASE=os.path.join(app.instance_path, 'tinamarie.sqlite'),
    )

    if test_config is None:

        # loads the instance config if it exists when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:

            # loads the test config if passed in
            app.config.from_mapping(test_config)

    # ensures the instance folder exists

    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # for testing: a simple page that says hello

    @app.route('/hello')
    def hello():
        return 'Hello, World!'

    from . import db
    db.init_app(app)

    from . import auth
    app.register_blueprint(auth.bp)

    return app
