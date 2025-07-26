package com.dartverein.repository;

import com.dartverein.model.Player;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PlayerRepository extends JpaRepository<Player, Long> {
    
    Optional<Player> findByName(String name);
    
    List<Player> findByIsActiveTrue();
    
    List<Player> findByNameContainingIgnoreCase(String name);
    
    @Query("SELECT p FROM Player p WHERE p.isActive = true ORDER BY p.name ASC")
    List<Player> findAllActivePlayersOrderByName();
    
    @Query("SELECT COUNT(p) FROM Player p WHERE p.isActive = true")
    long countActivePlayers();
    
    @Query("SELECT p FROM Player p WHERE p.email = :email AND p.isActive = true")
    Optional<Player> findActivePlayerByEmail(@Param("email") String email);
    
    boolean existsByNameAndIsActiveTrue(String name);
}