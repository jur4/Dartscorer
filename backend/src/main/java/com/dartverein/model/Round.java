package com.dartverein.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "rounds")
public class Round {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "game_id", nullable = false)
    @NotNull
    private Game game;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "player_id", nullable = false)
    @NotNull
    private Player player;

    @Column(name = "round_number", nullable = false)
    @NotNull
    private Integer roundNumber;

    @Column(name = "score_before", nullable = false)
    @NotNull
    private Integer scoreBefore;

    @Column(name = "score_after", nullable = false)
    @NotNull
    private Integer scoreAfter;

    @Column(name = "total_thrown")
    private Integer totalThrown = 0;

    @Column(name = "darts_thrown")
    private Integer dartsThrown = 0;

    @Column(name = "is_bust")
    private Boolean isBust = false;

    @Column(name = "is_checkout")
    private Boolean isCheckout = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "round", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Throw> dartThrows;

    // Constructors
    public Round() {
        this.createdAt = LocalDateTime.now();
    }

    public Round(Game game, Player player, Integer roundNumber, Integer scoreBefore) {
        this();
        this.game = game;
        this.player = player;
        this.roundNumber = roundNumber;
        this.scoreBefore = scoreBefore;
        this.scoreAfter = scoreBefore;
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

    public Player getPlayer() {
        return player;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }

    public Integer getRoundNumber() {
        return roundNumber;
    }

    public void setRoundNumber(Integer roundNumber) {
        this.roundNumber = roundNumber;
    }

    public Integer getScoreBefore() {
        return scoreBefore;
    }

    public void setScoreBefore(Integer scoreBefore) {
        this.scoreBefore = scoreBefore;
    }

    public Integer getScoreAfter() {
        return scoreAfter;
    }

    public void setScoreAfter(Integer scoreAfter) {
        this.scoreAfter = scoreAfter;
    }

    public Integer getTotalThrown() {
        return totalThrown;
    }

    public void setTotalThrown(Integer totalThrown) {
        this.totalThrown = totalThrown;
    }

    public Integer getDartsThrown() {
        return dartsThrown;
    }

    public void setDartsThrown(Integer dartsThrown) {
        this.dartsThrown = dartsThrown;
    }

    public Boolean getIsBust() {
        return isBust;
    }

    public void setIsBust(Boolean isBust) {
        this.isBust = isBust;
    }

    public Boolean getIsCheckout() {
        return isCheckout;
    }

    public void setIsCheckout(Boolean isCheckout) {
        this.isCheckout = isCheckout;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public List<Throw> getThrows() {
        return dartThrows;
    }

    public void setThrows(List<Throw> dartThrows) {
        this.dartThrows = dartThrows;
    }
}