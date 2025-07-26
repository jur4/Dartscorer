-- H2 Database Schema for Dart Scorer Application

-- Spieler Tabelle
CREATE TABLE players (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Spiele Tabelle
CREATE TABLE games (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    player1_id BIGINT NOT NULL,
    player2_id BIGINT,
    game_type VARCHAR(50) NOT NULL, -- 'X01', 'CRICKET', 'BOBS27'
    game_mode VARCHAR(50) NOT NULL, -- 'WITH_ENEMY', 'WITHOUT_ENEMY', 'VS_BOT'
    start_score INT NOT NULL,
    target_legs INT DEFAULT 0,
    target_sets INT DEFAULT 0,
    double_in BOOLEAN DEFAULT FALSE,
    double_out BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'IN_PROGRESS', -- 'IN_PROGRESS', 'FINISHED', 'ABORTED'
    winner_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP,
    FOREIGN KEY (player1_id) REFERENCES players(id),
    FOREIGN KEY (player2_id) REFERENCES players(id),
    FOREIGN KEY (winner_id) REFERENCES players(id)
);

-- Spielstand Tabelle (für laufende Spiele)
CREATE TABLE game_state (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_id BIGINT NOT NULL UNIQUE,
    player1_score INT NOT NULL,
    player2_score INT NOT NULL,
    player1_legs INT DEFAULT 0,
    player2_legs INT DEFAULT 0,
    player1_sets INT DEFAULT 0,
    player2_sets INT DEFAULT 0,
    current_player VARCHAR(20) NOT NULL, -- 'PLAYER1', 'PLAYER2'
    round_number INT DEFAULT 1,
    player1_darts_thrown INT DEFAULT 0,
    player2_darts_thrown INT DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
);

-- Würfe Tabelle (jeder einzelne Wurf)
CREATE TABLE throws (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_id BIGINT NOT NULL,
    player_id BIGINT NOT NULL,
    round_number INT NOT NULL,
    throw_number INT NOT NULL, -- 1, 2, 3 (within round)
    score INT NOT NULL,
    multiplier INT DEFAULT 1, -- 1=Single, 2=Double, 3=Triple
    segment INT, -- 1-20, 25 (Bull)
    is_bust BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players(id)
);

-- Runden Tabelle (3 Würfe = 1 Runde)
CREATE TABLE rounds (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_id BIGINT NOT NULL,
    player_id BIGINT NOT NULL,
    round_number INT NOT NULL,
    total_score INT NOT NULL,
    remaining_score_before INT NOT NULL,
    remaining_score_after INT NOT NULL,
    is_finish BOOLEAN DEFAULT FALSE,
    is_bust BOOLEAN DEFAULT FALSE,
    darts_used INT DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players(id),
    UNIQUE(game_id, player_id, round_number)
);

-- Spiel-Statistiken Tabelle
CREATE TABLE game_statistics (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    game_id BIGINT NOT NULL,
    player_id BIGINT NOT NULL,
    total_score INT DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0.00,
    highest_finish INT DEFAULT 0,
    total_180s INT DEFAULT 0,
    total_140s INT DEFAULT 0,
    total_100s INT DEFAULT 0,
    total_rounds INT DEFAULT 0,
    total_darts INT DEFAULT 0,
    doubles_hit INT DEFAULT 0,
    doubles_missed INT DEFAULT 0,
    legs_won INT DEFAULT 0,
    sets_won INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players(id),
    UNIQUE(game_id, player_id)
);

-- Gesamt-Statistiken View für jeden Spieler
CREATE VIEW player_overall_statistics AS
SELECT 
    p.id as player_id,
    p.name as player_name,
    COUNT(DISTINCT g.id) as total_games,
    COUNT(DISTINCT CASE WHEN g.winner_id = p.id THEN g.id END) as games_won,
    COUNT(DISTINCT CASE WHEN g.winner_id != p.id AND g.status = 'FINISHED' THEN g.id END) as games_lost,
    COALESCE(AVG(gs.average_score), 0) as overall_average,
    COALESCE(MAX(gs.highest_finish), 0) as best_finish,
    COALESCE(SUM(gs.total_180s), 0) as total_180s,
    COALESCE(SUM(gs.total_140s), 0) as total_140s,
    COALESCE(SUM(gs.total_100s), 0) as total_100s,
    COALESCE(SUM(gs.legs_won), 0) as total_legs_won,
    COALESCE(SUM(gs.sets_won), 0) as total_sets_won,
    COALESCE(SUM(gs.total_darts), 0) as total_darts_thrown
FROM players p
LEFT JOIN games g ON (p.id = g.player1_id OR p.id = g.player2_id)
LEFT JOIN game_statistics gs ON g.id = gs.game_id AND p.id = gs.player_id
WHERE p.is_active = TRUE
GROUP BY p.id, p.name;

-- Index für bessere Performance
CREATE INDEX idx_games_player1 ON games(player1_id);
CREATE INDEX idx_games_player2 ON games(player2_id);
CREATE INDEX idx_games_status ON games(status);
CREATE INDEX idx_throws_game_player ON throws(game_id, player_id);
CREATE INDEX idx_rounds_game_player ON rounds(game_id, player_id);
CREATE INDEX idx_game_statistics_player ON game_statistics(player_id);

-- Trigger um updated_at automatisch zu setzen (für H2 entfernt, da JPA @PreUpdate verwendet wird)