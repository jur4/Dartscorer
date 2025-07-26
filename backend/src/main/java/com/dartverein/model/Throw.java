package com.dartverein.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Max;
import java.time.LocalDateTime;

@Entity
@Table(name = "throws")
public class Throw {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id", nullable = false)
    @NotNull
    private Game game;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "round_id", nullable = false)
    @NotNull
    private Round round;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player_id", nullable = false)
    @NotNull
    private Player player;

    @Column(name = "dart_number", nullable = false)
    @NotNull
    @Min(value = 1, message = "Dart number must be at least 1")
    @Max(value = 3, message = "Dart number must be at most 3")
    private Integer dartNumber;

    @Column(name = "score", nullable = false)
    @NotNull
    @Min(value = 0, message = "Score cannot be negative")
    @Max(value = 180, message = "Score cannot exceed 180")
    private Integer score;

    @Column(name = "multiplier")
    @Min(value = 1, message = "Multiplier must be at least 1")
    @Max(value = 3, message = "Multiplier must be at most 3")
    private Integer multiplier = 1;

    @Column(name = "segment")
    @Min(value = 0, message = "Segment cannot be negative")
    @Max(value = 25, message = "Segment cannot exceed 25")
    private Integer segment;

    @Column(name = "is_double")
    private Boolean isDouble = false;

    @Column(name = "is_triple")
    private Boolean isTriple = false;

    @Column(name = "is_bullseye")
    private Boolean isBullseye = false;

    @Column(name = "is_miss")
    private Boolean isMiss = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // Constructors
    public Throw() {
        this.createdAt = LocalDateTime.now();
    }

    public Throw(Game game, Round round, Player player, Integer dartNumber, Integer score) {
        this();
        this.game = game;
        this.round = round;
        this.player = player;
        this.dartNumber = dartNumber;
        this.score = score;
        this.isMiss = (score == 0);
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

    public Round getRound() {
        return round;
    }

    public void setRound(Round round) {
        this.round = round;
    }

    public Player getPlayer() {
        return player;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }

    public Integer getDartNumber() {
        return dartNumber;
    }

    public void setDartNumber(Integer dartNumber) {
        this.dartNumber = dartNumber;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
        this.isMiss = (score == 0);
    }

    public Integer getMultiplier() {
        return multiplier;
    }

    public void setMultiplier(Integer multiplier) {
        this.multiplier = multiplier;
        this.isDouble = (multiplier == 2);
        this.isTriple = (multiplier == 3);
    }

    public Integer getSegment() {
        return segment;
    }

    public void setSegment(Integer segment) {
        this.segment = segment;
        this.isBullseye = (segment == 25);
    }

    public Boolean getIsDouble() {
        return isDouble;
    }

    public void setIsDouble(Boolean isDouble) {
        this.isDouble = isDouble;
    }

    public Boolean getIsTriple() {
        return isTriple;
    }

    public void setIsTriple(Boolean isTriple) {
        this.isTriple = isTriple;
    }

    public Boolean getIsBullseye() {
        return isBullseye;
    }

    public void setIsBullseye(Boolean isBullseye) {
        this.isBullseye = isBullseye;
    }

    public Boolean getIsMiss() {
        return isMiss;
    }

    public void setIsMiss(Boolean isMiss) {
        this.isMiss = isMiss;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}