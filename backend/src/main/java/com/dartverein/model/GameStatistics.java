package com.dartverein.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "game_statistics")
public class GameStatistics {
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

    @Column(name = "total_darts_thrown")
    private Integer totalDartsThrown = 0;

    @Column(name = "total_score")
    private Integer totalScore = 0;

    @Column(name = "average_score", precision = 5, scale = 2)
    private BigDecimal averageScore = BigDecimal.ZERO;

    @Column(name = "highest_checkout")
    private Integer highestCheckout = 0;

    @Column(name = "count_180")
    private Integer count180 = 0;

    @Column(name = "count_140_plus")
    private Integer count140Plus = 0;

    @Column(name = "count_100_plus")
    private Integer count100Plus = 0;

    @Column(name = "count_60_plus")
    private Integer count60Plus = 0;

    @Column(name = "count_doubles")
    private Integer countDoubles = 0;

    @Column(name = "count_triples")
    private Integer countTriples = 0;

    @Column(name = "count_bullseyes")
    private Integer countBullseyes = 0;

    @Column(name = "count_misses")
    private Integer countMisses = 0;

    @Column(name = "legs_won")
    private Integer legsWon = 0;

    @Column(name = "legs_lost")
    private Integer legsLost = 0;

    @Column(name = "sets_won")
    private Integer setsWon = 0;

    @Column(name = "sets_lost")
    private Integer setsLost = 0;

    @Column(name = "is_winner")
    private Boolean isWinner = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Constructors
    public GameStatistics() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public GameStatistics(Game game, Player player) {
        this();
        this.game = game;
        this.player = player;
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

    public Integer getTotalDartsThrown() {
        return totalDartsThrown;
    }

    public void setTotalDartsThrown(Integer totalDartsThrown) {
        this.totalDartsThrown = totalDartsThrown;
        updateAverageScore();
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(Integer totalScore) {
        this.totalScore = totalScore;
        updateAverageScore();
        this.updatedAt = LocalDateTime.now();
    }

    public BigDecimal getAverageScore() {
        return averageScore;
    }

    public void setAverageScore(BigDecimal averageScore) {
        this.averageScore = averageScore;
    }

    public Integer getHighestCheckout() {
        return highestCheckout;
    }

    public void setHighestCheckout(Integer highestCheckout) {
        this.highestCheckout = highestCheckout;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCount180() {
        return count180;
    }

    public void setCount180(Integer count180) {
        this.count180 = count180;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCount140Plus() {
        return count140Plus;
    }

    public void setCount140Plus(Integer count140Plus) {
        this.count140Plus = count140Plus;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCount100Plus() {
        return count100Plus;
    }

    public void setCount100Plus(Integer count100Plus) {
        this.count100Plus = count100Plus;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCount60Plus() {
        return count60Plus;
    }

    public void setCount60Plus(Integer count60Plus) {
        this.count60Plus = count60Plus;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCountDoubles() {
        return countDoubles;
    }

    public void setCountDoubles(Integer countDoubles) {
        this.countDoubles = countDoubles;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCountTriples() {
        return countTriples;
    }

    public void setCountTriples(Integer countTriples) {
        this.countTriples = countTriples;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCountBullseyes() {
        return countBullseyes;
    }

    public void setCountBullseyes(Integer countBullseyes) {
        this.countBullseyes = countBullseyes;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCountMisses() {
        return countMisses;
    }

    public void setCountMisses(Integer countMisses) {
        this.countMisses = countMisses;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getLegsWon() {
        return legsWon;
    }

    public void setLegsWon(Integer legsWon) {
        this.legsWon = legsWon;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getLegsLost() {
        return legsLost;
    }

    public void setLegsLost(Integer legsLost) {
        this.legsLost = legsLost;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getSetsWon() {
        return setsWon;
    }

    public void setSetsWon(Integer setsWon) {
        this.setsWon = setsWon;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getSetsLost() {
        return setsLost;
    }

    public void setSetsLost(Integer setsLost) {
        this.setsLost = setsLost;
        this.updatedAt = LocalDateTime.now();
    }

    public Boolean getIsWinner() {
        return isWinner;
    }

    public void setIsWinner(Boolean isWinner) {
        this.isWinner = isWinner;
        this.updatedAt = LocalDateTime.now();
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
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

    private void updateAverageScore() {
        if (totalDartsThrown != null && totalDartsThrown > 0 && totalScore != null) {
            this.averageScore = BigDecimal.valueOf(totalScore)
                    .divide(BigDecimal.valueOf(totalDartsThrown), 2, BigDecimal.ROUND_HALF_UP);
        }
    }

    public void incrementCount180() {
        this.count180++;
        this.count140Plus++;
        this.count100Plus++;
        this.count60Plus++;
        this.updatedAt = LocalDateTime.now();
    }

    public void incrementCount140Plus() {
        this.count140Plus++;
        this.count100Plus++;
        this.count60Plus++;
        this.updatedAt = LocalDateTime.now();
    }

    public void incrementCount100Plus() {
        this.count100Plus++;
        this.count60Plus++;
        this.updatedAt = LocalDateTime.now();
    }

    public void incrementCount60Plus() {
        this.count60Plus++;
        this.updatedAt = LocalDateTime.now();
    }
}