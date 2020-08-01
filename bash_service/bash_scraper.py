import requests
import re
from functools import lru_cache

_JOKE = re.compile(r"#\d+\s.+?\n%", re.MULTILINE | re.DOTALL)
_JOKE_PARSER = re.compile(
    r"^#(?P<number>\d+)\s\((?P<url>.+?)\)\n(?P<content>.+)\n%$",
    re.MULTILINE | re.DOTALL
)


class BashScraper:
    def __init__(self):
        self.url = "http://bash.org.pl/text"

    @lru_cache
    def get_raw_jokes(self):
        res = requests.get(self.url)
        res.raise_for_status()
        return res.text

    def list_of_jokes(self, count=100):
        jokes = self.parsed(self.get_raw_jokes())
        return jokes[:count]

    @staticmethod
    def parsed(raw_jokes):
        jokes = []
        for joke in _JOKE.finditer(raw_jokes):
            jokes.append(_JOKE_PARSER.search(joke.group()).groupdict())
        return jokes
