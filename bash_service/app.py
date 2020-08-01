from flask import Flask
from flask_restful import Resource, Api

from .bash_scraper import BashScraper

app = Flask(__name__)
api = Api(app)

bash = BashScraper()


class Jokes(Resource):
    def get(self):
        return bash.list_of_jokes()


api.add_resource(Jokes, "/")
