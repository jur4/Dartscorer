package com.dartverein.controller;

import com.dartverein.model.GameStatistics;
import com.dartverein.model.Player;
import com.dartverein.repository.GameStatisticsRepository;
import com.dartverein.repository.PlayerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/statistics")
@CrossOrigin(origins = "*")
public class StatisticsController {

    @Autowired
    private GameStatisticsRepository gameStatisticsRepository;
    
    @Autowired
    private PlayerRepository playerRepository;

    @GetMapping("/player/{playerId}")
    public ResponseEntity<List<GameStatistics>> getPlayerStatistics(@PathVariable Long playerId) {
        Optional<Player> player = playerRepository.findById(playerId);
        if (player.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        
        List<GameStatistics> statistics = gameStatisticsRepository.findStatisticsByPlayerId(playerId);
        return ResponseEntity.ok(statistics);
    }

    @GetMapping("/player/{playerId}/summary")
    public ResponseEntity<PlayerStatisticsSummary> getPlayerStatisticsSummary(@PathVariable Long playerId) {
        Optional<Player> player = playerRepository.findById(playerId);
        if (player.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        PlayerStatisticsSummary summary = new PlayerStatisticsSummary();
        summary.setPlayerId(playerId);
        summary.setPlayerName(player.get().getName());
        
        summary.setTotal180s(gameStatisticsRepository.getTotalCount180ByPlayer(playerId));
        summary.setTotal140Plus(gameStatisticsRepository.getTotalCount140PlusByPlayer(playerId));
        summary.setTotal100Plus(gameStatisticsRepository.getTotalCount100PlusByPlayer(playerId));
        summary.setTotalLegsWon(gameStatisticsRepository.getTotalLegsWonByPlayer(playerId));
        summary.setTotalLegsLost(gameStatisticsRepository.getTotalLegsLostByPlayer(playerId));
        summary.setHighestCheckout(gameStatisticsRepository.getHighestCheckoutByPlayer(playerId));
        summary.setOverallAverage(gameStatisticsRepository.getOverallAverageScoreByPlayer(playerId));
        summary.setGamesWon(gameStatisticsRepository.countWinsByPlayer(playerId));
        summary.setTotalGames(gameStatisticsRepository.countTotalGamesByPlayer(playerId));

        return ResponseEntity.ok(summary);
    }

    @GetMapping("/game/{gameId}")
    public List<GameStatistics> getGameStatistics(@PathVariable Long gameId) {
        return gameStatisticsRepository.findStatisticsByGameId(gameId);
    }

    public static class PlayerStatisticsSummary {
        private Long playerId;
        private String playerName;
        private Long total180s = 0L;
        private Long total140Plus = 0L;
        private Long total100Plus = 0L;
        private Long totalLegsWon = 0L;
        private Long totalLegsLost = 0L;
        private Integer highestCheckout = 0;
        private Double overallAverage = 0.0;
        private Long gamesWon = 0L;
        private Long totalGames = 0L;

        public Long getPlayerId() {
            return playerId;
        }

        public void setPlayerId(Long playerId) {
            this.playerId = playerId;
        }

        public String getPlayerName() {
            return playerName;
        }

        public void setPlayerName(String playerName) {
            this.playerName = playerName;
        }

        public Long getTotal180s() {
            return total180s != null ? total180s : 0L;
        }

        public void setTotal180s(Long total180s) {
            this.total180s = total180s;
        }

        public Long getTotal140Plus() {
            return total140Plus != null ? total140Plus : 0L;
        }

        public void setTotal140Plus(Long total140Plus) {
            this.total140Plus = total140Plus;
        }

        public Long getTotal100Plus() {
            return total100Plus != null ? total100Plus : 0L;
        }

        public void setTotal100Plus(Long total100Plus) {
            this.total100Plus = total100Plus;
        }

        public Long getTotalLegsWon() {
            return totalLegsWon != null ? totalLegsWon : 0L;
        }

        public void setTotalLegsWon(Long totalLegsWon) {
            this.totalLegsWon = totalLegsWon;
        }

        public Long getTotalLegsLost() {
            return totalLegsLost != null ? totalLegsLost : 0L;
        }

        public void setTotalLegsLost(Long totalLegsLost) {
            this.totalLegsLost = totalLegsLost;
        }

        public Integer getHighestCheckout() {
            return highestCheckout != null ? highestCheckout : 0;
        }

        public void setHighestCheckout(Integer highestCheckout) {
            this.highestCheckout = highestCheckout;
        }

        public Double getOverallAverage() {
            return overallAverage != null ? overallAverage : 0.0;
        }

        public void setOverallAverage(Double overallAverage) {
            this.overallAverage = overallAverage;
        }

        public Long getGamesWon() {
            return gamesWon != null ? gamesWon : 0L;
        }

        public void setGamesWon(Long gamesWon) {
            this.gamesWon = gamesWon;
        }

        public Long getTotalGames() {
            return totalGames != null ? totalGames : 0L;
        }

        public void setTotalGames(Long totalGames) {
            this.totalGames = totalGames;
        }

        public double getWinRate() {
            if (totalGames == null || totalGames == 0) {
                return 0.0;
            }
            return (double) (gamesWon != null ? gamesWon : 0L) / totalGames * 100;
        }
    }
}