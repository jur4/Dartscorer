package com.dartverein.repository;

import com.dartverein.model.GameState;
import com.dartverein.model.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface GameStateRepository extends JpaRepository<GameState, Long> {
    
    Optional<GameState> findByGame(Game game);
    
    Optional<GameState> findByGameId(Long gameId);
    
    @Query("SELECT gs FROM GameState gs WHERE gs.game.id = :gameId")
    Optional<GameState> findGameStateByGameId(@Param("gameId") Long gameId);
    
    void deleteByGame(Game game);
    
    void deleteByGameId(Long gameId);
}