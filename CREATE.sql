CREATE TABLE member (
    id          VARCHAR PRIMARY KEY NOT NULL,
    member_id   VARCHAR NOT NULL UNIQUE,
    image_url   VARCHAR NOT NULL,
    is_admin    INTEGER DEFAULT 0,
    created_at  DATETIME DEFAULT (DATETIME('now','localtime'))
);
------------------------
CREATE TABLE checklist (
    id             INTEGER PRIMARY KEY NOT NULL,
    circle_id      VARCHAR NOT NULL,
    member_id      VARCHAR NOT NULL,
    count          INTEGER NOT NULL,
    comment        VARCHAR,
    created_at     DATETIME DEFAULT (DATETIME('now','localtime')),
    UNIQUE(circle_id,member_id)
);
------------------------
CREATE TABLE circle (
    id            VARCHAR PRIMARY KEY NOT NULL,
    comiket_no    VARCHAR NOT NULL,
    circle_name   VARCHAR NOT NULL,
    circle_author VARCHAR NOT NULL,
    day           VARCHAR NOT NULL,
    area          VARCHAR NOT NULL,
    circle_sym    VARCHAR NOT NULL,
    circle_num    VARCHAR NOT NULL,
    circle_flag   VARCHAR NOT NULL,
    circlems      VARCHAR NOT NULL,
    url           VARCHAR NOT NULL,
    comment       VARCHAR,
    serialized    VARCHAR NOT NULL
);

CREATE INDEX IDX_circle_comiket_no  ON circle(comiket_no);
CREATE INDEX IDX_circle_day         ON circle(day);
CREATE INDEX IDX_circle_area        ON circle(area);
CREATE INDEX IDX_circle_circle_sym  ON circle(circle_sym);
------------------------
CREATE TABLE action_log (
    id          INTEGER PRIMARY KEY,
    circle_id   INTEGER,
    message_id  VARCHAR NOT NULL,
    parameters  VARCHAR NOT NULL,
    created_at  DATETIME DEFAULT (DATETIME('now','localtime'))
);

CREATE INDEX IDX_action_log_circle_id ON action_log(circle_id);
------------------------
CREATE TABLE assign_list (
    id          INTEGER PRIMARY KEY,
    name        VARCHAR NOT NULL,
    member_id   VARCHAR,
    comiket_no  VARCHAR NOT NULL,
    created_at  DATETIME DEFAULT (DATETIME('now','localtime')),
    UNIQUE(member_id,comiket_no)
);
------------------------
CREATE TABLE assign (
    id              INTEGER PRIMARY KEY,
    circle_id       VARCHAR NOT NULL,
    assign_list_id  INTEGER NOT NULL,
    created_at  DATETIME DEFAULT (DATETIME('now','localtime'))
);
