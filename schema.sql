-- ============================================================
--  WAXHAUS — Music Store Database
--  schema.sql
--
--  How to run this file:
--    sqlite3 store.db < schema.sql
--
--  Tables:
--    albums     — one row per album (title, artist, genre…)
--    inventory  — one row per (album + format) combo with price & stock
--    orders     — one row per checkout (customer name, total)
--    order_items — one row per item inside an order
-- ============================================================


-- ── 1. DROP OLD TABLES (so we can re-run this file cleanly) ──────────────────

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS albums;


-- ── 2. CREATE TABLES ──────────────────────────────────────────────────────────

-- albums: stores general info about each album
CREATE TABLE albums (
  id      INTEGER PRIMARY KEY,   -- unique number for each album
  title   TEXT    NOT NULL,      -- album name
  artist  TEXT    NOT NULL,      -- artist / band name
  genre   TEXT    NOT NULL,      -- e.g. Rock, Jazz, Electronic
  year    INTEGER NOT NULL,      -- release year
  label   TEXT    NOT NULL,      -- record label
  tracks  INTEGER NOT NULL       -- number of tracks
);

-- inventory: stores one row per album+format combination
-- An album can appear up to 3 times (vinyl, cd, digital)
CREATE TABLE inventory (
  id        INTEGER PRIMARY KEY AUTOINCREMENT,
  album_id  INTEGER NOT NULL,             -- links to albums.id
  format    TEXT    NOT NULL              -- 'vinyl', 'cd', or 'digital'
              CHECK (format IN ('vinyl','cd','digital')),
  price     INTEGER NOT NULL,             -- price in Indian Rupees (₹)
  stock     INTEGER NOT NULL DEFAULT 0,   -- how many copies we have

  FOREIGN KEY (album_id) REFERENCES albums(id)
);

-- orders: one row per completed checkout
CREATE TABLE orders (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  customer     TEXT    NOT NULL,          -- customer name
  total        INTEGER NOT NULL,          -- total amount paid (₹)
  placed_at    TEXT    DEFAULT (datetime('now'))  -- timestamp
);

-- order_items: every item inside an order
-- An order can have many items (one per album+format)
CREATE TABLE order_items (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  order_id    INTEGER NOT NULL,           -- links to orders.id
  album_id    INTEGER NOT NULL,           -- links to albums.id
  format      TEXT    NOT NULL,
  price       INTEGER NOT NULL,           -- price at time of purchase
  qty         INTEGER NOT NULL DEFAULT 1,

  FOREIGN KEY (order_id)  REFERENCES orders(id),
  FOREIGN KEY (album_id)  REFERENCES albums(id)
);


-- ── 3. INSERT SEED DATA (albums) ─────────────────────────────────────────────

INSERT INTO albums (id, title, artist, genre, year, label, tracks) VALUES
  -- Kanye West
  (13, 'The College Dropout',               'Kanye West',         'Hip-Hop',              2004, 'Roc-A-Fella',        22),
  (14, 'Late Registration',                 'Kanye West',         'Hip-Hop',              2005, 'Roc-A-Fella',        21),
  (15, 'Graduation',                        'Kanye West',         'Hip-Hop',              2007, 'Roc-A-Fella',        13),
  (16, 'My Beautiful Dark Twisted Fantasy', 'Kanye West',         'Hip-Hop',              2010, 'Def Jam',            13),
  -- Common
  (17, 'Be',                                'Common',             'Hip-Hop',              2005, 'GOOD Music',         11),
  -- Madvillain
  (18, 'Madvillainy',                       'Madvillain',         'Hip-Hop',              2004, 'Stones Throw',       22),
  -- Tyler, the Creator
  (19, 'IGOR',                              'Tyler, the Creator', 'Hip-Hop',              2019, 'Columbia',           12),
  -- JPEGMAFIA
  (20, 'I Lay Down My Life for You',        'JPEGMAFIA',          'Experimental Hip-Hop', 2024, 'EQT',                15),
  -- Quadeca
  (21, 'I Didn''t Mean to Haunt You',       'Quadeca',            'Indie Hip-Hop',         2022, 'Independent',       14),
  (22, 'Vanisher: Horizon Scraper',         'Quadeca',            'Indie Hip-Hop',         2024, 'Independent',       12),
  (23, 'Scrapyard',                         'Quadeca',            'Indie Hip-Hop',         2024, 'Independent',       11),
  -- Justice
  (24, '† (Cross)',                         'Justice',            'Electronic',            2007, 'Ed Banger',         11),
  (25, 'Hyperdrama',                        'Justice',            'Electronic',            2024, 'Ed Banger',         12),
  -- The Weeknd
  (26, 'House of Balloons',                 'The Weeknd',         'R&B',                  2011, 'XO',                  9),
  (27, 'Dawn FM',                           'The Weeknd',         'R&B',                  2022, 'XO / Republic',      16),
  (28, 'Hurry Up Tomorrow',                 'The Weeknd',         'R&B',                  2025, 'XO / Republic',      22),
  -- Magdalena Bay
  (29, 'Imaginal Disk',                     'Magdalena Bay',      'Synth-Pop',            2024, 'Neon Gold',          17),
  -- Tame Impala
  (30, 'Lonerism',                          'Tame Impala',        'Psychedelic Rock',      2012, 'Modular',           13),
  (31, 'Currents',                          'Tame Impala',        'Psychedelic Pop',       2015, 'Modular',           13),
  -- Sampha
  (32, 'Process',                           'Sampha',             'Soul',                  2017, 'Young Turks',       11),
  -- Kendrick Lamar
  (33, 'Mr. Morale & The Big Steppers',     'Kendrick Lamar',     'Hip-Hop',              2022, 'pgLang / Aftermath', 18),
  (34, 'GNX',                               'Kendrick Lamar',     'Hip-Hop',              2024, 'pgLang',             12),
  -- James Blake
  (35, 'Trying Times',                      'James Blake',        'Electronic Soul',       2024, 'Republic',          10),
  -- Daft Punk
  (36, 'Discovery',                         'Daft Punk',          'Electronic',            2001, 'Virgin',            14),
  (37, 'Random Access Memories',            'Daft Punk',          'Electronic',            2013, 'Columbia',          13);


