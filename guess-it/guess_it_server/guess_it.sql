PRAGMA FOREIGN_KEYS = ON;

CREATE TABLE AdminCode (
    code INTEGER,
    CONSTRAINT codePK PRIMARY KEY (code)
);

CREATE TABLE Schedule (
    id INTEGER,
    dateHour VARCHAR(50) NOT NULL,
    duration INTEGER NOT NULL DEFAULT 10,

    CONSTRAINT schedulePK PRIMARY KEY (id),
    CONSTRAINT scheduleFormat CHECK (dateHour IS strftime('%Y-%m-%d %H:%M', dateHour))
);

CREATE TABLE GuessItSession (
    id INTEGER PRIMARY KEY,
    schedule INTEGER NOT NULL,

    CONSTRAINT GuessItSessionSchedule FOREIGN KEY (schedule) REFERENCES Schedule ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE GameRound (
    id INTEGER PRIMARY KEY,
    time INTEGER NOT NULL,
    points INTEGER DEFAULT 0,
    word VARCHAR(50) NOT NULL,
    guessItSession INTEGER NOT NULL,

    CONSTRAINT guessItSessionFK FOREIGN KEY(guessItSession) REFERENCES GuessItSession ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Definitions(
    id INTEGER PRIMARY KEY,
    definition VARCHAR(100),
    gameRound INTEGER NOT NULL,

    CONSTRAINT definitionFK FOREIGN KEY(gameRound) REFERENCES GameRound ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uniqueDefinition UNIQUE(definition, gameRound)
);