package com.dartverein.repository;

import com.dartverein.model.Game;
import com.dartverein.model.Player;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface GameRepository extends JpaRepository<Game, Long> {
    
    List<Game> findByPlayer1OrPlayer2OrderByCreatedAtDesc(Player player1, Player player2);
    
    List<Game> findByStatusOrderByCreatedAtDesc(Game.GameStatus status);
    
    @Query("SELECT g FROM Game g WHERE g.status = 'IN_PROGRESS' AND (g.player1.id = :playerId OR g.player2.id = :playerId)")
    List<Game> findActiveGamesByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT g FROM Game g WHERE g.createdAt BETWEEN :startDate AND :endDate ORDER BY g.createdAt DESC")
    List<Game> findGamesBetweenDates(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT COUNT(g) FROM Game g WHERE g.winner.id = :playerId")
    long countWinsByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT COUNT(g) FROM Game g WHERE (g.player1.id = :playerId OR g.player2.id = :playerId) AND g.status = 'FINISHED'")
    long countTotalGamesByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT g FROM Game g WHERE (g.player1.id = :player1Id AND g.player2.id = :player2Id) OR (g.player1.id = :player2Id AND g.player2.id = :player1Id) ORDER BY g.createdAt DESC")
    List<Game> findGamesBetweenPlayers(@Param("player1Id") Long player1Id, @Param("player2Id") Long player2Id);
    
    Optional<Game> findTopByPlayer1OrPlayer2AndStatusOrderByCreatedAtDesc(Player player1, Player player2, Game.GameStatus status);
}