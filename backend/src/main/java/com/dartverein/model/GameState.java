package com.dartverein.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Entity
@Table(name = "game_state")
public class GameState {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id", nullable = false, unique = true)
    @NotNull
    private Game game;

    @Column(name = "player1_score", nullable = false)
    @NotNull
    private Integer player1Score;

    @Column(name = "player2_score", nullable = false)
    @NotNull
    private Integer player2Score;

    @Column(name = "player1_legs")
    private Integer player1Legs = 0;

    @Column(name = "player2_legs")
    private Integer player2Legs = 0;

    @Column(name = "player1_sets")
    private Integer player1Sets = 0;

    @Column(name = "player2_sets")
    private Integer player2Sets = 0;

    @Enumerated(EnumType.STRING)
    @Column(name = "current_player", nullable = false, length = 20)
    @NotNull
    private CurrentPlayer currentPlayer;

    @Column(name = "round_number")
    private Integer roundNumber = 1;

    @Column(name = "player1_darts_thrown")
    private Integer player1DartsThrown = 0;

    @Column(name = "player2_darts_thrown")
    private Integer player2DartsThrown = 0;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public enum CurrentPlayer {
        PLAYER1, PLAYER2
    }

    // Constructors
    public GameState() {
        this.updatedAt = LocalDateTime.now();
    }

    public GameState(Game game, Integer startScore) {
        this();
        this.game = game;
        this.player1Score = startScore;
        this.player2Score = startScore;
        this.currentPlayer = CurrentPlayer.PLAYER1;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }

    public Integer getPlayer1Score() {
        return player1Score;
    }

    public void setPlayer1Score(Integer player1Score) {
        this.player1Score = player1Score;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPlayer2Score() {
        return player2Score;
    }

    public void setPlayer2Score(Integer player2Score) {
        this.player2Score = player2Score;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPlayer1Legs() {
        return player1Legs;
    }

    public void setPlayer1Legs(Integer player1Legs) {
        this.player1Legs = player1Legs;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPlayer2Legs() {
        return player2Legs;
    }

    public void setPlayer2Legs(Integer player2Legs) {
        this.player2Legs = player2Legs;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPlayer1Sets() {
        return player1Sets;
    }

    public void setPlayer1Sets(Integer player1Sets) {
        this.player1Sets = player1Sets;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPlayer2Sets() {
        return player2Sets;
    }

    public void setPlayer2Sets(Integer player2Sets) {
        this.player2Sets = player2Sets;
        this.updatedAt = LocalDateTime.now();
    }

    public CurrentPlayer getCurrentPlayer() {
        return currentPlayer;
    }

    public void setCurrentPlayer(CurrentPlayer currentPlayer) {
        this.currentPlayer = currentPlayer;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getRoundNumber() {
        return roundNumber;
    }

    public void setRoundNumber(Integer roundNumber) {
        this.roundNumber = roundNumber;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPlayer1DartsThrown() {
        return player1DartsThrown;
    }

    public void setPlayer1DartsThrown(Integer player1DartsThrown) {
        this.player1DartsThrown = player1DartsThrown;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPlayer2DartsThrown() {
        return player2DartsThrown;
    }

    public void setPlayer2DartsThrown(Integer player2DartsThrown) {
        this.player2DartsThrown = player2DartsThrown;
        this.updatedAt = LocalDateTime.now();
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}