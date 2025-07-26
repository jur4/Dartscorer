package com.dartverein.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "games")
public class Game {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player1_id", nullable = false)
    @NotNull
    private Player player1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player2_id")
    private Player player2;

    @Enumerated(EnumType.STRING)
    @Column(name = "game_type", nullable = false, length = 50)
    @NotNull
    private GameType gameType;

    @Enumerated(EnumType.STRING)
    @Column(name = "game_mode", nullable = false, length = 50)
    @NotNull
    private GameMode gameMode;

    @Column(name = "start_score", nullable = false)
    @NotNull
    private Integer startScore;

    @Column(name = "target_legs")
    private Integer targetLegs = 0;

    @Column(name = "target_sets")
    private Integer targetSets = 0;

    @Column(name = "double_in")
    private Boolean doubleIn = false;

    @Column(name = "double_out")
    private Boolean doubleOut = true;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private GameStatus status = GameStatus.IN_PROGRESS;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "winner_id")
    private Player winner;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "finished_at")
    private LocalDateTime finishedAt;

    @OneToOne(mappedBy = "game", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private GameState gameState;

    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Round> rounds;

    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Throw> dartThrows;

    @OneToMany(mappedBy = "game", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<GameStatistics> gameStatistics;

    // Enums
    public enum GameType {
        X01, CRICKET, BOBS27
    }

    public enum GameMode {
        WITH_ENEMY, WITHOUT_ENEMY, VS_BOT
    }

    public enum GameStatus {
        IN_PROGRESS, FINISHED, ABORTED
    }

    // Constructors
    public Game() {
        this.createdAt = LocalDateTime.now();
    }

    public Game(Player player1, Player player2, GameType gameType, GameMode gameMode, Integer startScore) {
        this();
        this.player1 = player1;
        this.player2 = player2;
        this.gameType = gameType;
        this.gameMode = gameMode;
        this.startScore = startScore;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Player getPlayer1() {
        return player1;
    }

    public void setPlayer1(Player player1) {
        this.player1 = player1;
    }

    public Player getPlayer2() {
        return player2;
    }

    public void setPlayer2(Player player2) {
        this.player2 = player2;
    }

    public GameType getGameType() {
        return gameType;
    }

    public void setGameType(GameType gameType) {
        this.gameType = gameType;
    }

    public GameMode getGameMode() {
        return gameMode;
    }

    public void setGameMode(GameMode gameMode) {
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

    public GameStatus getStatus() {
        return status;
    }

    public void setStatus(GameStatus status) {
        this.status = status;
        if (status == GameStatus.FINISHED && this.finishedAt == null) {
            this.finishedAt = LocalDateTime.now();
        }
    }

    public Player getWinner() {
        return winner;
    }

    public void setWinner(Player winner) {
        this.winner = winner;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getFinishedAt() {
        return finishedAt;
    }

    public void setFinishedAt(LocalDateTime finishedAt) {
        this.finishedAt = finishedAt;
    }

    public GameState getGameState() {
        return gameState;
    }

    public void setGameState(GameState gameState) {
        this.gameState = gameState;
    }

    public List<Round> getRounds() {
        return rounds;
    }

    public void setRounds(List<Round> rounds) {
        this.rounds = rounds;
    }

    public List<Throw> getThrows() {
        return dartThrows;
    }

    public void setThrows(List<Throw> dartThrows) {
        this.dartThrows = dartThrows;
    }

    public List<GameStatistics> getGameStatistics() {
        return gameStatistics;
    }

    public void setGameStatistics(List<GameStatistics> gameStatistics) {
        this.gameStatistics = gameStatistics;
    }
}