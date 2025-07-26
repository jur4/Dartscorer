package com.dartverein.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Email;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "players")
public class Player {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Name is required")
    @Column(unique = true, nullable = false, length = 100)
    private String name;

    @Email(message = "Email should be valid")
    @Column(length = 255)
    private String email;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @OneToMany(mappedBy = "player1", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Game> gamesAsPlayer1;

    @OneToMany(mappedBy = "player2", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Game> gamesAsPlayer2;

    @OneToMany(mappedBy = "player", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<GameStatistics> gameStatistics;

    // Constructors
    public Player() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Player(String name, String email) {
        this();
        this.name = name;
        this.email = email;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
        this.updatedAt = LocalDateTime.now();
    }

    public List<Game> getGamesAsPlayer1() {
        return gamesAsPlayer1;
    }

    public void setGamesAsPlayer1(List<Game> gamesAsPlayer1) {
        this.gamesAsPlayer1 = gamesAsPlayer1;
    }

    public List<Game> getGamesAsPlayer2() {
        return gamesAsPlayer2;
    }

    public void setGamesAsPlayer2(List<Game> gamesAsPlayer2) {
        this.gamesAsPlayer2 = gamesAsPlayer2;
    }

    public List<GameStatistics> getGameStatistics() {
        return gameStatistics;
    }

    public void setGameStatistics(List<GameStatistics> gameStatistics) {
        this.gameStatistics = gameStatistics;
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    @Override
    public String toString() {
        return "Player{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}