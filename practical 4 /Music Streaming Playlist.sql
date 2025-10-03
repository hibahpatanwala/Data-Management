--
-- Set 10: Music Streaming Playlist
--

-- 1. Identify anomalies
-- Insert anomaly: Cannot add a new user or song without a playlist entry.
-- Update anomaly: Changing UserName or Artist requires updates in all playlist entries.
-- Deletion anomaly: Deleting a playlist entry may remove all info about a song or user if no other entries exist.

-- 2. Does schema meet 1NF? Explain
-- Yes, all columns contain atomic single values, no arrays or repeating groups.

-- 3. Normalize to 1NF (already is)

CREATE TABLE MusicPlaylist (
    PlaylistID INT,
    UserID INT,
    UserName VARCHAR(100),
    SongID INT,
    SongTitle VARCHAR(200),
    Artist VARCHAR(100),
    Album VARCHAR(100),
    Genre VARCHAR(50),
    Duration TIME,
    AddedDate DATE,
    PRIMARY KEY (PlaylistID, SongID)
);

-- Insert sample data for 1NF table
INSERT INTO MusicPlaylist (PlaylistID, UserID, UserName, SongID, SongTitle, Artist, Album, Genre, Duration, AddedDate)
VALUES
(1001, 201, 'Rahul Verma', 301, 'Shape of You', 'Ed Sheeran', 'Divide', 'Pop', '00:04:24', '2025-09-01'),
(1001, 201, 'Rahul Verma', 302, 'Blinding Lights', 'The Weeknd', 'After Hours', 'R&B', '00:03:20', '2025-09-05'),
(1002, 202, 'Anjali Mehta', 303, 'Levitating', 'Dua Lipa', 'Future Nostalgia', 'Pop', '00:03:23', '2025-09-03'),
(1002, 202, 'Anjali Mehta', 304, 'Watermelon Sugar', 'Harry Styles', 'Fine Line', 'Pop', '00:02:54', '2025-09-07'),
(1003, 203, 'Sunil Sharma', 305, 'Bad Guy', 'Billie Eilish', 'When We All Fall Asleep', 'Pop', '00:03:14', '2025-09-02');

-- 4. State primary key
-- Composite key: (PlaylistID, SongID)

-- 5. Write FDs
-- PlaylistID, SongID → all attributes except User and Song detail redundancies
-- UserID → UserName
-- SongID → SongTitle, Artist, Album, Genre, Duration

-- 6. Identify partial dependencies
-- PlaylistID, SongID composite key; 
-- UserName depends only on UserID (partial)
-- SongTitle, Artist, Album etc depend only on SongID

-- 7. Convert to 2NF

CREATE TABLE User (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100)
);

CREATE TABLE Song (
    SongID INT PRIMARY KEY,
    SongTitle VARCHAR(200),
    Artist VARCHAR(100),
    Album VARCHAR(100),
    Genre VARCHAR(50),
    Duration TIME
);

CREATE TABLE Playlist (
    PlaylistID INT,
    UserID INT,
    AddedDate DATE,
    PRIMARY KEY (PlaylistID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE PlaylistSong (
    PlaylistID INT,
    SongID INT,
    PRIMARY KEY (PlaylistID, SongID),
    FOREIGN KEY (PlaylistID) REFERENCES Playlist(PlaylistID),
    FOREIGN KEY (SongID) REFERENCES Song(SongID)
);

-- Insert sample data for 2NF tables
INSERT INTO User (UserID, UserName) VALUES
(201, 'Rahul Verma'),
(202, 'Anjali Mehta'),
(203, 'Sunil Sharma');

INSERT INTO Song (SongID, SongTitle, Artist, Album, Genre, Duration) VALUES
(301, 'Shape of You', 'Ed Sheeran', 'Divide', 'Pop', '00:04:24'),
(302, 'Blinding Lights', 'The Weeknd', 'After Hours', 'R&B', '00:03:20'),
(303, 'Levitating', 'Dua Lipa', 'Future Nostalgia', 'Pop', '00:03:23'),
(304, 'Watermelon Sugar', 'Harry Styles', 'Fine Line', 'Pop', '00:02:54'),
(305, 'Bad Guy', 'Billie Eilish', 'When We All Fall Asleep', 'Pop', '00:03:14');

INSERT INTO Playlist (PlaylistID, UserID, AddedDate) VALUES
(1001, 201, '2025-09-01'),
(1002, 202, '2025-09-03'),
(1003, 203, '2025-09-02');

INSERT INTO PlaylistSong (PlaylistID, SongID) VALUES
(1001, 301), (1001, 302),
(1002, 303), (1002, 304),
(1003, 305);

-- 8. Identify transitive dependencies
-- None: all non-key attributes fully dependent on primary keys in respective tables.

-- 9. Convert to 3NF (same as 2NF here)

-- 10. Write SQL for 3NF schema (same as 2NF schema)

-- 11. Check BCNF compliance
-- Yes, all determinants are candidate keys.

-- 12. Query: List songs in each playlist
SELECT P.PlaylistID, U.UserName, S.SongTitle, S.Artist
FROM PlaylistSong PS
JOIN Playlist P ON PS.PlaylistID = P.PlaylistID
JOIN User U ON P.UserID = U.UserID
JOIN Song S ON PS.SongID = S.SongID;

-- 13. Query: Count songs per user
SELECT U.UserName, COUNT(PS.SongID) AS NumberOfSongs
FROM PlaylistSong PS
JOIN Playlist P ON PS.PlaylistID = P.PlaylistID
JOIN User U ON P.UserID = U.UserID
GROUP BY U.UserName;

-- 14. Query: Find most played artist (Assuming "most played" as highest song count)
SELECT S.Artist, COUNT(*) AS PlayCount
FROM PlaylistSong PS
JOIN Song S ON PS.SongID = S.SongID
GROUP BY S.Artist
ORDER BY PlayCount DESC
LIMIT 1;

-- 15. Query: Find users with playlists > 50 songs
SELECT U.UserName, COUNT(PS.SongID) AS SongCount
FROM PlaylistSong PS
JOIN Playlist P ON PS.PlaylistID = P.PlaylistID
JOIN User U ON P.UserID = U.UserID
GROUP BY U.UserName
HAVING COUNT(PS.SongID) > 50;

-- 16. Query: Find average duration of songs per genre
SELECT Genre, SEC_TO_TIME(AVG(TIME_TO_SEC(Duration))) AS AvgDuration
FROM Song
GROUP BY Genre;

-- 17. Query: Top 3 albums by number of songs added
SELECT Album, COUNT(*) AS SongsCount
FROM Song
GROUP BY Album
ORDER BY SongsCount DESC
LIMIT 3;

-- 18. Query: List playlists containing songs of genre "Rock"
SELECT DISTINCT P.PlaylistID, U.UserName
FROM PlaylistSong PS
JOIN Song S ON PS.SongID = S.SongID
JOIN Playlist P ON PS.PlaylistID = P.PlaylistID
JOIN User U ON P.UserID = U.UserID
WHERE S.Genre = 'Rock';

-- 20. Discuss improvements after normalization
-- Data is no longer duplicated between users and songs.  
-- Updates to song or user details need to be made in only one place to maintain consistency.  
-- Query flexibility improved for reporting and analytics.
