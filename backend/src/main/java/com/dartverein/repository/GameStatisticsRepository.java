package com.dartverein.repository;

import com.dartverein.model.GameStatistics;
import com.dartverein.model.Game;
import com.dartverein.model.Player;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GameStatisticsRepository extends JpaRepository<GameStatistics, Long> {
    
    Optional<GameStatistics> findByGameAndPlayer(Game game, Player player);
    
    List<GameStatistics> findByPlayerOrderByCreatedAtDesc(Player player);
    
    @Query("SELECT gs FROM GameStatistics gs WHERE gs.player.id = :playerId ORDER BY gs.createdAt DESC")
    List<GameStatistics> findStatisticsByPlayerId(@Param("playerId") Long playerId);
    
    @Query("SELECT gs FROM GameStatistics gs WHERE gs.game.id = :gameId")
    List<GameStatistics> findStatisticsByGameId(@Param("gameId") Long gameId);
    
    @Query("SELECT SUM(gs.count180) FROM GameStatistics gs WHERE gs.player.id = :playerId")
    Long getTotalCount180ByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT SUM(gs.count140Plus) FROM GameStatistics gs WHERE gs.player.id = :playerId")
    Long getTotalCount140PlusByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT SUM(gs.count100Plus) FROM GameStatistics gs WHERE gs.player.id = :playerId")
    Long getTotalCount100PlusByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT SUM(gs.legsWon) FROM GameStatistics gs WHERE gs.player.id = :playerId")
    Long getTotalLegsWonByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT SUM(gs.legsLost) FROM GameStatistics gs WHERE gs.player.id = :playerId")
    Long getTotalLegsLostByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT MAX(gs.highestCheckout) FROM GameStatistics gs WHERE gs.player.id = :playerId")
    Integer getHighestCheckoutByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT AVG(gs.averageScore) FROM GameStatistics gs WHERE gs.player.id = :playerId")
    Double getOverallAverageScoreByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT COUNT(gs) FROM GameStatistics gs WHERE gs.player.id = :playerId AND gs.isWinner = true")
    long countWinsByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT COUNT(gs) FROM GameStatistics gs WHERE gs.player.id = :playerId")
    long countTotalGamesByPlayer(@Param("playerId") Long playerId);
}