package com.dartverein.controller;

import com.dartverein.model.Player;
import com.dartverein.repository.PlayerRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/players")
@CrossOrigin(origins = "*")
public class PlayerController {

    @Autowired
    private PlayerRepository playerRepository;

    @GetMapping
    public List<Player> getAllPlayers() {
        System.out.println("GET ALL PLAYERS");
        return playerRepository.findAllActivePlayersOrderByName();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Player> getPlayer2ById(@PathVariable Long id) {
        Optional<Player> player = playerRepository.findById(id);
        return player.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/search")
    public List<Player> searchPlayersByName(@RequestParam String name) {
        return playerRepository.findByNameContainingIgnoreCase(name);
    }

    @PostMapping
    public ResponseEntity<Player> createPlayer(@Valid @RequestBody PlayerCreateRequest request) {
        if (playerRepository.existsByNameAndIsActiveTrue(request.getName())) {
            return ResponseEntity.badRequest().build();
        }

        Player player = new Player(request.getName(), request.getEmail());
        Player savedPlayer = playerRepository.save(player);
        return ResponseEntity.ok(savedPlayer);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Player> updatePlayer(@PathVariable Long id, @Valid @RequestBody PlayerUpdateRequest request) {
        Optional<Player> optionalPlayer = playerRepository.findById(id);
        if (optionalPlayer.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Player player = optionalPlayer.get();
        
        if (!player.getName().equals(request.getName()) && 
            playerRepository.existsByNameAndIsActiveTrue(request.getName())) {
            return ResponseEntity.badRequest().build();
        }

        player.setName(request.getName());
        player.setEmail(request.getEmail());
        
        Player updatedPlayer = playerRepository.save(player);
        return ResponseEntity.ok(updatedPlayer);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePlayer(@PathVariable Long id) {
        Optional<Player> optionalPlayer = playerRepository.findById(id);
        if (optionalPlayer.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Player player = optionalPlayer.get();
        player.setIsActive(false);
        playerRepository.save(player);
        
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/count")
    public ResponseEntity<Long> getActivePlayerCount() {
        long count = playerRepository.countActivePlayers();
        return ResponseEntity.ok(count);
    }

    public static class PlayerCreateRequest {
        @jakarta.validation.constraints.NotBlank(message = "Name is required")
        private String name;
        
        private String email;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }
    }

    public static class PlayerUpdateRequest {
        @jakarta.validation.constraints.NotBlank(message = "Name is required")
        private String name;
        
        private String email;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }
    }
}