-- ── 4. INSERT SEED DATA (inventory) ──────────────────────────────────────────

INSERT INTO inventory (album_id, format, price, stock) VALUES
  -- Kanye West — vinyl + CD + digital
  (13, 'vinyl',   3299,  8),
  (14, 'vinyl',   3499,  6),
  (15, 'vinyl',   3299,  9),
  (16, 'vinyl',   3799,  5),
  (13, 'cd',       799, 20),
  (14, 'cd',       799, 18),
  (15, 'cd',       799, 22),
  (16, 'cd',       899, 14),
  (13, 'digital',  299, 999),
  (14, 'digital',  299, 999),
  (15, 'digital',  299, 999),
  (16, 'digital',  349, 999),
  -- Common — vinyl + CD + digital
  (17, 'vinyl',   2799,  7),
  (17, 'cd',       749, 15),
  (17, 'digital',  249, 999),
  -- Madvillain — vinyl + CD + digital
  (18, 'vinyl',   3999,  4),
  (18, 'cd',       999, 10),
  (18, 'digital',  299, 999),
  -- Tyler IGOR — vinyl + digital (CD rare)
  (19, 'vinyl',   3299,  7),
  (19, 'digital',  299, 999),
  -- JPEGMAFIA — digital only
  (20, 'digital',  199, 999),
  -- Quadeca — digital only
  (21, 'digital',  199, 999),
  (22, 'digital',  199, 999),
  (23, 'digital',  149, 999),
  -- Justice — vinyl + digital
  (24, 'vinyl',   3499,  6),
  (24, 'digital',  249, 999),
  (25, 'vinyl',   2999, 10),
  (25, 'digital',  249, 999),
  -- The Weeknd House of Balloons — vinyl + digital
  (26, 'vinyl',   3799,  4),
  (26, 'digital',  199, 999),
  -- The Weeknd Dawn FM — vinyl + digital
  (27, 'vinyl',   2999,  9),
  (27, 'digital',  249, 999),
  -- The Weeknd Hurry Up Tomorrow — vinyl + digital
  (28, 'vinyl',   3299, 11),
  (28, 'digital',  299, 999),
  -- Magdalena Bay — vinyl + digital
  (29, 'vinyl',   2999,  8),
  (29, 'digital',  199, 999),
  -- Tame Impala — vinyl + digital
  (30, 'vinyl',   3299,  7),
  (30, 'digital',  249, 999),
  (31, 'vinyl',   3299,  9),
  (31, 'digital',  249, 999),
  -- Sampha — vinyl + digital
  (32, 'vinyl',   2799,  6),
  (32, 'digital',  199, 999),
  -- Kendrick MMATS — vinyl + digital
  (33, 'vinyl',   3499,  5),
  (33, 'digital',  299, 999),
  -- Kendrick GNX — digital only
  (34, 'digital',  299, 999),
  -- James Blake — vinyl + digital
  (35, 'vinyl',   2799,  8),
  (35, 'digital',  199, 999),
  -- Daft Punk Discovery — vinyl + CD + digital
  (36, 'vinyl',   3299,  7),
  (36, 'cd',       849, 18),
  (36, 'digital',  249, 999),
  -- Daft Punk RAM — vinyl + CD + digital
  (37, 'vinyl',   3799,  5),
  (37, 'cd',       999, 12),
  (37, 'digital',  299, 999);


-- ── 5. EXAMPLE QUERIES (for your submission / teacher) ───────────────────────

-- Q1: Show all albums with their vinyl price (JOIN)
SELECT a.title, a.artist, i.price AS vinyl_price
FROM albums a
JOIN inventory i ON i.album_id = a.id
WHERE i.format = 'vinyl'
ORDER BY i.price DESC;

-- Q2: Show the full catalogue (all formats), cheapest first
SELECT a.title, a.artist, a.genre, i.format, i.price
FROM albums a
JOIN inventory i ON i.album_id = a.id
ORDER BY i.price ASC;

-- Q3: Search albums by genre (e.g. Jazz)
SELECT a.title, a.artist, a.year
FROM albums a
WHERE a.genre = 'Jazz';

-- Q4: Count how many items are available per format
SELECT format, COUNT(*) AS num_products, MIN(price) AS cheapest, MAX(price) AS priciest
FROM inventory
GROUP BY format;

-- Q5: Find low-stock vinyl (stock < 10) — important for reordering
SELECT a.title, a.artist, i.stock
FROM albums a
JOIN inventory i ON i.album_id = a.id
WHERE i.format = 'vinyl' AND i.stock < 10
ORDER BY i.stock ASC;

-- Q6: Insert a new order (simulate a checkout)
INSERT INTO orders (customer, total) VALUES ('Priya Sharma', 3748);

-- Q7: Insert the items for that order (order_id = 1) using active inventory keys
INSERT INTO order_items (order_id, album_id, format, price, qty) VALUES
  (1, 13, 'vinyl',   3299, 1),
  (1, 15, 'digital',  299, 1),
  (1, 17, 'digital',  249, 2);

-- Q8: See the full order with album names (JOIN across 3 tables)
SELECT o.customer, a.title, oi.format, oi.price, oi.qty,
       (oi.price * oi.qty) AS line_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN albums a       ON a.id = oi.album_id
WHERE o.id = 1;