package com.dartverein.controller;

import com.dartverein.model.*;
import com.dartverein.repository.*;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/games")
@CrossOrigin(origins = "*")
public class GameController {

    @Autowired
    private GameRepository gameRepository;
    
    @Autowired
    private PlayerRepository playerRepository;
    
    @Autowired
    private GameStateRepository gameStateRepository;
    
    @Autowired
    private GameStatisticsRepository gameStatisticsRepository;

    @GetMapping
    public List<Game> getAllGames() {
        return gameRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Game> getGameById(@PathVariable Long id) {
        Optional<Game> game = gameRepository.findById(id);
        return game.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/player/{playerId}")
    public List<Game> getGamesByPlayer(@PathVariable Long playerId) {
        Optional<Player> player = playerRepository.findById(playerId);
        if (player.isEmpty()) {
            return List.of();
        }
        return gameRepository.findByPlayer1OrPlayer2OrderByCreatedAtDesc(player.get(), player.get());
    }

    @GetMapping("/active")
    public List<Game> getActiveGames() {
        return gameRepository.findByStatusOrderByCreatedAtDesc(Game.GameStatus.IN_PROGRESS);
    }

    @GetMapping("/player/{playerId}/active")
    public List<Game> getActiveGamesByPlayer(@PathVariable Long playerId) {
        return gameRepository.findActiveGamesByPlayer(playerId);
    }

    @PostMapping
    public ResponseEntity<Game> createGame(@Valid @RequestBody GameCreateRequest request) {
        Optional<Player> player1 = playerRepository.findById(request.getPlayer1Id());
        if (player1.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        Player player2 = null;
        if (request.getPlayer2Id() != null) {
            Optional<Player> optionalPlayer2 = playerRepository.findById(request.getPlayer2Id());
            if (optionalPlayer2.isEmpty()) {
                return ResponseEntity.badRequest().build();
            }
            player2 = optionalPlayer2.get();
        }

        Game game = new Game(player1.get(), player2, request.getGameType(), request.getGameMode(), request.getStartScore());
        game.setTargetLegs(request.getTargetLegs());
        game.setTargetSets(request.getTargetSets());
        game.setDoubleIn(request.getDoubleIn());
        game.setDoubleOut(request.getDoubleOut());

        Game savedGame = gameRepository.save(game);

        GameState gameState = new GameState(savedGame, request.getStartScore());
        gameStateRepository.save(gameState);

        GameStatistics stats1 = new GameStatistics(savedGame, player1.get());
        gameStatisticsRepository.save(stats1);

        if (player2 != null) {
            GameStatistics stats2 = new GameStatistics(savedGame, player2);
            gameStatisticsRepository.save(stats2);
        }

        return ResponseEntity.ok(savedGame);
    }

    @PutMapping("/{id}/finish")
    public ResponseEntity<Game> finishGame(@PathVariable Long id, @RequestBody GameFinishRequest request) {
        Optional<Game> optionalGame = gameRepository.findById(id);
        if (optionalGame.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Game game = optionalGame.get();
        game.setStatus(Game.GameStatus.FINISHED);
        
        if (request.getWinnerId() != null) {
            Optional<Player> winner = playerRepository.findById(request.getWinnerId());
            if (winner.isPresent()) {
                game.setWinner(winner.get());
            }
        }

        Game savedGame = gameRepository.save(game);
        return ResponseEntity.ok(savedGame);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteGame(@PathVariable Long id) {
        if (!gameRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        
        gameRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    public static class GameCreateRequest {
        private Long player1Id;
        private Long player2Id;
        private Game.GameType gameType;
        private Game.GameMode gameMode;
        private Integer startScore;
        private Integer targetLegs = 0;
        private Integer targetSets = 0;
        private Boolean doubleIn = false;
        private Boolean doubleOut = true;

        public Long getPlayer1Id() {
            return player1Id;
        }

        public void setPlayer1Id(Long player1Id) {
            this.player1Id = player1Id;
        }

        public Long getPlayer2Id() {
            return player2Id;
        }

        public void setPlayer2Id(Long player2Id) {
            this.player2Id = player2Id;
        }

        public Game.GameType getGameType() {
            return gameType;
        }

        public void setGameType(Game.GameType gameType) {
            this.gameType = gameType;
        }

        public Game.GameMode getGameMode() {
            return gameMode;
        }

        public void setGameMode(Game.GameMode gameMode) {
            this.gameMode = gameMode;
        }

        public Integer getStartScore() {
            return startScore;
        }

        public void setStartScore(Integer startScore) {
            this.startScore = startScore;
        }

        public Integer getTargetLegs() {
            return targetLegs;
        }

        public void setTargetLegs(Integer targetLegs) {
            this.targetLegs = targetLegs;
        }

        public Integer getTargetSets() {
            return targetSets;
        }

        public void setTargetSets(Integer targetSets) {
            this.targetSets = targetSets;
        }

        public Boolean getDoubleIn() {
            return doubleIn;
        }

        public void setDoubleIn(Boolean doubleIn) {
            this.doubleIn = doubleIn;
        }

        public Boolean getDoubleOut() {
            return doubleOut;
        }

        public void setDoubleOut(Boolean doubleOut) {
            this.doubleOut = doubleOut;
        }
    }

    public static class GameFinishRequest {
        private Long winnerId;

        public Long getWinnerId() {
            return winnerId;
        }

        public void setWinnerId(Long winnerId) {
            this.winnerId = winnerId;
        }
    }
}