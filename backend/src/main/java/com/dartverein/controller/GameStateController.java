package com.dartverein.controller;

import com.dartverein.model.GameState;
import com.dartverein.repository.GameStateRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/gamestate")
@CrossOrigin(origins = "*")
public class GameStateController {

    @Autowired
    private GameStateRepository gameStateRepository;

    @GetMapping("/game/{gameId}")
    public ResponseEntity<GameState> getGameStateByGameId(@PathVariable Long gameId) {
        Optional<GameState> gameState = gameStateRepository.findByGameId(gameId);
        return gameState.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/game/{gameId}")
    public ResponseEntity<GameState> updateGameState(@PathVariable Long gameId, @Valid @RequestBody GameStateUpdateRequest request) {
        Optional<GameState> optionalGameState = gameStateRepository.findByGameId(gameId);
        if (optionalGameState.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        GameState gameState = optionalGameState.get();
        
        if (request.getPlayer1Score() != null) {
            gameState.setPlayer1Score(request.getPlayer1Score());
        }
        if (request.getPlayer2Score() != null) {
            gameState.setPlayer2Score(request.getPlayer2Score());
        }
        if (request.getPlayer1Legs() != null) {
            gameState.setPlayer1Legs(request.getPlayer1Legs());
        }
        if (request.getPlayer2Legs() != null) {
            gameState.setPlayer2Legs(request.getPlayer2Legs());
        }
        if (request.getPlayer1Sets() != null) {
            gameState.setPlayer1Sets(request.getPlayer1Sets());
        }
        if (request.getPlayer2Sets() != null) {
            gameState.setPlayer2Sets(request.getPlayer2Sets());
        }
        if (request.getCurrentPlayer() != null) {
            gameState.setCurrentPlayer(request.getCurrentPlayer());
        }
        if (request.getRoundNumber() != null) {
            gameState.setRoundNumber(request.getRoundNumber());
        }
        if (request.getPlayer1DartsThrown() != null) {
            gameState.setPlayer1DartsThrown(request.getPlayer1DartsThrown());
        }
        if (request.getPlayer2DartsThrown() != null) {
            gameState.setPlayer2DartsThrown(request.getPlayer2DartsThrown());
        }

        GameState savedGameState = gameStateRepository.save(gameState);
        return ResponseEntity.ok(savedGameState);
    }

    public static class GameStateUpdateRequest {
        private Integer player1Score;
        private Integer player2Score;
        private Integer player1Legs;
        private Integer player2Legs;
        private Integer player1Sets;
        private Integer player2Sets;
        private GameState.CurrentPlayer currentPlayer;
        private Integer roundNumber;
        private Integer player1DartsThrown;
        private Integer player2DartsThrown;

        public Integer getPlayer1Score() {
            return player1Score;
        }

        public void setPlayer1Score(Integer player1Score) {
            this.player1Score = player1Score;
        }

        public Integer getPlayer2Score() {
            return player2Score;
        }

        public void setPlayer2Score(Integer player2Score) {
            this.player2Score = player2Score;
        }

        public Integer getPlayer1Legs() {
            return player1Legs;
        }

        public void setPlayer1Legs(Integer player1Legs) {
            this.player1Legs = player1Legs;
        }

        public Integer getPlayer2Legs() {
            return player2Legs;
        }

        public void setPlayer2Legs(Integer player2Legs) {
            this.player2Legs = player2Legs;
        }

        public Integer getPlayer1Sets() {
            return player1Sets;
        }

        public void setPlayer1Sets(Integer player1Sets) {
            this.player1Sets = player1Sets;
        }

        public Integer getPlayer2Sets() {
            return player2Sets;
        }

        public void setPlayer2Sets(Integer player2Sets) {
            this.player2Sets = player2Sets;
        }

        public GameState.CurrentPlayer getCurrentPlayer() {
            return currentPlayer;
        }

        public void setCurrentPlayer(GameState.CurrentPlayer currentPlayer) {
            this.currentPlayer = currentPlayer;
        }

        public Integer getRoundNumber() {
            return roundNumber;
        }

        public void setRoundNumber(Integer roundNumber) {
            this.roundNumber = roundNumber;
        }

        public Integer getPlayer1DartsThrown() {
            return player1DartsThrown;
        }

        public void setPlayer1DartsThrown(Integer player1DartsThrown) {
            this.player1DartsThrown = player1DartsThrown;
        }

        public Integer getPlayer2DartsThrown() {
            return player2DartsThrown;
        }

        public void setPlayer2DartsThrown(Integer player2DartsThrown) {
            this.player2DartsThrown = player2DartsThrown;
        }
    }
}