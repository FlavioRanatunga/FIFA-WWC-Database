-- Insert data for the year 2019
INSERT INTO WorldCup (year, host, no_of_teams, champions, runners_up, top_scorer, no_of_matches)
VALUES (2019, 'France', 24, 'United States', 'Netherlands', 'Alex Morgan', 52);

SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE '/home/flavio/DBS/FinalAssesment/Locations.csv' 
INTO TABLE Location 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/flavio/DBS/FinalAssesment/Group.csv' 
INTO TABLE GroupStage 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/flavio/DBS/FinalAssesment/Teams.csv' 
INTO TABLE Team 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/flavio/DBS/FinalAssesment/Match.csv' 
INTO TABLE Matches 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/flavio/DBS/FinalAssesment/Player.csv' 
INTO TABLE Player 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/flavio/DBS/FinalAssesment/PlaysIn.csv' 
INTO TABLE PlaysIn
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/home/flavio/DBS/FinalAssesment/Awards1.csv' 
INTO TABLE Awards
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DELIMITER //
CREATE PROCEDURE GetPlayersByTeam(IN countryPar VARCHAR(50))
    BEGIN
     SELECT * FROM Player
     WHERE country = countryPar;
     END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE AvgGoalsPerTeam(IN worldCupYear INT)
BEGIN
    SELECT
        T.team_name AS TeamName,
        SUM(IF(M.homeTeam = T.team_name, M.homeScore, M.awayScore)) / COUNT(M.matchID) AS AverageGoalsPerMatch
    FROM
        Team AS T
    LEFT JOIN Matches AS M ON T.team_name = M.homeTeam OR T.team_name = M.awayTeam
    WHERE M.year = worldCupYear
    GROUP BY T.team_name;
END //
DELIMITER ;


DELIMITER //

CREATE PROCEDURE CalculateWinPercentage(IN teamName VARCHAR(255), IN worldCupYear INT)
BEGIN
    DECLARE totalMatches INT;
    DECLARE totalWins INT;
    DECLARE winPercentage DECIMAL(5,2);

    -- Calculate the total number of matches played by the team
    SELECT COUNT(*) INTO totalMatches
    FROM Matches
    WHERE (homeTeam = teamName OR awayTeam = teamName) AND year = worldCupYear;

    -- Calculate the total number of matches won by the team
    SELECT COUNT(*) INTO totalWins
    FROM Matches
    WHERE ((homeTeam = teamName AND homeScore > awayScore) OR (awayTeam = teamName AND awayScore > homeScore)) AND year = worldCupYear;

    -- Calculate the win percentage
    IF totalMatches > 0 THEN
        SET winPercentage = (totalWins / totalMatches) * 100;
    ELSE
        SET winPercentage = 0;
    END IF;

    -- Return the win percentage
    SELECT winPercentage AS WinPercentage;
END //

DELIMITER ;


CREATE VIEW MatchResultsView AS
    SELECT
    M.matchID,
    T1.team_name AS HomeTeam,
    T2.team_name AS AwayTeam,
    M.homeScore AS HomeTeamScore,
    M.awayScore AS AwayTeamScore,
    L.stadium_name AS Venue,
    M.winner AS MatchWinner
    FROM Matches AS M
    JOIN Location AS L ON M.venue = L.name
    JOIN Team AS T1 ON M.homeTeam = T1.team_name
    JOIN Team AS T2 ON M.awayTeam = T2.team_name;


CREATE VIEW TeamTotalGoals AS
     SELECT t.year, t.team_name, SUM(p.goals) AS total_goals
     FROM Team t
     JOIN Player p ON t.teamID = p.teamID
     GROUP BY t.year, t.team_name;


