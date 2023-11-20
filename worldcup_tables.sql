-- Create database
DROP DATABASE IF EXISTS FIFAWWorldCup_20908391;
CREATE DATABASE FIFAWWorldCup_20908391;

-- Use created db
USE FIFAWWorldCup_20908391;

-- Create the World Cup table
DROP TABLE IF EXISTS WorldCup;
CREATE TABLE WorldCup (
    year INT NOT NULL,
    host VARCHAR(25) NOT NULL,
    no_of_teams INT NOT NULL,
    champions VARCHAR(25) NOT NULL,
    runners_up VARCHAR(25) NOT NULL,
    top_scorer VARCHAR(25),
    no_of_matches INT,
    PRIMARY KEY (year)
);

-- Create the Location table
DROP TABLE IF EXISTS Location;
CREATE TABLE Location (
    name VARCHAR(25) NOT NULL,
    stadium_name VARCHAR(25) NOT NULL,
    seat_capacity INT,
    PRIMARY KEY (name, stadium_name)
);

-- Create the GroupStage table
DROP TABLE IF EXISTS GroupStage;
CREATE TABLE GroupStage (
    groupID INT NOT NULL,
    year INT NOT NULL,
    group_name VARCHAR(25) NOT NULL,
    team VARCHAR(25) NOT NULL,
    played INT NOT NULL,
    wins INT NOT NULL,
    draws INT NOT NULL,
    loses INT NOT NULL,
    points INT NOT NULL,
    qualified VARCHAR(1) NOT NULL,
    PRIMARY KEY (groupID),
    FOREIGN KEY (year) REFERENCES WorldCup(year)
);

-- Create the Team table
DROP TABLE IF EXISTS Team;
CREATE TABLE Team (
    teamID INT NOT NULL,
    year INT NOT NULL,
    groupID INT NOT NULL,
    team_name VARCHAR(25) NOT NULL,
    no_of_players INT,
    manager VARCHAR(50),
    captain VARCHAR(50),
    PRIMARY KEY (teamID),
    FOREIGN KEY (year) REFERENCES WorldCup(year),
    FOREIGN KEY (groupID) REFERENCES GroupStage(groupID)
);

-- Create the Player table
DROP TABLE IF EXISTS Player;
CREATE TABLE Player (
    playerID INT NOT NULL,
    teamID INT NOT NULL,
    playerNo INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    country VARCHAR(50) NOT NULL,
    position VARCHAR(25) NOT NULL,
    club VARCHAR(50),
    caps INT,
    goals INT,
    PRIMARY KEY (playerID),
    FOREIGN KEY (teamID) REFERENCES Team(teamID)
);

-- Create the Match table
DROP TABLE IF EXISTS Matches;
CREATE TABLE Matches (
    matchID INT NOT NULL,
    year INT NOT NULL,
    homeTeam VARCHAR(25) NOT NULL,
    awayTeam VARCHAR(25) NOT NULL,
    venue VARCHAR(50) NOT NULL,
    attendance INT,
    stage VARCHAR(25) NOT NULL,
    homeScore INT NOT NULL,
    awayScore INT NOT NULL,
    winner VARCHAR(25) NOT NULL,
    referee VARCHAR(50),
    m_date DATE,
    PRIMARY KEY (matchID),
    FOREIGN KEY (venue) REFERENCES Location(name),
    FOREIGN KEY (year) REFERENCES WorldCup(year)
);

-- Create the PlaysIn table to represent the many-to-many relationship between Team and Match
DROP TABLE IF EXISTS PlaysIn;
CREATE TABLE PlaysIn (
    matchID INT NOT NULL,
    homeTeamID INT NOT NULL,
    PRIMARY KEY (matchID, homeTeamID),
    FOREIGN KEY (homeTeamID) REFERENCES Team(teamID),
    FOREIGN KEY (matchID) REFERENCES Matches(matchID)
);

-- Create the Awards table
DROP TABLE IF EXISTS Awards;
CREATE TABLE Awards (
    awardID INT NOT NULL,
    year INT NOT NULL,
    award_name VARCHAR(50),
    playerID INT,
    player_name VARCHAR(50),
    PRIMARY KEY (awardID),
    FOREIGN KEY (playerID) REFERENCES Player(playerID),
    FOREIGN KEY (year) REFERENCES WorldCup(year)
);

/*CREATE TABLE Awards (
    year INT NOT NULL,
    golden_boot VARCHAR(25) NOT NULL,
    silver_boot VARCHAR(25) NOT NULL,
    bronze_boot VARCHAR(25) NOT NULL,
    golden_ball VARCHAR(25) NOT NULL,
    silver_ball VARCHAR(25) NOT NULL,
    bronze_ball VARCHAR(25) NOT NULL,
    golden_glove VARCHAR(25) NOT NULL,
    young_player_award VARCHAR(25) NOT NULL,
    PRIMARY KEY (year)
);*/

