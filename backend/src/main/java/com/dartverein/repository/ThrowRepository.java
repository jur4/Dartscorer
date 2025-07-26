package com.dartverein.repository;

import com.dartverein.model.Throw;
import com.dartverein.model.Game;
import com.dartverein.model.Player;
import com.dartverein.model.Round;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ThrowRepository extends JpaRepository<Throw, Long> {
    
    List<Throw> findByGameOrderByCreatedAtAsc(Game game);
    
    List<Throw> findByRoundOrderByDartNumberAsc(Round round);
    
    List<Throw> findByGameAndPlayerOrderByCreatedAtAsc(Game game, Player player);
    
    @Query("SELECT t FROM Throw t WHERE t.game.id = :gameId ORDER BY t.round.roundNumber ASC, t.dartNumber ASC")
    List<Throw> findThrowsByGameId(@Param("gameId") Long gameId);
    
    @Query("SELECT t FROM Throw t WHERE t.round.id = :roundId ORDER BY t.dartNumber ASC")
    List<Throw> findThrowsByRoundId(@Param("roundId") Long roundId);
    
    @Query("SELECT COUNT(t) FROM Throw t WHERE t.player.id = :playerId AND t.isDouble = true")
    long countDoublesByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT COUNT(t) FROM Throw t WHERE t.player.id = :playerId AND t.isTriple = true")
    long countTriplesByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT COUNT(t) FROM Throw t WHERE t.player.id = :playerId AND t.isBullseye = true")
    long countBullseyesByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT COUNT(t) FROM Throw t WHERE t.player.id = :playerId AND t.isMiss = true")
    long countMissesByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT AVG(CAST(t.score AS double)) FROM Throw t WHERE t.player.id = :playerId AND t.isMiss = false")
    Double getAverageScoreByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT MAX(t.score) FROM Throw t WHERE t.player.id = :playerId")
    Integer getHighestScoreByPlayer(@Param("playerId") Long playerId);
}