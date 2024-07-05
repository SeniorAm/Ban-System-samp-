#include <a_samp>
#include <a_mysql>

// Define constants
#define MAX_PLAYER_NAME 24

// Declare functions
forward OnPlayerCommandText(playerid, cmdtext[]);

// MySQL connection details
new MySQL:sqlConnection;
new sqlHost[] = "localhost";
new sqlUser[] = "root";
new sqlPass[] = "password";
new sqlDB[]   = "samp_db";

public OnGameModeInit()
{
    // Initialize MySQL connection
    sqlConnection = mysql_connect(sqlHost, sqlUser, sqlPass, sqlDB);
    if(sqlConnection == MYSQL_INVALID_HANDLE)
    {
        print("MySQL connection failed.");
        return 0;
    }
    print("MySQL connection successful.");
    return 1;
}

public OnGameModeExit()
{
    // Close MySQL connection
    mysql_close(sqlConnection);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(sscanf(cmdtext, "/ban %d %s[100]", targetid, reason))
    {
        // Get the player's name
        new name[MAX_PLAYER_NAME];
        GetPlayerName(targetid, name, MAX_PLAYER_NAME);

        // Ban the player
        Ban(targetid);

        // Insert ban record into database
        new query[256];
        format(query, sizeof(query), "INSERT INTO bans (player_name, ban_reason) VALUES ('%s', '%s')", name, reason);
        mysql_query(sqlConnection, query);

        // Notify the admin
        new adminName[MAX_PLAYER_NAME];
        GetPlayerName(playerid, adminName, MAX_PLAYER_NAME);
        new message[128];
        format(message, sizeof(message), "Admin %s banned player %s for: %s", adminName, name, reason);
        SendClientMessageToAll(COLOR_RED, message);

        return 1;
    }
    return 0;
}
