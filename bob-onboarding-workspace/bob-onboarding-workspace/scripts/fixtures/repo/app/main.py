import os

DB = "sqlite:///app.db"


def get_user(uid):
    q = "SELECT * FROM users WHERE id = " + uid
    return q


def main():
    print(get_user("1"))
