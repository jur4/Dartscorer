package com.dartverein.repository;

import com.dartverein.model.Round;
import com.dartverein.model.Game;
import com.dartverein.model.Player;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RoundRepository extends JpaRepository<Round, Long> {
    
    List<Round> findByGameOrderByRoundNumberAsc(Game game);
    
    List<Round> findByGameAndPlayerOrderByRoundNumberAsc(Game game, Player player);
    
    @Query("SELECT r FROM Round r WHERE r.game.id = :gameId ORDER BY r.roundNumber ASC")
    List<Round> findRoundsByGameId(@Param("gameId") Long gameId);
    
    @Query("SELECT r FROM Round r WHERE r.game.id = :gameId AND r.player.id = :playerId ORDER BY r.roundNumber ASC")
    List<Round> findRoundsByGameIdAndPlayerId(@Param("gameId") Long gameId, @Param("playerId") Long playerId);
    
    @Query("SELECT MAX(r.roundNumber) FROM Round r WHERE r.game.id = :gameId")
    Optional<Integer> findMaxRoundNumberByGameId(@Param("gameId") Long gameId);
    
    @Query("SELECT r FROM Round r WHERE r.game.id = :gameId AND r.player.id = :playerId AND r.roundNumber = :roundNumber")
    Optional<Round> findByGameIdPlayerIdAndRoundNumber(@Param("gameId") Long gameId, @Param("playerId") Long playerId, @Param("roundNumber") Integer roundNumber);
    
    @Query("SELECT COUNT(r) FROM Round r WHERE r.player.id = :playerId AND r.isCheckout = true")
    long countCheckoutsByPlayer(@Param("playerId") Long playerId);
    
    @Query("SELECT COUNT(r) FROM Round r WHERE r.player.id = :playerId AND r.totalThrown = 180")
    long count180sByPlayer(@Param("playerId") Long playerId);
}