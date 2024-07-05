#include <a_samp>
#include <a_mysql>

// تعریف ثابت‌ها
#define MAX_PLAYER_NAME 24

// اعلام توابع
forward OnPlayerCommandText(playerid, cmdtext[]);//دیفالت داره ولی اگر نداشت استفاده کنید  pawno این تابع رو گیم مود یا 
// تابع بالا اگر وجود نداشته باشه شما دستوری نمیتونید بزنید و اررور میده بهتون یا به عبارتی تابع وجود نداره 
// جزئیات اتصال MySQL
new MySQL:sqlConnection;
new sqlHost[] = "localhost";
new sqlUser[] = "root";//نام یوزری که ثبت کردین (root دیفالته)
new sqlPass[] = "password";//رمزی که برای یوزر انتخاب کردین (اگر رمزی ندارد درون " " را خالی بزارید)
new sqlDB[]   = "samp_db";//server هست شما هم اینجا بزارید server اسم دیتا بیستون  هرچی بود اینجا میزارید اسم دیتا بیستون فرق داره و حالت دیفالتی نداره پس اگر اسمش 

public OnGameModeInit()
{
    // راه‌اندازی اتصال MySQL
    sqlConnection = mysql_connect(sqlHost, sqlUser, sqlPass, sqlDB);
    if(sqlConnection == MYSQL_INVALID_HANDLE)
    {
        print("Server be data base motasel nashod .");
        return 0;
    }
    print("server be datat base motasel shod .");
    return 1;
}

public OnGameModeExit()
{
    // بستن اتصال MySQL
    mysql_close(sqlConnection);
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(sscanf(cmdtext, "/ban %d %s[100]", targetid, reason))
    {
        // دریافت نام بازیکن
        new name[MAX_PLAYER_NAME];
        GetPlayerName(targetid, name, MAX_PLAYER_NAME);

        // بن کردن بازیکن
        Ban(targetid);

        // درج رکورد بن در پایگاه داده
        new query[256];
        format(query, sizeof(query), "INSERT INTO bans (player_name, ban_reason) VALUES ('%s', '%s')", name, reason);
        mysql_query(sqlConnection, query);

        // اطلاع رسانی به ادمین
        new adminName[MAX_PLAYER_NAME];
        GetPlayerName(playerid, adminName, MAX_PLAYER_NAME);
        new message[128];
        format(message, sizeof(message), "admin %s bazikon %s ra ban kard / dalil : %s", adminName, name, reason);
        SendClientMessageToAll(COLOR_RED, message);

        return 1;
    }
    return 0;
}
